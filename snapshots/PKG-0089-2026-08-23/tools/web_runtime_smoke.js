/**
 * GETTING STRANGE — Web Runtime Smoke Test (Node.js, zero-dependency)
 *
 * Evaluates every web/js script in browser order inside a vm context with a
 * minimal DOM shim. Fails if any script throws during top-level evaluation
 * (e.g. ReferenceError from an undefined identifier assigned to window.*)
 * or if any required global class / function / engine export is missing.
 *
 * Usage: node tools/web_runtime_smoke.js
 * Exit code 0 = PASS, 1 = FAIL.
 */

const fs = require("fs");
const path = require("path");
const vm = require("vm");

const projectRoot = path.resolve(__dirname, "..");
const jsDir = path.join(projectRoot, "web", "js");

const SCRIPT_ORDER = [
  "i18n.js",
  "audio-synth.js",
  "game-engine.js",
  "gallery.js",
  "story-timeline.js",
  "app.js"
];

// --- Minimal DOM shim -------------------------------------------------------

function makeClassList() {
  return { add() {}, remove() {}, toggle() {}, contains() { return false; } };
}

function makeElementStub(tag = "div") {
  const el = {
    tagName: (tag || "div").toUpperCase(),
    style: {},
    dataset: {},
    classList: makeClassList(),
    children: [],
    value: "",
    innerText: "",
    textContent: "",
    checked: false,
    addEventListener() {},
    removeEventListener() {},
    appendChild(c) { return c; },
    removeChild(c) { return c; },
    setAttribute() {},
    getAttribute() { return null; },
    querySelector() { return null; },
    querySelectorAll() { return []; },
    getContext() { return null; },
    click() {},
    focus() {},
    remove() {},
    scrollTop: 0,
    scrollHeight: 0,
    width: 640,
    height: 360
  };
  Object.defineProperty(el, "innerHTML", {
    get() { return this._innerHTML || ""; },
    set(v) { this._innerHTML = String(v); }
  });
  return el;
}

const documentStub = {
  addEventListener() {},
  removeEventListener() {},
  getElementById() { return null; },
  querySelector() { return null; },
  querySelectorAll() { return []; },
  createElement(tag) { return makeElementStub(tag); },
  createTextNode(text) { return { textContent: String(text) }; },
  documentElement: makeElementStub("html"),
  body: makeElementStub("body"),
  head: makeElementStub("head"),
  readyState: "complete",
  hidden: false,
  visibilityState: "visible"
};

const sandbox = {
  console,
  document: documentStub,
  navigator: { clipboard: { writeText: () => Promise.resolve() }, language: "pl" },
  location: { href: "http://localhost/index.html", origin: "http://localhost", pathname: "/index.html" },
  performance: { now: () => Date.now() },
  requestAnimationFrame: () => 0,
  cancelAnimationFrame: () => {},
  setTimeout,
  setInterval,
  clearTimeout,
  clearInterval,
  fetch: () => Promise.reject(new Error("fetch disabled in smoke test")),
  localStorage: { getItem: () => null, setItem: () => {}, removeItem: () => {}, clear: () => {} },
  sessionStorage: { getItem: () => null, setItem: () => {}, removeItem: () => {}, clear: () => {} },
  getComputedStyle: () => ({ getPropertyValue: () => "" }),
  URL,
  Blob,
  AudioContext: undefined,
  webkitAudioContext: undefined,
  OfflineAudioContext: undefined
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

// --- Phase 2: required globals must exist -----------------------------------

const REQUIRED_GLOBALS = [
  // Core controllers
  "showToast", "copyShaToClipboard", "downloadReleasePackage",
  // Archive dossier reader (PKG-0089 fix)
  "openDossierModal", "closeDossierModal", "DOSSIER_DETAILS", "filterDossiers",
  // Custom Signal Designer (PKG-0089 fix)
  "playCustomDesignedSignal", "downloadCustomDesignedWav", "getCustomSignalParams",
  // Retro terminal quick commands (PKG-0089 fix)
  "executeRetroTerminalCmd", "IKPRetroTerminal",
  // Subsystem classes
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
  try {
    type = vm.runInContext(`typeof ${name}`, context);
  } catch (err) {
    type = "error";
  }
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

// --- Result -----------------------------------------------------------------

if (failures > 0) {
  console.error(`\nWEB RUNTIME SMOKE FAIL (${failures} problem(s))`);
  process.exit(1);
}
console.log("\nWEB RUNTIME SMOKE PASS: all scripts evaluate cleanly and all required globals exist.");
process.exit(0);
