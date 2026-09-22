/**
 * GETTING STRANGE — Web Runtime Smoke Test (Node.js, zero-dependency)
 * Phases: 1) script evaluation, 2) required globals, 3) dossier registry,
 * 4) progression source contract (PKG-0090), 5) behavioral key paths (PKG-0091).
 * Usage: node tools/web_runtime_smoke.js  (exit 0 = PASS, 1 = FAIL)
 */
const fs = require("fs");
const path = require("path");
const vm = require("vm");

const projectRoot = path.resolve(__dirname, "..");
const webDir = path.join(projectRoot, "web");
const jsDir = path.join(webDir, "js");
const SCRIPT_ORDER = ["i18n.js", "audio-synth.js", "game-engine.js", "gallery.js", "story-timeline.js", "app.js"];

const indexSource = fs.readFileSync(path.join(webDir, "index.html"), "utf8");

function makeClassList(initial = "") {
  const set = new Set(initial.split(/\s+/).filter(Boolean));
  return {
    add(...cs) { cs.forEach(c => set.add(c)); },
    remove(...cs) { cs.forEach(c => set.delete(c)); },
    toggle(c, force) {
      const want = force === undefined ? !set.has(c) : !!force;
      if (want) set.add(c); else set.delete(c);
      return want;
    },
    contains(c) { return set.has(c); },
    toString() { return [...set].join(" "); }
  };
}

function makeContext2dStub() {
  return new Proxy({}, {
    get(target, prop) {
      if (!(prop in target)) {
        target[prop] = () => (String(prop).startsWith("create") ? { addColorStop() {} } : undefined);
      }
      return target[prop];
    },
    set(target, prop, value) { target[prop] = value; return true; }
  });
}

function makeElementStub(tag = "div", attrs = {}) {
  const el = {
    tagName: (tag || "div").toUpperCase(),
    style: {},
    dataset: {},
    classList: makeClassList(attrs.class || ""),
    children: [],
    value: attrs.value !== undefined ? attrs.value : "",
    innerText: "",
    textContent: "",
    placeholder: attrs.placeholder || "",
    checked: attrs.checked === "true" || attrs.checked === true,
    listeners: {},
    addEventListener(type, fn) { (this.listeners[type] = this.listeners[type] || []).push(fn); },
    removeEventListener() {},
    appendChild(c) { this.children.push(c); return c; },
    removeChild(c) { const i = this.children.indexOf(c); if (i >= 0) this.children.splice(i, 1); return c; },
    setAttribute(k, v) { if (k === "class") this.classList = makeClassList(v); },
    getAttribute() { return null; },
    querySelector() { return null; },
    querySelectorAll() { return []; },
    getContext() { return makeContext2dStub(); },
    click() {}, focus() {}, remove() {},
    scrollTop: 0, scrollHeight: 0, width: 640, height: 360
  };
  Object.defineProperty(el, "innerHTML", {
    get() { return this._innerHTML || ""; },
    set(v) { this._innerHTML = String(v); }
  });
  return el;
}

// --- id registry parsed from real index.html --------------------------------
const idRegistry = new Map();
const tagRe = /<(\w+)((?:"[^"]*"|'[^']*'|[^>"'])*)>/g;
let tm;
while ((tm = tagRe.exec(indexSource)) !== null) {
  const attrsRaw = tm[2] || "";
  const idM = attrsRaw.match(/id="([^"]+)"/);
  if (!idM) continue;
  const attrs = {};
  const attrRe = /([\w-]+)="([^"]*)"/g;
  let am;
  while ((am = attrRe.exec(attrsRaw)) !== null) attrs[am[1]] = am[2];
  if (!idRegistry.has(idM[1])) idRegistry.set(idM[1], makeElementStub(tm[1], attrs));
}
// select elements expose first option as default value
const selectRe = /<select[^>]*id="([^"]+)"[^>]*>([\s\S]*?)<\/select>/g;
let sm;
while ((sm = selectRe.exec(indexSource)) !== null) {
  const el = idRegistry.get(sm[1]);
  if (!el) continue;
  const optM = sm[2].match(/<option[^>]*value="([^"]*)"/);
  if (optM && !el.value) el.value = optM[1];
}

const domContentLoadedHandlers = [];
const documentStub = {
  addEventListener(type, fn) { if (type === "DOMContentLoaded") domContentLoadedHandlers.push(fn); },
  removeEventListener() {},
  getElementById(id) { return idRegistry.get(id) || null; },
  querySelector() { return null; },
  querySelectorAll() { return []; },
  createElement(tag) { return makeElementStub(tag); },
  createTextNode(text) { return { textContent: String(text) }; },
  documentElement: makeElementStub("html"),
  body: makeElementStub("body"),
  head: makeElementStub("head"),
  title: "",
  readyState: "complete",
  hidden: false,
  visibilityState: "visible"
};

const storageBacking = new Map();
function makeStorage() {
  return {
    getItem: k => (storageBacking.has(k) ? storageBacking.get(k) : null),
    setItem: (k, v) => { storageBacking.set(k, String(v)); },
    removeItem: k => { storageBacking.delete(k); },
    clear: () => storageBacking.clear()
  };
}

const sandbox = {
  console,
  document: documentStub,
  navigator: { clipboard: { writeText: () => Promise.resolve() }, language: "pl" },
  location: { href: "http://localhost/index.html", origin: "http://localhost", pathname: "/index.html" },
  performance: { now: () => Date.now() },
  requestAnimationFrame: () => 0,
  cancelAnimationFrame: () => {},
  setTimeout: () => 0, // deferred callbacks intentionally not run in harness
  setInterval: () => 0,
  clearTimeout: () => {},
  clearInterval: () => {},
  fetch: (url) => {
    const rel = String(url).replace(/^\.\//, "");
    const filePath = path.join(webDir, rel);
    if (fs.existsSync(filePath)) {
      const raw = fs.readFileSync(filePath, "utf8");
      return Promise.resolve({
        ok: true, status: 200,
        json: () => Promise.resolve(JSON.parse(raw)),
        text: () => Promise.resolve(raw)
      });
    }
    return Promise.reject(new Error(`fetch not found: ${url}`));
  },
  localStorage: makeStorage(),
  sessionStorage: makeStorage(),
  getComputedStyle: () => ({ getPropertyValue: () => "" }),
  addEventListener() {},
  removeEventListener() {},
  URL, Blob,
  AudioContext: undefined, webkitAudioContext: undefined, OfflineAudioContext: undefined
};
sandbox.window = sandbox;
sandbox.globalThis = sandbox;
sandbox.self = sandbox;

const context = vm.createContext(sandbox);
let failures = 0;


// --- Phase 1: evaluate all scripts in browser order -------------------------
for (const file of SCRIPT_ORDER) {
  const filePath = path.join(jsDir, file);
  if (!fs.existsSync(filePath)) {
    console.error(`FAIL: missing script file: js/${file}`);
    failures++;
    continue;
  }
  const source = fs.readFileSync(filePath, "utf8");
  try {
    vm.runInContext(source, context, { filename: `js/${file}` });
    console.log(`PASS: js/${file} evaluated without errors`);
  } catch (err) {
    console.error(`FAIL: js/${file} threw during evaluation: ${err.stack || err}`);
    failures++;
  }
}

// --- Phase 2: required globals ----------------------------------------------
const REQUIRED_GLOBALS = [
  "showToast", "copyShaToClipboard", "downloadReleasePackage",
  "openDossierModal", "closeDossierModal", "DOSSIER_DETAILS", "filterDossiers",
  "playCustomDesignedSignal", "downloadCustomDesignedWav", "getCustomSignalParams",
  "executeRetroTerminalCmd", "IKPRetroTerminal",
  "GettingStrangeGallery", "GettingStrangeStoryTimeline",
  "GettingStrangeMiniEngine", "GettingStrangeDecisionSimulator",
  "CustomSignalDesigner", "ReelToReelTapeDeck", "LissajousVectorScope",
  "QuantumFieldInterferenceRack", "CondensationFluidRack",
  "MemoryResonanceSpectrometer", "VacuumTubeResonanceEngine",
  "AcousticMatrixAnalyzer", "PassengerQuantumManifestEngine",
  "TransitGridTopologicalMap", "ContinuitySafetyProtocolAuditor",
  "HarmonicWaveCoherenceEngine", "SedationStrataIsotopeRegistry",
  "PhaseTensorEngine", "QuantumEntanglementGraphEngine",
  "WaveguideDispersionEngine", "QuantumHologramEngine",
  "SeismicInfrasoundEngine", "LorentzSpacetimeEngine",
  "VectorVorticityEngine", "QuantumHilbertTopologyEngine",
  "MagnetoelectricResonanceEngine", "SpatialSolitonDynamicsEngine",
  "CrystalSeamPiezoEngine", "DeterministicChaosAttractorEngine",
  "QuantumTunnelingBarrierMatrix", "FeigenbaumBifurcationSpectrumEngine",
  "KramersKronigDispersionMatrix", "StochasticResonanceSignalEngine",
  "GaugeFieldCurvatureMatrix", "MagneticTensorLlgEngine",
  "OnsagerEntropyProductionEngine", "CasimirVacuumStressTensorEngine"
];
for (const name of REQUIRED_GLOBALS) {
  let type;
  try { type = vm.runInContext(`typeof ${name}`, context); } catch (e) { type = "error"; }
  if (type === "undefined" || type === "error") {
    console.error(`FAIL: required global '${name}' is ${type}`);
    failures++;
  }
}
console.log(`PASS: ${REQUIRED_GLOBALS.length} required globals verified`);

// --- Phase 3: dossier registry integrity ------------------------------------
try {
  const dossierCount = vm.runInContext("Object.keys(DOSSIER_DETAILS).length", context);
  if (dossierCount < 100) {
    console.error(`FAIL: DOSSIER_DETAILS holds ${dossierCount} entries, expected >= 100`);
    failures++;
  } else {
    console.log(`PASS: DOSSIER_DETAILS holds ${dossierCount} declassified dossiers`);
  }
} catch (err) {
  console.error(`FAIL: could not inspect DOSSIER_DETAILS: ${err}`);
  failures++;
}

// --- Phase 4: progression loop contract (PKG-0090) --------------------------
const engineSource = fs.readFileSync(path.join(jsDir, "game-engine.js"), "utf8");
const PROGRESSION_REQUIREMENTS = [
  { pattern: "getting_strange_progress_v1", label: "localStorage persistence key" },
  { pattern: "this.totalChambers = 20", label: "20-chamber campaign constant" },
  { pattern: "loadProgress()", label: "progress load method" },
  { pattern: "saveProgress()", label: "progress save method" },
  { pattern: "resetProgress()", label: "progress reset method" },
  { pattern: "completionBannerTimer", label: "campaign completion banner" },
  { pattern: "runsFinished", label: "finished-runs telemetry" }
];
for (const req of PROGRESSION_REQUIREMENTS) {
  if (!engineSource.includes(req.pattern)) {
    console.error(`FAIL: game-engine.js missing progression requirement: ${req.label} ('${req.pattern}')`);
    failures++;
  }
}
if (engineSource.includes("% 15")) {
  console.error("FAIL: game-engine.js still contains the '% 15' progression bug (chambers 16-20 unreachable)");
  failures++;
}
console.log(`PASS: progression loop contract verified (${PROGRESSION_REQUIREMENTS.length} requirements, no '% 15' regression)`);
if (!indexSource.includes("gameEngine.resetProgress()")) {
  console.error("FAIL: index.html missing the reset-progress control wiring");
  failures++;
} else {
  console.log("PASS: index.html wires the reset-progress control");
}


// --- Phase 5: behavioral key paths (PKG-0091) -------------------------------
(async () => {
  // 5.1 fire DOMContentLoaded handlers like a browser would
  let handlerErrors = 0;
  for (const fn of domContentLoadedHandlers) {
    try {
      const r = fn();
      if (r && typeof r.then === "function") await r.catch(e => { handlerErrors++; console.error(`FAIL: async DOMContentLoaded handler rejected: ${e.message || e}`); });
    } catch (e) {
      handlerErrors++;
      console.error(`FAIL: DOMContentLoaded handler threw: ${e.message || e}`);
    }
  }
  if (handlerErrors === 0) {
    console.log(`PASS: ${domContentLoadedHandlers.length} DOMContentLoaded handlers executed cleanly`);
  } else {
    failures += handlerErrors;
  }

  const bAssert = (cond, label) => {
    if (cond) { console.log(`PASS: ${label}`); }
    else { console.error(`FAIL: ${label}`); failures++; }
  };

  try {
    // 5.2 dossier reader modal
    vm.runInContext("openDossierModal('doc1')", context);
    const modal = idRegistry.get("dossierModal");
    const body = idRegistry.get("dossierModalBody");
    bAssert(modal && modal.classList.contains("active"), "dossier modal opens with 'active' class for doc1");
    bAssert(body && body.innerText.length > 40, "dossier modal body populated with doc1 content");
    vm.runInContext("closeDossierModal()", context);
    bAssert(modal && !modal.classList.contains("active"), "dossier modal closes cleanly");

    // 5.3 retro terminal quick commands
    vm.runInContext("executeRetroTerminalCmd('help')", context);
    const termOut = idRegistry.get("retroTerminalOutput");
    bAssert(termOut && termOut.children.length > 5, "CLI quick command 'help' prints command listing");
    vm.runInContext("executeRetroTerminalCmd('status')", context);
    bAssert(termOut.children.length > 15, "CLI quick command 'status' prints telemetry block");

    // 5.4 chamber campaign progression reset
    const geOk = vm.runInContext("typeof window.gameEngine !== 'undefined' && window.gameEngine !== null", context);
    bAssert(geOk, "game engine instantiated on DOMContentLoaded");
    if (geOk) {
      vm.runInContext("window.gameEngine.resetProgress()", context);
      const lastChamber = vm.runInContext("window.gameEngine.progress.lastChamber", context);
      const completed = vm.runInContext("window.gameEngine.progress.completed.length", context);
      bAssert(lastChamber === 1 && completed === 0, "resetProgress returns campaign to chamber 01 with empty completion list");
      const persisted = vm.runInContext("localStorage.getItem('getting_strange_progress_v1')", context);
      bAssert(typeof persisted === "string" && persisted.includes("lastChamber"), "progress persists to localStorage");
    }

    // 5.5 custom signal designer param readout
    const paramsJson = vm.runInContext("JSON.stringify(getCustomSignalParams())", context);
    const params = JSON.parse(paramsJson);
    bAssert(params.freq === 740 && params.waveform === "sine" && params.attack > 0, "signal designer reads DOM defaults (740 Hz, sine, ADSR)");
  } catch (e) {
    console.error(`FAIL: behavioral phase crashed: ${e.stack || e}`);
    failures++;
  }

  // --- Result ---------------------------------------------------------------
  if (failures > 0) {
    console.error(`\nWEB RUNTIME SMOKE FAIL (${failures} problem(s))`);
    process.exit(1);
  }
  console.log("\nWEB RUNTIME SMOKE PASS: scripts evaluate, globals exist, dossiers intact, progression contract holds, behavioral key paths PASS.");
  process.exit(0);
})();

