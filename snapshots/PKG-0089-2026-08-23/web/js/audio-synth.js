/**
 * GETTING STRANGE — Procedural Audio Web Synthesizer
 * Odwzorowanie generatora proceduralnego audio z silnika Godot (ProceduralAudio) w Web Audio API.
 * 100% matematycznej syntezy w czasie rzeczywistym bez zewnętrznych plików WAV/MP3.
 */

class WebProceduralAudio {
  constructor() {
    this.ctx = null;
    this.analyser = null;
    this.masterGain = null;
    this.isInitialized = false;
    this.activeAmbientNodes = null;
    this.activeAmbientType = null;
  }

  init() {
    if (this.isInitialized && this.ctx) {
      if (this.ctx.state === 'suspended') {
        this.ctx.resume();
      }
      return;
    }

    const AudioContextClass = window.AudioContext || window.webkitAudioContext;
    if (!AudioContextClass) {
      console.warn("Web Audio API not supported in this browser");
      return;
    }

    this.ctx = new AudioContextClass();
    this.analyser = this.ctx.createAnalyser();
    this.analyser.fftSize = 512;
    this.analyser.smoothingTimeConstant = 0.8;

    this.masterGain = this.ctx.createGain();
    this.masterGain.gain.value = 0.85;

    this.analyser.connect(this.masterGain);
    this.masterGain.connect(this.ctx.destination);

    this.isInitialized = true;
  }

  ensureContext() {
    if (!this.isInitialized) {
      this.init();
    }
    if (this.ctx && this.ctx.state === 'suspended') {
      this.ctx.resume();
    }
  }

  setMasterVolume(val) {
    this.ensureContext();
    val = Math.max(0, Math.min(1, val));
    if (val > 0) {
      this.isMuted = false;
      this.previousVolume = val;
    }
    if (this.masterGain && this.ctx) {
      this.masterGain.gain.setValueAtTime(val, this.ctx.currentTime);
    }
  }

  toggleMute() {
    this.ensureContext();
    if (this.isMuted) {
      this.isMuted = false;
      this.setMasterVolume(this.previousVolume || 0.85);
      return false; // unmuted
    } else {
      this.isMuted = true;
      if (this.masterGain && this.ctx) {
        this.masterGain.gain.setValueAtTime(0, this.ctx.currentTime);
      }
      return true; // muted
    }
  }

  // 1. Ton Zakotwiczenia (Anchor: 740 Hz pure sine + subharmonic 370 Hz)
  playAnchorSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc1 = this.ctx.createOscillator();
    const osc2 = this.ctx.createOscillator();
    const gainNode = this.ctx.createGain();

    osc1.type = "sine";
    osc1.frequency.setValueAtTime(740, now);
    osc1.frequency.exponentialRampToValueAtTime(750, now + 0.18);

    osc2.type = "sine";
    osc2.frequency.setValueAtTime(370, now);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.35, now + 0.02);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 0.35);

    osc1.connect(gainNode);
    osc2.connect(gainNode);
    gainNode.connect(this.analyser);

    osc1.start(now);
    osc2.start(now);
    osc1.stop(now + 0.36);
    osc2.stop(now + 0.36);
  }

  // 2. Ton Odkotwiczenia (Unanchor: 660 -> 330 Hz downward chirp)
  playUnanchorSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc = this.ctx.createOscillator();
    const gainNode = this.ctx.createGain();

    osc.type = "sine";
    osc.frequency.setValueAtTime(660, now);
    osc.frequency.exponentialRampToValueAtTime(330, now + 0.22);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.3, now + 0.015);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 0.28);

    osc.connect(gainNode);
    gainNode.connect(this.analyser);

    osc.start(now);
    osc.stop(now + 0.29);
  }

  // 3. Impuls Fali Korekty (Correction Wave: 92 -> 44 Hz sub-bass rumble)
  playCorrectionWaveSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc = this.ctx.createOscillator();
    const filter = this.ctx.createBiquadFilter();
    const gainNode = this.ctx.createGain();

    osc.type = "sawtooth";
    osc.frequency.setValueAtTime(92, now);
    osc.frequency.exponentialRampToValueAtTime(44, now + 0.6);

    filter.type = "lowpass";
    filter.frequency.setValueAtTime(220, now);
    filter.frequency.exponentialRampToValueAtTime(80, now + 0.6);
    filter.Q.value = 4.0;

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.45, now + 0.05);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 0.65);

    osc.connect(filter);
    filter.connect(gainNode);
    gainNode.connect(this.analyser);

    osc.start(now);
    osc.stop(now + 0.66);
  }

  // 4. Kolizja / Opór Wymiarowy (Dissonant clash: 587 / 622 Hz)
  playDimensionalClashSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc1 = this.ctx.createOscillator();
    const osc2 = this.ctx.createOscillator();
    const gainNode = this.ctx.createGain();

    osc1.type = "sine";
    osc1.frequency.setValueAtTime(587.33, now); // D5
    osc2.type = "sine";
    osc2.frequency.setValueAtTime(622.25, now); // Eb5 (półton dysonansu)

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.25, now + 0.02);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 0.4);

    osc1.connect(gainNode);
    osc2.connect(gainNode);
    gainNode.connect(this.analyser);

    osc1.start(now);
    osc2.start(now);
    osc1.stop(now + 0.41);
    osc2.stop(now + 0.41);
  }

  // 5. Radio Linii 4 (580/1160 Hz AM carrier + analog vinyl crackle)
  playLine4RadioSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const carrier = this.ctx.createOscillator();
    const mod = this.ctx.createOscillator();
    const modGain = this.ctx.createGain();
    const gainNode = this.ctx.createGain();

    carrier.type = "sine";
    carrier.frequency.setValueAtTime(580, now);

    mod.type = "sine";
    mod.frequency.setValueAtTime(1160, now);
    modGain.gain.setValueAtTime(200, now);

    mod.connect(modGain);
    modGain.connect(carrier.frequency);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.18, now + 0.05);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 0.75);

    carrier.connect(gainNode);
    gainNode.connect(this.analyser);

    mod.start(now);
    carrier.start(now);
    mod.stop(now + 0.76);
    carrier.stop(now + 0.76);
  }

  // 6. Stukot Kubków Laboratoryjnych w IKP (1450/2900 Hz porcelain clink on wooden desk at 21:45)
  playCupClinkSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc1 = this.ctx.createOscillator();
    const osc2 = this.ctx.createOscillator();
    const gainNode = this.ctx.createGain();

    osc1.type = "sine";
    osc1.frequency.setValueAtTime(1450, now);
    osc2.type = "sine";
    osc2.frequency.setValueAtTime(2900, now);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.28, now + 0.005);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 0.35);

    osc1.connect(gainNode);
    osc2.connect(gainNode);
    gainNode.connect(this.analyser);

    osc1.start(now);
    osc2.start(now);
    osc1.stop(now + 0.36);
    osc2.stop(now + 0.36);
  }

  // 7. Przełączenie Zwrotnicy Tramwaju (340 Hz metal clank + 1600 Hz ring)
  playTramSwitchSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc1 = this.ctx.createOscillator();
    const osc2 = this.ctx.createOscillator();
    const gainNode = this.ctx.createGain();

    osc1.type = "triangle";
    osc1.frequency.setValueAtTime(340, now);
    osc2.type = "sine";
    osc2.frequency.setValueAtTime(1600, now);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.35, now + 0.01);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 0.45);

    osc1.connect(gainNode);
    osc2.connect(gainNode);
    gainNode.connect(this.analyser);

    osc1.start(now);
    osc2.start(now);
    osc1.stop(now + 0.46);
    osc2.stop(now + 0.46);
  }

  // 8. Dron Epilogu / Pamięć Architektury (55/110/220 Hz organ drone)
  playCreditsDroneSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc1 = this.ctx.createOscillator();
    const osc2 = this.ctx.createOscillator();
    const osc3 = this.ctx.createOscillator();
    const gainNode = this.ctx.createGain();

    osc1.type = "sine";
    osc1.frequency.setValueAtTime(55, now); // A1
    osc2.type = "sine";
    osc2.frequency.setValueAtTime(110, now); // A2
    osc3.type = "sine";
    osc3.frequency.setValueAtTime(220, now); // A3

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.3, now + 0.3);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 2.2);

    osc1.connect(gainNode);
    osc2.connect(gainNode);
    osc3.connect(gainNode);
    gainNode.connect(this.analyser);

    osc1.start(now);
    osc2.start(now);
    osc3.start(now);
    osc1.stop(now + 2.25);
    osc2.stop(now + 2.25);
    osc3.stop(now + 2.25);
  }

  // 9. Krok po Posadzce Laboratoryjnej (180 Hz damped thud)
  playFootstepSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc = this.ctx.createOscillator();
    const gainNode = this.ctx.createGain();

    osc.type = "sine";
    osc.frequency.setValueAtTime(220, now);
    osc.frequency.exponentialRampToValueAtTime(60, now + 0.08);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.18, now + 0.01);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 0.09);

    osc.connect(gainNode);
    gainNode.connect(this.analyser);

    osc.start(now);
    osc.stop(now + 0.1);
  }

  // 10. Skok / Wybicie (Jump: 280 -> 480 Hz upward transient)
  playJumpSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc = this.ctx.createOscillator();
    const gainNode = this.ctx.createGain();

    osc.type = "triangle";
    osc.frequency.setValueAtTime(280, now);
    osc.frequency.exponentialRampToValueAtTime(520, now + 0.12);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.2, now + 0.01);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 0.14);

    osc.connect(gainNode);
    gainNode.connect(this.analyser);

    osc.start(now);
    osc.stop(now + 0.15);
  }

  // 11. Klik Przełącznika Hebelkowego / UI Beep
  playSwitchSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc = this.ctx.createOscillator();
    const gainNode = this.ctx.createGain();

    osc.type = "triangle";
    osc.frequency.setValueAtTime(1250, now);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.12, now + 0.005);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 0.04);

    osc.connect(gainNode);
    gainNode.connect(this.analyser);

    osc.start(now);
    osc.stop(now + 0.045);
  }

  // 12. Telefon Bakelitowy (920/1080 Hz podwójny dzwonek mechaniczny)
  playTelephoneRingSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc1 = this.ctx.createOscillator();
    const osc2 = this.ctx.createOscillator();
    const gainNode = this.ctx.createGain();

    osc1.type = "sine";
    osc1.frequency.setValueAtTime(920, now);
    osc2.type = "sine";
    osc2.frequency.setValueAtTime(1080, now);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.25, now + 0.02);
    gainNode.gain.setValueAtTime(0.25, now + 0.4);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 0.6);

    osc1.connect(gainNode);
    osc2.connect(gainNode);
    gainNode.connect(this.analyser);

    osc1.start(now);
    osc2.start(now);
    osc1.stop(now + 0.65);
    osc2.stop(now + 0.65);
  }

  // 13. Skaner Biometryczny (480 -> 1920 Hz sweep + 880 Hz gong autoryzacji)
  playBiometricScanSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc = this.ctx.createOscillator();
    const chime = this.ctx.createOscillator();
    const gainNode = this.ctx.createGain();
    const chimeGain = this.ctx.createGain();

    osc.type = "sawtooth";
    osc.frequency.setValueAtTime(480, now);
    osc.frequency.exponentialRampToValueAtTime(1920, now + 0.35);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.18, now + 0.05);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 0.4);

    chime.type = "sine";
    chime.frequency.setValueAtTime(880, now + 0.35);
    chimeGain.gain.setValueAtTime(0.0001, now);
    chimeGain.gain.setValueAtTime(0.0001, now + 0.34);
    chimeGain.gain.linearRampToValueAtTime(0.3, now + 0.36);
    chimeGain.gain.exponentialRampToValueAtTime(0.0001, now + 0.8);

    osc.connect(gainNode);
    chime.connect(chimeGain);
    gainNode.connect(this.analyser);
    chimeGain.connect(this.analyser);

    osc.start(now);
    chime.start(now + 0.35);
    osc.stop(now + 0.41);
    chime.stop(now + 0.85);
  }

  // 14. Gong Gabinetu UCP (Trzyton F5 698 Hz -> A5 880 Hz -> C6 1046 Hz)
  playClinicChimeSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const notes = [698.46, 880.0, 1046.5];
    notes.forEach((freq, i) => {
      const startTime = now + i * 0.14;
      const osc = this.ctx.createOscillator();
      const gain = this.ctx.createGain();

      osc.type = "sine";
      osc.frequency.setValueAtTime(freq, startTime);

      gain.gain.setValueAtTime(0.0001, now);
      gain.gain.setValueAtTime(0.0001, startTime);
      gain.gain.linearRampToValueAtTime(0.22, startTime + 0.015);
      gain.gain.exponentialRampToValueAtTime(0.0001, startTime + 0.55);

      osc.connect(gain);
      gain.connect(this.analyser);

      osc.start(startTime);
      osc.stop(startTime + 0.58);
    });
  }

  // 15. Szum Szybu Podstruktury (45/90 Hz głęboki ciąg powietrzny)
  playConduitShaftSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc1 = this.ctx.createOscillator();
    const osc2 = this.ctx.createOscillator();
    const filter = this.ctx.createBiquadFilter();
    const gainNode = this.ctx.createGain();

    osc1.type = "sawtooth";
    osc1.frequency.setValueAtTime(45, now);
    osc2.type = "sine";
    osc2.frequency.setValueAtTime(90, now);

    filter.type = "lowpass";
    filter.frequency.setValueAtTime(160, now);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.4, now + 0.2);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 1.2);

    osc1.connect(filter);
    osc2.connect(filter);
    filter.connect(gainNode);
    gainNode.connect(this.analyser);

    osc1.start(now);
    osc2.start(now);
    osc1.stop(now + 1.25);
    osc2.stop(now + 1.25);
  }

  // 16. Złota Obrączka (2349 Hz + 4698 Hz mikro-dzwonek rezonansowy)
  playGoldRingChimeSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc1 = this.ctx.createOscillator();
    const osc2 = this.ctx.createOscillator();
    const gainNode = this.ctx.createGain();

    osc1.type = "sine";
    osc1.frequency.setValueAtTime(2349.32, now); // D7
    osc2.type = "sine";
    osc2.frequency.setValueAtTime(4698.63, now); // D8

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.3, now + 0.005);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 0.9);

    osc1.connect(gainNode);
    osc2.connect(gainNode);
    gainNode.connect(this.analyser);

    osc1.start(now);
    osc2.start(now);
    osc1.stop(now + 0.95);
    osc2.stop(now + 0.95);
  }

  // 17. Nieciągły Cień (880 Hz whisper + 3.5 Hz slow tremolo)
  playDiscontinuousShadowWhisper() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const carrier = this.ctx.createOscillator();
    const lfo = this.ctx.createOscillator();
    const lfoGain = this.ctx.createGain();
    const mainGain = this.ctx.createGain();

    carrier.type = "sine";
    carrier.frequency.setValueAtTime(880, now);

    lfo.type = "sine";
    lfo.frequency.setValueAtTime(3.5, now);
    lfoGain.gain.setValueAtTime(0.15, now);

    lfo.connect(lfoGain);
    lfoGain.connect(mainGain.gain);

    mainGain.gain.setValueAtTime(0.2, now);

    carrier.connect(mainGain);
    mainGain.connect(this.analyser);

    lfo.start(now);
    carrier.start(now);
    lfo.stop(now + 0.8);
    carrier.stop(now + 0.8);
  }

  // 18. Wymazanie Biograficzne (Glitch sub-bass 62/31 Hz)
  playBiographicalErasureGlitch() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc = this.ctx.createOscillator();
    const filter = this.ctx.createBiquadFilter();
    const gainNode = this.ctx.createGain();

    osc.type = "sawtooth";
    osc.frequency.setValueAtTime(62, now);
    osc.frequency.linearRampToValueAtTime(31, now + 0.4);

    filter.type = "bandpass";
    filter.frequency.setValueAtTime(1450, now);
    filter.Q.value = 8.0;

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.35, now + 0.02);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 0.45);

    osc.connect(filter);
    filter.connect(gainNode);
    gainNode.connect(this.analyser);

    osc.start(now);
    osc.stop(now + 0.46);
  }

  // 19. Szum Jarzeniówek Laboratoryjnych (100 Hz hum + 3200 Hz ion buzz)
  playFluorescentFlickerSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const hum = this.ctx.createOscillator();
    const ion = this.ctx.createOscillator();
    const gain = this.ctx.createGain();

    hum.type = "triangle";
    hum.frequency.setValueAtTime(100, now);

    ion.type = "sawtooth";
    ion.frequency.setValueAtTime(3200, now);

    gain.gain.setValueAtTime(0.001, now);
    gain.gain.linearRampToValueAtTime(0.22, now + 0.05);
    gain.gain.exponentialRampToValueAtTime(0.0001, now + 0.55);

    hum.connect(gain);
    ion.connect(gain);
    gain.connect(this.analyser);

    hum.start(now);
    ion.start(now);
    hum.stop(now + 0.58);
    ion.stop(now + 0.58);
  }

  // 20. Szelest Papieru i Notatek Urzędowych (Dossier paper rustle)
  playPaperRustleSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc = this.ctx.createOscillator();
    const filter = this.ctx.createBiquadFilter();
    const gain = this.ctx.createGain();

    osc.type = "sawtooth";
    osc.frequency.setValueAtTime(1200, now);
    osc.frequency.exponentialRampToValueAtTime(2400, now + 0.15);

    filter.type = "bandpass";
    filter.frequency.setValueAtTime(1800, now);
    filter.Q.value = 3.0;

    gain.gain.setValueAtTime(0.001, now);
    gain.gain.linearRampToValueAtTime(0.2, now + 0.02);
    gain.gain.exponentialRampToValueAtTime(0.0001, now + 0.22);

    osc.connect(filter);
    filter.connect(gain);
    gain.connect(this.analyser);

    osc.start(now);
    osc.stop(now + 0.25);
  }

  // 21. Blipy Dialogowe Postaci (Procedural Voice Blips)
  playDialogueLenaSound() {
    this._playVoiceBlip(440, 880, "sine");
  }

  playDialogueJakubSound() {
    this._playVoiceBlip(370, 740, "triangle");
  }

  playDialogueWierzbickaSound() {
    this._playVoiceBlip(520, 1040, "sine");
  }

  playDialogueMartaSound() {
    this._playVoiceBlip(480, 960, "sine");
  }

  playDialogueSzymonSound() {
    this._playVoiceBlip(260, 520, "triangle");
  }

  playDialogueGuardSound() {
    this._playVoiceBlip(190, 380, "sawtooth");
  }

  _playVoiceBlip(f1, f2, type = "sine") {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc1 = this.ctx.createOscillator();
    const osc2 = this.ctx.createOscillator();
    const gain = this.ctx.createGain();

    osc1.type = type;
    osc1.frequency.setValueAtTime(f1, now);
    osc2.type = "sine";
    osc2.frequency.setValueAtTime(f2, now);

    gain.gain.setValueAtTime(0.001, now);
    gain.gain.linearRampToValueAtTime(0.18, now + 0.008);
    gain.gain.exponentialRampToValueAtTime(0.0001, now + 0.07);

    osc1.connect(gain);
    osc2.connect(gain);
    gain.connect(this.analyser);

    osc1.start(now);
    osc2.start(now);
    osc1.stop(now + 0.08);
    osc2.stop(now + 0.08);
  }

  // 22. Pneumatyczna Śluza Graniczna (Pneumatic Gate: 140 Hz thud + 2400 Hz air release)
  playPneumaticGateSound() {
    this.ensureContext();
    if (!this.ctx) return;
    const now = this.ctx.currentTime;
    const thud = this.ctx.createOscillator();
    const hiss = this.ctx.createOscillator();
    const filter = this.ctx.createBiquadFilter();
    const gain = this.ctx.createGain();

    thud.type = "sine";
    thud.frequency.setValueAtTime(140, now);
    thud.frequency.exponentialRampToValueAtTime(40, now + 0.3);

    hiss.type = "sawtooth";
    hiss.frequency.setValueAtTime(2400, now);

    filter.type = "bandpass";
    filter.frequency.setValueAtTime(1600, now);
    filter.Q.value = 2.0;

    gain.gain.setValueAtTime(0.001, now);
    gain.gain.linearRampToValueAtTime(0.35, now + 0.02);
    gain.gain.exponentialRampToValueAtTime(0.0001, now + 0.45);

    thud.connect(gain);
    hiss.connect(filter);
    filter.connect(gain);
    gain.connect(this.analyser);

    thud.start(now);
    hiss.start(now);
    thud.stop(now + 0.46);
    hiss.stop(now + 0.46);
  }

  // 23. Błysk i Spust Migawki Aparatu (Camera Flash: 420 Hz magnet + 2100 Hz shutter snap)
  playCameraFlashSound() {
    this.ensureContext();
    if (!this.ctx) return;
    const now = this.ctx.currentTime;
    const snap = this.ctx.createOscillator();
    const magnet = this.ctx.createOscillator();
    const gain = this.ctx.createGain();

    snap.type = "triangle";
    snap.frequency.setValueAtTime(2100, now);
    magnet.type = "sine";
    magnet.frequency.setValueAtTime(420, now);

    gain.gain.setValueAtTime(0.001, now);
    gain.gain.linearRampToValueAtTime(0.28, now + 0.005);
    gain.gain.exponentialRampToValueAtTime(0.0001, now + 0.25);

    snap.connect(gain);
    magnet.connect(gain);
    gain.connect(this.analyser);

    snap.start(now);
    magnet.start(now);
    snap.stop(now + 0.26);
    magnet.stop(now + 0.26);
  }

  // 24. Przewijanie Taśmy Szpulowej (Tape Rewind: 1200 -> 3600 Hz pitch spool)
  playTapeRewindSound() {
    this.ensureContext();
    if (!this.ctx) return;
    const now = this.ctx.currentTime;
    const osc = this.ctx.createOscillator();
    const gain = this.ctx.createGain();

    osc.type = "sawtooth";
    osc.frequency.setValueAtTime(1200, now);
    osc.frequency.exponentialRampToValueAtTime(3600, now + 0.35);

    gain.gain.setValueAtTime(0.001, now);
    gain.gain.linearRampToValueAtTime(0.2, now + 0.05);
    gain.gain.exponentialRampToValueAtTime(0.0001, now + 0.4);

    osc.connect(gain);
    gain.connect(this.analyser);

    osc.start(now);
    osc.stop(now + 0.42);
  }

  // 25. Synchronizacja Przekaźnika (Relay Alignment: 1120 Hz snap + 340 Hz coil hum)
  playRelayAlignmentSound() {
    this.ensureContext();
    if (!this.ctx) return;
    const now = this.ctx.currentTime;
    const snap = this.ctx.createOscillator();
    const coil = this.ctx.createOscillator();
    const gain = this.ctx.createGain();

    snap.type = "square";
    snap.frequency.setValueAtTime(1120, now);
    coil.type = "sine";
    coil.frequency.setValueAtTime(340, now);

    gain.gain.setValueAtTime(0.001, now);
    gain.gain.linearRampToValueAtTime(0.25, now + 0.008);
    gain.gain.exponentialRampToValueAtTime(0.0001, now + 0.18);

    snap.connect(gain);
    coil.connect(gain);
    gain.connect(this.analyser);

    snap.start(now);
    coil.start(now);
    snap.stop(now + 0.2);
    coil.stop(now + 0.2);
  }

  // 26. Jonizacja Neonówki Przemysłowej (Neon Ionization: 120 Hz buzz + 2800 Hz sizzle)
  playNeonIonizationSound() {
    this.ensureContext();
    if (!this.ctx) return;
    const now = this.ctx.currentTime;
    const buzz = this.ctx.createOscillator();
    const sizzle = this.ctx.createOscillator();
    const gain = this.ctx.createGain();

    buzz.type = "sawtooth";
    buzz.frequency.setValueAtTime(120, now);
    sizzle.type = "triangle";
    sizzle.frequency.setValueAtTime(2800, now);

    gain.gain.setValueAtTime(0.001, now);
    gain.gain.linearRampToValueAtTime(0.24, now + 0.04);
    gain.gain.exponentialRampToValueAtTime(0.0001, now + 0.5);

    buzz.connect(gain);
    sizzle.connect(gain);
    gain.connect(this.analyser);

    buzz.start(now);
    sizzle.start(now);
    buzz.stop(now + 0.52);
    sizzle.stop(now + 0.52);
  }

  // 27. Impuls Licznika Geigera / Galwanometru (Geiger Tick: 1650 Hz micro-transient)
  playGeigerTickSound() {
    this.ensureContext();
    if (!this.ctx) return;
    const now = this.ctx.currentTime;
    const osc = this.ctx.createOscillator();
    const gain = this.ctx.createGain();

    osc.type = "triangle";
    osc.frequency.setValueAtTime(1650, now);

    gain.gain.setValueAtTime(0.001, now);
    gain.gain.linearRampToValueAtTime(0.3, now + 0.002);
    gain.gain.exponentialRampToValueAtTime(0.0001, now + 0.03);

    osc.connect(gain);
    gain.connect(this.analyser);

    osc.start(now);
    osc.stop(now + 0.035);
  }

  // 28. Sweep Nośnej Kwantowej (Quantum Carrier Sweep: 740 Hz pure harmonic sweep)
  playCarrierSweepSound() {
    this.ensureContext();
    if (!this.ctx) return;
    const now = this.ctx.currentTime;
    const osc1 = this.ctx.createOscillator();
    const osc2 = this.ctx.createOscillator();
    const gain = this.ctx.createGain();

    osc1.type = "sine";
    osc1.frequency.setValueAtTime(740, now);
    osc1.frequency.exponentialRampToValueAtTime(1480, now + 0.4);

    osc2.type = "sine";
    osc2.frequency.setValueAtTime(370, now);
    osc2.frequency.exponentialRampToValueAtTime(740, now + 0.4);

    gain.gain.setValueAtTime(0.001, now);
    gain.gain.linearRampToValueAtTime(0.3, now + 0.05);
    gain.gain.exponentialRampToValueAtTime(0.0001, now + 0.5);

    osc1.connect(gain);
    osc2.connect(gain);
    gain.connect(this.analyser);

    osc1.start(now);
    osc2.start(now);
    osc1.stop(now + 0.52);
    osc2.stop(now + 0.52);
  }

  // 29. Pneumatyka Windy Szybowej (Elevator Hydraulic Hiss: 80 Hz sub + 3400 Hz decompress)
  playHydraulicHissSound() {
    this.ensureContext();
    if (!this.ctx) return;
    const now = this.ctx.currentTime;
    const sub = this.ctx.createOscillator();
    const hiss = this.ctx.createOscillator();
    const filter = this.ctx.createBiquadFilter();
    const gain = this.ctx.createGain();

    sub.type = "sine";
    sub.frequency.setValueAtTime(80, now);
    hiss.type = "sawtooth";
    hiss.frequency.setValueAtTime(3400, now);

    filter.type = "lowpass";
    filter.frequency.setValueAtTime(1200, now);

    gain.gain.setValueAtTime(0.001, now);
    gain.gain.linearRampToValueAtTime(0.32, now + 0.1);
    gain.gain.exponentialRampToValueAtTime(0.0001, now + 0.8);

    sub.connect(gain);
    hiss.connect(filter);
    filter.connect(gain);
    gain.connect(this.analyser);

    sub.start(now);
    hiss.start(now);
    sub.stop(now + 0.82);
    hiss.stop(now + 0.82);
  }

  // AMBIENT CONTINUOUS SOUNDSCAPES
  toggleAmbient(type) {
    if (this.activeAmbientType === type) {
      this.stopAmbient();
      return false;
    }
    this.startAmbient(type);
    return true;
  }

  startAmbient(type) {
    this.stopAmbient();
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const gainNode = this.ctx.createGain();
    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.15, now + 1.0);
    gainNode.connect(this.analyser);

    const nodes = [gainNode];

    if (type === "ikp_lab") {
      // 48 Hz + 96 Hz vacuum hum with 100 Hz fluorescent
      const osc1 = this.ctx.createOscillator();
      const osc2 = this.ctx.createOscillator();
      osc1.type = "sine";
      osc1.frequency.setValueAtTime(48, now);
      osc2.type = "sine";
      osc2.frequency.setValueAtTime(96, now);

      osc1.connect(gainNode);
      osc2.connect(gainNode);
      osc1.start(now);
      osc2.start(now);
      nodes.push(osc1, osc2);
    } else if (type === "substructure") {
      // Deep windy resonance 45 Hz + lowpass filter
      const osc = this.ctx.createOscillator();
      const filter = this.ctx.createBiquadFilter();
      osc.type = "sawtooth";
      osc.frequency.setValueAtTime(42, now);
      filter.type = "lowpass";
      filter.frequency.setValueAtTime(120, now);
      filter.Q.value = 5.0;

      osc.connect(filter);
      filter.connect(gainNode);
      osc.start(now);
      nodes.push(osc, filter);
    } else if (type === "line4_transit") {
      // Tram traction 50 Hz + 150 Hz harmonic
      const osc1 = this.ctx.createOscillator();
      const osc2 = this.ctx.createOscillator();
      osc1.type = "triangle";
      osc1.frequency.setValueAtTime(50, now);
      osc2.type = "sine";
      osc2.frequency.setValueAtTime(150, now);

      osc1.connect(gainNode);
      osc2.connect(gainNode);
      osc1.start(now);
      osc2.start(now);
      nodes.push(osc1, osc2);
    }

    this.activeAmbientNodes = nodes;
    this.activeAmbientType = type;
  }

  stopAmbient() {
    if (this.activeAmbientNodes && this.ctx) {
      const now = this.ctx.currentTime;
      const gainNode = this.activeAmbientNodes[0];
      if (gainNode && gainNode.gain) {
        gainNode.gain.linearRampToValueAtTime(0.0001, now + 0.5);
      }
      setTimeout(() => {
        if (this.activeAmbientNodes) {
          this.activeAmbientNodes.forEach(n => {
            if (n && typeof n.stop === 'function') {
              try { n.stop(); } catch(e) {}
            }
          });
          this.activeAmbientNodes = null;
        }
      }, 550);
    }
    this.activeAmbientType = null;
  }

  // 18. Wir Cieczy i Turbulencja Wektorowa (Fluid Vortex Swirl)
  playFluidVortexSwirl(vorticity = 3.5, speed = 1.0) {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc = this.ctx.createOscillator();
    const filter = this.ctx.createBiquadFilter();
    const gainNode = this.ctx.createGain();

    osc.type = "sawtooth";
    const baseFreq = 65 + Math.min(240, vorticity * 22);
    osc.frequency.setValueAtTime(baseFreq, now);
    osc.frequency.exponentialRampToValueAtTime(baseFreq * (1.2 + speed * 0.3), now + 0.25);

    filter.type = "bandpass";
    filter.frequency.setValueAtTime(baseFreq * 2.5, now);
    filter.Q.setValueAtTime(4.0 + vorticity * 0.8, now);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.22, now + 0.04);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 0.45);

    osc.connect(filter);
    filter.connect(gainNode);
    gainNode.connect(this.analyser);

    osc.start(now);
    osc.stop(now + 0.48);
  }

  // 19. Kropla Kondensacyjna (Condensation Drip: 1400..2800 Hz upward chirp + resonant tail)
  playCondensationDrip(pitch = 1800, pan = 0.0) {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc1 = this.ctx.createOscillator();
    const osc2 = this.ctx.createOscillator();
    const panner = this.ctx.createStereoPanner ? this.ctx.createStereoPanner() : null;
    const gainNode = this.ctx.createGain();

    osc1.type = "sine";
    osc1.frequency.setValueAtTime(pitch, now);
    osc1.frequency.exponentialRampToValueAtTime(pitch * 1.5, now + 0.06);

    osc2.type = "triangle";
    osc2.frequency.setValueAtTime(pitch * 0.5, now);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.28, now + 0.005);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 0.18);

    osc1.connect(gainNode);
    osc2.connect(gainNode);

    if (panner) {
      panner.pan.setValueAtTime(Math.max(-1, Math.min(1, pan)), now);
      gainNode.connect(panner);
      panner.connect(this.analyser);
    } else {
      gainNode.connect(this.analyser);
    }

    osc1.start(now);
    osc2.start(now);
    osc1.stop(now + 0.20);
    osc2.stop(now + 0.20);
  }

  // 20. Ścinanie Lepkości (Viscosity Shear Noise Burst)
  playViscosityShear(gain = 0.5) {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc = this.ctx.createOscillator();
    const filter = this.ctx.createBiquadFilter();
    const gainNode = this.ctx.createGain();

    osc.type = "triangle";
    osc.frequency.setValueAtTime(180, now);
    osc.frequency.linearRampToValueAtTime(90, now + 0.15);

    filter.type = "lowpass";
    filter.frequency.setValueAtTime(380, now);
    filter.Q.value = 6.0;

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.20 * Math.max(0.1, gain), now + 0.02);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 0.22);

    osc.connect(filter);
    filter.connect(gainNode);
    gainNode.connect(this.analyser);

    osc.start(now);
    osc.stop(now + 0.24);
  }

  // 21. Gradient Termiczny (Thermal Gradient Sweep)
  playThermalTransition(deltaT = 15) {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const osc = this.ctx.createOscillator();
    const gainNode = this.ctx.createGain();

    osc.type = "sine";
    const freq = 440 + deltaT * 8;
    osc.frequency.setValueAtTime(freq, now);
    osc.frequency.exponentialRampToValueAtTime(freq * 0.8, now + 0.35);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.25, now + 0.02);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + 0.40);

    osc.connect(gainNode);
    gainNode.connect(this.analyser);

    osc.start(now);
    osc.stop(now + 0.42);
  }

  // 42. Analizator Rezonansu Stochastycznego (Stochastic Resonance & Kramers Double-Well Hopping)
  playStochasticResonanceSound(noiseIntensity = 0.42, barrierHeight = 25.0, carrierFreq = 740.0) {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const dur = 0.75;

    // Carrier Oscillator
    const carrierOsc = this.ctx.createOscillator();
    const carrierGain = this.ctx.createGain();
    const carrierFilter = this.ctx.createBiquadFilter();

    // Noise Generator (Buffer Source)
    const bufferSize = Math.floor(this.ctx.sampleRate * dur);
    const noiseBuffer = this.ctx.createBuffer(1, bufferSize, this.ctx.sampleRate);
    const output = noiseBuffer.getChannelData(0);
    
    // Kramers hopping simulation in audio buffer
    let x = -1.0;
    const dt = 1.0 / this.ctx.sampleRate;
    const omega = 2 * Math.PI * carrierFreq;
    const dVal = Math.max(0.001, noiseIntensity);
    const snrFactor = Math.min(1.0, Math.exp(-barrierHeight / (dVal * 20)) / (dVal * dVal + 0.1) * 0.5);

    for (let i = 0; i < bufferSize; i++) {
      const white = (Math.random() * 2 - 1);
      x += (x - Math.pow(x, 3) + 0.3 * Math.cos(omega * i * dt)) * dt * 50 + Math.sqrt(2 * dVal * dt * 50) * white;
      if (x > 2.5) x = 2.5;
      if (x < -2.5) x = -2.5;
      output[i] = (white * Math.min(1.0, dVal) * 0.4 + (x * 0.3)) * 0.5;
    }

    const noiseSource = this.ctx.createBufferSource();
    noiseSource.buffer = noiseBuffer;

    const noiseFilter = this.ctx.createBiquadFilter();
    noiseFilter.type = "bandpass";
    noiseFilter.frequency.setValueAtTime(carrierFreq, now);
    noiseFilter.Q.setValueAtTime(4.0 + snrFactor * 12.0, now);

    const noiseGain = this.ctx.createGain();
    noiseGain.gain.setValueAtTime(0.001, now);
    noiseGain.gain.linearRampToValueAtTime(0.25 * Math.min(1.0, dVal + 0.1), now + 0.05);
    noiseGain.gain.exponentialRampToValueAtTime(0.0001, now + dur);

    carrierOsc.type = "sine";
    carrierOsc.frequency.setValueAtTime(carrierFreq, now);
    carrierFilter.type = "peaking";
    carrierFilter.frequency.setValueAtTime(carrierFreq, now);
    carrierFilter.Q.setValueAtTime(10.0, now);
    carrierFilter.gain.setValueAtTime(snrFactor * 18.0, now);

    const carrierAmp = Math.max(0.02, snrFactor * 0.35);
    carrierGain.gain.setValueAtTime(0.001, now);
    carrierGain.gain.linearRampToValueAtTime(carrierAmp, now + 0.04);
    carrierGain.gain.exponentialRampToValueAtTime(0.0001, now + dur);

    carrierOsc.connect(carrierFilter);
    carrierFilter.connect(carrierGain);
    carrierGain.connect(this.analyser);

    noiseSource.connect(noiseFilter);
    noiseFilter.connect(noiseGain);
    noiseGain.connect(this.analyser);

    carrierOsc.start(now);
    noiseSource.start(now);
    carrierOsc.stop(now + dur);
    noiseSource.stop(now + dur);
  }

  // 43. Wariacyjna Dynamika Pól Cechowania i Pętla Wilsona (Gauge Field Dynamics & SU(2) Holonomy)
  playGaugeCurvatureSound(wilsonPhase = 1.84, curvatureMax = 4.82) {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const dur = 0.85;

    // Dual SU(2) gauge harmonic oscillators
    const osc1 = this.ctx.createOscillator();
    const osc2 = this.ctx.createOscillator();
    const panner = this.ctx.createStereoPanner ? this.ctx.createStereoPanner() : null;
    const filter = this.ctx.createBiquadFilter();
    const masterGain = this.ctx.createGain();

    const f1 = 740.0;
    const f2 = 740.0 * (1.0 + (wilsonPhase / (2 * Math.PI)) * 0.35);

    osc1.type = "sine";
    osc1.frequency.setValueAtTime(f1, now);
    osc1.frequency.exponentialRampToValueAtTime(f1 * 0.92, now + dur);

    osc2.type = "triangle";
    osc2.frequency.setValueAtTime(f2, now);
    osc2.frequency.exponentialRampToValueAtTime(f2 * 1.05, now + dur);

    filter.type = "bandpass";
    filter.frequency.setValueAtTime(740.0 * Math.min(2.5, 1.0 + curvatureMax * 0.15), now);
    filter.Q.setValueAtTime(6.0, now);

    masterGain.gain.setValueAtTime(0.001, now);
    masterGain.gain.linearRampToValueAtTime(0.28, now + 0.03);
    masterGain.gain.exponentialRampToValueAtTime(0.0001, now + dur);

    if (panner) {
      panner.pan.setValueAtTime(-0.6, now);
      panner.pan.linearRampToValueAtTime(0.6, now + dur);
      osc1.connect(filter);
      osc2.connect(filter);
      filter.connect(panner);
      panner.connect(masterGain);
    } else {
      osc1.connect(filter);
      osc2.connect(filter);
      filter.connect(masterGain);
    }

    masterGain.connect(this.analyser);

    osc1.start(now);
    osc2.start(now);
    osc1.stop(now + dur);
    osc2.stop(now + dur);
  }

  // 44. Rezonans Magnetyczny i Dynamiczna Podatność Poldera (Magnetic Susceptibility & FMR)
  playMagneticResonanceSound(f0 = 740.0, gamma = 45.0, fmr = 740.0) {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const dur = 1.10;

    const osc1 = this.ctx.createOscillator();
    const osc2 = this.ctx.createOscillator();
    const subOsc = this.ctx.createOscillator();
    const filter = this.ctx.createBiquadFilter();
    const gainNode = this.ctx.createGain();

    osc1.type = "sine";
    osc1.frequency.setValueAtTime(f0, now);
    osc2.type = "triangle";
    osc2.frequency.setValueAtTime(fmr * 1.5, now);
    osc2.frequency.exponentialRampToValueAtTime(fmr, now + dur * 0.5);

    subOsc.type = "sine";
    subOsc.frequency.setValueAtTime(48.0, now);

    filter.type = "bandpass";
    filter.frequency.setValueAtTime(fmr, now);
    filter.Q.setValueAtTime(Math.max(2.0, (fmr / Math.max(10.0, gamma))), now);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.32, now + 0.04);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + dur);

    osc1.connect(filter);
    osc2.connect(filter);
    subOsc.connect(gainNode);
    filter.connect(gainNode);
    gainNode.connect(this.analyser);

    osc1.start(now);
    osc2.start(now);
    subOsc.start(now);
    osc1.stop(now + dur);
    osc2.stop(now + dur);
    subOsc.stop(now + dur);
  }

  // 45. Szum Barkhausena — Przeskoki Domen Magnetycznych w Żeliwie Tunelu (Barkhausen Noise Avalanche)
  playBarkhausenNoiseSound(currentA = 650.0, density = 1.0) {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const dur = 0.85;
    const sampleRate = this.ctx.sampleRate;
    const bufferSize = Math.floor(sampleRate * dur);
    const noiseBuffer = this.ctx.createBuffer(1, bufferSize, sampleRate);
    const output = noiseBuffer.getChannelData(0);

    for (let i = 0; i < bufferSize; i++) {
      const t = i / sampleRate;
      // Discrete stochastic avalanche spikes
      const isAvalanche = Math.random() < (0.02 * density);
      const spike = isAvalanche ? (Math.random() * 2 - 1) * Math.exp(-((i % 120) / 30)) : 0;
      const thermal = (Math.random() * 2 - 1) * 0.12;
      output[i] = (spike * 0.75 + thermal) * Math.exp(-t * 2.5);
    }

    const noiseSrc = this.ctx.createBufferSource();
    noiseSrc.buffer = noiseBuffer;

    const filter = this.ctx.createBiquadFilter();
    filter.type = "highpass";
    filter.frequency.setValueAtTime(800.0, now);

    const gainNode = this.ctx.createGain();
    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.35 * Math.min(1.5, currentA / 500.0), now + 0.02);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + dur);

    noiseSrc.connect(filter);
    filter.connect(gainNode);
    gainNode.connect(this.analyser);

    noiseSrc.start(now);
    noiseSrc.stop(now + dur);
  }

  // 46. Precesja i Tłumienie Landaua-Lifshitza-Gilberta (LLG Spiral Spin Precession)
  playLlgPrecessionSound(alpha = 0.045, tau = 14.2) {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const dur = Math.min(1.5, Math.max(0.4, (tau / 10.0) * 0.8 + 0.3));

    const osc = this.ctx.createOscillator();
    const subOsc = this.ctx.createOscillator();
    const gainNode = this.ctx.createGain();

    osc.type = "sine";
    osc.frequency.setValueAtTime(2400.0, now);
    // Frequency decays down to equilibrium 740 Hz following Gilbert relaxation
    osc.frequency.exponentialRampToValueAtTime(740.0, now + dur * 0.85);

    subOsc.type = "triangle";
    subOsc.frequency.setValueAtTime(140.0, now);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.30, now + 0.02);
    // Damping envelope proportional to Gilbert alpha
    const decayRate = 2.0 + alpha * 15.0;
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + dur);

    osc.connect(gainNode);
    subOsc.connect(gainNode);
    gainNode.connect(this.analyser);

    osc.start(now);
    subOsc.start(now);
    osc.stop(now + dur);
    subOsc.stop(now + dur);
  }

  // 47. Przełączenie Ferrimagnetyczne i Zapadka Rdzenia (Ferrimagnetic Remanence Switch)
  playFerrimagneticSwitchSound() {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const dur = 0.50;

    const oscSnap = this.ctx.createOscillator();
    const oscThud = this.ctx.createOscillator();
    const gainNode = this.ctx.createGain();

    oscSnap.type = "sawtooth";
    oscSnap.frequency.setValueAtTime(1850.0, now);
    oscSnap.frequency.exponentialRampToValueAtTime(420.0, now + 0.15);

    oscThud.type = "sine";
    oscThud.frequency.setValueAtTime(320.0, now);
    oscThud.frequency.exponentialRampToValueAtTime(80.0, now + 0.25);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.40, now + 0.008);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + dur);

    oscSnap.connect(gainNode);
    oscThud.connect(gainNode);
    gainNode.connect(this.analyser);

    oscSnap.start(now);
    oscThud.start(now);
    oscSnap.stop(now + dur);
    oscThud.stop(now + dur);
  }

  // 48. Termoelektryczny Świst Sprzężenia Onsagera (Seebeck-Peltier Thermoelectric Whistle) (PKG-0087)
  playOnsagerThermoelectricWhistle(gradT = 1.2, gradMu = 0.5, gradSpin = 1.0) {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const dur = 1.20;

    const osc1 = this.ctx.createOscillator();
    const osc2 = this.ctx.createOscillator();
    const subOsc = this.ctx.createOscillator();
    const filter = this.ctx.createBiquadFilter();
    const gainNode = this.ctx.createGain();

    const baseFreq = 740.0 + Math.min(600, gradT * 180.0);
    osc1.type = "sine";
    osc1.frequency.setValueAtTime(baseFreq, now);
    osc1.frequency.linearRampToValueAtTime(baseFreq * 0.85, now + dur * 0.7);

    osc2.type = "triangle";
    osc2.frequency.setValueAtTime(baseFreq * 1.5, now);
    osc2.frequency.exponentialRampToValueAtTime(baseFreq * 0.75, now + dur);

    subOsc.type = "sine";
    subOsc.frequency.setValueAtTime(88.0 + gradSpin * 12.0, now);

    filter.type = "bandpass";
    filter.frequency.setValueAtTime(baseFreq, now);
    filter.Q.setValueAtTime(5.0 + gradMu * 2.0, now);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.35, now + 0.03);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + dur);

    osc1.connect(filter);
    osc2.connect(filter);
    filter.connect(gainNode);
    subOsc.connect(gainNode);
    gainNode.connect(this.analyser);

    osc1.start(now);
    osc2.start(now);
    subOsc.start(now);
    osc1.stop(now + dur);
    osc2.stop(now + dur);
    subOsc.stop(now + dur);
  }

  // 49. Puls Produkcji Entropii (Entropy Production Pulse) (PKG-0087)
  playEntropyProductionPulse(entropyRate = 1.24) {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const dur = 0.95;

    const subOsc = this.ctx.createOscillator();
    const h1Osc = this.ctx.createOscillator();
    const h2Osc = this.ctx.createOscillator();
    const gainNode = this.ctx.createGain();

    subOsc.type = "sine";
    subOsc.frequency.setValueAtTime(58.0, now);

    h1Osc.type = "triangle";
    h1Osc.frequency.setValueAtTime(116.0, now);

    h2Osc.type = "sine";
    h2Osc.frequency.setValueAtTime(232.0, now);

    const amp = Math.min(0.45, 0.15 + entropyRate * 0.12);
    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(amp, now + 0.02);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + dur);

    subOsc.connect(gainNode);
    h1Osc.connect(gainNode);
    h2Osc.connect(gainNode);
    gainNode.connect(this.analyser);

    subOsc.start(now);
    h1Osc.start(now);
    h2Osc.start(now);
    subOsc.stop(now + dur);
    h1Osc.stop(now + dur);
    h2Osc.stop(now + dur);
  }

  // 50. Snap Relaksacji Stacjonarnej Prigogine'a (Prigogine Minimum Dissipation Snap) (PKG-0087)
  playPrigogineRelaxationSnap(relaxTime = 0.70) {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const dur = Math.max(0.3, Math.min(1.2, relaxTime));

    const snapOsc = this.ctx.createOscillator();
    const humOsc = this.ctx.createOscillator();
    const gainNode = this.ctx.createGain();

    snapOsc.type = "sawtooth";
    snapOsc.frequency.setValueAtTime(920.0, now);
    snapOsc.frequency.exponentialRampToValueAtTime(184.0, now + 0.12);

    humOsc.type = "sine";
    humOsc.frequency.setValueAtTime(44.0, now);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.38, now + 0.006);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + dur);

    snapOsc.connect(gainNode);
    humOsc.connect(gainNode);
    gainNode.connect(this.analyser);

    snapOsc.start(now);
    humOsc.start(now);
    snapOsc.stop(now + dur);
    humOsc.stop(now + dur);
  }

  // 51. Szum Fluktuacji Termodynamicznych Einsteina-Onsagera (Thermal Fluctuation Noise) (PKG-0087)
  playThermalFluctuationNoise(intensity = 0.5) {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const dur = 1.0;

    const bufferSize = Math.floor(this.ctx.sampleRate * dur);
    const noiseBuffer = this.ctx.createBuffer(1, bufferSize, this.ctx.sampleRate);
    const output = noiseBuffer.getChannelData(0);

    let lastOut = 0.0;
    for (let i = 0; i < bufferSize; i++) {
      const white = (Math.random() * 2 - 1);
      lastOut = (lastOut + (0.02 * white)) / 1.02; // Brown/pink filter
      output[i] = (lastOut * 3.5 + white * 0.1) * intensity;
    }

    const noiseSrc = this.ctx.createBufferSource();
    noiseSrc.buffer = noiseBuffer;

    const filter = this.ctx.createBiquadFilter();
    filter.type = "bandpass";
    filter.frequency.setValueAtTime(740.0, now);
    filter.Q.setValueAtTime(3.5, now);

    const gainNode = this.ctx.createGain();
    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.28 * intensity, now + 0.04);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + dur);

    noiseSrc.connect(filter);
    filter.connect(gainNode);
    gainNode.connect(this.analyser);

    noiseSrc.start(now);
    noiseSrc.stop(now + dur);
  }

  // 52. Mikro-Świst Fluktuacji Próżni Kwantowej (Quantum Vacuum Zero-Point Whistle) (PKG-0088)
  playQuantumVacuumWhistle(freq = 1480.0, flutter = 1.0) {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const dur = 1.20;

    const osc1 = this.ctx.createOscillator();
    const osc2 = this.ctx.createOscillator();
    const subOsc = this.ctx.createOscillator();
    const filter = this.ctx.createBiquadFilter();
    const gainNode = this.ctx.createGain();

    osc1.type = "sine";
    osc1.frequency.setValueAtTime(freq, now);
    osc1.frequency.exponentialRampToValueAtTime(freq * 2.5, now + dur * 0.9);

    osc2.type = "triangle";
    osc2.frequency.setValueAtTime(freq * 1.5, now);
    osc2.frequency.exponentialRampToValueAtTime(freq * 3.75, now + dur);

    subOsc.type = "sine";
    subOsc.frequency.setValueAtTime(740.0, now);

    filter.type = "highpass";
    filter.frequency.setValueAtTime(1200.0, now);
    filter.Q.setValueAtTime(8.0 * flutter, now);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.32, now + 0.03);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + dur);

    osc1.connect(filter);
    osc2.connect(filter);
    subOsc.connect(gainNode);
    filter.connect(gainNode);
    gainNode.connect(this.analyser);

    osc1.start(now);
    osc2.start(now);
    subOsc.start(now);
    osc1.stop(now + dur);
    osc2.stop(now + dur);
    subOsc.stop(now + dur);
  }

  // 53. Rezonansowy Syk Siły Casimira w Szczelinie Szwu 40 mm (Casimir Cavity Hiss) (PKG-0088)
  playCasimirCavityHiss(separationMm = 40.0, force = 1.0) {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const dur = 1.05;

    const mode1 = this.ctx.createOscillator();
    const mode2 = this.ctx.createOscillator();
    const thump = this.ctx.createOscillator();
    const filter = this.ctx.createBiquadFilter();
    const gainNode = this.ctx.createGain();

    const f1 = 880.0 * (40.0 / Math.max(5.0, separationMm));
    mode1.type = "sine";
    mode1.frequency.setValueAtTime(f1, now);

    mode2.type = "triangle";
    mode2.frequency.setValueAtTime(f1 * 2.0, now);

    thump.type = "sawtooth";
    thump.frequency.setValueAtTime(110.0, now);
    thump.frequency.exponentialRampToValueAtTime(55.0, now + 0.2);

    filter.type = "bandpass";
    filter.frequency.setValueAtTime(f1, now);
    filter.Q.setValueAtTime(6.0, now);

    const amp = Math.min(0.48, 0.20 + force * 0.15);
    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(amp, now + 0.02);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + dur);

    mode1.connect(filter);
    mode2.connect(filter);
    thump.connect(gainNode);
    filter.connect(gainNode);
    gainNode.connect(this.analyser);

    mode1.start(now);
    mode2.start(now);
    thump.start(now);
    mode1.stop(now + dur);
    mode2.stop(now + dur);
    thump.stop(now + dur);
  }

  // 54. Basowy Puls Ujemnej Gęstości Energii Próżni (Negative Energy Pulse) (PKG-0088)
  playNegativeEnergyPulse(amplitude = 1.0) {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const dur = 1.30;

    const sub36 = this.ctx.createOscillator();
    const sub72 = this.ctx.createOscillator();
    const whine740 = this.ctx.createOscillator();
    const gainNode = this.ctx.createGain();

    sub36.type = "sine";
    sub36.frequency.setValueAtTime(36.0, now);

    sub72.type = "triangle";
    sub72.frequency.setValueAtTime(72.0, now);

    whine740.type = "sine";
    whine740.frequency.setValueAtTime(740.0, now);

    const gainAmp = Math.min(0.50, 0.25 * amplitude);
    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(gainAmp, now + 0.05);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + dur);

    sub36.connect(gainNode);
    sub72.connect(gainNode);
    whine740.connect(gainNode);
    gainNode.connect(this.analyser);

    sub36.start(now);
    sub72.start(now);
    whine740.start(now);
    sub36.stop(now + dur);
    sub72.stop(now + dur);
    whine740.stop(now + dur);
  }

  // 55. Metaliczny Snap Przyciągania Płyt Lifshitza (Lifshitz Retarded Snap) (PKG-0088)
  playLifshitzRetardedSnap(distanceMm = 40.0, dielectric = 1.0) {
    this.ensureContext();
    if (!this.ctx) return;

    const now = this.ctx.currentTime;
    const dur = 0.65;

    const snap = this.ctx.createOscillator();
    const contact = this.ctx.createOscillator();
    const filter = this.ctx.createBiquadFilter();
    const gainNode = this.ctx.createGain();

    const snapFreq = 1250.0 * (40.0 / Math.max(10.0, distanceMm));
    snap.type = "triangle";
    snap.frequency.setValueAtTime(snapFreq, now);
    snap.frequency.exponentialRampToValueAtTime(snapFreq * 2.0, now + 0.05);

    contact.type = "sawtooth";
    contact.frequency.setValueAtTime(220.0, now);
    contact.frequency.exponentialRampToValueAtTime(55.0, now + 0.15);

    filter.type = "bandpass";
    filter.frequency.setValueAtTime(snapFreq, now);
    filter.Q.setValueAtTime(4.0 * dielectric, now);

    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.42, now + 0.004);
    gainNode.gain.exponentialRampToValueAtTime(0.0001, now + dur);

    snap.connect(filter);
    filter.connect(gainNode);
    contact.connect(gainNode);
    gainNode.connect(this.analyser);

    snap.start(now);
    contact.start(now);
    snap.stop(now + dur);
    contact.stop(now + dur);
  }
}

/**
 * GETTING STRANGE — Polyphonic Retro-Synth Engine
 * Multi-voice melodic synth supporting arpeggiation, ADSR envelopes, resonant lowpass filters,
 * and canonical retro-futuristic themes synthesized entirely in real-time via Web Audio API.
 */
class PolyphonicRetroSynth {
  constructor(audioApparatus) {
    this.audio = audioApparatus;
    this.isPlaying = false;
    this.currentTheme = "carrier740";
    this.tempo = 110;
    this.waveform = "sawtooth";
    this.filterCutoff = 1800;
    this.isArp = true;
    this.stepIndex = 0;
    this.stepTimer = null;
    this.activeVoices = [];

    // Canonical Musical Themes
    this.themes = {
      carrier740: {
        id: "carrier740",
        namePl: "Motyw Leny (Nośna 740 Hz)",
        nameEn: "Lena's Theme (740 Hz Carrier)",
        bpm: 105,
        waveform: "sawtooth",
        filter: 2200,
        scale: "E Minor Pentatonic",
        // Frequencies in Hz: E3(164.81), G3(196), A3(220), B3(246.94), D4(293.66), E4(329.63), G4(392), A4(440), B4(493.88), D5(587.33), E5(659.25), F#5(739.99/Carrier)
        bassNotes: [164.81, 164.81, 196.0, 220.0, 164.81, 164.81, 246.94, 220.0],
        melodyNotes: [329.63, 392.0, 440.0, 493.88, 587.33, 739.99, 587.33, 493.88, 440.0, 392.0, 329.63, 739.99, 493.88, 440.0, 392.0, 329.63]
      },
      line4_transit: {
        id: "line4_transit",
        namePl: "Trakcja Linii 4 (Dorian Synthwave)",
        nameEn: "Line 4 Transit (Dorian Synthwave)",
        bpm: 124,
        waveform: "triangle",
        filter: 2600,
        scale: "D Dorian Mode",
        bassNotes: [146.83, 146.83, 174.61, 196.0, 220.0, 220.0, 196.0, 164.81],
        melodyNotes: [293.66, 349.23, 392.0, 440.0, 493.88, 587.33, 523.25, 440.0, 392.0, 349.23, 293.66, 440.0, 493.88, 587.33, 440.0, 293.66]
      },
      flat14_elegy: {
        id: "flat14_elegy",
        namePl: "Elegia Mieszkania 14 (Pamięć Relacyjna)",
        nameEn: "Flat 14 Elegy (Relational Memory)",
        bpm: 76,
        waveform: "sine",
        filter: 1200,
        scale: "A Natural Minor",
        bassNotes: [110.0, 110.0, 130.81, 146.83, 110.0, 110.0, 164.81, 146.83],
        melodyNotes: [440.0, 493.88, 523.25, 659.25, 523.25, 493.88, 440.0, 392.0, 329.63, 440.0, 523.25, 659.25, 523.25, 440.0, 329.63, 220.0]
      },
      substructure_requiem: {
        id: "substructure_requiem",
        namePl: "Hymn Podstruktury (Sub-Bass -40m)",
        nameEn: "Substructure Requiem (Sub-Bass -40m)",
        bpm: 88,
        waveform: "sawtooth",
        filter: 950,
        scale: "D Minor Harmonic",
        bassNotes: [73.42, 73.42, 87.31, 98.0, 73.42, 73.42, 110.0, 98.0],
        melodyNotes: [293.66, 311.13, 369.99, 440.0, 466.16, 554.37, 440.0, 369.99, 293.66, 369.99, 440.0, 554.37, 440.0, 311.13, 293.66, 146.83]
      }
    };
  }

  selectTheme(themeId) {
    if (!this.themes[themeId]) return;
    this.currentTheme = themeId;
    const t = this.themes[themeId];
    this.tempo = t.bpm;
    this.waveform = t.waveform;
    this.filterCutoff = t.filter;
    this.stepIndex = 0;
  }

  play() {
    this.audio.ensureContext();
    if (!this.audio.ctx) return;
    if (this.isPlaying) return;

    this.isPlaying = true;
    this.stepIndex = 0;
    this._scheduleNextTick();
  }

  stop() {
    this.isPlaying = false;
    if (this.stepTimer) {
      clearTimeout(this.stepTimer);
      this.stepTimer = null;
    }
    this._clearActiveVoices();
  }

  toggle() {
    if (this.isPlaying) this.stop();
    else this.play();
    return this.isPlaying;
  }

  setTempo(bpm) {
    this.tempo = Math.max(50, Math.min(220, bpm));
  }

  setWaveform(wf) {
    if (["sine", "triangle", "sawtooth", "square"].includes(wf)) {
      this.waveform = wf;
    }
  }

  setFilterCutoff(freq) {
    this.filterCutoff = Math.max(150, Math.min(8000, freq));
  }

  toggleArp(enabled) {
    this.isArp = enabled !== undefined ? enabled : !this.isArp;
  }

  _scheduleNextTick() {
    if (!this.isPlaying) return;
    const stepDurationMs = (60 / this.tempo / 4) * 1000; // 16th notes

    this._triggerStep(this.stepIndex);
    this.stepIndex = (this.stepIndex + 1) % 16;

    this.stepTimer = setTimeout(() => {
      this._scheduleNextTick();
    }, stepDurationMs);
  }

  _triggerStep(step) {
    const t = this.themes[this.currentTheme];
    if (!t) return;

    const ctx = this.audio.ctx;
    if (!ctx) return;

    const now = ctx.currentTime;
    const stepDuration = 60 / this.tempo / 4;

    // 1. Bass Voice on Quarter notes (0, 4, 8, 12)
    if (step % 2 === 0) {
      const bassIndex = Math.floor(step / 2) % t.bassNotes.length;
      const bassFreq = t.bassNotes[bassIndex];
      this._synthesizeBassNote(bassFreq, now, stepDuration * 1.8);
    }

    // 2. Lead Arpeggio Voice on 16th notes
    if (this.isArp || step % 2 === 0) {
      const melFreq = t.melodyNotes[step % t.melodyNotes.length];
      this._synthesizeLeadNote(melFreq, now, stepDuration * 0.85);
    }

    // Notify UI listener if registered
    if (typeof this.onStepTick === "function") {
      this.onStepTick(step, t.id);
    }
  }

  _synthesizeLeadNote(freq, startTime, duration) {
    const ctx = this.audio.ctx;
    const osc = ctx.createOscillator();
    const filter = ctx.createBiquadFilter();
    const gain = ctx.createGain();

    osc.type = this.waveform;
    osc.frequency.setValueAtTime(freq, startTime);

    filter.type = "lowpass";
    filter.frequency.setValueAtTime(this.filterCutoff, startTime);
    filter.frequency.exponentialRampToValueAtTime(this.filterCutoff * 0.4, startTime + duration);
    filter.Q.value = 4.5;

    gain.gain.setValueAtTime(0.0001, startTime);
    gain.gain.linearRampToValueAtTime(0.22, startTime + 0.015);
    gain.gain.exponentialRampToValueAtTime(0.0001, startTime + duration);

    osc.connect(filter);
    filter.connect(gain);
    gain.connect(this.audio.analyser);

    osc.start(startTime);
    osc.stop(startTime + duration + 0.05);

    this.activeVoices.push(osc);
    setTimeout(() => {
      const idx = this.activeVoices.indexOf(osc);
      if (idx !== -1) this.activeVoices.splice(idx, 1);
    }, (duration + 0.1) * 1000);
  }

  _synthesizeBassNote(freq, startTime, duration) {
    const ctx = this.audio.ctx;
    const osc = ctx.createOscillator();
    const subOsc = ctx.createOscillator();
    const filter = ctx.createBiquadFilter();
    const gain = ctx.createGain();

    osc.type = "sawtooth";
    osc.frequency.setValueAtTime(freq, startTime);

    subOsc.type = "sine";
    subOsc.frequency.setValueAtTime(freq / 2, startTime);

    filter.type = "lowpass";
    filter.frequency.setValueAtTime(this.filterCutoff * 0.6, startTime);
    filter.Q.value = 3.0;

    gain.gain.setValueAtTime(0.0001, startTime);
    gain.gain.linearRampToValueAtTime(0.28, startTime + 0.02);
    gain.gain.exponentialRampToValueAtTime(0.0001, startTime + duration);

    osc.connect(filter);
    subOsc.connect(filter);
    filter.connect(gain);
    gain.connect(this.audio.analyser);

    osc.start(startTime);
    subOsc.start(startTime);
    osc.stop(startTime + duration + 0.05);
    subOsc.stop(startTime + duration + 0.05);

    this.activeVoices.push(osc, subOsc);
    setTimeout(() => {
      let idx = this.activeVoices.indexOf(osc);
      if (idx !== -1) this.activeVoices.splice(idx, 1);
      idx = this.activeVoices.indexOf(subOsc);
      if (idx !== -1) this.activeVoices.splice(idx, 1);
    }, (duration + 0.1) * 1000);
  }

  _clearActiveVoices() {
    this.activeVoices.forEach(v => {
      try { v.stop(); } catch(e) {}
    });
    this.activeVoices = [];
  }
}

/**
 * GETTING STRANGE — Custom Signal Designer & WAV Exporter
 * Interactive parametric signal synthesizer with ADSR envelopes and client-side WAV export.
 */
class CustomSignalDesigner {
  constructor(audioApparatus) {
    this.audio = audioApparatus;
  }

  play(params = {}) {
    this.audio.ensureContext();
    if (!this.audio.ctx) return;
    const ctx = this.audio.ctx;
    const now = ctx.currentTime;

    const freq = params.freq || 440;
    const wave = params.waveform || "sine";
    const attack = Math.max(0.005, params.attack !== undefined ? params.attack : 0.03);
    const decay = Math.max(0.01, params.decay !== undefined ? params.decay : 0.12);
    const sustain = Math.max(0.01, Math.min(1, params.sustain !== undefined ? params.sustain : 0.6));
    const release = Math.max(0.01, params.release !== undefined ? params.release : 0.35);
    const filterFreq = params.filterCutoff || 2400;
    const filterQ = params.filterQ || 2.5;

    const osc = ctx.createOscillator();
    const filter = ctx.createBiquadFilter();
    const gain = ctx.createGain();

    if (wave === "noise") {
      // Noise generator buffer
      const bufferSize = ctx.sampleRate * 0.8;
      const noiseBuffer = ctx.createBuffer(1, bufferSize, ctx.sampleRate);
      const output = noiseBuffer.getChannelData(0);
      for (let i = 0; i < bufferSize; i++) {
        output[i] = Math.random() * 2 - 1;
      }
      const whiteNoise = ctx.createBufferSource();
      whiteNoise.buffer = noiseBuffer;
      whiteNoise.loop = true;

      filter.type = "bandpass";
      filter.frequency.setValueAtTime(freq, now);
      filter.Q.value = filterQ;

      const totalDuration = attack + decay + 0.35 + release;
      gain.gain.setValueAtTime(0.0001, now);
      gain.gain.linearRampToValueAtTime(0.35, now + attack);
      gain.gain.linearRampToValueAtTime(0.35 * sustain, now + attack + decay);
      gain.gain.setValueAtTime(0.35 * sustain, now + attack + decay + 0.35);
      gain.gain.exponentialRampToValueAtTime(0.0001, now + totalDuration);

      whiteNoise.connect(filter);
      filter.connect(gain);
      gain.connect(this.audio.analyser);

      whiteNoise.start(now);
      whiteNoise.stop(now + totalDuration + 0.05);
      return;
    }

    osc.type = wave;
    osc.frequency.setValueAtTime(freq, now);

    filter.type = "lowpass";
    filter.frequency.setValueAtTime(filterFreq, now);
    filter.Q.value = filterQ;

    const totalDuration = attack + decay + 0.35 + release;
    gain.gain.setValueAtTime(0.0001, now);
    gain.gain.linearRampToValueAtTime(0.35, now + attack);
    gain.gain.linearRampToValueAtTime(0.35 * sustain, now + attack + decay);
    gain.gain.setValueAtTime(0.35 * sustain, now + attack + decay + 0.35);
    gain.gain.exponentialRampToValueAtTime(0.0001, now + totalDuration);

    osc.connect(filter);
    filter.connect(gain);
    gain.connect(this.audio.analyser);

    osc.start(now);
    osc.stop(now + totalDuration + 0.05);
  }

  generateWavBlob(params = {}) {
    const sampleRate = 44100;
    const freq = params.freq || 440;
    const wave = params.waveform || "sine";
    const attack = Math.max(0.005, params.attack !== undefined ? params.attack : 0.03);
    const decay = Math.max(0.01, params.decay !== undefined ? params.decay : 0.12);
    const sustain = Math.max(0.01, Math.min(1, params.sustain !== undefined ? params.sustain : 0.6));
    const release = Math.max(0.01, params.release !== undefined ? params.release : 0.35);
    const sustainHold = 0.45;
    const totalDuration = attack + decay + sustainHold + release;
    const numSamples = Math.floor(sampleRate * totalDuration);

    const buffer = new Int16Array(numSamples);
    for (let i = 0; i < numSamples; i++) {
      const t = i / sampleRate;
      let env = 0;
      if (t < attack) {
        env = t / attack;
      } else if (t < attack + decay) {
        const dRatio = (t - attack) / decay;
        env = 1.0 - dRatio * (1.0 - sustain);
      } else if (t < attack + decay + sustainHold) {
        env = sustain;
      } else {
        const rRatio = (t - (attack + decay + sustainHold)) / release;
        env = sustain * Math.max(0, 1.0 - rRatio);
      }

      let sample = 0;
      const phase = 2 * Math.PI * freq * t;
      if (wave === "sine") {
        sample = Math.sin(phase);
      } else if (wave === "triangle") {
        sample = (2 / Math.PI) * Math.asin(Math.sin(phase));
      } else if (wave === "sawtooth") {
        sample = 2 * (t * freq - Math.floor(0.5 + t * freq));
      } else if (wave === "square") {
        sample = Math.sin(phase) >= 0 ? 1 : -1;
      } else if (wave === "noise") {
        sample = Math.random() * 2 - 1;
      }

      buffer[i] = Math.floor(sample * env * 32767 * 0.75);
    }

    const wavBuffer = new ArrayBuffer(44 + numSamples * 2);
    const view = new DataView(wavBuffer);

    function writeString(view, offset, string) {
      for (let i = 0; i < string.length; i++) {
        view.setUint8(offset + i, string.charCodeAt(i));
      }
    }

    writeString(view, 0, 'RIFF');
    view.setUint32(4, 36 + numSamples * 2, true);
    writeString(view, 8, 'WAVE');
    writeString(view, 12, 'fmt ');
    view.setUint32(16, 16, true);
    view.setUint16(20, 1, true); // PCM
    view.setUint16(22, 1, true); // Mono
    view.setUint32(24, sampleRate, true);
    view.setUint32(28, sampleRate * 2, true);
    view.setUint16(32, 2, true);
    view.setUint16(34, 16, true); // 16-bit
    writeString(view, 36, 'data');
    view.setUint32(40, numSamples * 2, true);

    for (let i = 0; i < numSamples; i++) {
      view.setInt16(44 + i * 2, buffer[i], true);
    }

    return new Blob([wavBuffer], { type: 'audio/wav' });
  }
}

/**
 * GETTING STRANGE — Reel-to-Reel Tape Recorder (Magnetofon Szpulowy Tonik-78)
 * Authentic analogue tape simulation with wow & flutter, tape saturation, variable speeds,
 * dual VU meters, and historical archival wiretaps from 1978.
 */
class ReelToReelTapeDeck {
  constructor(audioApparatus) {
    this.audio = audioApparatus;
    this.isPlaying = false;
    this.currentTapeId = "tape1";
    this.tapeSpeed = "19"; // 9.5, 19, 38 cm/s
    this.saturation = true;
    this.playbackTimer = null;
    this.playbackTime = 0;
    this.activeNodes = [];
    this.vuLevelLeft = 0;
    this.vuLevelRight = 0;
    this.onStateChange = null;
    this.onVuUpdate = null;

    this.tapes = {
      tape1: {
        id: "tape1",
        titlePl: "Raport Dr Heleny Wierzbickiej — UCP (03.11.1978 22:45)",
        titleEn: "Report of Dr. Helena Wierzbicka — UCP (03.11.1978 22:45)",
        duration: 38,
        descriptionPl: "Nagranie z gabinetu dyrekcji: decyzja o wygaszeniu szwu relacyjnego na Linii 4 i zakazie przymusowej sedacji Leny Wolskiej.",
        descriptionEn: "Directorate recording: decision to stabilize relational seam on Line 4 and prohibit forced sedation of Lena Wolska.",
        carrierFreq: 520,
        voicePitch: 260
      },
      tape2: {
        id: "tape2",
        titlePl: "Dyspozytura Tramwajowa — Incydent Linii 4 (22:30)",
        titleEn: "Tramway Dispatch — Line 4 Incident (22:30)",
        duration: 34,
        descriptionPl: "Zgłoszenie radiowe motorniczej: wagon 105N na dwóch torach jednocześnie i rozbicie szyby pod lewym żebrem Jakuba.",
        descriptionEn: "Motorman radio log: tramcar 105N on two tracks simultaneously and glass shatter at Jakub's left rib.",
        carrierFreq: 580,
        voicePitch: 370
      },
      tape3: {
        id: "tape3",
        titlePl: "Zeznanie Sensoryczne — Szymon Bera (Rezonans 528 Hz)",
        titleEn: "Sensory Deposition — Szymon Bera (528 Hz Resonance)",
        duration: 36,
        descriptionPl: "Przesłuchanie kreślarza: opis znikającego 3. piętra bloku przy ul. Rówieńskiej oraz rezonans pigmentu woskowego.",
        descriptionEn: "Draftsman interrogation: description of erased 3rd floor at Rówieńska St and wax pigment resonance.",
        carrierFreq: 528,
        voicePitch: 220
      },
      tape4: {
        id: "tape4",
        titlePl: "Kalibracja Oscyloskopu IKP — Lena Wolska (740 Hz)",
        titleEn: "IKP Oscilloscope Calibration — Lena Wolska (740 Hz)",
        duration: 40,
        descriptionPl: "Dziennik pomiarowy: próba korelacji próżniowej o 21:45, rozbieżność cienia 12.4 stopnia i dzwoniący telefon od Marty.",
        descriptionEn: "Measurement log: vacuum correlation test at 21:45, 12.4 degree shadow lag, and incoming call from Marta.",
        carrierFreq: 740,
        voicePitch: 440
      }
    };
  }

  selectTape(tapeId) {
    if (!this.tapes[tapeId]) return;
    const wasPlaying = this.isPlaying;
    this.stop();
    this.currentTapeId = tapeId;
    this.playbackTime = 0;
    if (typeof this.onStateChange === "function") {
      this.onStateChange(this.getState());
    }
    if (wasPlaying) {
      this.play();
    }
  }

  setSpeed(speed) {
    this.tapeSpeed = speed;
    if (this.isPlaying) {
      // Re-trigger current audio graph with new speed parameters
      const currTime = this.playbackTime;
      this._stopAudioNodes();
      this._startAudioNodes(currTime);
    }
    if (typeof this.onStateChange === "function") {
      this.onStateChange(this.getState());
    }
  }

  toggleSaturation(enable) {
    this.saturation = enable !== undefined ? enable : !this.saturation;
    if (this.isPlaying) {
      const currTime = this.playbackTime;
      this._stopAudioNodes();
      this._startAudioNodes(currTime);
    }
  }

  play() {
    this.audio.ensureContext();
    if (!this.audio.ctx) return;
    if (this.isPlaying) return;

    this.isPlaying = true;
    this._startAudioNodes(this.playbackTime);

    const stepInterval = 100;
    this.playbackTimer = setInterval(() => {
      let speedMult = 1.0;
      if (this.tapeSpeed === "9.5") speedMult = 0.8;
      if (this.tapeSpeed === "38") speedMult = 1.3;

      this.playbackTime += (stepInterval / 1000) * speedMult;
      const tape = this.tapes[this.currentTapeId];

      if (this.playbackTime >= tape.duration) {
        this.stop();
        this.playbackTime = 0;
      }

      // Update simulated VU meters with ballistic damping
      this._updateVuMeters();

      if (typeof this.onStateChange === "function") {
        this.onStateChange(this.getState());
      }
    }, stepInterval);

    if (typeof this.onStateChange === "function") {
      this.onStateChange(this.getState());
    }
  }

  pause() {
    if (!this.isPlaying) return;
    this.isPlaying = false;
    clearInterval(this.playbackTimer);
    this._stopAudioNodes();
    this.vuLevelLeft = 0;
    this.vuLevelRight = 0;
    if (typeof this.onVuUpdate === "function") {
      this.onVuUpdate(0, 0);
    }
    if (typeof this.onStateChange === "function") {
      this.onStateChange(this.getState());
    }
  }

  stop() {
    this.isPlaying = false;
    clearInterval(this.playbackTimer);
    this._stopAudioNodes();
    this.playbackTime = 0;
    this.vuLevelLeft = 0;
    this.vuLevelRight = 0;
    if (typeof this.onVuUpdate === "function") {
      this.onVuUpdate(0, 0);
    }
    if (typeof this.onStateChange === "function") {
      this.onStateChange(this.getState());
    }
  }

  rewind() {
    this.playbackTime = Math.max(0, this.playbackTime - 5);
    if (this.isPlaying) {
      this._stopAudioNodes();
      this._startAudioNodes(this.playbackTime);
    }
    if (typeof this.onStateChange === "function") {
      this.onStateChange(this.getState());
    }
  }

  fastForward() {
    const tape = this.tapes[this.currentTapeId];
    this.playbackTime = Math.min(tape.duration - 1, this.playbackTime + 5);
    if (this.isPlaying) {
      this._stopAudioNodes();
      this._startAudioNodes(this.playbackTime);
    }
    if (typeof this.onStateChange === "function") {
      this.onStateChange(this.getState());
    }
  }

  getState() {
    const tape = this.tapes[this.currentTapeId];
    return {
      isPlaying: this.isPlaying,
      currentTapeId: this.currentTapeId,
      tapeTitlePl: tape.titlePl,
      tapeTitleEn: tape.titleEn,
      tapeDescPl: tape.descriptionPl,
      tapeDescEn: tape.descriptionEn,
      playbackTime: this.playbackTime,
      duration: tape.duration,
      progress: tape.duration > 0 ? (this.playbackTime / tape.duration) : 0,
      tapeSpeed: this.tapeSpeed,
      saturation: this.saturation
    };
  }

  _updateVuMeters() {
    if (!this.isPlaying) {
      this.vuLevelLeft *= 0.8;
      this.vuLevelRight *= 0.8;
    } else {
      // Dynamic needle deflection based on tape signal energy
      const baseRnd = 0.55 + Math.random() * 0.35;
      const targetL = Math.min(1.0, baseRnd + (Math.sin(this.playbackTime * 6) * 0.15));
      const targetR = Math.min(1.0, baseRnd + (Math.cos(this.playbackTime * 5.5) * 0.15));

      // Inertial spring-mass damping
      this.vuLevelLeft += (targetL - this.vuLevelLeft) * 0.35;
      this.vuLevelRight += (targetR - this.vuLevelRight) * 0.35;
    }

    if (typeof this.onVuUpdate === "function") {
      this.onVuUpdate(this.vuLevelLeft, this.vuLevelRight);
    }
  }

  _startAudioNodes(offsetSec = 0) {
    if (!this.audio.ctx) return;
    const ctx = this.audio.ctx;
    const now = ctx.currentTime;
    const tape = this.tapes[this.currentTapeId];

    let speedMult = 1.0;
    let filterCutoff = 3200;
    if (this.tapeSpeed === "9.5") {
      speedMult = 0.85;
      filterCutoff = 1600;
    } else if (this.tapeSpeed === "38") {
      speedMult = 1.15;
      filterCutoff = 6500;
    }

    // 1. Tape Motor Hum (38 Hz sub-hum)
    const motorOsc = ctx.createOscillator();
    const motorGain = ctx.createGain();
    motorOsc.type = "sine";
    motorOsc.frequency.setValueAtTime(38 * speedMult, now);
    motorGain.gain.setValueAtTime(0.06, now);
    motorOsc.connect(motorGain);
    motorGain.connect(this.audio.analyser);
    motorOsc.start(now);
    this.activeNodes.push(motorOsc, motorGain);

    // 2. Tape Hiss & Grain (Pink-filtered white noise)
    const bufSize = ctx.sampleRate * 2;
    const noiseBuffer = ctx.createBuffer(1, bufSize, ctx.sampleRate);
    const noiseOut = noiseBuffer.getChannelData(0);
    let b0 = 0, b1 = 0, b2 = 0;
    for (let i = 0; i < bufSize; i++) {
      const white = Math.random() * 2 - 1;
      b0 = 0.99886 * b0 + white * 0.0555179;
      b1 = 0.99332 * b1 + white * 0.0750759;
      b2 = 0.96900 * b2 + white * 0.1538520;
      noiseOut[i] = (b0 + b1 + b2 + white * 0.5362) * 0.08;
    }
    const hissSource = ctx.createBufferSource();
    hissSource.buffer = noiseBuffer;
    hissSource.loop = true;
    const hissFilter = ctx.createBiquadFilter();
    hissFilter.type = "bandpass";
    hissFilter.frequency.setValueAtTime(filterCutoff * 0.8, now);
    hissFilter.Q.value = 1.2;
    const hissGain = ctx.createGain();
    hissGain.gain.setValueAtTime(0.08, now);
    hissSource.connect(hissFilter);
    hissFilter.connect(hissGain);
    hissGain.connect(this.audio.analyser);
    hissSource.start(now);
    this.activeNodes.push(hissSource, hissFilter, hissGain);

    // 3. Wow & Flutter Modulator (LFO frequency shift at 4.2 Hz)
    const lfo = ctx.createOscillator();
    const lfoGain = ctx.createGain();
    lfo.type = "sine";
    lfo.frequency.setValueAtTime(4.2, now);
    lfoGain.gain.setValueAtTime(tape.carrierFreq * 0.008, now); // ~0.8% flutter
    lfo.connect(lfoGain);

    // 4. Primary Carrier Resonance & Formant Voice
    const carrierOsc = ctx.createOscillator();
    carrierOsc.type = "sawtooth";
    carrierOsc.frequency.setValueAtTime(tape.carrierFreq * speedMult, now);
    lfoGain.connect(carrierOsc.frequency);

    const voiceOsc = ctx.createOscillator();
    voiceOsc.type = "triangle";
    voiceOsc.frequency.setValueAtTime(tape.voicePitch * speedMult, now);
    lfoGain.connect(voiceOsc.frequency);

    // Filter stage
    const mainFilter = ctx.createBiquadFilter();
    mainFilter.type = "lowpass";
    mainFilter.frequency.setValueAtTime(filterCutoff, now);
    mainFilter.Q.value = 3.5;

    // Saturation Waveshaper
    let saturationNode = null;
    if (this.saturation) {
      saturationNode = ctx.createWaveShaper();
      saturationNode.curve = this._makeDistortionCurve(18);
      saturationNode.oversample = '2x';
    }

    const masterTapeGain = ctx.createGain();
    masterTapeGain.gain.setValueAtTime(0.001, now);
    masterTapeGain.gain.linearRampToValueAtTime(0.24, now + 0.1);

    carrierOsc.connect(mainFilter);
    voiceOsc.connect(mainFilter);

    if (saturationNode) {
      mainFilter.connect(saturationNode);
      saturationNode.connect(masterTapeGain);
    } else {
      mainFilter.connect(masterTapeGain);
    }

    masterTapeGain.connect(this.audio.analyser);

    lfo.start(now);
    carrierOsc.start(now);
    voiceOsc.start(now);

    this.activeNodes.push(lfo, lfoGain, carrierOsc, voiceOsc, mainFilter, masterTapeGain);
    if (saturationNode) this.activeNodes.push(saturationNode);
  }

  _stopAudioNodes() {
    this.activeNodes.forEach(node => {
      try {
        if (typeof node.stop === "function") node.stop();
        if (typeof node.disconnect === "function") node.disconnect();
      } catch (e) {}
    });
    this.activeNodes = [];
  }

  _makeDistortionCurve(amount) {
    const k = typeof amount === 'number' ? amount : 20;
    const n_samples = 44100;
    const curve = new Float32Array(n_samples);
    const deg = Math.PI / 180;
    for (let i = 0; i < n_samples; ++i) {
      const x = (i * 2) / n_samples - 1;
      curve[i] = ((3 + k) * x * 20 * deg) / (Math.PI + k * Math.abs(x));
    }
    return curve;
  }
}

/**
 * GETTING STRANGE — 4-Track Studio Cassette Mixer Unitra Studio M-531S
 * Real-time 4-channel procedural multitrack mixer with individual volume faders,
 * stereo pan, mute/solo buttons, animated peak meters, and 16-bit master WAV export.
 */
class UnitraMultitrackMixer {
  constructor(audioApparatus) {
    this.audio = audioApparatus;
    this.isPlaying = false;
    this.masterVol = 0.85;
    this.activeNodes = [];
    this.masterGainNode = null;
    this.meterInterval = null;

    this.tracks = {
      t1: {
        id: "t1",
        namePl: "Ścieżka 1: Nośna Leny (740 Hz)",
        nameEn: "Track 1: Lena Carrier (740 Hz)",
        vol: 0.80,
        pan: -0.25,
        mute: false,
        solo: false,
        peak: 0,
        gainNode: null,
        panNode: null
      },
      t2: {
        id: "t2",
        namePl: "Ścieżka 2: Trakcja Linii 4",
        nameEn: "Track 2: Transit Line 4",
        vol: 0.70,
        pan: 0.25,
        mute: false,
        solo: false,
        peak: 0,
        gainNode: null,
        panNode: null
      },
      t3: {
        id: "t3",
        namePl: "Ścieżka 3: Szepty Podstruktury (-40 m)",
        nameEn: "Track 3: Substructure Whispers (-40 m)",
        vol: 0.65,
        pan: -0.60,
        mute: false,
        solo: false,
        peak: 0,
        gainNode: null,
        panNode: null
      },
      t4: {
        id: "t4",
        namePl: "Ścieżka 4: Dron Reaktora (-85 m)",
        nameEn: "Track 4: Reactor Drone (-85 m)",
        vol: 0.75,
        pan: 0.60,
        mute: false,
        solo: false,
        peak: 0,
        gainNode: null,
        panNode: null
      }
    };
  }

  setTrackVol(trackId, val) {
    if (!this.tracks[trackId]) return;
    this.tracks[trackId].vol = parseFloat(val);
    this._updateTrackGains();
  }

  setTrackPan(trackId, val) {
    if (!this.tracks[trackId]) return;
    this.tracks[trackId].pan = parseFloat(val);
    if (this.tracks[trackId].panNode && this.audio.ctx) {
      try {
        if (this.tracks[trackId].panNode.pan) {
          this.tracks[trackId].panNode.pan.setValueAtTime(this.tracks[trackId].pan, this.audio.ctx.currentTime);
        }
      } catch (e) {}
    }
  }

  toggleTrackMute(trackId) {
    if (!this.tracks[trackId]) return;
    this.tracks[trackId].mute = !this.tracks[trackId].mute;
    this._updateTrackGains();
  }

  toggleTrackSolo(trackId) {
    if (!this.tracks[trackId]) return;
    this.tracks[trackId].solo = !this.tracks[trackId].solo;
    this._updateTrackGains();
  }

  setMasterVol(val) {
    this.masterVol = parseFloat(val);
    if (this.masterGainNode && this.audio.ctx) {
      this.masterGainNode.gain.setValueAtTime(this.masterVol, this.audio.ctx.currentTime);
    }
  }

  _hasSoloActive() {
    return Object.values(this.tracks).some(t => t.solo);
  }

  _updateTrackGains() {
    if (!this.audio.ctx) return;
    const hasSolo = this._hasSoloActive();
    const now = this.audio.ctx.currentTime;

    for (const key in this.tracks) {
      const t = this.tracks[key];
      if (t.gainNode) {
        let targetGain = t.vol;
        if (t.mute) {
          targetGain = 0;
        } else if (hasSolo && !t.solo) {
          targetGain = 0;
        }
        t.gainNode.gain.cancelScheduledValues(now);
        t.gainNode.gain.setValueAtTime(t.gainNode.gain.value, now);
        t.gainNode.gain.linearRampToValueAtTime(targetGain * 0.28, now + 0.05);
      }
    }
  }

  play() {
    this.audio.ensureContext();
    if (!this.audio.ctx) return;
    if (this.isPlaying) return;

    this.isPlaying = true;
    const ctx = this.audio.ctx;
    const now = ctx.currentTime;

    this.masterGainNode = ctx.createGain();
    this.masterGainNode.gain.setValueAtTime(this.masterVol, now);
    this.masterGainNode.connect(this.audio.analyser);

    // Setup Track 1: Lena Carrier (740 Hz + Sub 370 Hz + Vibrato)
    const t1 = this.tracks.t1;
    t1.gainNode = ctx.createGain();
    t1.panNode = this._createPanner(ctx, t1.pan);
    const osc1a = ctx.createOscillator();
    const osc1b = ctx.createOscillator();
    const lfo1 = ctx.createOscillator();
    const lfoGain1 = ctx.createGain();
    osc1a.type = "sawtooth";
    osc1a.frequency.setValueAtTime(740, now);
    osc1b.type = "sine";
    osc1b.frequency.setValueAtTime(370, now);
    lfo1.type = "sine";
    lfo1.frequency.setValueAtTime(3.5, now);
    lfoGain1.gain.setValueAtTime(6.0, now);
    lfo1.connect(lfoGain1);
    lfoGain1.connect(osc1a.frequency);

    const f1 = ctx.createBiquadFilter();
    f1.type = "lowpass";
    f1.frequency.setValueAtTime(2200, now);
    f1.Q.value = 2.5;

    osc1a.connect(f1);
    osc1b.connect(f1);
    f1.connect(t1.gainNode);
    t1.gainNode.connect(t1.panNode);
    t1.panNode.connect(this.masterGainNode);

    lfo1.start(now);
    osc1a.start(now);
    osc1b.start(now);
    this.activeNodes.push(lfo1, lfoGain1, osc1a, osc1b, f1, t1.gainNode, t1.panNode);

    // Setup Track 2: Line 4 Transit (50 Hz hum + 150 Hz rail + 3400 Hz spark band)
    const t2 = this.tracks.t2;
    t2.gainNode = ctx.createGain();
    t2.panNode = this._createPanner(ctx, t2.pan);
    const osc2a = ctx.createOscillator();
    const osc2b = ctx.createOscillator();
    osc2a.type = "sawtooth";
    osc2a.frequency.setValueAtTime(50, now);
    osc2b.type = "triangle";
    osc2b.frequency.setValueAtTime(150, now);

    const f2 = ctx.createBiquadFilter();
    f2.type = "bandpass";
    f2.frequency.setValueAtTime(850, now);
    f2.Q.value = 1.8;

    osc2a.connect(f2);
    osc2b.connect(f2);
    f2.connect(t2.gainNode);
    t2.gainNode.connect(t2.panNode);
    t2.panNode.connect(this.masterGainNode);

    osc2a.start(now);
    osc2b.start(now);
    this.activeNodes.push(osc2a, osc2b, f2, t2.gainNode, t2.panNode);

    // Setup Track 3: Substructure Whispers (-40 m) (Pink noise + 880 Hz breathing band)
    const t3 = this.tracks.t3;
    t3.gainNode = ctx.createGain();
    t3.panNode = this._createPanner(ctx, t3.pan);

    const bufSize = ctx.sampleRate * 2;
    const noiseBuffer = ctx.createBuffer(1, bufSize, ctx.sampleRate);
    const noiseOut = noiseBuffer.getChannelData(0);
    let b0 = 0, b1 = 0, b2 = 0;
    for (let i = 0; i < bufSize; i++) {
      const white = Math.random() * 2 - 1;
      b0 = 0.99886 * b0 + white * 0.0555179;
      b1 = 0.99332 * b1 + white * 0.0750759;
      b2 = 0.96900 * b2 + white * 0.1538520;
      noiseOut[i] = (b0 + b1 + b2 + white * 0.5362) * 0.15;
    }
    const noiseSrc = ctx.createBufferSource();
    noiseSrc.buffer = noiseBuffer;
    noiseSrc.loop = true;

    const f3 = ctx.createBiquadFilter();
    f3.type = "bandpass";
    f3.frequency.setValueAtTime(880, now);
    f3.Q.value = 4.0;

    const lfo3 = ctx.createOscillator();
    const lfoGain3 = ctx.createGain();
    lfo3.type = "sine";
    lfo3.frequency.setValueAtTime(0.8, now);
    lfoGain3.gain.setValueAtTime(240, now);
    lfo3.connect(lfoGain3);
    lfoGain3.connect(f3.frequency);

    noiseSrc.connect(f3);
    f3.connect(t3.gainNode);
    t3.gainNode.connect(t3.panNode);
    t3.panNode.connect(this.masterGainNode);

    lfo3.start(now);
    noiseSrc.start(now);
    this.activeNodes.push(noiseSrc, f3, lfo3, lfoGain3, t3.gainNode, t3.panNode);

    // Setup Track 4: Reactor Drone (-85 m) (52 Hz sub + 104 Hz 2nd harmonic)
    const t4 = this.tracks.t4;
    t4.gainNode = ctx.createGain();
    t4.panNode = this._createPanner(ctx, t4.pan);
    const osc4a = ctx.createOscillator();
    const osc4b = ctx.createOscillator();
    osc4a.type = "sine";
    osc4a.frequency.setValueAtTime(52, now);
    osc4b.type = "sine";
    osc4b.frequency.setValueAtTime(104, now);

    const f4 = ctx.createBiquadFilter();
    f4.type = "lowpass";
    f4.frequency.setValueAtTime(320, now);
    f4.Q.value = 2.0;

    osc4a.connect(f4);
    osc4b.connect(f4);
    f4.connect(t4.gainNode);
    t4.gainNode.connect(t4.panNode);
    t4.panNode.connect(this.masterGainNode);

    osc4a.start(now);
    osc4b.start(now);
    this.activeNodes.push(osc4a, osc4b, f4, t4.gainNode, t4.panNode);

    this._updateTrackGains();
    this._startMeterLoop();
  }

  _createPanner(ctx, panVal) {
    if (ctx.createStereoPanner) {
      const panner = ctx.createStereoPanner();
      panner.pan.setValueAtTime(panVal, ctx.currentTime);
      return panner;
    } else {
      // Fallback gain node
      const fallback = ctx.createGain();
      fallback.gain.value = 1.0;
      return fallback;
    }
  }

  stop() {
    this.isPlaying = false;
    if (this.meterInterval) {
      clearInterval(this.meterInterval);
      this.meterInterval = null;
    }
    this.activeNodes.forEach(node => {
      try {
        if (typeof node.stop === "function") node.stop();
        if (typeof node.disconnect === "function") node.disconnect();
      } catch (e) {}
    });
    this.activeNodes = [];
    if (this.masterGainNode) {
      try { this.masterGainNode.disconnect(); } catch (e) {}
      this.masterGainNode = null;
    }
    for (const k in this.tracks) {
      this.tracks[k].gainNode = null;
      this.tracks[k].panNode = null;
      this.tracks[k].peak = 0;
    }
    this._renderMeters();
  }

  _startMeterLoop() {
    if (this.meterInterval) clearInterval(this.meterInterval);
    this.meterInterval = setInterval(() => {
      if (!this.isPlaying) return;
      const hasSolo = this._hasSoloActive();
      for (const k in this.tracks) {
        const t = this.tracks[k];
        if (t.mute || (hasSolo && !t.solo)) {
          t.peak = 0;
        } else {
          const jitter = (Math.random() * 0.25);
          t.peak = Math.min(1.0, t.vol * (0.75 + jitter));
        }
      }
      this._renderMeters();
    }, 80);
  }

  _renderMeters() {
    for (const k in this.tracks) {
      const t = this.tracks[k];
      const meterEl = document.getElementById(`mixerMeter-${t.id}`);
      if (meterEl) {
        meterEl.style.height = `${Math.round(t.peak * 100)}%`;
      }
    }
    const masterMeterL = document.getElementById("mixerMasterMeterL");
    const masterMeterR = document.getElementById("mixerMasterMeterR");
    if (masterMeterL && masterMeterR) {
      if (this.isPlaying) {
        const pL = Math.min(1.0, this.masterVol * (0.7 + Math.random() * 0.28));
        const pR = Math.min(1.0, this.masterVol * (0.7 + Math.random() * 0.28));
        masterMeterL.style.height = `${Math.round(pL * 100)}%`;
        masterMeterR.style.height = `${Math.round(pR * 100)}%`;
      } else {
        masterMeterL.style.height = "0%";
        masterMeterR.style.height = "0%";
      }
    }
  }

  renderMasterWav(durationSec = 8) {
    const sampleRate = 44100;
    const numChannels = 2;
    const numSamples = Math.floor(sampleRate * durationSec);
    const hasSolo = this._hasSoloActive();

    // Compute float buffers for L and R
    const leftBuffer = new Float32Array(numSamples);
    const rightBuffer = new Float32Array(numSamples);

    for (let i = 0; i < numSamples; i++) {
      const t = i / sampleRate;
      let sampleL = 0;
      let sampleR = 0;

      // Track 1: Lena 740 Hz
      if (!this.tracks.t1.mute && (!hasSolo || this.tracks.t1.solo)) {
        const v1 = this.tracks.t1.vol;
        const pan1 = this.tracks.t1.pan;
        const f1 = 740 + Math.sin(2 * Math.PI * 3.5 * t) * 6.0;
        const saw = (2 * ((t * f1) % 1)) - 1;
        const sub = Math.sin(2 * Math.PI * 370 * t);
        const sig1 = (saw * 0.6 + sub * 0.4) * v1 * 0.3;
        const gainL = Math.cos((pan1 + 1) * (Math.PI / 4));
        const gainR = Math.sin((pan1 + 1) * (Math.PI / 4));
        sampleL += sig1 * gainL;
        sampleR += sig1 * gainR;
      }

      // Track 2: Line 4 Transit
      if (!this.tracks.t2.mute && (!hasSolo || this.tracks.t2.solo)) {
        const v2 = this.tracks.t2.vol;
        const pan2 = this.tracks.t2.pan;
        const hum = ((2 * ((t * 50) % 1)) - 1) * 0.5;
        const rail = Math.sin(2 * Math.PI * 150 * t) * 0.5;
        const sig2 = (hum + rail) * v2 * 0.25;
        const gainL = Math.cos((pan2 + 1) * (Math.PI / 4));
        const gainR = Math.sin((pan2 + 1) * (Math.PI / 4));
        sampleL += sig2 * gainL;
        sampleR += sig2 * gainR;
      }

      // Track 3: Substructure -40m Whispers
      if (!this.tracks.t3.mute && (!hasSolo || this.tracks.t3.solo)) {
        const v3 = this.tracks.t3.vol;
        const pan3 = this.tracks.t3.pan;
        const mod = (Math.sin(2 * Math.PI * 0.8 * t) + 1) * 0.5;
        const noise = (Math.random() * 2 - 1) * mod;
        const sig3 = noise * v3 * 0.15;
        const gainL = Math.cos((pan3 + 1) * (Math.PI / 4));
        const gainR = Math.sin((pan3 + 1) * (Math.PI / 4));
        sampleL += sig3 * gainL;
        sampleR += sig3 * gainR;
      }

      // Track 4: Reactor Drone -85m
      if (!this.tracks.t4.mute && (!hasSolo || this.tracks.t4.solo)) {
        const v4 = this.tracks.t4.vol;
        const pan4 = this.tracks.t4.pan;
        const sub1 = Math.sin(2 * Math.PI * 52 * t);
        const sub2 = Math.sin(2 * Math.PI * 104 * t) * 0.4;
        const sig4 = (sub1 + sub2) * v4 * 0.28;
        const gainL = Math.cos((pan4 + 1) * (Math.PI / 4));
        const gainR = Math.sin((pan4 + 1) * (Math.PI / 4));
        sampleL += sig4 * gainL;
        sampleR += sig4 * gainR;
      }

      // Apply master gain and slight soft-clipping
      leftBuffer[i] = Math.max(-1, Math.min(1, sampleL * this.masterVol));
      rightBuffer[i] = Math.max(-1, Math.min(1, sampleR * this.masterVol));
    }

    // Build 16-bit PCM WAV File Header
    const byteLength = 44 + numSamples * numChannels * 2;
    const arrayBuffer = new ArrayBuffer(byteLength);
    const view = new DataView(arrayBuffer);

    // RIFF chunk descriptor
    this._writeString(view, 0, 'RIFF');
    view.setUint32(4, 36 + numSamples * numChannels * 2, true);
    this._writeString(view, 8, 'WAVE');

    // fmt sub-chunk
    this._writeString(view, 12, 'fmt ');
    view.setUint32(16, 16, true);
    view.setUint16(20, 1, true); // PCM
    view.setUint16(22, numChannels, true);
    view.setUint32(24, sampleRate, true);
    view.setUint32(28, sampleRate * numChannels * 2, true); // byte rate
    view.setUint16(32, numChannels * 2, true); // block align
    view.setUint16(34, 16, true); // bits per sample

    // data sub-chunk
    this._writeString(view, 36, 'data');
    view.setUint32(40, numSamples * numChannels * 2, true);

    // Write interleaved 16-bit PCM samples
    let offset = 44;
    for (let i = 0; i < numSamples; i++) {
      let sL = Math.max(-1, Math.min(1, leftBuffer[i]));
      let sR = Math.max(-1, Math.min(1, rightBuffer[i]));
      let int16L = sL < 0 ? sL * 0x8000 : sL * 0x7FFF;
      let int16R = sR < 0 ? sR * 0x8000 : sR * 0x7FFF;
      view.setInt16(offset, int16L, true);
      view.setInt16(offset + 2, int16R, true);
      offset += 4;
    }

    const blob = new Blob([view], { type: 'audio/wav' });
    const url = URL.createObjectURL(blob);
    const anchor = document.createElement('a');
    anchor.href = url;
    anchor.download = 'getting_strange_multitrack_master_1978.wav';
    document.body.appendChild(anchor);
    anchor.click();
    setTimeout(() => {
      document.body.removeChild(anchor);
      URL.revokeObjectURL(url);
    }, 1000);
  }

  _writeString(view, offset, string) {
    for (let i = 0; i < string.length; i++) {
      view.setUint8(offset + i, string.charCodeAt(i));
    }
  }
}

/**
 * GETTING STRANGE — Lissajous Vector Scope & Spatial Distortion Analyzer
 * Real-time XY CRT vector scope rendering electron beam traces, frequency interference,
 * and spatial coherence analysis between multiple reality vectors.
 */
class LissajousVectorScope {
  constructor(canvasId) {
    this.canvas = document.getElementById(canvasId);
    this.ctx = this.canvas ? this.canvas.getContext('2d') : null;
    this.freqX = 740;
    this.freqY = 370;
    this.phase = Math.PI / 2;
    this.distortion = 0.15;
    this.phosphor = 'cyan'; // 'cyan', 'amber', 'green'
    this.isAnalyzing = true;
    this.time = 0;
    this.animId = null;

    if (this.ctx) {
      this._startRenderLoop();
    }
  }

  setPreset(presetId) {
    if (presetId === 'sync11') {
      this.freqX = 740;
      this.freqY = 740;
      this.phase = Math.PI / 2;
      this.distortion = 0.05;
    } else if (presetId === 'line4') {
      this.freqX = 740;
      this.freqY = 370;
      this.phase = 0;
      this.distortion = 0.18;
    } else if (presetId === 'szymon') {
      this.freqX = 740;
      this.freqY = 528;
      this.phase = Math.PI / 4;
      this.distortion = 0.25;
    } else if (presetId === 'shadow') {
      this.freqX = 555;
      this.freqY = 740;
      this.phase = Math.PI / 3;
      this.distortion = 0.35;
    }
    this._updateUIElements();
  }

  _updateUIElements() {
    const fxSlider = document.getElementById('lissajousFreqXSlider');
    const fySlider = document.getElementById('lissajousFreqYSlider');
    const phaseSlider = document.getElementById('lissajousPhaseSlider');
    const fxVal = document.getElementById('lissajousFreqXVal');
    const fyVal = document.getElementById('lissajousFreqYVal');
    const phaseVal = document.getElementById('lissajousPhaseVal');

    if (fxSlider) fxSlider.value = this.freqX;
    if (fySlider) fySlider.value = this.freqY;
    if (phaseSlider) phaseSlider.value = Math.round((this.phase / Math.PI) * 180);
    if (fxVal) fxVal.innerText = `${this.freqX} Hz`;
    if (fyVal) fyVal.innerText = `${this.freqY} Hz`;
    if (phaseVal) phaseVal.innerText = `${Math.round((this.phase / Math.PI) * 180)}°`;
  }

  _startRenderLoop() {
    const render = () => {
      this._renderFrame();
      this.animId = requestAnimationFrame(render);
    };
    this.animId = requestAnimationFrame(render);
  }

  _renderFrame() {
    if (!this.ctx || !this.canvas) return;
    const ctx = this.ctx;
    const w = this.canvas.width;
    const h = this.canvas.height;
    const cx = w / 2;
    const cy = h / 2;
    const r = Math.min(w, h) * 0.42;

    this.time += 0.02;

    // Phosphor persistence decay fade
    ctx.fillStyle = 'rgba(5, 8, 12, 0.22)';
    ctx.fillRect(0, 0, w, h);

    // Draw CRT Graticule / Scope Grid
    ctx.strokeStyle = 'rgba(36, 58, 71, 0.35)';
    ctx.lineWidth = 1;

    // Concentric circles
    ctx.beginPath();
    ctx.arc(cx, cy, r * 0.33, 0, Math.PI * 2);
    ctx.arc(cx, cy, r * 0.66, 0, Math.PI * 2);
    ctx.arc(cx, cy, r, 0, Math.PI * 2);
    ctx.stroke();

    // Crosshairs
    ctx.beginPath();
    ctx.moveTo(cx - r, cy);
    ctx.lineTo(cx + r, cy);
    ctx.moveTo(cx, cy - r);
    ctx.lineTo(cx, cy + r);
    ctx.stroke();

    // Color theme
    let strokeColor = 'rgba(93, 163, 152, 0.9)';
    let glowColor = 'rgba(117, 199, 195, 0.4)';
    if (this.phosphor === 'amber') {
      strokeColor = 'rgba(211, 154, 98, 0.9)';
      glowColor = 'rgba(226, 176, 96, 0.4)';
    } else if (this.phosphor === 'green') {
      strokeColor = 'rgba(110, 215, 120, 0.9)';
      glowColor = 'rgba(140, 235, 150, 0.4)';
    }

    // Draw Lissajous Trace
    ctx.save();
    ctx.shadowBlur = 10;
    ctx.shadowColor = glowColor;
    ctx.strokeStyle = strokeColor;
    ctx.lineWidth = 2.0;

    const numPoints = 360;
    const ratio = this.freqX / (this.freqY || 1);
    const slowMod = this.time * 0.5;

    ctx.beginPath();
    for (let i = 0; i <= numPoints; i++) {
      const theta = (i / numPoints) * Math.PI * 2;
      const x = cx + r * Math.sin(theta * ratio + this.phase + Math.sin(slowMod) * this.distortion);
      const y = cy + r * Math.sin(theta + Math.cos(slowMod * 0.7) * (this.distortion * 0.5));

      if (i === 0) {
        ctx.moveTo(x, y);
      } else {
        ctx.lineTo(x, y);
      }
    }
    ctx.stroke();
    ctx.restore();
  }
}

/**
 * GETTING STRANGE — Quantum Field & Waveform Interference Rack
 * Zaawansowany generator i analizator interferencji pola kwantowego Równi.
 * Multi-layer Web Audio synthesis, real-time 2D Canvas CRT visualization with
 * probability density heatmap, orthogonal state vectors, and 16-bit Stereo PCM WAV exporter.
 */
class QuantumFieldInterferenceRack {
  constructor(canvasId, proceduralAudio) {
    this.canvas = document.getElementById(canvasId);
    this.ctx2d = this.canvas ? this.canvas.getContext('2d') : null;
    this.audio = proceduralAudio;
    this.isPlaying = false;

    // Synthesis parameters
    this.carrierFreq = 740;
    this.harmonicAmp = 0.45;
    this.phaseModDeg = 45;
    this.quantumNoise = 0.20;
    this.driftSpeed = 1.2;
    this.filterQ = 8.0;
    this.theme = 'cyan'; // 'cyan', 'amber', 'crimson'

    // Runtime audio nodes
    this.audioNodes = null;
    this.time = 0;
    this.animId = null;

    if (this.ctx2d) {
      this._startRenderLoop();
    }
  }

  setPreset(presetId) {
    if (presetId === 'ikp740') {
      this.carrierFreq = 740;
      this.harmonicAmp = 0.40;
      this.phaseModDeg = 45;
      this.quantumNoise = 0.15;
      this.driftSpeed = 0.5;
      this.filterQ = 8.0;
      this.theme = 'cyan';
    } else if (presetId === 'line4_528') {
      this.carrierFreq = 528;
      this.harmonicAmp = 0.65;
      this.phaseModDeg = 90;
      this.quantumNoise = 0.25;
      this.driftSpeed = 2.4;
      this.filterQ = 12.0;
      this.theme = 'amber';
    } else if (presetId === 'sub40m') {
      this.carrierFreq = 110;
      this.harmonicAmp = 0.85;
      this.phaseModDeg = 180;
      this.quantumNoise = 0.55;
      this.driftSpeed = 0.8;
      this.filterQ = 4.0;
      this.theme = 'crimson';
    } else if (presetId === 'reactor85m') {
      this.carrierFreq = 52;
      this.harmonicAmp = 0.95;
      this.phaseModDeg = 270;
      this.quantumNoise = 0.40;
      this.driftSpeed = 3.8;
      this.filterQ = 18.0;
      this.theme = 'amber';
    } else if (presetId === 'sun1978') {
      this.carrierFreq = 880;
      this.harmonicAmp = 0.70;
      this.phaseModDeg = 30;
      this.quantumNoise = 0.30;
      this.driftSpeed = 1.2;
      this.filterQ = 14.0;
      this.theme = 'cyan';
    }

    this._updateUI();
    if (this.isPlaying) {
      this._restartAudio();
    }
  }

  _updateUI() {
    const carrierSlider = document.getElementById('quantumCarrierSlider');
    const harmSlider = document.getElementById('quantumHarmonicSlider');
    const phaseSlider = document.getElementById('quantumPhaseSlider');
    const noiseSlider = document.getElementById('quantumNoiseSlider');
    const driftSlider = document.getElementById('quantumDriftSlider');
    const qSlider = document.getElementById('quantumQSlider');

    const carrierVal = document.getElementById('quantumCarrierVal');
    const harmVal = document.getElementById('quantumHarmonicVal');
    const phaseVal = document.getElementById('quantumPhaseVal');
    const noiseVal = document.getElementById('quantumNoiseVal');
    const driftVal = document.getElementById('quantumDriftVal');
    const qVal = document.getElementById('quantumQVal');

    if (carrierSlider) carrierSlider.value = this.carrierFreq;
    if (harmSlider) harmSlider.value = Math.round(this.harmonicAmp * 100);
    if (phaseSlider) phaseSlider.value = this.phaseModDeg;
    if (noiseSlider) noiseSlider.value = Math.round(this.quantumNoise * 100);
    if (driftSlider) driftSlider.value = this.driftSpeed;
    if (qSlider) qSlider.value = this.filterQ;

    if (carrierVal) carrierVal.innerText = `${this.carrierFreq} Hz`;
    if (harmVal) harmVal.innerText = `${Math.round(this.harmonicAmp * 100)}%`;
    if (phaseVal) phaseVal.innerText = `${this.phaseModDeg}°`;
    if (noiseVal) noiseVal.innerText = `${Math.round(this.quantumNoise * 100)}%`;
    if (driftVal) driftVal.innerText = `${this.driftSpeed} Hz`;
    if (qVal) qVal.innerText = `Q ${this.filterQ}`;
  }

  play() {
    if (!this.audio) return;
    this.audio.ensureContext();
    if (!this.audio.ctx) return;

    this.stop();
    const ctx = this.audio.ctx;
    const now = ctx.currentTime;

    // 1. Primary Carrier Oscillator (Sine)
    const oscCarrier = ctx.createOscillator();
    oscCarrier.type = 'sine';
    oscCarrier.frequency.setValueAtTime(this.carrierFreq, now);

    // 2. Subharmonic Oscillator (0.5x Sine)
    const oscSub = ctx.createOscillator();
    oscSub.type = 'sine';
    oscSub.frequency.setValueAtTime(this.carrierFreq * 0.5, now);

    // 3. Secondary Harmonic (2.0x Sawtooth filtered)
    const oscHarm = ctx.createOscillator();
    oscHarm.type = 'triangle';
    oscHarm.frequency.setValueAtTime(this.carrierFreq * 2.0, now);

    // 4. LFO Drift / Phase Modulator
    const lfo = ctx.createOscillator();
    const lfoGain = ctx.createGain();
    lfo.type = 'sine';
    lfo.frequency.setValueAtTime(this.driftSpeed, now);
    lfoGain.gain.setValueAtTime(this.carrierFreq * 0.08 * (this.phaseModDeg / 180), now);
    lfo.connect(lfoGain);
    lfoGain.connect(oscCarrier.frequency);

    // 5. Quantum Fluctuation Pink/White Noise Buffer
    const bufferSize = ctx.sampleRate * 2;
    const noiseBuffer = ctx.createBuffer(1, bufferSize, ctx.sampleRate);
    const output = noiseBuffer.getChannelData(0);
    let b0 = 0, b1 = 0, b2 = 0;
    for (let i = 0; i < bufferSize; i++) {
      const white = Math.random() * 2 - 1;
      b0 = 0.99886 * b0 + white * 0.0555179;
      b1 = 0.99332 * b1 + white * 0.0750759;
      b2 = 0.96900 * b2 + white * 0.1538520;
      output[i] = (b0 + b1 + b2) * 0.35;
    }
    const noiseSource = ctx.createBufferSource();
    noiseSource.buffer = noiseBuffer;
    noiseSource.loop = true;

    // Noise Gain
    const noiseGain = ctx.createGain();
    noiseGain.gain.setValueAtTime(this.quantumNoise * 0.25, now);
    noiseSource.connect(noiseGain);

    // 6. Resonant Biquad Filter
    const filter = ctx.createBiquadFilter();
    filter.type = 'bandpass';
    filter.frequency.setValueAtTime(this.carrierFreq, now);
    filter.Q.setValueAtTime(this.filterQ, now);

    // Gain nodes for mixing
    const carrierGain = ctx.createGain();
    carrierGain.gain.setValueAtTime(0.35, now);

    const subGain = ctx.createGain();
    subGain.gain.setValueAtTime(0.20, now);

    const harmGain = ctx.createGain();
    harmGain.gain.setValueAtTime(this.harmonicAmp * 0.25, now);

    const masterRackGain = ctx.createGain();
    masterRackGain.gain.setValueAtTime(0.001, now);
    masterRackGain.gain.linearRampToValueAtTime(0.75, now + 0.08);

    // Connect audio graph
    oscCarrier.connect(carrierGain);
    oscSub.connect(subGain);
    oscHarm.connect(harmGain);

    carrierGain.connect(filter);
    subGain.connect(filter);
    harmGain.connect(filter);
    noiseGain.connect(filter);

    filter.connect(masterRackGain);
    masterRackGain.connect(this.audio.analyser);

    oscCarrier.start(now);
    oscSub.start(now);
    oscHarm.start(now);
    lfo.start(now);
    noiseSource.start(now);

    this.audioNodes = {
      oscCarrier,
      oscSub,
      oscHarm,
      lfo,
      lfoGain,
      noiseSource,
      noiseGain,
      filter,
      masterRackGain
    };

    this.isPlaying = true;
  }

  stop() {
    if (this.audioNodes && this.audio && this.audio.ctx) {
      const now = this.audio.ctx.currentTime;
      try {
        this.audioNodes.masterRackGain.gain.linearRampToValueAtTime(0.0001, now + 0.05);
        setTimeout(() => {
          try {
            this.audioNodes.oscCarrier.stop();
            this.audioNodes.oscSub.stop();
            this.audioNodes.oscHarm.stop();
            this.audioNodes.lfo.stop();
            this.audioNodes.noiseSource.stop();
          } catch (e) {}
          this.audioNodes = null;
        }, 60);
      } catch (e) {
        this.audioNodes = null;
      }
    }
    this.isPlaying = false;
  }

  _restartAudio() {
    this.play();
  }

  _startRenderLoop() {
    const render = () => {
      this._renderFrame();
      this.animId = requestAnimationFrame(render);
    };
    this.animId = requestAnimationFrame(render);
  }

  _renderFrame() {
    if (!this.ctx2d || !this.canvas) return;
    const ctx = this.ctx2d;
    const w = this.canvas.width;
    const h = this.canvas.height;

    this.time += 0.025;

    // Dark phosphor CRT background with fade trail
    ctx.fillStyle = 'rgba(3, 6, 10, 0.28)';
    ctx.fillRect(0, 0, w, h);

    // Color theme definitions
    let mainColor = '#5da398';
    let glowColor = 'rgba(93, 163, 152, 0.4)';

    if (this.theme === 'amber') {
      mainColor = '#e2b060';
      glowColor = 'rgba(226, 176, 96, 0.4)';
    } else if (this.theme === 'crimson') {
      mainColor = '#de7570';
      glowColor = 'rgba(222, 117, 112, 0.4)';
    }

    // 1. CRT Technical Grid & Scale
    ctx.strokeStyle = 'rgba(36, 58, 71, 0.35)';
    ctx.lineWidth = 1;
    for (let x = 0; x < w; x += 40) {
      ctx.beginPath();
      ctx.moveTo(x, 0);
      ctx.lineTo(x, h);
      ctx.stroke();
    }
    for (let y = 0; y < h; y += 30) {
      ctx.beginPath();
      ctx.moveTo(0, y);
      ctx.lineTo(w, y);
      ctx.stroke();
    }

    // 2. Quantum Probability Density Matrix (Background Heat-Mesh)
    const gridSize = 16;
    const cols = Math.floor(w / gridSize);
    const rows = Math.floor(h / gridSize);
    for (let r = 0; r < rows; r++) {
      for (let c = 0; c < cols; c++) {
        const x = c * gridSize;
        const y = r * gridSize;
        const distFromCenter = Math.hypot(x - w * 0.38, y - h * 0.5) / 120;
        const wave = Math.sin(distFromCenter * 4.0 - this.time * 2.0) * Math.cos(x * 0.05 + this.time);
        const prob = Math.max(0, (wave + 1) * 0.5 * (1 - Math.min(1, distFromCenter * 0.6)));

        if (prob > 0.15) {
          ctx.fillStyle = this.theme === 'amber'
            ? `rgba(226, 176, 96, ${prob * 0.22})`
            : (this.theme === 'crimson' ? `rgba(222, 117, 112, ${prob * 0.22})` : `rgba(93, 163, 152, ${prob * 0.22})`);
          ctx.fillRect(x + 1, y + 1, gridSize - 2, gridSize - 2);
        }
      }
    }

    // 3. Polar Bloch / Quantum Phase State Gauge (Right Corner)
    const gaugeX = w - 90;
    const gaugeY = 85;
    const gaugeR = 55;

    ctx.save();
    ctx.strokeStyle = 'rgba(93, 163, 152, 0.4)';
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    ctx.arc(gaugeX, gaugeY, gaugeR, 0, Math.PI * 2);
    ctx.stroke();

    // Polar crosshairs
    ctx.beginPath();
    ctx.moveTo(gaugeX - gaugeR, gaugeY); ctx.lineTo(gaugeX + gaugeR, gaugeY);
    ctx.moveTo(gaugeX, gaugeY - gaugeR); ctx.lineTo(gaugeX, gaugeY + gaugeR);
    ctx.stroke();

    // Rotating Orthogonal Quantum State Vector (Alpha |0> + Beta |1>)
    const angle1 = (this.phaseModDeg * Math.PI / 180) + this.time * (this.driftSpeed * 0.8);
    const angle2 = angle1 + Math.PI / 2;

    ctx.shadowBlur = 8;
    ctx.shadowColor = glowColor;

    // Vector 1 (Alpha)
    ctx.strokeStyle = mainColor;
    ctx.lineWidth = 2.0;
    ctx.beginPath();
    ctx.moveTo(gaugeX, gaugeY);
    ctx.lineTo(gaugeX + Math.cos(angle1) * (gaugeR * 0.88), gaugeY + Math.sin(angle1) * (gaugeR * 0.88));
    ctx.stroke();

    // Vector 2 (Beta / Entangled Phase)
    ctx.strokeStyle = '#d39a62';
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    ctx.moveTo(gaugeX, gaugeY);
    ctx.lineTo(gaugeX + Math.cos(angle2) * (gaugeR * 0.65), gaugeY + Math.sin(angle2) * (gaugeR * 0.65));
    ctx.stroke();

    ctx.restore();

    // Gauge Labels
    ctx.fillStyle = '#6b8291';
    ctx.font = '8px monospace';
    ctx.textAlign = 'center';
    ctx.fillText('|ψ⟩ WEKTOR FAZOWY', gaugeX, gaugeY + gaugeR + 14);

    // 4. Primary Multi-layer Waveform Interference Trace
    ctx.save();
    ctx.shadowBlur = 10;
    ctx.shadowColor = glowColor;
    ctx.strokeStyle = mainColor;
    ctx.lineWidth = 2.2;
    ctx.beginPath();

    const waveAreaWidth = w - 180;
    const midY = h * 0.52;
    const phaseRad = (this.phaseModDeg * Math.PI) / 180;
    const noiseLevel = this.quantumNoise * 14;

    for (let x = 0; x < waveAreaWidth; x += 2) {
      const k = x / 50;
      const primary = Math.sin(k * (this.carrierFreq / 100) - this.time * 3.0);
      const sub = Math.sin(k * (this.carrierFreq / 200) - this.time * 1.5) * 0.45;
      const harm = Math.sin(k * (this.carrierFreq / 50) + phaseRad - this.time * 6.0) * this.harmonicAmp;
      const drift = Math.sin(this.time * this.driftSpeed + x * 0.02) * (this.filterQ * 1.2);
      const randNoise = (Math.random() * 2 - 1) * noiseLevel;

      const y = midY + (primary + sub + harm) * 45 + drift + randNoise;

      if (x === 0) ctx.moveTo(x + 20, y);
      else ctx.lineTo(x + 20, y);
    }
    ctx.stroke();
    ctx.restore();

    // 5. Technical Telemetry Overlay (Bottom & Top HUD)
    ctx.fillStyle = '#6b8291';
    ctx.font = '9px monospace';
    ctx.textAlign = 'left';
    ctx.fillText(`NOŚNA: ${this.carrierFreq.toFixed(1)} Hz | FLUX: ${(this.quantumNoise * 100).toFixed(1)}% | Q-FACTOR: ${this.filterQ.toFixed(1)}`, 20, 24);

    const tensorDet = (Math.cos(this.time * 0.5) * 0.94 + 0.05).toFixed(4);
    ctx.fillText(`TENSOR ZGODNOŚCI det(T): ${tensorDet} | SPÓJNOŚĆ RÓWNI: 99.4%`, 20, h - 18);

    ctx.textAlign = 'right';
    ctx.fillStyle = this.isPlaying ? mainColor : '#6b8291';
    ctx.fillText(this.isPlaying ? '● EMISJA AKTYWNA (WEB AUDIO 16-BIT)' : '○ STAN JAŁOWY (PROFILOWANIE)', w - 20, h - 18);
  }

  renderQuantumWav(durationSeconds = 6) {
    const sampleRate = 44100;
    const numChannels = 2;
    const numSamples = Math.floor(sampleRate * durationSeconds);
    const leftBuffer = new Float32Array(numSamples);
    const rightBuffer = new Float32Array(numSamples);

    const phaseRad = (this.phaseModDeg * Math.PI) / 180;
    const noiseLevel = this.quantumNoise * 0.22;

    for (let i = 0; i < numSamples; i++) {
      const t = i / sampleRate;
      // Envelope
      let env = 1.0;
      if (t < 0.05) env = t / 0.05;
      else if (t > durationSeconds - 0.2) env = (durationSeconds - t) / 0.2;

      // Synthesis formulas
      const primary = Math.sin(2 * Math.PI * this.carrierFreq * t);
      const sub = Math.sin(2 * Math.PI * (this.carrierFreq * 0.5) * t) * 0.45;
      const harm = Math.sin(2 * Math.PI * (this.carrierFreq * 2.0) * t + phaseRad) * this.harmonicAmp;
      const driftLfo = Math.sin(2 * Math.PI * this.driftSpeed * t);
      const noise = (Math.random() * 2 - 1) * noiseLevel;

      // Stereo field panning with phase modulation
      const modSig = (primary * 0.5 + sub * 0.25 + harm * 0.25 + noise) * env;
      const panL = Math.cos((driftLfo + 1) * (Math.PI / 4));
      const panR = Math.sin((driftLfo + 1) * (Math.PI / 4));

      leftBuffer[i] = Math.max(-1, Math.min(1, modSig * panL * 0.85));
      rightBuffer[i] = Math.max(-1, Math.min(1, modSig * panR * 0.85));
    }

    // Build 16-bit PCM WAV File Header
    const byteLength = 44 + numSamples * numChannels * 2;
    const arrayBuffer = new ArrayBuffer(byteLength);
    const view = new DataView(arrayBuffer);

    this._writeString(view, 0, 'RIFF');
    view.setUint32(4, 36 + numSamples * numChannels * 2, true);
    this._writeString(view, 8, 'WAVE');

    this._writeString(view, 12, 'fmt ');
    view.setUint32(16, 16, true);
    view.setUint16(20, 1, true); // PCM
    view.setUint16(22, numChannels, true);
    view.setUint32(24, sampleRate, true);
    view.setUint32(28, sampleRate * numChannels * 2, true);
    view.setUint16(32, numChannels * 2, true);
    view.setUint16(34, 16, true);

    this._writeString(view, 36, 'data');
    view.setUint32(40, numSamples * numChannels * 2, true);

    let offset = 44;
    for (let i = 0; i < numSamples; i++) {
      let sL = Math.max(-1, Math.min(1, leftBuffer[i]));
      let sR = Math.max(-1, Math.min(1, rightBuffer[i]));
      let int16L = sL < 0 ? sL * 0x8000 : sL * 0x7FFF;
      let int16R = sR < 0 ? sR * 0x8000 : sR * 0x7FFF;
      view.setInt16(offset, int16L, true);
      view.setInt16(offset + 2, int16R, true);
      offset += 4;
    }

    const blob = new Blob([view], { type: 'audio/wav' });
    const url = URL.createObjectURL(blob);
    const anchor = document.createElement('a');
    anchor.href = url;
    anchor.download = `getting_strange_quantum_field_${this.carrierFreq}hz.wav`;
    document.body.appendChild(anchor);
    anchor.click();
    setTimeout(() => {
      document.body.removeChild(anchor);
      URL.revokeObjectURL(url);
    }, 1000);
  }

  _writeString(view, offset, string) {
    for (let i = 0; i < string.length; i++) {
      view.setUint8(offset + i, string.charCodeAt(i));
    }
  }
}

/**
 * GETTING STRANGE — Anomalous Particle Vector Emitter & Condensation Fluid Simulation Rack
 * Multi-vector Eulerian-Lagrangian fluid dynamics simulation with Web Audio acoustic coupling,
 * vector gravity fields, vorticity confinement, thermal phase condensation, and 16-bit PCM WAV rendering.
 */
class CondensationFluidRack {
  constructor(canvasId, audioApparatus) {
    this.canvasId = canvasId;
    this.canvas = document.getElementById(canvasId);
    this.audio = audioApparatus;
    this.ctx = this.canvas ? this.canvas.getContext('2d') : null;

    this.isPlaying = true;
    this.time = 0;
    this.theme = 'cyan';

    // Physical & Simulation parameters
    this.viscosity = 0.08;
    this.vorticity = 3.5;
    this.energyDamping = 0.985;
    this.particleRate = 80;
    this.condensationPhase = 40; // 0 to 100%
    this.thermalGradient = 15; // -50 to +50 °C
    this.vectorGravity = 60; // px/s^2
    this.audioGain = 0.75;

    // Simulation grid & particles
    this.gridWidth = 31;
    this.gridHeight = 13;
    this.gridCellSize = 20;
    this.velocityGridU = new Float32Array(this.gridWidth * this.gridHeight);
    this.velocityGridV = new Float32Array(this.gridWidth * this.gridHeight);
    this.temperatureGrid = new Float32Array(this.gridWidth * this.gridHeight);

    this.particles = [];
    this.maxParticles = 550;
    this.droplets = [];

    // Interaction & Telemetry
    this.pointer = { x: -1, y: -1, isDown: false, prevX: -1, prevY: -1 };
    this.lastAudioEmitTime = 0;
    this.totalVorticityFlux = 0;
    this.kineticEnergy = 0;

    this._initGrid();
    this._initParticles();
    this._bindInputs();
    this._startLoop();
  }

  _initGrid() {
    const total = this.gridWidth * this.gridHeight;
    for (let i = 0; i < total; i++) {
      this.velocityGridU[i] = (Math.random() * 2 - 1) * 8;
      this.velocityGridV[i] = (Math.random() * 2 - 1) * 8;
      this.temperatureGrid[i] = this.thermalGradient + (Math.random() * 4 - 2);
    }
  }

  _initParticles() {
    this.particles = [];
    const count = 180;
    const w = this.canvas ? this.canvas.width : 620;
    const h = this.canvas ? this.canvas.height : 260;

    for (let i = 0; i < count; i++) {
      this.particles.push({
        x: Math.random() * w,
        y: Math.random() * h,
        vx: (Math.random() * 2 - 1) * 15,
        vy: (Math.random() * 2 - 1) * 15,
        life: Math.random() * 4 + 2,
        maxLife: 6,
        mass: Math.random() * 0.8 + 0.6,
        temp: this.thermalGradient,
        phase: Math.random() < (this.condensationPhase / 100) ? 1 : 0
      });
    }
  }

  _bindInputs() {
    if (!this.canvas) return;

    const getCanvasPos = (e) => {
      const rect = this.canvas.getBoundingClientRect();
      const scaleX = this.canvas.width / rect.width;
      const scaleY = this.canvas.height / rect.height;
      return {
        x: (e.clientX - rect.left) * scaleX,
        y: (e.clientY - rect.top) * scaleY
      };
    };

    this.canvas.addEventListener('pointerdown', (e) => {
      const pos = getCanvasPos(e);
      this.pointer.isDown = true;
      this.pointer.x = pos.x;
      this.pointer.y = pos.y;
      this.pointer.prevX = pos.x;
      this.pointer.prevY = pos.y;

      this.injectParticles(pos.x, pos.y, 25);
      if (this.audio && this.audioGain > 0.05) {
        this.audio.playViscosityShear(this.audioGain);
      }
    });

    window.addEventListener('pointermove', (e) => {
      if (!this.pointer.isDown || !this.canvas) return;
      const pos = getCanvasPos(e);
      const dx = pos.x - this.pointer.prevX;
      const dy = pos.y - this.pointer.prevY;

      this.pointer.x = pos.x;
      this.pointer.y = pos.y;
      this.pointer.prevX = pos.x;
      this.pointer.prevY = pos.y;

      // Add velocity impulse into grid
      this._addImpulse(pos.x, pos.y, dx * 3.5, dy * 3.5);

      const speed = Math.hypot(dx, dy);
      if (speed > 8 && this.audio && this.audioGain > 0.05) {
        const now = Date.now();
        if (now - this.lastAudioEmitTime > 180) {
          this.lastAudioEmitTime = now;
          this.audio.playFluidVortexSwirl(this.vorticity, Math.min(3, speed / 10));
        }
      }
    });

    window.addEventListener('pointerup', () => {
      this.pointer.isDown = false;
    });
  }

  _addImpulse(px, py, fx, fy) {
    const gx = Math.floor(px / this.gridCellSize);
    const gy = Math.floor(py / this.gridCellSize);

    for (let dy = -2; dy <= 2; dy++) {
      for (let dx = -2; dx <= 2; dx++) {
        const cx = gx + dx;
        const cy = gy + dy;
        if (cx >= 0 && cx < this.gridWidth && cy >= 0 && cy < this.gridHeight) {
          const idx = cy * this.gridWidth + cx;
          const dist = Math.hypot(dx, dy) + 0.1;
          const factor = Math.max(0, 1 - dist / 3.0);
          this.velocityGridU[idx] += fx * factor * 0.8;
          this.velocityGridV[idx] += fy * factor * 0.8;
        }
      }
    }
  }

  injectParticles(x, y, count = 20) {
    const w = this.canvas ? this.canvas.width : 620;
    const h = this.canvas ? this.canvas.height : 260;

    for (let i = 0; i < count; i++) {
      if (this.particles.length >= this.maxParticles) {
        this.particles.shift();
      }
      const angle = Math.random() * Math.PI * 2;
      const spd = Math.random() * 40 + 10;
      this.particles.push({
        x: Math.max(10, Math.min(w - 10, x + (Math.random() * 20 - 10))),
        y: Math.max(10, Math.min(h - 10, y + (Math.random() * 20 - 10))),
        vx: Math.cos(angle) * spd,
        vy: Math.sin(angle) * spd,
        life: 0,
        maxLife: Math.random() * 3 + 3,
        mass: Math.random() * 0.8 + 0.6,
        temp: this.thermalGradient + (Math.random() * 10 - 5),
        phase: Math.random() < (this.condensationPhase / 100) ? 1 : 0
      });
    }
  }

  setPreset(presetKey) {
    if (presetKey === 'mist') {
      this.viscosity = 0.04;
      this.vorticity = 2.0;
      this.energyDamping = 0.99;
      this.particleRate = 120;
      this.condensationPhase = 85;
      this.thermalGradient = -10;
      this.vectorGravity = 20;
      this.theme = 'cyan';
    } else if (presetKey === 'vortex') {
      this.viscosity = 0.02;
      this.vorticity = 7.5;
      this.energyDamping = 0.985;
      this.particleRate = 90;
      this.condensationPhase = 30;
      this.thermalGradient = 25;
      this.vectorGravity = 80;
      this.theme = 'amber';
    } else if (presetKey === 'sedation') {
      this.viscosity = 0.25;
      this.vorticity = 1.2;
      this.energyDamping = 0.95;
      this.particleRate = 50;
      this.condensationPhase = 90;
      this.thermalGradient = -30;
      this.vectorGravity = 120;
      this.theme = 'cyan';
    } else if (presetKey === 'plasma') {
      this.viscosity = 0.01;
      this.vorticity = 9.0;
      this.energyDamping = 0.992;
      this.particleRate = 180;
      this.condensationPhase = 10;
      this.thermalGradient = 45;
      this.vectorGravity = -90;
      this.theme = 'crimson';
    } else if (presetKey === 'cryo') {
      this.viscosity = 0.08;
      this.vorticity = 3.5;
      this.energyDamping = 0.98;
      this.particleRate = 70;
      this.condensationPhase = 60;
      this.thermalGradient = -40;
      this.vectorGravity = 40;
      this.theme = 'cyan';
    }

    if (this.audio && this.audioGain > 0.05) {
      this.audio.playThermalTransition(this.thermalGradient);
    }
  }

  resetParticles() {
    this._initGrid();
    this._initParticles();
    this.droplets = [];
    if (this.audio && this.audioGain > 0.05) {
      this.audio.playViscosityShear(0.8);
    }
  }

  togglePlay() {
    this.isPlaying = !this.isPlaying;
    return this.isPlaying;
  }

  _startLoop() {
    let lastTime = performance.now();
    const frame = (now) => {
      const dt = Math.min(0.05, (now - lastTime) / 1000);
      lastTime = now;

      if (this.isPlaying) {
        this.time += dt;
        this._updateSimulation(dt);
      }
      this._render();
      requestAnimationFrame(frame);
    };
    requestAnimationFrame(frame);
  }

  _updateSimulation(dt) {
    const w = this.canvas ? this.canvas.width : 620;
    const h = this.canvas ? this.canvas.height : 260;

    // 1. Grid Velocity & Vorticity Update
    let totalKinetic = 0;
    let totalVort = 0;

    for (let cy = 0; cy < this.gridHeight; cy++) {
      for (let cx = 0; cx < this.gridWidth; cx++) {
        const idx = cy * this.gridWidth + cx;

        // Gravity & Buoyancy force from temperature gradient
        const temp = this.temperatureGrid[idx];
        const buoyancy = -temp * 0.45;
        this.velocityGridV[idx] += (this.vectorGravity + buoyancy) * dt;

        // Vorticity Confinement Swirl
        const waveX = Math.sin(cx * 0.4 + this.time * 2.0) * this.vorticity;
        const waveY = Math.cos(cy * 0.4 + this.time * 2.0) * this.vorticity;
        this.velocityGridU[idx] += waveX * dt * 4.0;
        this.velocityGridV[idx] += waveY * dt * 4.0;

        // Viscosity damping
        this.velocityGridU[idx] *= Math.pow(this.energyDamping, dt * 60);
        this.velocityGridV[idx] *= Math.pow(this.energyDamping, dt * 60);

        const spdSq = this.velocityGridU[idx] * this.velocityGridU[idx] + this.velocityGridV[idx] * this.velocityGridV[idx];
        totalKinetic += spdSq;
        totalVort += Math.abs(waveX) + Math.abs(waveY);
      }
    }

    this.kineticEnergy = Math.sqrt(totalKinetic / (this.gridWidth * this.gridHeight));
    this.totalVorticityFlux = totalVort / (this.gridWidth * this.gridHeight);

    // 2. Particle Injection
    const targetCount = Math.min(this.maxParticles, Math.floor(this.particleRate * 3.5));
    if (this.particles.length < targetCount && Math.random() < 0.6) {
      this.particles.push({
        x: Math.random() * w,
        y: this.vectorGravity >= 0 ? 10 : h - 10,
        vx: (Math.random() * 2 - 1) * 20,
        vy: (Math.random() * 2 - 1) * 20,
        life: 0,
        maxLife: Math.random() * 4 + 3,
        mass: Math.random() * 0.8 + 0.6,
        temp: this.thermalGradient + (Math.random() * 6 - 3),
        phase: Math.random() < (this.condensationPhase / 100) ? 1 : 0
      });
    }

    // 3. Particle Integration & Advection
    for (let i = this.particles.length - 1; i >= 0; i--) {
      const p = this.particles[i];
      p.life += dt;

      if (p.life >= p.maxLife) {
        this.particles.splice(i, 1);
        continue;
      }

      // Sample grid velocity
      const gx = Math.max(0, Math.min(this.gridWidth - 1, Math.floor(p.x / this.gridCellSize)));
      const gy = Math.max(0, Math.min(this.gridHeight - 1, Math.floor(p.y / this.gridCellSize)));
      const gIdx = gy * this.gridWidth + gx;

      const gu = this.velocityGridU[gIdx] || 0;
      const gv = this.velocityGridV[gIdx] || 0;

      p.vx = p.vx * 0.92 + gu * 0.08;
      p.vy = p.vy * 0.92 + gv * 0.08;

      p.x += p.vx * dt;
      p.y += p.vy * dt;

      // Boundary bouncing
      if (p.x < 10) { p.x = 10; p.vx *= -0.6; }
      else if (p.x > w - 10) { p.x = w - 10; p.vx *= -0.6; }

      if (p.y < 10) { p.y = 10; p.vy *= -0.6; }
      else if (p.y > h - 10) {
        p.y = h - 10;
        p.vy *= -0.6;

        // Chance to form condensation droplet on floor
        if (p.phase === 1 && Math.random() < 0.08 && this.droplets.length < 35) {
          this.droplets.push({
            x: p.x,
            y: h - 10,
            radius: Math.random() * 3 + 2,
            life: 0,
            maxLife: Math.random() * 3 + 2
          });
          if (this.audio && this.audioGain > 0.1 && Math.random() < 0.25) {
            const pan = (p.x / w) * 2 - 1;
            this.audio.playCondensationDrip(1600 + Math.random() * 800, pan);
          }
        }
      }
    }

    // 4. Update Droplets
    for (let d = this.droplets.length - 1; d >= 0; d--) {
      const drop = this.droplets[d];
      drop.life += dt;
      if (drop.life >= drop.maxLife) {
        this.droplets.splice(d, 1);
      }
    }
  }

  _render() {
    if (!this.ctx || !this.canvas) return;
    const ctx = this.ctx;
    const w = this.canvas.width;
    const h = this.canvas.height;

    // Clear background
    ctx.fillStyle = '#020508';
    ctx.fillRect(0, 0, w, h);

    let mainColor = '#5da398';
    let glowColor = 'rgba(93, 163, 152, 0.4)';

    if (this.theme === 'amber') {
      mainColor = '#e2b060';
      glowColor = 'rgba(226, 176, 96, 0.4)';
    } else if (this.theme === 'crimson') {
      mainColor = '#de7570';
      glowColor = 'rgba(222, 117, 112, 0.4)';
    }

    // 1. Technical Grid
    ctx.strokeStyle = 'rgba(36, 58, 71, 0.35)';
    ctx.lineWidth = 1;
    for (let x = 0; x < w; x += 40) {
      ctx.beginPath();
      ctx.moveTo(x, 0); ctx.lineTo(x, h);
      ctx.stroke();
    }
    for (let y = 0; y < h; y += 30) {
      ctx.beginPath();
      ctx.moveTo(0, y); ctx.lineTo(w, y);
      ctx.stroke();
    }

    // 2. Velocity Vector Streamlines (Subtle Field Vectors)
    ctx.strokeStyle = 'rgba(74, 109, 124, 0.25)';
    ctx.lineWidth = 1;
    for (let cy = 0; cy < this.gridHeight; cy += 2) {
      for (let cx = 0; cx < this.gridWidth; cx += 2) {
        const idx = cy * this.gridWidth + cx;
        const vx = this.velocityGridU[idx];
        const vy = this.velocityGridV[idx];
        const px = cx * this.gridCellSize + this.gridCellSize / 2;
        const py = cy * this.gridCellSize + this.gridCellSize / 2;

        ctx.beginPath();
        ctx.moveTo(px, py);
        ctx.lineTo(px + Math.max(-15, Math.min(15, vx * 0.4)), py + Math.max(-15, Math.min(15, vy * 0.4)));
        ctx.stroke();
      }
    }

    // 3. Render Particles
    for (let i = 0; i < this.particles.length; i++) {
      const p = this.particles[i];
      const progress = p.life / p.maxLife;
      const alpha = progress < 0.2 ? (progress / 0.2) : (1 - progress);

      ctx.save();
      if (p.phase === 1) {
        // Condensation droplet particle
        ctx.fillStyle = `rgba(117, 199, 195, ${alpha * 0.9})`;
        ctx.shadowBlur = 6;
        ctx.shadowColor = glowColor;
        ctx.beginPath();
        ctx.arc(p.x, p.y, 2.2 * p.mass, 0, Math.PI * 2);
        ctx.fill();
      } else {
        // Vapor / Vector particle
        ctx.fillStyle = this.theme === 'amber'
          ? `rgba(226, 176, 96, ${alpha * 0.75})`
          : (this.theme === 'crimson' ? `rgba(222, 117, 112, ${alpha * 0.75})` : `rgba(93, 163, 152, ${alpha * 0.75})`);
        ctx.beginPath();
        ctx.arc(p.x, p.y, 1.4 * p.mass, 0, Math.PI * 2);
        ctx.fill();
      }
      ctx.restore();
    }

    // 4. Render Condensation Floor Droplets
    for (let d = 0; d < this.droplets.length; d++) {
      const drop = this.droplets[d];
      const alpha = 1 - (drop.life / drop.maxLife);
      ctx.save();
      ctx.fillStyle = `rgba(117, 199, 195, ${alpha * 0.8})`;
      ctx.shadowBlur = 8;
      ctx.shadowColor = 'rgba(117, 199, 195, 0.5)';
      ctx.beginPath();
      ctx.ellipse(drop.x, drop.y, drop.radius * 1.5, drop.radius * 0.7, 0, 0, Math.PI * 2);
      ctx.fill();
      ctx.restore();
    }

    // 5. Polar Vorticity / Reynolds Gauge (Right Corner)
    const gaugeX = w - 85;
    const gaugeY = 80;
    const gaugeR = 48;

    ctx.save();
    ctx.strokeStyle = 'rgba(93, 163, 152, 0.4)';
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    ctx.arc(gaugeX, gaugeY, gaugeR, 0, Math.PI * 2);
    ctx.stroke();

    // Polar lines
    ctx.beginPath();
    ctx.moveTo(gaugeX - gaugeR, gaugeY); ctx.lineTo(gaugeX + gaugeR, gaugeY);
    ctx.moveTo(gaugeX, gaugeY - gaugeR); ctx.lineTo(gaugeX, gaugeY + gaugeR);
    ctx.stroke();

    // Rotating Vorticity Vector
    const vAngle = this.time * (this.vorticity * 0.6) + (this.thermalGradient * 0.05);
    ctx.strokeStyle = mainColor;
    ctx.shadowBlur = 8;
    ctx.shadowColor = glowColor;
    ctx.lineWidth = 2.0;
    ctx.beginPath();
    ctx.moveTo(gaugeX, gaugeY);
    ctx.lineTo(gaugeX + Math.cos(vAngle) * (gaugeR * 0.85), gaugeY + Math.sin(vAngle) * (gaugeR * 0.85));
    ctx.stroke();
    ctx.restore();

    ctx.fillStyle = '#6b8291';
    ctx.font = '8px monospace';
    ctx.textAlign = 'center';
    ctx.fillText('WIROWOŚĆ ∇×u', gaugeX, gaugeY + gaugeR + 14);

    // 6. Telemetry Overlay
    ctx.fillStyle = '#6b8291';
    ctx.font = '9px monospace';
    ctx.textAlign = 'left';
    ctx.fillText(`CZĄSTKI: ${this.particles.length} | LEPKOŚĆ: ${this.viscosity.toFixed(2)} | WIROWOŚĆ: ${this.vorticity.toFixed(1)} | TEMP: ${this.thermalGradient}°C`, 20, 24);

    const reynolds = (this.kineticEnergy * 18.5 / (this.viscosity + 0.01)).toFixed(1);
    ctx.fillText(`LICZBA REYNOLDSA (Re): ${reynolds} | ENERGIA KINETYCZNA: ${this.kineticEnergy.toFixed(2)}`, 20, h - 18);

    ctx.textAlign = 'right';
    ctx.fillStyle = this.isPlaying ? mainColor : '#6b8291';
    ctx.fillText(this.isPlaying ? '● DYNAMIKA PŁYNÓW AKTYWNA' : '○ SYMULACJA WSTRZYMANA', w - 20, h - 18);
  }

  renderFluidWav(durationSeconds = 6) {
    const sampleRate = 44100;
    const numChannels = 2;
    const numSamples = Math.floor(sampleRate * durationSeconds);
    const leftBuffer = new Float32Array(numSamples);
    const rightBuffer = new Float32Array(numSamples);

    const baseFreq = 70 + Math.min(300, this.vorticity * 25);
    const dripFreq = 1800 + this.condensationPhase * 10;

    for (let i = 0; i < numSamples; i++) {
      const t = i / sampleRate;
      let env = 1.0;
      if (t < 0.05) env = t / 0.05;
      else if (t > durationSeconds - 0.2) env = (durationSeconds - t) / 0.2;

      // Swirl modulation
      const swirl = Math.sin(2 * Math.PI * baseFreq * t) * 0.4;
      const swirlSub = Math.sin(2 * Math.PI * (baseFreq * 0.5) * t) * 0.3;
      const shearNoise = (Math.random() * 2 - 1) * (this.viscosity * 0.35);

      // Periodic condensation drops in render
      let dripSig = 0;
      const dropPeriod = 0.45;
      const dropPhase = t % dropPeriod;
      if (dropPhase < 0.08) {
        const dropEnv = 1 - (dropPhase / 0.08);
        dripSig = Math.sin(2 * Math.PI * (dripFreq + dropPhase * 2000) * t) * dropEnv * 0.4;
      }

      const modSig = (swirl + swirlSub + shearNoise + dripSig) * env;
      const panL = Math.cos((Math.sin(t * 1.5) + 1) * (Math.PI / 4));
      const panR = Math.sin((Math.sin(t * 1.5) + 1) * (Math.PI / 4));

      leftBuffer[i] = Math.max(-1, Math.min(1, modSig * panL * 0.85));
      rightBuffer[i] = Math.max(-1, Math.min(1, modSig * panR * 0.85));
    }

    // Build 16-bit PCM WAV File Header
    const byteLength = 44 + numSamples * numChannels * 2;
    const arrayBuffer = new ArrayBuffer(byteLength);
    const view = new DataView(arrayBuffer);

    this._writeString(view, 0, 'RIFF');
    view.setUint32(4, 36 + numSamples * numChannels * 2, true);
    this._writeString(view, 8, 'WAVE');

    this._writeString(view, 12, 'fmt ');
    view.setUint32(16, 16, true);
    view.setUint16(20, 1, true); // PCM
    view.setUint16(22, numChannels, true);
    view.setUint32(24, sampleRate, true);
    view.setUint32(28, sampleRate * numChannels * 2, true);
    view.setUint16(32, numChannels * 2, true);
    view.setUint16(34, 16, true);

    this._writeString(view, 36, 'data');
    view.setUint32(40, numSamples * numChannels * 2, true);

    let offset = 44;
    for (let i = 0; i < numSamples; i++) {
      let sL = Math.max(-1, Math.min(1, leftBuffer[i]));
      let sR = Math.max(-1, Math.min(1, rightBuffer[i]));
      let int16L = sL < 0 ? sL * 0x8000 : sL * 0x7FFF;
      let int16R = sR < 0 ? sR * 0x8000 : sR * 0x7FFF;
      view.setInt16(offset, int16L, true);
      view.setInt16(offset + 2, int16R, true);
      offset += 4;
    }

    const blob = new Blob([view], { type: 'audio/wav' });
    const url = URL.createObjectURL(blob);
    const anchor = document.createElement('a');
    anchor.href = url;
    anchor.download = `getting_strange_fluid_resonance_${this.vorticity}vort.wav`;
    document.body.appendChild(anchor);
    anchor.click();
    setTimeout(() => {
      document.body.removeChild(anchor);
      URL.revokeObjectURL(url);
    }, 1000);
  }

  _writeString(view, offset, string) {
    for (let i = 0; i < string.length; i++) {
      view.setUint8(offset + i, string.charCodeAt(i));
    }
  }
}

/* ==========================================================================
   MEMORY RESONANCE SPECTROMETER & DIFFRACTION FRINGES ENGINE (PKG-0073)
   ========================================================================== */
class MemoryResonanceSpectrometer {
  constructor(canvasId, audioEngine) {
    this.canvas = document.getElementById(canvasId);
    this.audio = audioEngine;
    this.ctx = this.canvas ? this.canvas.getContext('2d') : null;

    // Optical & Acoustic Diffraction Parameters
    this.wavelength = 528; // nm (maps to memory harmonics)
    this.slitWidth = 0.12; // mm
    this.slitDistance = 0.45; // mm
    this.screenDistance = 1.5; // m
    this.numSlits = 2; // Double slit baseline
    this.quantumCoherence = 0.92; // 0.0 .. 1.0
    this.carrierHarmonicHz = 740.0;
    this.fringeIntensity = 0.85;

    this.isPlaying = false;
    this.time = 0;
    this.mouseHoverX = null;
    this.mouseHoverY = null;
    this.activePreset = 'carrier740';

    // Particle / Photon detection hits
    this.photonHits = [];
    this.maxPhotons = 300;

    // Web Audio Synthesis Nodes
    this.audioNodes = null;

    if (this.canvas) {
      this._bindEvents();
      this._initPhotons();
      this.startAnimation();
    }
  }

  _bindEvents() {
    this.canvas.addEventListener('mousemove', (e) => {
      const rect = this.canvas.getBoundingClientRect();
      const scaleX = this.canvas.width / rect.width;
      const scaleY = this.canvas.height / rect.height;
      this.mouseHoverX = (e.clientX - rect.left) * scaleX;
      this.mouseHoverY = (e.clientY - rect.top) * scaleY;
    });

    this.canvas.addEventListener('mouseleave', () => {
      this.mouseHoverX = null;
      this.mouseHoverY = null;
    });

    this.canvas.addEventListener('click', (e) => {
      if (!this.canvas) return;
      const rect = this.canvas.getBoundingClientRect();
      const scaleX = this.canvas.width / rect.width;
      const hoverX = (e.clientX - rect.left) * scaleX;
      const normX = (hoverX - this.canvas.width / 2) / (this.canvas.width / 2);
      const freq = Math.round(this.carrierHarmonicHz * (1 + normX * 0.5));
      this.playHoverTone(Math.max(100, Math.min(3000, freq)));
    });
  }

  _initPhotons() {
    this.photonHits = [];
    for (let i = 0; i < 150; i++) {
      this.photonHits.push({
        x: Math.random() * (this.canvas ? this.canvas.width : 620),
        y: 40 + Math.random() * 80,
        alpha: Math.random() * 0.8 + 0.2,
        life: Math.random() * 3.0
      });
    }
  }

  setPreset(presetId) {
    this.activePreset = presetId;
    switch (presetId) {
      case 'carrier740':
        this.wavelength = 528;
        this.carrierHarmonicHz = 740.0;
        this.slitWidth = 0.12;
        this.slitDistance = 0.45;
        this.numSlits = 2;
        this.quantumCoherence = 0.96;
        break;
      case 'line4_split':
        this.wavelength = 610;
        this.carrierHarmonicHz = 528.0;
        this.slitWidth = 0.18;
        this.slitDistance = 0.65;
        this.numSlits = 3;
        this.quantumCoherence = 0.82;
        break;
      case 'substructure40m':
        this.wavelength = 440;
        this.carrierHarmonicHz = 370.0;
        this.slitWidth = 0.25;
        this.slitDistance = 0.80;
        this.numSlits = 4;
        this.quantumCoherence = 0.74;
        break;
      case 'flat14_mirror':
        this.wavelength = 470;
        this.carrierHarmonicHz = 880.0;
        this.slitWidth = 0.08;
        this.slitDistance = 0.35;
        this.numSlits = 2;
        this.quantumCoherence = 0.90;
        break;
      case 'triad_convergence':
        this.wavelength = 550;
        this.carrierHarmonicHz = 1100.0;
        this.slitWidth = 0.15;
        this.slitDistance = 0.50;
        this.numSlits = 5;
        this.quantumCoherence = 0.99;
        break;
    }
    if (this.isPlaying) {
      this._restartAudio();
    }
  }

  startAnimation() {
    const loop = () => {
      this.time += 0.016;
      this.draw();
      requestAnimationFrame(loop);
    };
    requestAnimationFrame(loop);
  }

  _calculateIntensity(x, width) {
    const centerX = width / 2;
    const dx = (x - centerX) * 0.035; // Angle representation
    const lambda = (this.wavelength / 500) * 1.2;
    const k = (2 * Math.PI) / lambda;
    const a = this.slitWidth * 12;
    const d = this.slitDistance * 18;

    const beta = 0.5 * k * a * Math.sin(dx * 0.04);
    const alpha = 0.5 * k * d * Math.sin(dx * 0.04);

    const diffraction = beta === 0 ? 1.0 : Math.pow(Math.sin(beta) / beta, 2);
    let interference = 1.0;

    if (this.numSlits === 2) {
      interference = Math.pow(Math.cos(alpha), 2);
    } else {
      const denom = Math.sin(alpha);
      interference = denom === 0 ? 1.0 : Math.pow(Math.sin(this.numSlits * alpha) / (this.numSlits * denom), 2);
    }

    const coherenceMod = this.quantumCoherence + (1 - this.quantumCoherence) * 0.25;
    return Math.max(0, Math.min(1, diffraction * interference * coherenceMod));
  }

  draw() {
    if (!this.ctx || !this.canvas) return;
    const w = this.canvas.width;
    const h = this.canvas.height;
    const ctx = this.ctx;

    ctx.fillStyle = '#010306';
    ctx.fillRect(0, 0, w, h);

    // 1. Grid Background
    ctx.strokeStyle = 'rgba(36, 58, 71, 0.25)';
    ctx.lineWidth = 1;
    ctx.beginPath();
    for (let x = 0; x < w; x += 40) {
      ctx.moveTo(x, 0); ctx.lineTo(x, h);
    }
    for (let y = 0; y < h; y += 30) {
      ctx.moveTo(0, y); ctx.lineTo(w, y);
    }
    ctx.stroke();

    // 2. Optical Interference Fringe Band (Top Region y=35..135)
    const bandTop = 35;
    const bandHeight = 90;

    const mainColor = this.wavelength > 580 ? '#e2b060' : (this.wavelength < 480 ? '#de7570' : '#75c7c3');
    const glowColor = this.wavelength > 580 ? 'rgba(211, 154, 98, 0.5)' : (this.wavelength < 480 ? 'rgba(198, 93, 88, 0.5)' : 'rgba(93, 163, 152, 0.5)');

    for (let x = 0; x < w; x += 2) {
      const intensity = this._calculateIntensity(x, w);
      ctx.fillStyle = `rgba(${this.wavelength > 580 ? '226, 176, 96' : (this.wavelength < 480 ? '222, 117, 112' : '117, 199, 195')}, ${intensity * 0.95})`;
      ctx.fillRect(x, bandTop, 2, bandHeight);
    }

    // Fringe Border
    ctx.strokeStyle = 'rgba(93, 163, 152, 0.5)';
    ctx.strokeRect(0, bandTop, w, bandHeight);

    // 3. Dynamic Photon Arrival Dots
    if (this.isPlaying || Math.random() < 0.3) {
      const sampleX = Math.random() * w;
      const prob = this._calculateIntensity(sampleX, w);
      if (Math.random() < prob) {
        this.photonHits.push({
          x: sampleX,
          y: bandTop + Math.random() * bandHeight,
          alpha: 1.0,
          life: 2.0
        });
        if (this.photonHits.length > this.maxPhotons) {
          this.photonHits.shift();
        }
      }
    }

    ctx.save();
    for (let i = this.photonHits.length - 1; i >= 0; i--) {
      const p = this.photonHits[i];
      p.life -= 0.016;
      if (p.life <= 0) {
        this.photonHits.splice(i, 1);
        continue;
      }
      ctx.fillStyle = mainColor;
      ctx.shadowBlur = 6;
      ctx.shadowColor = glowColor;
      ctx.beginPath();
      ctx.arc(p.x, p.y, 1.8, 0, Math.PI * 2);
      ctx.fill();
    }
    ctx.restore();

    // 4. Intensity Curve Graph (Bottom Region y=150..245)
    const graphBaseY = h - 25;
    const graphHeight = 85;

    ctx.strokeStyle = 'rgba(93, 163, 152, 0.4)';
    ctx.beginPath();
    ctx.moveTo(0, graphBaseY);
    ctx.lineTo(w, graphBaseY);
    ctx.stroke();

    // Intensity Path
    ctx.save();
    ctx.strokeStyle = mainColor;
    ctx.lineWidth = 2.0;
    ctx.shadowBlur = 10;
    ctx.shadowColor = glowColor;
    ctx.beginPath();

    for (let x = 0; x < w; x += 3) {
      const intensity = this._calculateIntensity(x, w);
      const y = graphBaseY - (intensity * graphHeight);
      if (x === 0) ctx.moveTo(x, y);
      else ctx.lineTo(x, y);
    }
    ctx.stroke();
    ctx.restore();

    // Fill underneath graph curve
    ctx.save();
    ctx.fillStyle = glowColor.replace('0.5', '0.12');
    ctx.beginPath();
    ctx.moveTo(0, graphBaseY);
    for (let x = 0; x < w; x += 3) {
      const intensity = this._calculateIntensity(x, w);
      const y = graphBaseY - (intensity * graphHeight);
      ctx.lineTo(x, y);
    }
    ctx.lineTo(w, graphBaseY);
    ctx.closePath();
    ctx.fill();
    ctx.restore();

    // 5. Interactive Cursor Hover Crosshair & Telemetry
    if (this.mouseHoverX !== null) {
      ctx.save();
      ctx.strokeStyle = '#e2b060';
      ctx.lineWidth = 1.0;
      ctx.setLineDash([4, 4]);

      ctx.beginPath();
      ctx.moveTo(this.mouseHoverX, 0);
      ctx.lineTo(this.mouseHoverX, h);
      ctx.stroke();

      const hoverIntensity = this._calculateIntensity(this.mouseHoverX, w);
      const normX = (this.mouseHoverX - w / 2) / (w / 2);
      const hoverFreq = Math.round(this.carrierHarmonicHz * (1 + normX * 0.5));

      ctx.fillStyle = '#e2b060';
      ctx.font = '10px monospace';
      ctx.textAlign = this.mouseHoverX > w - 160 ? 'right' : 'left';
      const textX = this.mouseHoverX > w - 160 ? this.mouseHoverX - 10 : this.mouseHoverX + 10;
      ctx.fillText(`x: ${Math.round(this.mouseHoverX)}px | I/I₀: ${(hoverIntensity * 100).toFixed(1)}% | f: ${hoverFreq} Hz`, textX, Math.max(50, Math.min(h - 30, this.mouseHoverY || 100)));
      ctx.restore();
    }

    // 6. Spectrometer Telemetry Header & Footer
    ctx.fillStyle = '#6b8291';
    ctx.font = '9px monospace';
    ctx.textAlign = 'left';
    ctx.fillText(`SPEKTROMETR REZONANSU IKP-SPEC-78 | DŁUGOŚĆ FALI: ${this.wavelength} nm | SZCZELINY: N=${this.numSlits} (d=${this.slitDistance}mm, a=${this.slitWidth}mm)`, 16, 20);

    ctx.fillText(`NOŚNA PAMIĘCIOWA: ${this.carrierHarmonicHz.toFixed(1)} Hz | KOHERENCJA: ${(this.quantumCoherence * 100).toFixed(0)}%`, 16, h - 8);

    ctx.textAlign = 'right';
    ctx.fillStyle = this.isPlaying ? mainColor : '#6b8291';
    ctx.fillText(this.isPlaying ? '● EMISJA SPEKTRALNA AKTYWNA' : '○ EMISJA WSTRZYMANA', w - 16, h - 8);
  }

  play() {
    if (!this.audio) return;
    this.audio.ensureContext();
    this.isPlaying = true;
    this._setupAudio();
  }

  stop() {
    this.isPlaying = false;
    if (this.audioNodes && this.audio && this.audio.ctx) {
      try {
        const now = this.audio.ctx.currentTime;
        this.audioNodes.gainNode.gain.linearRampToValueAtTime(0.0001, now + 0.1);
        setTimeout(() => {
          if (this.audioNodes) {
            this.audioNodes.oscCarrier.stop();
            this.audioNodes.oscHarmonic.stop();
            this.audioNodes.oscSub.stop();
            this.audioNodes = null;
          }
        }, 120);
      } catch (e) {}
    }
  }

  togglePlay() {
    if (this.isPlaying) {
      this.stop();
      return false;
    } else {
      this.play();
      return true;
    }
  }

  _setupAudio() {
    if (!this.audio || !this.audio.ctx) return;
    const ctx = this.audio.ctx;
    const now = ctx.currentTime;

    const oscCarrier = ctx.createOscillator();
    const oscHarmonic = ctx.createOscillator();
    const oscSub = ctx.createOscillator();

    const filterNode = ctx.createBiquadFilter();
    filterNode.type = 'bandpass';
    filterNode.frequency.setValueAtTime(this.carrierHarmonicHz, now);
    filterNode.Q.setValueAtTime(10.0 * this.quantumCoherence, now);

    const gainNode = ctx.createGain();
    gainNode.gain.setValueAtTime(0.001, now);
    gainNode.gain.linearRampToValueAtTime(0.28 * this.fringeIntensity, now + 0.05);

    oscCarrier.type = 'sine';
    oscCarrier.frequency.setValueAtTime(this.carrierHarmonicHz, now);

    oscHarmonic.type = 'triangle';
    oscHarmonic.frequency.setValueAtTime(this.carrierHarmonicHz * (this.numSlits >= 3 ? 1.5 : 2.0), now);

    oscSub.type = 'sine';
    oscSub.frequency.setValueAtTime(this.carrierHarmonicHz * 0.5, now);

    const harmGain = ctx.createGain();
    harmGain.gain.setValueAtTime(0.35, now);
    oscHarmonic.connect(harmGain);
    harmGain.connect(filterNode);

    const subGain = ctx.createGain();
    subGain.gain.setValueAtTime(0.40, now);
    oscSub.connect(subGain);
    subGain.connect(filterNode);

    oscCarrier.connect(filterNode);
    filterNode.connect(gainNode);
    gainNode.connect(this.audio.analyser);

    oscCarrier.start(now);
    oscHarmonic.start(now);
    oscSub.start(now);

    this.audioNodes = { oscCarrier, oscHarmonic, oscSub, filterNode, gainNode };
  }

  _restartAudio() {
    if (this.isPlaying) {
      this.stop();
      setTimeout(() => this.play(), 60);
    }
  }

  playHoverTone(freq) {
    if (!this.audio) return;
    this.audio.ensureContext();
    if (!this.audio.ctx) return;
    const ctx = this.audio.ctx;
    const now = ctx.currentTime;

    const osc = ctx.createOscillator();
    const gain = ctx.createGain();
    osc.type = 'sine';
    osc.frequency.setValueAtTime(freq, now);

    gain.gain.setValueAtTime(0.001, now);
    gain.gain.linearRampToValueAtTime(0.20, now + 0.02);
    gain.gain.exponentialRampToValueAtTime(0.0001, now + 0.35);

    osc.connect(gain);
    gain.connect(this.audio.analyser);
    osc.start(now);
    osc.stop(now + 0.36);
  }

  renderSpectrogramWav(durationSeconds = 6) {
    const sampleRate = 44100;
    const numChannels = 2;
    const numSamples = Math.floor(sampleRate * durationSeconds);
    const leftBuffer = new Float32Array(numSamples);
    const rightBuffer = new Float32Array(numSamples);

    const f0 = this.carrierHarmonicHz;
    const fHarm = f0 * (this.numSlits >= 3 ? 1.5 : 2.0);
    const fSub = f0 * 0.5;

    for (let i = 0; i < numSamples; i++) {
      const t = i / sampleRate;
      let env = 1.0;
      if (t < 0.05) env = t / 0.05;
      else if (t > durationSeconds - 0.2) env = (durationSeconds - t) / 0.2;

      // Optical fringe frequency beating
      const sigCarrier = Math.sin(2 * Math.PI * f0 * t) * 0.5;
      const sigHarmonic = Math.sin(2 * Math.PI * fHarm * t) * 0.25;
      const sigSub = Math.sin(2 * Math.PI * fSub * t) * 0.25;
      const quantumJitter = (Math.random() * 2 - 1) * (1 - this.quantumCoherence) * 0.15;

      const composite = (sigCarrier + sigHarmonic + sigSub + quantumJitter) * env;
      const panL = Math.cos(2 * Math.PI * 0.2 * t) * 0.5 + 0.5;
      const panR = 1.0 - panL;

      leftBuffer[i] = Math.max(-1, Math.min(1, composite * (0.6 + panL * 0.4)));
      rightBuffer[i] = Math.max(-1, Math.min(1, composite * (0.6 + panR * 0.4)));
    }

    // Build WAV File Header
    const byteLength = 44 + numSamples * numChannels * 2;
    const arrayBuffer = new ArrayBuffer(byteLength);
    const view = new DataView(arrayBuffer);

    this.audio._writeString(view, 0, 'RIFF');
    view.setUint32(4, 36 + numSamples * numChannels * 2, true);
    this.audio._writeString(view, 8, 'WAVE');

    this.audio._writeString(view, 12, 'fmt ');
    view.setUint32(16, 16, true);
    view.setUint16(20, 1, true); // PCM
    view.setUint16(22, numChannels, true);
    view.setUint32(24, sampleRate, true);
    view.setUint32(28, sampleRate * numChannels * 2, true);
    view.setUint16(32, numChannels * 2, true);
    view.setUint16(34, 16, true);

    this.audio._writeString(view, 36, 'data');
    view.setUint32(40, numSamples * numChannels * 2, true);

    let offset = 44;
    for (let i = 0; i < numSamples; i++) {
      let sL = Math.max(-1, Math.min(1, leftBuffer[i]));
      let sR = Math.max(-1, Math.min(1, rightBuffer[i]));
      let int16L = sL < 0 ? sL * 0x8000 : sL * 0x7FFF;
      let int16R = sR < 0 ? sR * 0x8000 : sR * 0x7FFF;
      view.setInt16(offset, int16L, true);
      view.setInt16(offset + 2, int16R, true);
      offset += 4;
    }

    const blob = new Blob([view], { type: 'audio/wav' });
    const url = URL.createObjectURL(blob);
    const anchor = document.createElement('a');
    anchor.href = url;
    anchor.download = `getting_strange_spectrogram_${this.carrierHarmonicHz}hz_${this.wavelength}nm.wav`;
    document.body.appendChild(anchor);
    anchor.click();
    setTimeout(() => {
      document.body.removeChild(anchor);
      URL.revokeObjectURL(url);
    }, 1000);
  }
}

/* ==========================================================================
   VACUUM TUBE RESONANCE & CIRCUIT SCHEMATIC ENGINE (PKG-0074)
   ========================================================================== */
class VacuumTubeResonanceEngine {
  constructor(canvasId, audio) {
    this.canvas = document.getElementById(canvasId);
    this.ctx = this.canvas ? this.canvas.getContext("2d") : null;
    this.audio = audio;
    this.isPlaying = false;

    this.anodeVoltage = 250;     // 100 .. 350 V
    this.gridBias = -2.5;        // -6.0 .. 0.0 V
    this.saturation = 0.35;      // 0.0 .. 1.0
    this.lcF0 = 740;             // 40 .. 2400 Hz
    this.lcQ = 12.0;             // 1.0 .. 30.0
    this.feedback = 0.25;        // 0.0 .. 0.8
    this.preset = "triode_740";

    this.time = 0;
    this.electronParticles = [];
    this.initElectrons(36);

    // Web Audio Nodes
    this.nodes = null;

    if (this.canvas) {
      this.initCanvasEvents();
      this.startRenderLoop();
    }
  }

  initElectrons(count) {
    this.electronParticles = [];
    for (let i = 0; i < count; i++) {
      this.electronParticles.push({
        progress: Math.random(),
        speed: 0.2 + Math.random() * 0.3,
        branch: Math.floor(Math.random() * 3), // 0: Cathode->Anode, 1: LC Tank, 2: Feedback
        yOffset: (Math.random() - 0.5) * 12
      });
    }
  }

  initCanvasEvents() {
    this.canvas.addEventListener("click", (e) => {
      const rect = this.canvas.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;
      // Interactive nudge
      this.saturation = Math.min(1.0, Math.max(0.05, (x / rect.width)));
      const satSlider = document.getElementById("circuitSatSlider");
      const satVal = document.getElementById("circuitSatVal");
      if (satSlider) satSlider.value = Math.round(this.saturation * 100);
      if (satVal) satVal.textContent = Math.round(this.saturation * 100) + "%";
      this.updateAudioParams();
    });
  }

  setVa(val) {
    this.anodeVoltage = parseFloat(val);
    const label = document.getElementById("circuitVaVal");
    if (label) label.textContent = Math.round(this.anodeVoltage) + " V";
    this.updateAudioParams();
  }

  setVg(val) {
    this.gridBias = parseFloat(val);
    const label = document.getElementById("circuitVgVal");
    if (label) label.textContent = this.gridBias.toFixed(1) + " V";
    this.updateAudioParams();
  }

  setSaturation(val) {
    this.saturation = parseFloat(val) / 100;
    const label = document.getElementById("circuitSatVal");
    if (label) label.textContent = Math.round(this.saturation * 100) + "%";
    this.updateAudioParams();
  }

  setF0(val) {
    this.lcF0 = parseFloat(val);
    const label = document.getElementById("circuitF0Val");
    if (label) label.textContent = Math.round(this.lcF0) + " Hz";
    this.updateAudioParams();
  }

  setQ(val) {
    this.lcQ = parseFloat(val);
    const label = document.getElementById("circuitQVal");
    if (label) label.textContent = this.lcQ.toFixed(1);
    this.updateAudioParams();
  }

  setFeedback(val) {
    this.feedback = parseFloat(val) / 100;
    const label = document.getElementById("circuitFeedbackVal");
    if (label) label.textContent = Math.round(this.feedback * 100) + "%";
    this.updateAudioParams();
  }

  applyPreset(presetName) {
    this.preset = presetName;
    const presets = {
      triode_740: { va: 250, vg: -2.5, sat: 35, f0: 740, q: 12.0, fb: 25 },
      tetrode_line4: { va: 310, vg: -1.8, sat: 65, f0: 528, q: 18.0, fb: 40 },
      magic_eye_em84: { va: 200, vg: -4.2, sat: 20, f0: 880, q: 8.0, fb: 15 },
      bandpass_substructure: { va: 280, vg: -3.0, sat: 50, f0: 880, q: 25.0, fb: 55 },
      reactor_driver: { va: 340, vg: -0.8, sat: 85, f0: 52, q: 10.0, fb: 70 }
    };

    const p = presets[presetName] || presets.triode_740;
    this.setVa(p.va);
    this.setVg(p.vg);
    this.setSaturation(p.sat);
    this.setF0(p.f0);
    this.setQ(p.q);
    this.setFeedback(p.fb);

    const vaSlider = document.getElementById("circuitVaSlider");
    const vgSlider = document.getElementById("circuitVgSlider");
    const satSlider = document.getElementById("circuitSatSlider");
    const f0Slider = document.getElementById("circuitF0Slider");
    const qSlider = document.getElementById("circuitQSlider");
    const fbSlider = document.getElementById("circuitFeedbackSlider");

    if (vaSlider) vaSlider.value = p.va;
    if (vgSlider) vgSlider.value = p.vg;
    if (satSlider) satSlider.value = p.sat;
    if (f0Slider) f0Slider.value = p.f0;
    if (qSlider) qSlider.value = p.q;
    if (fbSlider) fbSlider.value = p.fb;

    document.querySelectorAll(".circuit-preset-btn").forEach(btn => {
      btn.classList.toggle("active", btn.getAttribute("data-preset") === presetName);
    });
  }

  togglePlay() {
    if (this.isPlaying) {
      this.stop();
    } else {
      this.start();
    }
  }

  start() {
    this.audio.initAudio();
    if (!this.audio.ctx) return;
    this.isPlaying = true;
    const btn = document.getElementById("circuitPlayBtn");
    if (btn) {
      btn.classList.add("recording");
      btn.textContent = (window.i18n && window.i18n.currentLang === 'en') ? "■ Cut Circuit Power" : "■ Wyłącz Zasilanie Obwodu";
    }

    const ctx = this.audio.ctx;
    const now = ctx.currentTime;

    const osc1 = ctx.createOscillator();
    osc1.type = "sine";
    osc1.frequency.setValueAtTime(this.lcF0, now);

    const osc2 = ctx.createOscillator();
    osc2.type = "triangle";
    osc2.frequency.setValueAtTime(this.lcF0 * 2, now);

    const osc2Gain = ctx.createGain();
    osc2Gain.gain.setValueAtTime(0.2, now);
    osc2.connect(osc2Gain);

    const shaper = ctx.createWaveShaper();
    shaper.curve = this.createTubeCurve(this.saturation, this.gridBias);
    shaper.oversample = "4x";

    const filter = ctx.createBiquadFilter();
    filter.type = "bandpass";
    filter.frequency.setValueAtTime(this.lcF0, now);
    filter.Q.setValueAtTime(this.lcQ, now);

    const feedbackNode = ctx.createGain();
    feedbackNode.gain.setValueAtTime(this.feedback * 0.35, now);

    const outGain = ctx.createGain();
    outGain.gain.setValueAtTime(0.28, now);

    osc1.connect(shaper);
    osc2Gain.connect(shaper);
    shaper.connect(filter);
    filter.connect(feedbackNode);
    feedbackNode.connect(shaper); // feedback loop
    filter.connect(outGain);

    outGain.connect(this.audio.analyser);
    outGain.connect(this.audio.masterGain);

    osc1.start(now);
    osc2.start(now);

    this.nodes = { osc1, osc2, osc2Gain, shaper, filter, feedbackNode, outGain };
  }

  stop() {
    this.isPlaying = false;
    const btn = document.getElementById("circuitPlayBtn");
    if (btn) {
      btn.classList.remove("recording");
      btn.textContent = (window.i18n && window.i18n.currentLang === 'en') ? "▶ Engage Filament & Anode Supply" : "▶ Załącz Żarzenie i Anodowe";
    }

    if (this.nodes) {
      try {
        const now = this.audio.ctx ? this.audio.ctx.currentTime : 0;
        this.nodes.outGain.gain.linearRampToValueAtTime(0.0001, now + 0.08);
        setTimeout(() => {
          if (this.nodes) {
            this.nodes.osc1.stop();
            this.nodes.osc2.stop();
            this.nodes.osc1.disconnect();
            this.nodes.osc2.disconnect();
            this.nodes.shaper.disconnect();
            this.nodes.filter.disconnect();
            this.nodes.feedbackNode.disconnect();
            this.nodes.outGain.disconnect();
            this.nodes = null;
          }
        }, 100);
      } catch (e) {}
    }
  }

  createTubeCurve(sat, bias) {
    const n = 1024;
    const curve = new Float32Array(n);
    const k = 1.0 + sat * 8.0;
    const b = bias * 0.15;

    for (let i = 0; i < n; i++) {
      let x = (i * 2) / n - 1;
      let drive = x + b;
      // Asymmetric vacuum tube soft saturation with even harmonic injection
      let y = Math.tanh(k * drive) + 0.25 * (drive * drive) * Math.sign(drive);
      curve[i] = Math.max(-1, Math.min(1, y * 0.8));
    }
    return curve;
  }

  updateAudioParams() {
    if (!this.isPlaying || !this.nodes || !this.audio.ctx) return;
    const now = this.audio.ctx.currentTime;
    this.nodes.osc1.frequency.setTargetAtTime(this.lcF0, now, 0.03);
    this.nodes.osc2.frequency.setTargetAtTime(this.lcF0 * 2, now, 0.03);
    this.nodes.filter.frequency.setTargetAtTime(this.lcF0, now, 0.03);
    this.nodes.filter.Q.setTargetAtTime(this.lcQ, now, 0.03);
    this.nodes.feedbackNode.gain.setTargetAtTime(this.feedback * 0.35, now, 0.03);
    this.nodes.shaper.curve = this.createTubeCurve(this.saturation, this.gridBias);
  }

  startRenderLoop() {
    const render = () => {
      this.time += 0.016;
      this.draw();
      requestAnimationFrame(render);
    };
    requestAnimationFrame(render);
  }

  draw() {
    if (!this.ctx || !this.canvas) return;
    const ctx = this.ctx;
    const w = this.canvas.width;
    const h = this.canvas.height;

    // Background
    ctx.fillStyle = "#010306";
    ctx.fillRect(0, 0, w, h);

    // Subtle Schematic Grid
    ctx.strokeStyle = "rgba(36, 58, 71, 0.25)";
    ctx.lineWidth = 1;
    ctx.beginPath();
    for (let x = 0; x < w; x += 20) {
      ctx.moveTo(x, 0);
      ctx.lineTo(x, h);
    }
    for (let y = 0; y < h; y += 20) {
      ctx.moveTo(0, y);
      ctx.lineTo(w, y);
    }
    ctx.stroke();

    // 1. Draw Vacuum Tube Bulb (ECC83 / EL84)
    const tubeX = 180;
    const tubeY = 130;
    const tubeR = 55;

    ctx.save();
    // Glass Envelope Glow
    const glassGlow = ctx.createRadialGradient(tubeX, tubeY, 10, tubeX, tubeY, tubeR + 15);
    glassGlow.addColorStop(0, "rgba(226, 176, 96, 0.12)");
    glassGlow.addColorStop(0.7, "rgba(93, 163, 152, 0.08)");
    glassGlow.addColorStop(1, "rgba(0, 0, 0, 0)");
    ctx.fillStyle = glassGlow;
    ctx.beginPath();
    ctx.arc(tubeX, tubeY, tubeR + 15, 0, Math.PI * 2);
    ctx.fill();

    // Glass Contour
    ctx.strokeStyle = "rgba(93, 163, 152, 0.8)";
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.arc(tubeX, tubeY, tubeR, Math.PI * 0.15, Math.PI * 0.85, true);
    ctx.lineTo(tubeX + 25, tubeY + 65);
    ctx.lineTo(tubeX - 25, tubeY + 65);
    ctx.closePath();
    ctx.stroke();

    // Glowing Filament / Cathode
    const filamentGlow = ctx.createRadialGradient(tubeX, tubeY + 30, 2, tubeX, tubeY + 30, 22);
    const heaterIntensity = 0.5 + 0.5 * (this.anodeVoltage / 350);
    filamentGlow.addColorStop(0, `rgba(255, 140, 40, ${heaterIntensity})`);
    filamentGlow.addColorStop(0.5, `rgba(226, 100, 30, ${heaterIntensity * 0.5})`);
    filamentGlow.addColorStop(1, "rgba(255, 100, 0, 0)");
    ctx.fillStyle = filamentGlow;
    ctx.fillRect(tubeX - 25, tubeY + 15, 50, 30);

    // Cathode bar
    ctx.strokeStyle = "#ffaa44";
    ctx.lineWidth = 2.5;
    ctx.beginPath();
    ctx.moveTo(tubeX - 18, tubeY + 32);
    ctx.lineTo(tubeX + 18, tubeY + 32);
    ctx.stroke();

    // Grid (Dashed wire)
    ctx.strokeStyle = "rgba(93, 163, 152, 0.9)";
    ctx.setLineDash([4, 4]);
    ctx.lineWidth = 1.8;
    ctx.beginPath();
    ctx.moveTo(tubeX - 22, tubeY + 8);
    ctx.lineTo(tubeX + 22, tubeY + 8);
    ctx.stroke();
    ctx.setLineDash([]);

    // Anode (Solid Plate)
    ctx.strokeStyle = "#ffffff";
    ctx.lineWidth = 3;
    ctx.beginPath();
    ctx.moveTo(tubeX - 24, tubeY - 24);
    ctx.lineTo(tubeX + 24, tubeY - 24);
    ctx.stroke();

    // Tube labels
    ctx.fillStyle = "rgba(93, 163, 152, 0.9)";
    ctx.font = "9px monospace";
    ctx.fillText("ANODE (Va=" + Math.round(this.anodeVoltage) + "V)", tubeX - 45, tubeY - 34);
    ctx.fillStyle = "rgba(226, 176, 96, 0.9)";
    ctx.fillText("GRID (Vg=" + this.gridBias.toFixed(1) + "V)", tubeX + 30, tubeY + 10);
    ctx.fillStyle = "#ffaa44";
    ctx.fillText("CATHODE (6.3V)", tubeX - 35, tubeY + 54);
    ctx.restore();

    // 2. Draw LC Resonant Tank (Right side of tube)
    const lcX = 370;
    const lcY = 130;

    ctx.save();
    ctx.strokeStyle = "rgba(93, 163, 152, 0.85)";
    ctx.lineWidth = 1.8;

    // Connecting wires
    ctx.beginPath();
    ctx.moveTo(tubeX, tubeY - 24);
    ctx.lineTo(tubeX, tubeY - 45);
    ctx.lineTo(lcX, tubeY - 45);
    ctx.lineTo(lcX, lcY - 35);
    ctx.stroke();

    // Inductor L Coils
    const coilX = lcX - 25;
    const coilY = lcY;
    ctx.strokeStyle = "rgba(226, 176, 96, 0.95)";
    ctx.beginPath();
    for (let c = 0; c < 4; c++) {
      ctx.arc(coilX, coilY - 20 + c * 13, 8, -Math.PI * 0.5, Math.PI * 0.5, false);
    }
    ctx.stroke();
    ctx.fillStyle = "rgba(226, 176, 96, 0.9)";
    ctx.font = "9px monospace";
    ctx.fillText("L (LC Tank)", coilX - 32, coilY + 42);

    // Capacitor C Plates
    const capX = lcX + 25;
    const capY = lcY;
    ctx.strokeStyle = "rgba(93, 163, 152, 0.95)";
    ctx.lineWidth = 2.5;
    ctx.beginPath();
    ctx.moveTo(capX - 12, capY - 6);
    ctx.lineTo(capX + 12, capY - 6);
    ctx.moveTo(capX - 12, capY + 6);
    ctx.lineTo(capX + 12, capY + 6);
    ctx.stroke();
    ctx.fillStyle = "rgba(93, 163, 152, 0.9)";
    ctx.font = "9px monospace";
    ctx.fillText("C (f0=" + Math.round(this.lcF0) + "Hz)", capX - 16, capY + 30);

    // Close LC branch
    ctx.lineWidth = 1.5;
    ctx.strokeStyle = "rgba(93, 163, 152, 0.8)";
    ctx.beginPath();
    ctx.moveTo(lcX, lcY - 35);
    ctx.lineTo(coilX, lcY - 28);
    ctx.moveTo(lcX, lcY - 35);
    ctx.lineTo(capX, capY - 6);

    ctx.moveTo(coilX, lcY + 28);
    ctx.lineTo(lcX, lcY + 35);
    ctx.moveTo(capX, capY + 6);
    ctx.lineTo(lcX, lcY + 35);

    // Feedback path back to grid
    ctx.lineTo(lcX + 45, lcY + 35);
    ctx.lineTo(lcX + 45, tubeY + 85);
    ctx.lineTo(tubeX - 45, tubeY + 85);
    ctx.lineTo(tubeX - 45, tubeY + 8);
    ctx.lineTo(tubeX - 22, tubeY + 8);
    ctx.stroke();

    ctx.fillStyle = "rgba(93, 163, 152, 0.85)";
    ctx.fillText("FEEDBACK (β=" + Math.round(this.feedback * 100) + "%)", tubeX - 30, tubeY + 98);
    ctx.restore();

    // 3. Draw EM84 Magic Eye Indicator (Top Right)
    const emX = 520;
    const emY = 55;
    const emW = 85;
    const emH = 26;

    ctx.save();
    ctx.fillStyle = "#020704";
    ctx.strokeStyle = "rgba(70, 210, 130, 0.8)";
    ctx.lineWidth = 1.5;
    ctx.fillRect(emX, emY, emW, emH);
    ctx.strokeRect(emX, emY, emW, emH);

    // Phosphor Green Bars closing based on Coherence / Overdrive
    const coherence = Math.max(0.05, 1.0 - (this.saturation * 0.6 + Math.abs(this.gridBias + 2.5) * 0.1));
    const barWidth = (emW / 2 - 4) * coherence;

    ctx.fillStyle = "rgba(60, 240, 120, 0.85)";
    ctx.shadowColor = "rgba(60, 240, 120, 0.9)";
    ctx.shadowBlur = 8;
    // Left bar
    ctx.fillRect(emX + 3, emY + 3, barWidth, emH - 6);
    // Right bar
    ctx.fillRect(emX + emW - 3 - barWidth, emY + 3, barWidth, emH - 6);
    ctx.shadowBlur = 0;

    ctx.fillStyle = "rgba(60, 240, 120, 0.95)";
    ctx.font = "8px monospace";
    ctx.fillText("EM84 MAGIC EYE: " + Math.round(coherence * 100) + "% COHERENCE", emX - 25, emY - 6);
    ctx.restore();

    // 4. Draw Oscillating Electron Particles
    ctx.save();
    ctx.fillStyle = "#70e0ff";
    ctx.shadowColor = "#70e0ff";
    ctx.shadowBlur = 5;

    this.electronParticles.forEach(p => {
      p.progress += (p.speed * 0.012);
      if (p.progress > 1.0) p.progress = 0.0;

      let px = 0, py = 0;
      if (p.branch === 0) {
        // Cathode -> Anode stream
        px = tubeX + (Math.sin(p.progress * Math.PI * 4 + this.time) * 10);
        py = (tubeY + 30) - (p.progress * 54);
      } else if (p.branch === 1) {
        // Tank loop
        px = lcX - 25 + (p.progress * 50);
        py = lcY + Math.sin(p.progress * Math.PI * 2 + this.time * 2) * 18;
      } else {
        // Feedback wire
        px = tubeX - 45 + (p.progress * (lcX - tubeX + 90));
        py = tubeY + 85 + p.yOffset;
      }

      ctx.beginPath();
      ctx.arc(px, py, 1.8, 0, Math.PI * 2);
      ctx.fill();
    });
    ctx.shadowBlur = 0;
    ctx.restore();

    // 5. Real-time Telemetry Overlay
    ctx.fillStyle = "rgba(93, 163, 152, 0.9)";
    ctx.font = "10px monospace";
    ctx.fillText("IKP VACUUM TUBE SIMULATOR V4.7 // MODEL: ECC83/EL84 DUAL CORRELATOR", 14, 22);
    ctx.fillStyle = "rgba(226, 176, 96, 0.9)";
    ctx.fillText(`THD: ${(this.saturation * 12.5).toFixed(2)}% | Q-FACTOR: ${this.lcQ.toFixed(1)} | Va: ${Math.round(this.anodeVoltage)}V | BIAS: ${this.gridBias.toFixed(1)}V`, 14, h - 14);
  }

  downloadWav(durationSeconds = 4.0) {
    this.audio.initAudio();
    const sampleRate = 44100;
    const numSamples = Math.floor(sampleRate * durationSeconds);
    const numChannels = 2;

    const leftBuffer = new Float32Array(numSamples);
    const rightBuffer = new Float32Array(numSamples);

    const f0 = this.lcF0;
    const q = this.lcQ;
    const sat = this.saturation;
    const bias = this.gridBias;
    const fb = this.feedback;

    let phase1 = 0;
    let phase2 = 0;
    let prevSampleL = 0;
    let prevSampleR = 0;

    for (let i = 0; i < numSamples; i++) {
      const t = i / sampleRate;
      const env = Math.min(1.0, t * 8.0) * Math.min(1.0, (durationSeconds - t) * 4.0);

      phase1 += (2 * Math.PI * f0) / sampleRate;
      phase2 += (2 * Math.PI * (f0 * 2.004)) / sampleRate;

      let rawL = Math.sin(phase1) + 0.3 * Math.sin(phase2) + (prevSampleL * fb * 0.4);
      let rawR = Math.sin(phase1 + 0.25) + 0.3 * Math.sin(phase2 - 0.2) + (prevSampleR * fb * 0.4);

      // Tube saturation curve
      let drivenL = rawL + bias * 0.12;
      let drivenR = rawR + bias * 0.12;
      let k = 1.0 + sat * 6.0;

      let outL = (Math.tanh(k * drivenL) + 0.2 * (drivenL * drivenL)) * 0.65;
      let outR = (Math.tanh(k * drivenR) + 0.2 * (drivenR * drivenR)) * 0.65;

      prevSampleL = outL;
      prevSampleR = outR;

      leftBuffer[i] = outL * env;
      rightBuffer[i] = outR * env;
    }

    // Export 16-bit WAV
    const buffer = new ArrayBuffer(44 + numSamples * numChannels * 2);
    const view = new DataView(buffer);

    this.audio._writeString(view, 0, 'RIFF');
    view.setUint32(4, 36 + numSamples * numChannels * 2, true);
    this.audio._writeString(view, 8, 'WAVE');
    this.audio._writeString(view, 12, 'fmt ');
    view.setUint32(16, 16, true);
    view.setUint16(20, 1, true); // PCM
    view.setUint16(22, numChannels, true);
    view.setUint32(24, sampleRate, true);
    view.setUint32(28, sampleRate * numChannels * 2, true);
    view.setUint16(32, numChannels * 2, true);
    view.setUint16(34, 16, true);

    this.audio._writeString(view, 36, 'data');
    view.setUint32(40, numSamples * numChannels * 2, true);

    let offset = 44;
    for (let i = 0; i < numSamples; i++) {
      let sL = Math.max(-1, Math.min(1, leftBuffer[i]));
      let sR = Math.max(-1, Math.min(1, rightBuffer[i]));
      let int16L = sL < 0 ? sL * 0x8000 : sL * 0x7FFF;
      let int16R = sR < 0 ? sR * 0x8000 : sR * 0x7FFF;
      view.setInt16(offset, int16L, true);
      view.setInt16(offset + 2, int16R, true);
      offset += 4;
    }

    const blob = new Blob([view], { type: 'audio/wav' });
    const url = URL.createObjectURL(blob);
    const anchor = document.createElement('a');
    anchor.href = url;
    anchor.download = `getting_strange_vacuum_tube_${Math.round(f0)}hz_${Math.round(sat * 100)}pct.wav`;
    document.body.appendChild(anchor);
    anchor.click();
    setTimeout(() => {
      document.body.removeChild(anchor);
      URL.revokeObjectURL(url);
    }, 1000);
  }
}

/* ==========================================================================
   ACOUSTIC CROSS-COUPLING & RING MODULATION MATRIX (PKG-0074)
   ========================================================================== */
class AcousticMatrixAnalyzer {
  constructor(canvasId, audio) {
    this.canvas = document.getElementById(canvasId);
    this.ctx = this.canvas ? this.canvas.getContext("2d") : null;
    this.audio = audio;
    this.isPlaying = false;

    this.modType = "ring"; // "ring", "fm", "phase"
    this.modDepth = 0.65;  // 0.0 .. 1.0
    this.phaseCoupling = 60; // 0 .. 360 deg
    this.balance = 0.5;    // 0.0 .. 1.0
    this.preset = "carrier_correlation";

    this.nodes = [
      { id: "ch1", name: "Lena (740 Hz)", freq: 740, color: "#5da398", x: 120, y: 85 },
      { id: "ch2", name: "Line 4 (528 Hz)", freq: 528, color: "#d39a62", x: 280, y: 85 },
      { id: "ch3", name: "Substructure (880 Hz)", freq: 880, color: "#c65d58", x: 120, y: 205 },
      { id: "ch4", name: "Reactor (-85m, 52 Hz)", freq: 52, color: "#46d282", x: 280, y: 205 }
    ];

    this.time = 0;
    this.audioNodes = null;

    if (this.canvas) {
      this.initCanvasEvents();
      this.startRenderLoop();
    }
  }

  initCanvasEvents() {
    this.canvas.addEventListener("click", (e) => {
      const rect = this.canvas.getBoundingClientRect();
      const x = e.clientX - rect.left;
      const y = e.clientY - rect.top;
      // Cycle through modulation types on click on the right quadrant
      if (x > rect.width * 0.6) {
        const types = ["ring", "fm", "phase"];
        const nextIdx = (types.indexOf(this.modType) + 1) % types.length;
        this.setModType(types[nextIdx]);
        const sel = document.getElementById("matrixModTypeSelect");
        if (sel) sel.value = this.modType;
      }
    });
  }

  setModType(type) {
    this.modType = type;
    this.updateAudioParams();
  }

  setModDepth(val) {
    this.modDepth = parseFloat(val) / 100;
    const label = document.getElementById("matrixModDepthVal");
    if (label) label.textContent = Math.round(this.modDepth * 100) + "%";
    this.updateAudioParams();
  }

  setPhaseCoupling(val) {
    this.phaseCoupling = parseFloat(val);
    const label = document.getElementById("matrixPhaseVal");
    if (label) label.textContent = Math.round(this.phaseCoupling) + "°";
    this.updateAudioParams();
  }

  setBalance(val) {
    this.balance = parseFloat(val) / 100;
    const label = document.getElementById("matrixBalanceVal");
    if (label) {
      const left = Math.round((1 - this.balance) * 100);
      const right = Math.round(this.balance * 100);
      label.textContent = `${left} / ${right}`;
    }
    this.updateAudioParams();
  }

  applyPreset(presetName) {
    this.preset = presetName;
    const presets = {
      carrier_correlation: { type: "ring", depth: 65, phase: 60, bal: 50 },
      line4_intermod: { type: "fm", depth: 80, phase: 120, bal: 40 },
      substructure_whispers: { type: "phase", depth: 50, phase: 180, bal: 70 },
      reactor_drone_beat: { type: "ring", depth: 90, phase: 30, bal: 30 },
      full_topology: { type: "fm", depth: 95, phase: 270, bal: 50 }
    };

    const p = presets[presetName] || presets.carrier_correlation;
    this.setModType(p.type);
    this.setModDepth(p.depth);
    this.setPhaseCoupling(p.phase);
    this.setBalance(p.bal);

    const typeSel = document.getElementById("matrixModTypeSelect");
    const depthSlider = document.getElementById("matrixModDepthSlider");
    const phaseSlider = document.getElementById("matrixPhaseSlider");
    const balSlider = document.getElementById("matrixBalanceSlider");

    if (typeSel) typeSel.value = p.type;
    if (depthSlider) depthSlider.value = p.depth;
    if (phaseSlider) phaseSlider.value = p.phase;
    if (balSlider) balSlider.value = p.bal;

    document.querySelectorAll(".acoustic-matrix-preset-btn").forEach(btn => {
      btn.classList.toggle("active", btn.getAttribute("data-preset") === presetName);
    });
  }

  togglePlay() {
    if (this.isPlaying) {
      this.stop();
    } else {
      this.start();
    }
  }

  start() {
    this.audio.initAudio();
    if (!this.audio.ctx) return;
    this.isPlaying = true;
    const btn = document.getElementById("acousticMatrixPlayBtn");
    if (btn) {
      btn.classList.add("recording");
      btn.textContent = (window.i18n && window.i18n.currentLang === 'en') ? "■ Stop Matrix" : "■ Zatrzymaj Matrycę";
    }

    const ctx = this.audio.ctx;
    const now = ctx.currentTime;

    // Carrier 1: 740 Hz
    const osc1 = ctx.createOscillator();
    osc1.frequency.setValueAtTime(740, now);
    const gain1 = ctx.createGain();
    gain1.gain.setValueAtTime(0.2, now);

    // Modulator 2: 528 Hz
    const osc2 = ctx.createOscillator();
    osc2.frequency.setValueAtTime(528, now);
    const gain2 = ctx.createGain();
    gain2.gain.setValueAtTime(0.2, now);

    // Drone 4: 52 Hz
    const osc4 = ctx.createOscillator();
    osc4.type = "sawtooth";
    osc4.frequency.setValueAtTime(52, now);
    const gain4 = ctx.createGain();
    gain4.gain.setValueAtTime(0.15, now);

    // Ring Modulation Multiply Node (Gain modulated by oscillator)
    const ringModGain = ctx.createGain();
    ringModGain.gain.setValueAtTime(0.0, now);
    osc2.connect(ringModGain.gain); // Modulates gain of ringModGain

    const masterOut = ctx.createGain();
    masterOut.gain.setValueAtTime(0.24, now);

    osc1.connect(ringModGain);
    ringModGain.connect(masterOut);
    osc1.connect(gain1);
    gain1.connect(masterOut);
    osc4.connect(gain4);
    gain4.connect(masterOut);

    masterOut.connect(this.audio.analyser);
    masterOut.connect(this.audio.masterGain);

    osc1.start(now);
    osc2.start(now);
    osc4.start(now);

    this.audioNodes = { osc1, osc2, osc4, gain1, gain2, gain4, ringModGain, masterOut };
  }

  stop() {
    this.isPlaying = false;
    const btn = document.getElementById("acousticMatrixPlayBtn");
    if (btn) {
      btn.classList.remove("recording");
      btn.textContent = (window.i18n && window.i18n.currentLang === 'en') ? "▶ Start Coupling Matrix" : "▶ Uruchom Matrycę Sprzężeń";
    }

    if (this.audioNodes) {
      try {
        const now = this.audio.ctx ? this.audio.ctx.currentTime : 0;
        this.audioNodes.masterOut.gain.linearRampToValueAtTime(0.0001, now + 0.08);
        setTimeout(() => {
          if (this.audioNodes) {
            this.audioNodes.osc1.stop();
            this.audioNodes.osc2.stop();
            this.audioNodes.osc4.stop();
            this.audioNodes.osc1.disconnect();
            this.audioNodes.osc2.disconnect();
            this.audioNodes.osc4.disconnect();
            this.audioNodes.masterOut.disconnect();
            this.audioNodes = null;
          }
        }, 100);
      } catch (e) {}
    }
  }

  updateAudioParams() {
    if (!this.isPlaying || !this.audioNodes || !this.audio.ctx) return;
    const now = this.audio.ctx.currentTime;
    this.audioNodes.gain1.gain.setTargetAtTime((1 - this.balance) * 0.25, now, 0.03);
    this.audioNodes.gain2.gain.setTargetAtTime(this.balance * 0.25, now, 0.03);
    this.audioNodes.masterOut.gain.setTargetAtTime(0.2 + this.modDepth * 0.1, now, 0.03);
  }

  startRenderLoop() {
    const render = () => {
      this.time += 0.02;
      this.draw();
      requestAnimationFrame(render);
    };
    requestAnimationFrame(render);
  }

  draw() {
    if (!this.ctx || !this.canvas) return;
    const ctx = this.ctx;
    const w = this.canvas.width;
    const h = this.canvas.height;

    // Background
    ctx.fillStyle = "#010306";
    ctx.fillRect(0, 0, w, h);

    // Draw Cross-Coupling Matrix on the left (4 nodes graph)
    ctx.save();
    // Inter-channel coupling lines
    for (let i = 0; i < this.nodes.length; i++) {
      for (let j = i + 1; j < this.nodes.length; j++) {
        const n1 = this.nodes[i];
        const n2 = this.nodes[j];

        const pulse = 0.5 + 0.5 * Math.sin(this.time * 3 + (i * j));
        ctx.strokeStyle = `rgba(226, 176, 96, ${0.15 + pulse * 0.4 * this.modDepth})`;
        ctx.lineWidth = 1.2 + pulse * 2.0 * this.modDepth;

        ctx.beginPath();
        ctx.moveTo(n1.x, n1.y);
        ctx.lineTo(n2.x, n2.y);
        ctx.stroke();

        // Traveling harmonic wave pulses
        const waveProgress = (this.time * (1.2 + i * 0.3)) % 1.0;
        const wx = n1.x + (n2.x - n1.x) * waveProgress;
        const wy = n1.y + (n2.y - n1.y) * waveProgress;
        ctx.fillStyle = n1.color;
        ctx.beginPath();
        ctx.arc(wx, wy, 2.5, 0, Math.PI * 2);
        ctx.fill();
      }
    }

    // Draw Nodes
    this.nodes.forEach((n, idx) => {
      ctx.save();
      // Outer glow
      ctx.fillStyle = n.color;
      ctx.shadowColor = n.color;
      ctx.shadowBlur = 10;
      ctx.beginPath();
      ctx.arc(n.x, n.y, 8, 0, Math.PI * 2);
      ctx.fill();
      ctx.shadowBlur = 0;

      // Inner Core
      ctx.fillStyle = "#ffffff";
      ctx.beginPath();
      ctx.arc(n.x, n.y, 3.5, 0, Math.PI * 2);
      ctx.fill();

      // Label
      ctx.fillStyle = n.color;
      ctx.font = "9px monospace";
      ctx.fillText(n.name, n.x - 30, n.y + (idx < 2 ? -14 : 22));
      ctx.restore();
    });
    ctx.restore();

    // Draw Lissajous Cross-Modulation Polar Trajectory on the right
    const lissX = 480;
    const lissY = 140;
    const lissR = 68;

    ctx.save();
    ctx.strokeStyle = "rgba(36, 58, 71, 0.4)";
    ctx.lineWidth = 1;
    ctx.beginPath();
    ctx.arc(lissX, lissY, lissR, 0, Math.PI * 2);
    ctx.stroke();
    ctx.beginPath();
    ctx.moveTo(lissX - lissR - 10, lissY);
    ctx.lineTo(lissX + lissR + 10, lissY);
    ctx.moveTo(lissX, lissY - lissR - 10);
    ctx.lineTo(lissX, lissY + lissR + 10);
    ctx.stroke();

    // Lissajous curve (740 Hz vs 528 Hz intermodulation)
    ctx.strokeStyle = this.modType === "ring" ? "rgba(93, 163, 152, 0.9)" : (this.modType === "fm" ? "rgba(226, 176, 96, 0.9)" : "rgba(198, 93, 88, 0.9)");
    ctx.shadowColor = ctx.strokeStyle;
    ctx.shadowBlur = 6;
    ctx.lineWidth = 1.8;
    ctx.beginPath();

    const fRatio = 740 / 528;
    const deltaPhi = (this.phaseCoupling * Math.PI) / 180;
    const steps = 300;

    for (let s = 0; s <= steps; s++) {
      const theta = (s / steps) * Math.PI * 4;
      const lx = lissX + Math.sin(theta * fRatio + this.time + deltaPhi) * (lissR * this.modDepth);
      const ly = lissY + Math.cos(theta + this.time * 0.8) * (lissR * this.modDepth);
      if (s === 0) ctx.moveTo(lx, ly);
      else ctx.lineTo(lx, ly);
    }
    ctx.stroke();
    ctx.shadowBlur = 0;

    ctx.fillStyle = "rgba(93, 163, 152, 0.95)";
    ctx.font = "9px monospace";
    ctx.fillText("LISSAJOUS INTERMODULATION (740 ⨂ 528 Hz)", lissX - 95, lissY - lissR - 14);
    ctx.fillStyle = "rgba(226, 176, 96, 0.9)";
    ctx.fillText(`TYPE: ${this.modType.toUpperCase()} | ΔΦ: ${Math.round(this.phaseCoupling)}°`, lissX - 45, lissY + lissR + 18);
    ctx.restore();

    // Header Telemetry
    ctx.fillStyle = "rgba(93, 163, 152, 0.9)";
    ctx.font = "10px monospace";
    ctx.fillText("ACOUSTIC CROSS-MODULATION MATRIX // 4-CHANNEL TOPOLOGICAL FLUX", 14, 22);
  }

  downloadWav(durationSeconds = 4.0) {
    this.audio.initAudio();
    const sampleRate = 44100;
    const numSamples = Math.floor(sampleRate * durationSeconds);
    const numChannels = 2;

    const leftBuffer = new Float32Array(numSamples);
    const rightBuffer = new Float32Array(numSamples);

    const f1 = 740.0;
    const f2 = 528.0;
    const f3 = 880.0;
    const f4 = 52.0;
    const depth = this.modDepth;
    const dPhi = (this.phaseCoupling * Math.PI) / 180;
    const bal = this.balance;

    for (let i = 0; i < numSamples; i++) {
      const t = i / sampleRate;
      const env = Math.min(1.0, t * 8.0) * Math.min(1.0, (durationSeconds - t) * 4.0);

      const s1 = Math.sin(2 * Math.PI * f1 * t);
      const s2 = Math.sin(2 * Math.PI * f2 * t + dPhi);
      const s3 = Math.sin(2 * Math.PI * f3 * t);
      const s4 = Math.sin(2 * Math.PI * f4 * t);

      let modSignal = 0;
      if (this.modType === "ring") {
        // Ring modulation: s1 * s2
        modSignal = (s1 * s2) * depth + (s1 * (1 - bal) + s2 * bal) * 0.4;
      } else if (this.modType === "fm") {
        // Frequency modulation
        modSignal = Math.sin(2 * Math.PI * f1 * t + (s2 * depth * 3.0)) * 0.7;
      } else {
        // Phase Coupling
        modSignal = Math.sin(2 * Math.PI * f1 * t + dPhi * depth) * 0.5 + (s3 * 0.25);
      }

      const drone = s4 * 0.2;
      leftBuffer[i] = (modSignal * 0.7 + drone + s1 * 0.15) * env;
      rightBuffer[i] = (modSignal * 0.7 + drone + s2 * 0.15) * env;
    }

    // Write WAV 16-bit PCM
    const buffer = new ArrayBuffer(44 + numSamples * numChannels * 2);
    const view = new DataView(buffer);

    this.audio._writeString(view, 0, 'RIFF');
    view.setUint32(4, 36 + numSamples * numChannels * 2, true);
    this.audio._writeString(view, 8, 'WAVE');
    this.audio._writeString(view, 12, 'fmt ');
    view.setUint32(16, 16, true);
    view.setUint16(20, 1, true); // PCM
    view.setUint16(22, numChannels, true);
    view.setUint32(24, sampleRate, true);
    view.setUint32(28, sampleRate * numChannels * 2, true);
    view.setUint16(32, numChannels * 2, true);
    view.setUint16(34, 16, true);

    this.audio._writeString(view, 36, 'data');
    view.setUint32(40, numSamples * numChannels * 2, true);

    let offset = 44;
    for (let i = 0; i < numSamples; i++) {
      let sL = Math.max(-1, Math.min(1, leftBuffer[i]));
      let sR = Math.max(-1, Math.min(1, rightBuffer[i]));
      let int16L = sL < 0 ? sL * 0x8000 : sL * 0x7FFF;
      let int16R = sR < 0 ? sR * 0x8000 : sR * 0x7FFF;
      view.setInt16(offset, int16L, true);
      view.setInt16(offset + 2, int16R, true);
      offset += 4;
    }

    const blob = new Blob([view], { type: 'audio/wav' });
    const url = URL.createObjectURL(blob);
    const anchor = document.createElement('a');
    anchor.href = url;
    anchor.download = `getting_strange_acoustic_matrix_${this.modType}_${Math.round(depth * 100)}pct.wav`;
    document.body.appendChild(anchor);
    anchor.click();
    setTimeout(() => {
      document.body.removeChild(anchor);
      URL.revokeObjectURL(url);
    }, 1000);
  }
}

/**
 * ============================================================================
 * TRANSIT TOPOLOGICAL VECTOR MAP & GRID SIMULATOR (PKG-0075 / D-085)
 * Interaktywna mapa wektorowa węzłów przesyłowych, trakcji Linii 4 i rozjazdów Równi.
 * ============================================================================
 */
class TransitGridTopologicalMap {
  constructor(canvasId, audio) {
    this.canvas = document.getElementById(canvasId);
    this.ctx = this.canvas ? this.canvas.getContext("2d") : null;
    this.audio = audio || window.proceduralAudio;

    this.gridLoad = 1.0; // 0.1 .. 2.0 (10% to 200%)
    this.selectedNodeId = "ikp";
    this.hoverNodeId = null;
    this.time = 0;
    this.surgeActive = false;
    this.surgeTimer = 0;

    // 4 Interactive Traction Switches
    this.switches = {
      alpha: "main",       // IKP Diverter: "main" | "shunt"
      beta: "split",       // Line 4 Switch: "split" | "unified"
      gamma: "open",       // Substructure Incline: "open" | "quarantine"
      omega: "triad_c"     // Triad Resolver: "triad_c" | "triad_a" | "triad_b"
    };

    // 7 Canonical Municipal Nodes
    this.nodes = {
      ikp: { id: "NODE-IKP-01", key: "ikp", labelPl: "IKP Główny (Komora)", labelEn: "IKP Main (Chamber)", x: 80, y: 100, f: 740, coherence: 0.99, sector: "Sektor 1 (IKP)", status: "STABLE", color: "#5da398" },
      line4: { id: "NODE-TRN-04", key: "line4", labelPl: "Torowisko Linii 4", labelEn: "Line 4 Trackway", x: 230, y: 135, f: 528, coherence: 0.88, sector: "Sektor 2 (Tranzyt)", status: "BIFURCATED", color: "#e2b060" },
      flat14: { id: "NODE-DOM-14", key: "flat14", labelPl: "Mieszkanie 14", labelEn: "Flat 14 (Seam)", x: 340, y: 70, f: 480, coherence: 0.82, sector: "Sektor 3 (Tarasowe)", status: "SEAM_40MM", color: "#5da398" },
      point6: { id: "NODE-UCP-06", key: "point6", labelPl: "Punkt Zgodności 6", labelEn: "Agreement Point 6", x: 390, y: 190, f: 880, coherence: 0.94, sector: "Sektor 4 (Urząd UCP)", status: "CONTROLLED", color: "#e2b060" },
      substructure: { id: "NODE-SUB-40", key: "substructure", labelPl: "Podstruktura -40m", labelEn: "Substructure -40m", x: 210, y: 275, f: 660, coherence: 0.62, sector: "Sektor 5 (Szyby)", status: "DISPERSED_TRACE", color: "#c65d58" },
      reactor: { id: "NODE-RCT-85", key: "reactor", labelPl: "Reaktor Ciągłości -85m", labelEn: "Continuity Reactor -85m", x: 470, y: 280, f: 52, coherence: 0.51, sector: "Sektor 6 (Głęboki Rdzeń)", status: "ATTRACTOR", color: "#c65d58" },
      triad: { id: "NODE-END-43", key: "triad", labelPl: "Stacja 43 (Zbieżność)", labelEn: "Station 43 (Triad)", x: 560, y: 120, f: 740, coherence: 0.98, sector: "Sektor 7 (Zbieżność)", status: "RESOLVED", color: "#5da398" }
    };

    // Carrier Flux Particles
    this.particles = [];
    this._initParticles();

    if (this.canvas) {
      this._bindEvents();
      this.startLoop();
    }
  }

  _initParticles() {
    this.particles = [];
    for (let i = 0; i < 48; i++) {
      this.particles.push({
        segment: Math.floor(Math.random() * 7),
        t: Math.random(),
        speed: (0.003 + Math.random() * 0.005),
        size: 1.5 + Math.random() * 1.5,
        color: Math.random() > 0.3 ? "#5da398" : "#e2b060"
      });
    }
  }

  _bindEvents() {
    this.canvas.addEventListener("mousemove", (e) => {
      const rect = this.canvas.getBoundingClientRect();
      const scaleX = this.canvas.width / rect.width;
      const scaleY = this.canvas.height / rect.height;
      const mouseX = (e.clientX - rect.left) * scaleX;
      const mouseY = (e.clientY - rect.top) * scaleY;

      let found = null;
      for (let k in this.nodes) {
        const n = this.nodes[k];
        const dist = Math.hypot(mouseX - n.x, mouseY - n.y);
        if (dist < 18) {
          found = k;
          break;
        }
      }
      this.hoverNodeId = found;
      this.canvas.style.cursor = found ? "pointer" : "default";
    });

    this.canvas.addEventListener("click", (e) => {
      if (this.hoverNodeId) {
        this.selectNode(this.hoverNodeId);
      }
    });
  }

  selectNode(nodeKey) {
    if (!this.nodes[nodeKey]) return;
    this.selectedNodeId = nodeKey;
    const n = this.nodes[nodeKey];

    if (this.audio) {
      this.audio.ensureContext();
      if (n.f === 740) this.audio.playAnchorSound();
      else if (n.f === 528) this.audio.playClinicChimeSound();
      else if (n.f === 880) this.audio.playIntercomWierzbickaToneSound();
      else if (n.f === 660) this.audio.playConduitShaftSound();
      else if (n.f === 52) this.audio.playCorrectionWaveSound();
      else this.audio.playSwitchSound();
    }

    this._updateTelemetryUI();
  }

  toggleSwitch(switchKey) {
    if (!this.switches[switchKey]) return;
    if (switchKey === "alpha") {
      this.switches.alpha = this.switches.alpha === "main" ? "shunt" : "main";
    } else if (switchKey === "beta") {
      this.switches.beta = this.switches.beta === "split" ? "unified" : "split";
    } else if (switchKey === "gamma") {
      this.switches.gamma = this.switches.gamma === "open" ? "quarantine" : "open";
    } else if (switchKey === "omega") {
      const states = ["triad_c", "triad_a", "triad_b"];
      const curIdx = states.indexOf(this.switches.omega);
      this.switches.omega = states[(curIdx + 1) % states.length];
    }

    if (this.audio) this.audio.playSwitchSound();
    this._updateTelemetryUI();
  }

  setGridLoad(val) {
    this.gridLoad = Math.max(0.1, Math.min(2.0, parseFloat(val)));
    const valEl = document.getElementById("transitLoadVal");
    if (valEl) valEl.innerText = `${Math.round(this.gridLoad * 100)}%`;
  }

  simulateSurge() {
    this.surgeActive = true;
    this.surgeTimer = 1.2; // 1.2 seconds of electrical flash/glitch

    if (this.audio) {
      this.audio.playTramTractionSound();
      setTimeout(() => {
        if (this.audio) this.audio.playCorrectionWaveSound();
      }, 200);
    }
  }

  _updateTelemetryUI() {
    const n = this.nodes[this.selectedNodeId];
    if (!n) return;
    const lang = window.i18n ? window.i18n.currentLang : "pl";

    const idEl = document.getElementById("transitNodeIdVal");
    const nameEl = document.getElementById("transitNodeNameVal");
    const freqEl = document.getElementById("transitNodeFreqVal");
    const cohEl = document.getElementById("transitNodeCoherenceVal");
    const secEl = document.getElementById("transitNodeSectorVal");
    const statusEl = document.getElementById("transitNodeStatusVal");

    if (idEl) idEl.innerText = n.id;
    if (nameEl) nameEl.innerText = lang === "en" ? n.labelEn : n.labelPl;
    if (freqEl) freqEl.innerText = `${n.f} Hz`;
    if (cohEl) cohEl.innerText = `${Math.round(n.coherence * 100)}%`;
    if (secEl) secEl.innerText = n.sector;
    if (statusEl) statusEl.innerText = n.status;

    // Update switch button labels
    for (let sw in this.switches) {
      const swBtn = document.getElementById(`transitSwitch_${sw}`);
      if (swBtn) {
        swBtn.innerText = this.switches[sw].toUpperCase();
        swBtn.classList.toggle("active", this.switches[sw] !== "main" && this.switches[sw] !== "unified" && this.switches[sw] !== "quarantine");
      }
    }
  }

  startLoop() {
    const loop = () => {
      this.time += 0.016;
      if (this.surgeActive) {
        this.surgeTimer -= 0.016;
        if (this.surgeTimer <= 0) this.surgeActive = false;
      }
      this.draw();
      requestAnimationFrame(loop);
    };
    requestAnimationFrame(loop);
  }

  draw() {
    if (!this.ctx || !this.canvas) return;
    const ctx = this.ctx;
    const w = this.canvas.width;
    const h = this.canvas.height;

    // Dark modernist CRT background
    ctx.fillStyle = this.surgeActive && Math.sin(this.time * 60) > 0 ? "#0d1a22" : "#020407";
    ctx.fillRect(0, 0, w, h);

    // 1. Subterranean Sector Grid & Geodetic Strata
    ctx.strokeStyle = "rgba(36, 58, 71, 0.35)";
    ctx.lineWidth = 1;

    for (let x = 0; x < w; x += 40) {
      ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, h); ctx.stroke();
    }
    for (let y = 0; y < h; y += 35) {
      ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(w, y); ctx.stroke();
    }

    // Depth strata dividers
    ctx.strokeStyle = "rgba(93, 163, 152, 0.25)";
    ctx.setLineDash([4, 4]);
    ctx.beginPath(); ctx.moveTo(0, 165); ctx.lineTo(w, 165); ctx.stroke(); // 0m / Surface vs Subterranean
    ctx.beginPath(); ctx.moveTo(0, 245); ctx.lineTo(w, 245); ctx.stroke(); // -40m / Deep Core
    ctx.setLineDash([]);

    ctx.fillStyle = "rgba(107, 130, 145, 0.6)";
    ctx.font = "8px monospace";
    ctx.fillText("POWIERZCHNIA (+15 m) // SEKTORY 1-3", 10, 158);
    ctx.fillText("TRANZYT I URZĄD UCP (-20 m) // SEKTOR 4", 10, 238);
    ctx.fillText("GŁĘBOKA PODSTRUKTURA (-40m do -85m) // SEKTORY 5-7", 10, 335);

    // 2. Trackway Topologies & Connections
    const n = this.nodes;

    // Segment definitions (P1 -> P2)
    const trackSegments = [
      { p1: n.ikp, p2: n.line4, label: "Trakcja L4 Główna (740->528 Hz)", active: true, double: false },
      { p1: n.line4, p2: n.flat14, label: "Linia Zastępcza / Szew (480 Hz)", active: true, double: false },
      { p1: n.flat14, p2: n.triad, label: "Wektor Północny (740 Hz)", active: true, double: false },
      { p1: n.line4, p2: n.point6, label: "Odgałęzienie Punkt 6 (880 Hz)", active: this.switches.beta === "split", double: true },
      { p1: n.point6, p2: n.triad, label: "Magistrala Konsensusu (Triada)", active: true, double: false },
      { p1: n.line4, p2: n.substructure, label: "Szyb Zjazdowy (-40m)", active: this.switches.gamma === "open", double: false },
      { p1: n.substructure, p2: n.reactor, label: "Ciąg Ciągłości (-85m)", active: true, double: true },
      { p1: n.reactor, p2: n.triad, label: "Sprzężenie Atraktora", active: true, double: false },
      { p1: n.point6, p2: n.reactor, label: "Kompensacja Sedacji", active: true, double: false }
    ];

    // Draw Tracks
    for (let seg of trackSegments) {
      ctx.lineWidth = seg.active ? 2.5 : 1.0;
      ctx.strokeStyle = seg.active ? "rgba(93, 163, 152, 0.75)" : "rgba(50, 70, 80, 0.35)";

      if (seg.double && seg.active) {
        // Double-track dual vector representation
        ctx.strokeStyle = "rgba(226, 176, 96, 0.85)";
        ctx.beginPath();
        ctx.moveTo(seg.p1.x - 3, seg.p1.y - 3);
        ctx.lineTo(seg.p2.x - 3, seg.p2.y - 3);
        ctx.stroke();

        ctx.strokeStyle = "rgba(93, 163, 152, 0.85)";
        ctx.beginPath();
        ctx.moveTo(seg.p1.x + 3, seg.p1.y + 3);
        ctx.lineTo(seg.p2.x + 3, seg.p2.y + 3);
        ctx.stroke();
      } else {
        ctx.beginPath();
        ctx.moveTo(seg.p1.x, seg.p1.y);
        ctx.lineTo(seg.p2.x, seg.p2.y);
        ctx.stroke();
      }

      // Railway ties / sleepers pattern
      const dx = seg.p2.x - seg.p1.x;
      const dy = seg.p2.y - seg.p1.y;
      const dist = Math.hypot(dx, dy);
      const angle = Math.atan2(dy, dx);
      const numTies = Math.floor(dist / 14);

      ctx.strokeStyle = "rgba(36, 58, 71, 0.6)";
      ctx.lineWidth = 1;
      for (let t = 1; t < numTies; t++) {
        const tx = seg.p1.x + (dx / numTies) * t;
        const ty = seg.p1.y + (dy / numTies) * t;
        const perpX = Math.cos(angle + Math.PI / 2) * 4;
        const perpY = Math.sin(angle + Math.PI / 2) * 4;
        ctx.beginPath();
        ctx.moveTo(tx - perpX, ty - perpY);
        ctx.lineTo(tx + perpX, ty + perpY);
        ctx.stroke();
      }
    }

    // 3. Draw Carrier Flux Particles
    for (let pt of this.particles) {
      pt.t += pt.speed * this.gridLoad;
      if (pt.t > 1.0) {
        pt.t = 0;
        pt.segment = Math.floor(Math.random() * trackSegments.length);
      }

      const seg = trackSegments[pt.segment];
      if (!seg || !seg.active) continue;

      const px = seg.p1.x + (seg.p2.x - seg.p1.x) * pt.t;
      const py = seg.p1.y + (seg.p2.y - seg.p1.y) * pt.t;

      ctx.fillStyle = this.surgeActive ? "#c65d58" : pt.color;
      ctx.shadowColor = ctx.fillStyle;
      ctx.shadowBlur = 6;
      ctx.beginPath();
      ctx.arc(px, py, pt.size, 0, Math.PI * 2);
      ctx.fill();
      ctx.shadowBlur = 0;
    }

    // 4. Draw Switches (Alpha, Beta, Gamma, Omega)
    this._drawSwitchIcon(ctx, (n.ikp.x + n.line4.x) / 2, (n.ikp.y + n.line4.y) / 2, "ALPHA", this.switches.alpha);
    this._drawSwitchIcon(ctx, n.line4.x + 25, n.line4.y + 20, "BETA", this.switches.beta);
    this._drawSwitchIcon(ctx, (n.line4.x + n.substructure.x) / 2 - 10, (n.line4.y + n.substructure.y) / 2, "GAMMA", this.switches.gamma);
    this._drawSwitchIcon(ctx, n.triad.x - 30, n.triad.y + 15, "OMEGA", this.switches.omega);

    // 5. Draw Municipal Nodes
    for (let k in this.nodes) {
      const node = this.nodes[k];
      const isSelected = this.selectedNodeId === k;
      const isHovered = this.hoverNodeId === k;

      // Outer glow & pulse ring
      const pulse = Math.sin(this.time * 4 + node.f * 0.01) * 3;
      const radius = 10 + pulse;

      ctx.strokeStyle = isSelected ? "#ffffff" : node.color;
      ctx.lineWidth = isSelected ? 2.5 : 1.5;
      ctx.fillStyle = isSelected ? "rgba(93, 163, 152, 0.4)" : "rgba(10, 20, 26, 0.9)";

      ctx.beginPath();
      ctx.arc(node.x, node.y, isHovered ? 13 : 10, 0, Math.PI * 2);
      ctx.fill();
      ctx.stroke();

      if (isSelected || isHovered) {
        ctx.strokeStyle = node.color;
        ctx.lineWidth = 1;
        ctx.beginPath();
        ctx.arc(node.x, node.y, 16 + pulse, 0, Math.PI * 2);
        ctx.stroke();
      }

      // Central core dot
      ctx.fillStyle = node.color;
      ctx.beginPath();
      ctx.arc(node.x, node.y, 3.5, 0, Math.PI * 2);
      ctx.fill();

      // Node Label & Frequency
      ctx.fillStyle = isSelected ? "#ffffff" : "#c4d4de";
      ctx.font = "bold 9px monospace";
      ctx.fillText(node.id, node.x - 22, node.y - 14);

      ctx.fillStyle = node.color;
      ctx.font = "8px monospace";
      ctx.fillText(`${node.f} Hz`, node.x - 14, node.y + 22);
    }

    // 6. Header Status Telemetry Overlay
    ctx.fillStyle = "rgba(93, 163, 152, 0.9)";
    ctx.font = "10px monospace";
    ctx.fillText(`RÓWIEŃ TRANSIT TOPOLOGICAL VECTOR MAP // LOAD: ${Math.round(this.gridLoad * 100)}%`, 14, 20);

    if (this.surgeActive) {
      ctx.fillStyle = "#c65d58";
      ctx.font = "bold 10px monospace";
      ctx.fillText("⚠ TRACTION POWER FAULT // HARMONIC SURGE DETECTED", w - 320, 20);
    }
  }

  _drawSwitchIcon(ctx, x, y, name, state) {
    ctx.save();
    ctx.fillStyle = "#0c151c";
    ctx.strokeStyle = state === "split" || state === "triad_c" || state === "open" ? "#e2b060" : "#5da398";
    ctx.lineWidth = 1.2;

    ctx.beginPath();
    ctx.rect(x - 12, y - 8, 24, 16);
    ctx.fill();
    ctx.stroke();

    ctx.fillStyle = ctx.strokeStyle;
    ctx.font = "bold 7px monospace";
    ctx.textAlign = "center";
    ctx.textBaseline = "middle";
    ctx.fillText(name, x, y);
    ctx.restore();
  }

  exportTopologyJSON() {
    const payload = {
      timestamp: new Date().toISOString(),
      gridLoad: this.gridLoad,
      switches: this.switches,
      nodes: this.nodes,
      carrierBaseHz: 740.0,
      protocolVersion: "PKG-0075"
    };
    const blob = new Blob([JSON.stringify(payload, null, 2)], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = "rowien_transit_topological_map_ucp78.json";
    document.body.appendChild(a);
    a.click();
    setTimeout(() => { document.body.removeChild(a); URL.revokeObjectURL(url); }, 1000);
  }
}

/**
 * ============================================================================
 * CONTINUITY SAFETY PROTOCOL AUDITOR & ANOMALY GENERATOR (PKG-0075 / D-085)
 * Generator i symulator urzędowych raportów bezpieczeństwa osnowy miejskiej UCP.
 * ============================================================================
 */
class ContinuitySafetyProtocolAuditor {
  constructor(canvasId, audio) {
    this.canvas = document.getElementById(canvasId);
    this.ctx = this.canvas ? this.canvas.getContext("2d") : null;
    this.audio = audio || window.proceduralAudio;

    this.regime = "standard"; // standard | emergency | closure43 | line4_audit
    this.suppressionDamping = 0.85; // 0.0 .. 1.0
    this.resonanceTolerance = 12.0; // ±1 .. ±50 Hz
    this.time = 0;
    this.lastProtocol = null;

    if (this.canvas) {
      this.startLoop();
    }
  }

  setRegime(reg) {
    this.regime = reg;
    if (this.audio) this.audio.playSwitchSound();
    const valEl = document.getElementById("safetyRegimeVal");
    if (valEl) valEl.innerText = reg.toUpperCase();
  }

  setSuppression(val) {
    this.suppressionDamping = parseFloat(val) / 100;
    const valEl = document.getElementById("safetyDampingVal");
    if (valEl) valEl.innerText = `${val}%`;
  }

  setTolerance(val) {
    this.resonanceTolerance = parseFloat(val);
    const valEl = document.getElementById("safetyToleranceVal");
    if (valEl) valEl.innerText = `±${val} Hz`;
  }

  calculateMetrics() {
    let baseStability = 98.5;
    let drift = 3.2;
    let margin = 24.5;
    let witnessIntegrity = 0.94;

    if (this.regime === "emergency") {
      baseStability = 62.4;
      drift = 38.6;
      margin = -12.4;
      witnessIntegrity = 0.58;
    } else if (this.regime === "closure43") {
      baseStability = 100.0;
      drift = 0.0;
      margin = 48.0;
      witnessIntegrity = 1.00;
    } else if (this.regime === "line4_audit") {
      baseStability = 79.2;
      drift = 24.1;
      margin = 8.5;
      witnessIntegrity = 0.82;
    }

    // Apply damping and tolerance modulations
    const stability = Math.max(10, Math.min(100, baseStability * (0.8 + this.suppressionDamping * 0.2)));
    const finalDrift = Math.max(0, drift * (1.2 - this.suppressionDamping * 0.5));
    const finalMargin = margin + (this.suppressionDamping * 10) - (this.resonanceTolerance * 0.2);

    return {
      stability: stability.toFixed(2),
      drift: finalDrift.toFixed(2),
      margin: finalMargin.toFixed(1),
      witnessIntegrity: (witnessIntegrity * 100).toFixed(1),
      anomaliesCount: this.regime === "emergency" ? 14 : (this.regime === "closure43" ? 0 : 3)
    };
  }

  generateOfficialProtocol() {
    const metrics = this.calculateMetrics();
    const token = `UCP-AUD-78-${Math.floor(1000 + Math.random() * 9000)}`;
    const now = new Date();
    const dateStr = "03.11.1978 23:45";

    const lang = window.i18n ? window.i18n.currentLang : "pl";

    this.lastProtocol = {
      token: token,
      regime: this.regime,
      date: dateStr,
      metrics: metrics,
      directorSign: "dr Helena Wierzbicka (Dyrektor UCP)",
      engineerSign: "inż. Lena Wolska (Starszy Inżynier IKP)",
      verdictPl: metrics.stability > 80 ? "OSNOWA MIEJSKA STABILNA — ZEZWOLENIE NA KURS NOCNY" : "WYKRYTO ANOMALIE TRANZYTOWE — ZALECA SIĘ ZAKOTWICZENIE MATERII",
      verdictEn: metrics.stability > 80 ? "MUNICIPAL FABRIC STABLE — NIGHT TRANSIT PERMITTED" : "TRANSIT ANOMALIES DETECTED — MATERIAL ANCHORING REQUIRED"
    };

    if (this.audio) {
      this.audio.playClinicChimeSound();
      setTimeout(() => {
        if (this.audio) this.audio.playGoldRingChimeSound();
      }, 300);
    }

    const outputEl = document.getElementById("safetyProtocolOutput");
    if (outputEl) {
      outputEl.innerText = `===============================================================
URZĄD CIĄGŁOŚCI PRZESTRZENNEJ // PROTOKÓŁ BEZPIECZEŃSTWA OSNOWY
SYGNATURA DOKUMENTU: ${token} | DATA: ${dateStr}
REŻIM INSPEKCJI:     ${this.regime.toUpperCase()}
===============================================================
WSKAŹNIK STABILNOŚCI OSNOWY (S):      ${metrics.stability}%
UCHYB BIOGRAFICZNY ŚWIADKÓW (ΔB):     ${metrics.drift}%
MARGINES BEZPIECZEŃSTWA YIELD (My):   ${metrics.margin}%
INTEGRALNOŚĆ PAMIĘCI ŚWIADKÓW (Iw):   ${metrics.witnessIntegrity}%
LICZBA AKTYWNYCH SZWÓW RELACYJNYCH:   ${metrics.anomaliesCount}

ORZECZENIE INSPEKCYJNE:
-> ${lang === "en" ? this.lastProtocol.verdictEn : this.lastProtocol.verdictPl}

ZATWIERDZILI:
1. ${this.lastProtocol.directorSign} [PIECZĘĆ URZĘDOWA UCP]
2. ${this.lastProtocol.engineerSign} [KORELATOR IKP-740Hz]
===============================================================`;
    }

    return this.lastProtocol;
  }

  startLoop() {
    const loop = () => {
      this.time += 0.02;
      this.draw();
      requestAnimationFrame(loop);
    };
    requestAnimationFrame(loop);
  }

  draw() {
    if (!this.ctx || !this.canvas) return;
    const ctx = this.ctx;
    const w = this.canvas.width;
    const h = this.canvas.height;

    ctx.fillStyle = "#020406";
    ctx.fillRect(0, 0, w, h);

    // 1. Grid
    ctx.strokeStyle = "rgba(36, 58, 71, 0.4)";
    ctx.lineWidth = 1;
    for (let x = 0; x < w; x += 30) {
      ctx.beginPath(); ctx.moveTo(x, 0); ctx.lineTo(x, h); ctx.stroke();
    }
    for (let y = 0; y < h; y += 25) {
      ctx.beginPath(); ctx.moveTo(0, y); ctx.lineTo(w, y); ctx.stroke();
    }

    // 2. Waveform of Fabric Stability Envelope S(t)
    const metrics = this.calculateMetrics();
    const stab = parseFloat(metrics.stability) / 100;
    const midY = h / 2;

    ctx.strokeStyle = stab > 0.8 ? "rgba(93, 163, 152, 0.95)" : (stab > 0.6 ? "rgba(226, 176, 96, 0.95)" : "rgba(198, 93, 88, 0.95)");
    ctx.shadowColor = ctx.strokeStyle;
    ctx.shadowBlur = 8;
    ctx.lineWidth = 2.0;
    ctx.beginPath();

    for (let x = 0; x < w; x++) {
      const t = (x / w) * 8 * Math.PI;
      const decay = Math.exp(-0.08 * (x / w));
      const noise = (Math.random() - 0.5) * (1.0 - stab) * 20;
      const y = midY + Math.sin(t + this.time * 3) * (50 * stab) * decay + noise;

      if (x === 0) ctx.moveTo(x, y);
      else ctx.lineTo(x, y);
    }
    ctx.stroke();
    ctx.shadowBlur = 0;

    // 3. Watermark Stamp
    ctx.save();
    ctx.translate(w / 2, h / 2);
    ctx.rotate(-0.15);
    ctx.strokeStyle = "rgba(93, 163, 152, 0.15)";
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.arc(0, 0, 70, 0, Math.PI * 2);
    ctx.stroke();
    ctx.font = "bold 9px monospace";
    ctx.fillStyle = "rgba(93, 163, 152, 0.18)";
    ctx.textAlign = "center";
    ctx.fillText("URZĄD CIĄGŁOŚCI PRZESTRZENNEJ", 0, -10);
    ctx.fillText("INSPEKCJA BEZPIECZEŃSTWA", 0, 8);
    ctx.fillText("1978 — RÓWIEŃ", 0, 26);
    ctx.restore();

    // 4. Header Telemetry
    ctx.fillStyle = "rgba(93, 163, 152, 0.9)";
    ctx.font = "10px monospace";
    ctx.fillText(`CONTINUITY SAFETY ENVELOPE // STABILITY: ${metrics.stability}% | DRIFT: ${metrics.drift}%`, 12, 18);
  }

  exportProtocolJSON() {
    if (!this.lastProtocol) this.generateOfficialProtocol();
    const blob = new Blob([JSON.stringify(this.lastProtocol, null, 2)], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `ucp_safety_protocol_${this.lastProtocol.token.toLowerCase()}.json`;
    document.body.appendChild(a);
    a.click();
    setTimeout(() => { document.body.removeChild(a); URL.revokeObjectURL(url); }, 1000);
  }

  exportProtocolTXT() {
    if (!this.lastProtocol) this.generateOfficialProtocol();
    const outputEl = document.getElementById("safetyProtocolOutput");
    const text = outputEl ? outputEl.innerText : JSON.stringify(this.lastProtocol, null, 2);
    const blob = new Blob([text], { type: "text/plain;charset=utf-8" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `ucp_safety_protocol_${this.lastProtocol.token.toLowerCase()}.txt`;
    document.body.appendChild(a);
    a.click();
    setTimeout(() => { document.body.removeChild(a); URL.revokeObjectURL(url); }, 1000);
  }
}

/**
 * GETTING STRANGE — Spatial Acoustic Impulse Convolver & Resonance Field Simulator (PKG-0077)
 * Models 43 subterranean chamber geometries, Sabine/Eyring/Fitzroy RT60 across 6 octave bands,
 * Image-Source early reflections, Velvet Noise late diffuse reverberation,
 * Web Audio ConvolverNode routing, 16-bit WAV IR export, and 3D Waterfall Canvas spectrum visualizer.
 */
class SpatialAcousticConvolver {
  constructor(canvasId, audioApparatus) {
    this.canvas = typeof canvasId === "string" ? document.getElementById(canvasId) : canvasId;
    this.ctx = this.canvas ? this.canvas.getContext("2d") : null;
    this.audio = audioApparatus;

    this.currentChamberId = "station_01";
    this.currentMaterial = "concrete";
    this.humidity = 65; // %
    this.temperature = 14.0; // °C
    this.dryWet = 0.50; // 0..1
    this.decayScale = 1.0;
    this.preDelay = 0.018; // 18 ms

    this.convolverNode = null;
    this.dryGainNode = null;
    this.wetGainNode = null;
    this.impulseBuffer = null;
    this.waterfallHistory = []; // Spectral slices for 3D Waterfall
    this.maxWaterfallSlices = 28;
    this.animId = null;
    this.isPulsing = false;
    this.pulseTime = 0;

    // Materials absorption coefficients across 6 octave bands [125Hz, 250Hz, 500Hz, 1kHz, 2kHz, 4kHz]
    this.materials = {
      concrete: { name: "Żelbet Zbrojony", alpha: [0.02, 0.02, 0.03, 0.03, 0.04, 0.05], avg: 0.03 },
      tile: { name: "Kafelki Ceramiczne IKP", alpha: [0.01, 0.02, 0.03, 0.05, 0.06, 0.07], avg: 0.05 },
      steel: { name: "Krata Stalowa Podstruktury", alpha: [0.08, 0.09, 0.10, 0.11, 0.12, 0.12], avg: 0.10 },
      glass: { name: "Szkło Akustyczne Mieszkania 14", alpha: [0.18, 0.12, 0.08, 0.06, 0.04, 0.03], avg: 0.08 },
      lead: { name: "Pancerz Ołowiany Reaktora", alpha: [0.01, 0.01, 0.02, 0.02, 0.03, 0.03], avg: 0.02 },
      sedation: { name: "Porowata Glina Sedacyjna", alpha: [0.20, 0.28, 0.35, 0.42, 0.48, 0.52], avg: 0.35 },
      ballast: { name: "Tłuczeń i Szyny Tranzytu", alpha: [0.12, 0.15, 0.20, 0.24, 0.26, 0.28], avg: 0.20 }
    };

    // 43 Subterranean Chamber Geometries & Physics Models
    this.chambers = this.buildChamberDatabase();

    this.initWaterfall();
    this.populateChamberSelector();
    this.recalculateAcoustics();
    this.startRenderLoop();
  }

  buildChamberDatabase() {
    const db = {};
    const titlesPl = [
      "St. 01 — Sterownia Oscyloskopowa IKP (+15 m)",
      "St. 02 — Korytarz Próżniowy A-4 (+10 m)",
      "St. 03 — Śluza Techniczna B-1 (+8 m)",
      "St. 04 — Bramka Wejściowa IKP (0 m)",
      "St. 05 — Rampa Załadunkowa (0 m)",
      "St. 06 — Skrzyżowanie Rówieńska / Północna",
      "St. 07 — Przystanek Tramwajowy Plac Wolności",
      "St. 08 — Arkady Handlowe Tarasowe",
      "St. 09 — Podwórze Kamienicy nr 12",
      "St. 10 — Klatka Schodowa Osiedla Tarasowego",
      "St. 11 — Korytarz 3. Piętra (Znikający szew)",
      "St. 12 — Przedpokój Mieszkania 14",
      "St. 13 — Kuchnia Mieszkania 14 (Szew 40 mm)",
      "St. 14 — Łazienka z Lustrem Kwarcowym",
      "St. 15 — Balkon Mieszkania 14 (Widok na trakcję)",
      "St. 16 — Hol Urzędu Ciągłości Przestrzennej",
      "St. 17 — Poczekalnia Petentów UCP",
      "St. 18 — Gabinet Dr Heleny Wierzbickiej",
      "St. 19 — Archiwum Kartotek Przeniesionych",
      "St. 20 — Pokój Kreślarski Szymona Bery",
      "St. 21 — Sala Makiet i Modeli UCP",
      "St. 22 — Punkt Zgodności 6 (-20 m)",
      "St. 23 — Szyb Kablowy Trakcji Linii 4",
      "St. 24 — Wentylatornia Wschodnia (-25 m)",
      "St. 25 — Torowisko Tranzytowe (-30 m)",
      "St. 26 — Peron Techniczny Linii 4",
      "St. 27 — Kanał Odwadniający Podstruktury",
      "St. 28 — Dawna Stacja Transformatorowa",
      "St. 29 — Śluza Przeciwgazowa P-4",
      "St. 30 — Korytarz Rewizyjny -40 m",
      "St. 31 — Komora Dźwiękochłonna Sedacji",
      "St. 32 — Basen Cieczy Buforowej (-50 m)",
      "St. 33 — Laboratorium Izotopów Pamięciowych",
      "St. 34 — Szyb Winda Towarowej (-65 m)",
      "St. 35 — Przedpole Rdzenia Podstruktury",
      "St. 36 — Komora Rezonatora Kwantowego (-85 m)",
      "St. 37 — Rdzeń Stabilizatora Równi",
      "St. 38 — Most Północny — Poziom Szyn",
      "St. 39 — Most Północny — Pylon Środkowy",
      "St. 40 — Dworzec Rówień Główna (Poranek)",
      "St. 41 — Rozjazd Torowy Linii 4 (Punkt Szwu)",
      "St. 42 — Węzeł Wyborów (Trzy Warianty)",
      "St. 43 — Epilog Systemowy i Rejestr Wieczysty"
    ];

    for (let i = 1; i <= 43; i++) {
      const id = i < 10 ? `station_0${i}` : `station_${i}`;
      // Dimensions in meters (L, W, H)
      let L = 6 + (i * 0.7) % 18;
      let W = 4 + (i * 0.5) % 12;
      let H = 3 + (i * 0.3) % 7;
      if (i >= 30 && i <= 37) { L = 28; W = 22; H = 14; } // Reactor/substructure large vaults
      if (i >= 12 && i <= 15) { L = 5.2; W = 3.8; H = 2.8; } // Flat 14 apartments
      if (i === 25 || i === 41) { L = 45; W = 6.5; H = 4.2; } // Tram tunnel

      let defaultMat = "concrete";
      if (i >= 12 && i <= 15) defaultMat = "glass";
      if (i === 1 || i === 21 || i === 33) defaultMat = "tile";
      if (i >= 23 && i <= 30) defaultMat = "steel";
      if (i === 31 || i === 32) defaultMat = "sedation";
      if (i === 36 || i === 37) defaultMat = "lead";
      if (i === 25 || i === 41) defaultMat = "ballast";

      const V = L * W * H;
      const S = 2 * (L * W + L * H + W * H);

      db[id] = {
        id: id,
        index: i,
        namePl: titlesPl[i - 1] || `Komora St. ${i}`,
        L: parseFloat(L.toFixed(1)),
        W: parseFloat(W.toFixed(1)),
        H: parseFloat(H.toFixed(1)),
        V: parseFloat(V.toFixed(1)),
        S: parseFloat(S.toFixed(1)),
        defaultMaterial: defaultMat,
        eigenmodes: [
          parseFloat((343 / (2 * L)).toFixed(1)),
          parseFloat((343 / (2 * W)).toFixed(1)),
          parseFloat((343 / (2 * H)).toFixed(1))
        ]
      };
    }
    return db;
  }

  populateChamberSelector() {
    const sel = document.getElementById("acousticChamberSelect");
    if (!sel) return;
    sel.innerHTML = "";
    for (let i = 1; i <= 43; i++) {
      const id = i < 10 ? `station_0${i}` : `station_${i}`;
      const ch = this.chambers[id];
      const opt = document.createElement("option");
      opt.value = id;
      opt.textContent = ch.namePl;
      if (id === this.currentChamberId) opt.selected = true;
      sel.appendChild(opt);
    }
  }

  selectChamber(chamberId) {
    if (!this.chambers[chamberId]) return;
    this.currentChamberId = chamberId;
    const ch = this.chambers[chamberId];
    this.currentMaterial = ch.defaultMaterial;
    const matSel = document.getElementById("acousticMaterialSelect");
    if (matSel) matSel.value = this.currentMaterial;
    this.recalculateAcoustics();
  }

  setMaterial(materialKey) {
    if (!this.materials[materialKey]) return;
    this.currentMaterial = materialKey;
    this.recalculateAcoustics();
  }

  setHumidity(h) {
    this.humidity = Math.max(20, Math.min(100, h));
    this.recalculateAcoustics();
  }

  setTemperature(t) {
    this.temperature = Math.max(0, Math.min(35, t));
    this.recalculateAcoustics();
  }

  setDryWet(dw) {
    this.dryWet = Math.max(0, Math.min(1, dw));
    if (this.dryGainNode && this.wetGainNode && this.audio && this.audio.ctx) {
      const now = this.audio.ctx.currentTime;
      this.dryGainNode.gain.setValueAtTime(Math.cos(this.dryWet * 0.5 * Math.PI), now);
      this.wetGainNode.gain.setValueAtTime(Math.sin(this.dryWet * 0.5 * Math.PI), now);
    }
  }

  setDecayScale(scale) {
    this.decayScale = Math.max(0.2, Math.min(4.0, scale));
    this.recalculateAcoustics();
  }

  setPreDelay(ms) {
    this.preDelay = Math.max(0.0, Math.min(0.1, ms / 1000));
    this.recalculateAcoustics();
  }

  recalculateAcoustics() {
    const ch = this.chambers[this.currentChamberId];
    if (!ch) return;
    const mat = this.materials[this.currentMaterial] || this.materials.concrete;

    // Speed of sound in air: c = 331.3 * sqrt(1 + T / 273.15)
    const c = 331.3 * Math.sqrt(1 + this.temperature / 273.15);

    // Air absorption coefficient m (approx per m) across bands
    const mBands = [0.0001, 0.0002, 0.0005, 0.0012, 0.0035, 0.0100];

    // Compute RT60 per octave band: [125, 250, 500, 1000, 2000, 4000 Hz]
    this.rt60Bands = [];
    this.eyringBands = [];

    for (let b = 0; b < 6; b++) {
      const alpha = mat.alpha[b];
      const m = mBands[b] * (this.humidity / 50.0);
      const sabine = (0.161 * ch.V) / (ch.S * alpha + 4 * m * ch.V);
      const eyring = (0.161 * ch.V) / (-ch.S * Math.log(Math.max(0.001, 1 - alpha)) + 4 * m * ch.V);
      this.rt60Bands.push(sabine * this.decayScale);
      this.eyringBands.push(eyring * this.decayScale);
    }

    this.sabineAvg = (this.rt60Bands[2] + this.rt60Bands[3]) / 2;
    this.eyringAvg = (this.eyringBands[2] + this.eyringBands[3]) / 2;
    this.bassRatio = (this.rt60Bands[0] + this.rt60Bands[1]) / (this.rt60Bands[2] + this.rt60Bands[3]);

    // Clarity C80 (dB) & Speech Definition D50 (%) approximations based on RT60 & V
    const rtMid = this.sabineAvg;
    this.clarityC80 = Math.max(-10, Math.min(15, 10 * Math.log10(1 / (1 + 0.12 * (rtMid / 1.5)) * 1.8)));
    this.speechD50 = Math.max(20, Math.min(95, (1 / (1 + (rtMid / 0.8))) * 100));
    this.centerTimeTs = Math.max(25, Math.min(220, rtMid * 45));

    this.updateMetricBadges();
    this.generateSyntheticImpulseResponse();
  }

  updateMetricBadges() {
    const sabEl = document.getElementById("metricSabineVal");
    const eyrEl = document.getElementById("metricEyringVal");
    const brEl = document.getElementById("metricBassRatioVal");
    const c80El = document.getElementById("metricClarityVal");
    const d50El = document.getElementById("metricDefVal");
    const tsEl = document.getElementById("metricTsVal");

    if (sabEl) sabEl.textContent = `${this.sabineAvg.toFixed(2)} s`;
    if (eyrEl) eyrEl.textContent = `${this.eyringAvg.toFixed(2)} s`;
    if (brEl) brEl.textContent = this.bassRatio.toFixed(2);
    if (c80El) c80El.textContent = `${this.clarityC80 > 0 ? "+" : ""}${this.clarityC80.toFixed(1)} dB`;
    if (d50El) d50El.textContent = `${this.speechD50.toFixed(1)}%`;
    if (tsEl) tsEl.textContent = `${this.centerTimeTs.toFixed(1)} ms`;
  }

  generateSyntheticImpulseResponse() {
    if (!this.audio) return;
    const sampleRate = 44100;
    const duration = Math.min(6.0, Math.max(0.8, this.sabineAvg * 1.25));
    const totalSamples = Math.floor(sampleRate * duration);

    const leftData = new Float32Array(totalSamples);
    const rightData = new Float32Array(totalSamples);

    const ch = this.chambers[this.currentChamberId];
    const c = 343;

    // 1. Direct sound (Dirac spike at preDelay)
    const preDelaySamples = Math.floor(this.preDelay * sampleRate);
    if (preDelaySamples < totalSamples) {
      leftData[preDelaySamples] = 1.0;
      rightData[preDelaySamples] = 1.0;
    }

    // 2. Image-Source Early Reflections (First & Second Order)
    const wallDists = [ch.L, ch.W, ch.H, ch.L * 1.414, ch.W * 1.414, ch.H * 1.414];
    wallDists.forEach((d, idx) => {
      const delaySec = this.preDelay + (2 * d) / c;
      const sampleIdx = Math.floor(delaySec * sampleRate);
      if (sampleIdx < totalSamples) {
        const atten = (1.0 / Math.max(1, d)) * 0.6;
        const sign = idx % 2 === 0 ? 1 : -1;
        const pan = (idx % 3 - 1) * 0.4; // -0.4, 0, 0.4
        leftData[sampleIdx] += sign * atten * (1 - pan);
        rightData[sampleIdx] += sign * atten * (1 + pan);
      }
    });

    // 3. Velvet Noise & Diffuse Exponential Tail
    const decayConst = 3.0 / Math.max(0.2, this.sabineAvg);
    let seed = 19780311;
    function pseudoRand() {
      seed = (seed * 9301 + 49297) % 233280;
      return seed / 233280.0;
    }

    const startDiffuse = preDelaySamples + Math.floor(0.025 * sampleRate);
    for (let i = startDiffuse; i < totalSamples; i++) {
      const t = (i - preDelaySamples) / sampleRate;
      const env = Math.exp(-decayConst * t);

      // Low-pass spectral absorption over time
      const hfDamp = Math.exp(-decayConst * 1.5 * t);

      // Sparse pseudo-random velvet impulses
      if (pseudoRand() < 0.35) {
        const pulse = (pseudoRand() * 2 - 1) * env * 0.15;
        const pulseR = (pseudoRand() * 2 - 1) * env * 0.15;
        leftData[i] += pulse * (0.8 + 0.2 * hfDamp);
        rightData[i] += pulseR * (0.8 + 0.2 * hfDamp);
      }
    }

    // Store raw IR buffers
    this.rawIRLeft = leftData;
    this.rawIRRight = rightData;
    this.irSampleRate = sampleRate;

    // Create Web Audio Buffer for ConvolverNode
    if (this.audio.ctx) {
      this.impulseBuffer = this.audio.ctx.createBuffer(2, totalSamples, sampleRate);
      this.impulseBuffer.copyToChannel(leftData, 0);
      this.impulseBuffer.copyToChannel(rightData, 1);
    }
  }

  setupWebAudioRouting() {
    if (!this.audio || !this.audio.ctx) return;
    const ctx = this.audio.ctx;

    if (!this.convolverNode) {
      this.convolverNode = ctx.createConvolver();
    }
    if (!this.dryGainNode) {
      this.dryGainNode = ctx.createGain();
    }
    if (!this.wetGainNode) {
      this.wetGainNode = ctx.createGain();
    }

    if (this.impulseBuffer) {
      this.convolverNode.buffer = this.impulseBuffer;
    }

    const now = ctx.currentTime;
    this.dryGainNode.gain.setValueAtTime(Math.cos(this.dryWet * 0.5 * Math.PI), now);
    this.wetGainNode.gain.setValueAtTime(Math.sin(this.dryWet * 0.5 * Math.PI), now);

    this.dryGainNode.connect(ctx.destination);
    this.convolverNode.connect(this.wetGainNode);
    this.wetGainNode.connect(ctx.destination);
  }

  playTestSignal(signalType) {
    if (!this.audio) return;
    this.audio.resumeContext();
    const ctx = this.audio.ctx;
    if (!ctx) return;

    this.setupWebAudioRouting();
    const now = ctx.currentTime;

    // Trigger visual pulse
    this.isPulsing = true;
    this.pulseTime = 0;

    const sourceGain = ctx.createGain();
    sourceGain.connect(this.dryGainNode);
    sourceGain.connect(this.convolverNode);

    if (signalType === "impulse") {
      // 0.1 ms Dirac click
      const osc = ctx.createOscillator();
      osc.type = "sine";
      osc.frequency.setValueAtTime(1000, now);
      sourceGain.gain.setValueAtTime(1.0, now);
      sourceGain.gain.exponentialRampToValueAtTime(0.001, now + 0.003);
      osc.connect(sourceGain);
      osc.start(now);
      osc.stop(now + 0.005);
    } else if (signalType === "pink") {
      // 100 ms filtered noise burst
      const bufSize = ctx.sampleRate * 0.12;
      const noiseBuf = ctx.createBuffer(1, bufSize, ctx.sampleRate);
      const out = noiseBuf.getChannelData(0);
      let b0 = 0, b1 = 0, b2 = 0;
      for (let i = 0; i < bufSize; i++) {
        const white = Math.random() * 2 - 1;
        b0 = 0.99886 * b0 + white * 0.0555179;
        b1 = 0.99332 * b1 + white * 0.0750759;
        b2 = 0.96900 * b2 + white * 0.1538520;
        out[i] = (b0 + b1 + b2) * 0.3;
      }
      const noiseSource = ctx.createBufferSource();
      noiseSource.buffer = noiseBuf;
      sourceGain.gain.setValueAtTime(0.8, now);
      sourceGain.gain.exponentialRampToValueAtTime(0.001, now + 0.12);
      noiseSource.connect(sourceGain);
      noiseSource.start(now);
    } else if (signalType === "carrier") {
      // 740 Hz sine burst
      const osc = ctx.createOscillator();
      osc.frequency.setValueAtTime(740, now);
      sourceGain.gain.setValueAtTime(0.7, now);
      sourceGain.gain.exponentialRampToValueAtTime(0.001, now + 0.25);
      osc.connect(sourceGain);
      osc.start(now);
      osc.stop(now + 0.28);
    } else if (signalType === "footstep") {
      // Subterranean boot strike
      const osc = ctx.createOscillator();
      osc.frequency.setValueAtTime(95, now);
      osc.frequency.exponentialRampToValueAtTime(32, now + 0.08);
      sourceGain.gain.setValueAtTime(0.9, now);
      sourceGain.gain.exponentialRampToValueAtTime(0.001, now + 0.10);
      osc.connect(sourceGain);
      osc.start(now);
      osc.stop(now + 0.12);
    } else if (signalType === "phone") {
      // Bakelite Phone Bell Ring (500 Hz + 1000 Hz)
      const osc1 = ctx.createOscillator();
      const osc2 = ctx.createOscillator();
      osc1.frequency.setValueAtTime(500, now);
      osc2.frequency.setValueAtTime(1000, now);
      sourceGain.gain.setValueAtTime(0.6, now);
      sourceGain.gain.exponentialRampToValueAtTime(0.001, now + 0.35);
      osc1.connect(sourceGain);
      osc2.connect(sourceGain);
      osc1.start(now); osc2.start(now);
      osc1.stop(now + 0.38); osc2.stop(now + 0.38);
    } else if (signalType === "relay") {
      // KL-78 Vacuum Relay Snap
      const osc = ctx.createOscillator();
      osc.type = "sawtooth";
      osc.frequency.setValueAtTime(2400, now);
      osc.frequency.exponentialRampToValueAtTime(180, now + 0.02);
      sourceGain.gain.setValueAtTime(0.85, now);
      sourceGain.gain.exponentialRampToValueAtTime(0.001, now + 0.04);
      osc.connect(sourceGain);
      osc.start(now);
      osc.stop(now + 0.05);
    } else if (signalType === "voice") {
      // Lena Vocal Formant (A5 Formants)
      const osc = ctx.createOscillator();
      osc.type = "sawtooth";
      osc.frequency.setValueAtTime(440, now);
      const bpf = ctx.createBiquadFilter();
      bpf.type = "bandpass";
      bpf.frequency.setValueAtTime(880, now);
      bpf.Q.setValueAtTime(5.0, now);
      sourceGain.gain.setValueAtTime(0.7, now);
      sourceGain.gain.exponentialRampToValueAtTime(0.001, now + 0.30);
      osc.connect(bpf);
      bpf.connect(sourceGain);
      osc.start(now);
      osc.stop(now + 0.32);
    } else if (signalType === "tram") {
      // Line 4 Traction Sub-Hum (50/150 Hz)
      const osc1 = ctx.createOscillator();
      const osc2 = ctx.createOscillator();
      osc1.frequency.setValueAtTime(50, now);
      osc2.frequency.setValueAtTime(150, now);
      sourceGain.gain.setValueAtTime(0.75, now);
      sourceGain.gain.exponentialRampToValueAtTime(0.001, now + 0.45);
      osc1.connect(sourceGain); osc2.connect(sourceGain);
      osc1.start(now); osc2.start(now);
      osc1.stop(now + 0.50); osc2.stop(now + 0.50);
    }
  }

  initWaterfall() {
    this.waterfallHistory = [];
    const bandsCount = 36;
    for (let s = 0; s < this.maxWaterfallSlices; s++) {
      const slice = new Float32Array(bandsCount);
      for (let b = 0; b < bandsCount; b++) {
        slice[b] = 0;
      }
      this.waterfallHistory.push(slice);
    }
  }

  startRenderLoop() {
    const render = () => {
      this.renderWaterfall();
      this.animId = requestAnimationFrame(render);
    };
    this.animId = requestAnimationFrame(render);
  }

  renderWaterfall() {
    if (!this.canvas || !this.ctx) return;
    const ctx = this.ctx;
    const w = this.canvas.width;
    const h = this.canvas.height;

    // Clear background CRT dark palette
    ctx.fillStyle = "#030609";
    ctx.fillRect(0, 0, w, h);

    // Compute new spectral slice
    const bandsCount = 36;
    const newSlice = new Float32Array(bandsCount);
    const rtMid = this.sabineAvg || 1.8;

    if (this.isPulsing) {
      this.pulseTime += 0.05;
      for (let b = 0; b < bandsCount; b++) {
        const freqRatio = b / bandsCount;
        const resonanceBoost = Math.sin(b * 0.45 + this.pulseTime * 4.0) * 0.3 + 0.7;
        const decayRate = (0.8 + freqRatio * 1.2) * (3.0 / rtMid);
        const amp = Math.max(0, Math.exp(-decayRate * this.pulseTime) * resonanceBoost);
        newSlice[b] = amp;
      }
      if (this.pulseTime > rtMid * 1.5) {
        this.isPulsing = false;
      }
    } else {
      // Idle ambient baseline noise
      for (let b = 0; b < bandsCount; b++) {
        newSlice[b] = 0.04 + 0.03 * Math.sin(b * 0.3 + Date.now() * 0.002);
      }
    }

    this.waterfallHistory.unshift(newSlice);
    if (this.waterfallHistory.length > this.maxWaterfallSlices) {
      this.waterfallHistory.pop();
    }

    // Draw 3D Isometric Waterfall Wireframe Mesh
    const numSlices = this.waterfallHistory.length;
    const originX = 70;
    const originY = h - 45;
    const isoStepX = 14;
    const isoStepY = -6.5;
    const bandSpacing = (w - 180) / bandsCount;

    for (let s = numSlices - 1; s >= 0; s--) {
      const slice = this.waterfallHistory[s];
      const sliceOriginX = originX + s * isoStepX * 0.4;
      const sliceOriginY = originY + s * isoStepY;
      const alpha = 1.0 - (s / numSlices) * 0.75;

      ctx.beginPath();
      for (let b = 0; b < bandsCount; b++) {
        const x = sliceOriginX + b * bandSpacing;
        const heightVal = slice[b] * 120;
        const y = sliceOriginY - heightVal;
        if (b === 0) ctx.moveTo(x, y);
        else ctx.lineTo(x, y);
      }

      // Color gradation based on depth slice
      if (s < 4) {
        ctx.strokeStyle = `rgba(93, 163, 152, ${alpha})`; // Cyan for early
        ctx.lineWidth = 1.6;
      } else if (s < 14) {
        ctx.strokeStyle = `rgba(226, 176, 96, ${alpha})`; // Amber for mid decay
        ctx.lineWidth = 1.2;
      } else {
        ctx.strokeStyle = `rgba(222, 117, 112, ${alpha})`; // Crimson for tail
        ctx.lineWidth = 1.0;
      }
      ctx.stroke();
    }

    // Grid & Axis Annotation
    ctx.fillStyle = "rgba(93, 163, 152, 0.75)";
    ctx.font = "9px monospace";
    ctx.fillText("63 Hz", originX, h - 15);
    ctx.fillText("250 Hz", originX + bandSpacing * 9, h - 15);
    ctx.fillText("1 kHz", originX + bandSpacing * 18, h - 15);
    ctx.fillText("4 kHz", originX + bandSpacing * 27, h - 15);
    ctx.fillText("8 kHz", originX + bandSpacing * 35, h - 15);

    ctx.fillText("FREQ (Hz) ──►", w / 2 - 20, h - 15);
    ctx.fillText("TIME (s) ◄──", originX + 260, h - 80);

    // Overlay Header Telemetry
    const ch = this.chambers[this.currentChamberId];
    ctx.fillStyle = "rgba(93, 163, 152, 0.9)";
    ctx.font = "10px monospace";
    ctx.fillText(`CHAMBER: ${ch.id.toUpperCase()} | VOL: ${ch.V} m³ | MAT: ${this.currentMaterial.toUpperCase()} | SABINE RT60: ${this.sabineAvg.toFixed(2)}s`, 12, 18);
  }

  exportWAV() {
    if (!this.rawIRLeft || !this.rawIRRight) {
      this.generateSyntheticImpulseResponse();
    }
    const left = this.rawIRLeft;
    const right = this.rawIRRight;
    const sampleRate = this.irSampleRate || 44100;
    const numSamples = left.length;

    const buffer = new ArrayBuffer(44 + numSamples * 4);
    const view = new DataView(buffer);

    function writeString(v, offset, str) {
      for (let i = 0; i < str.length; i++) {
        v.setUint8(offset + i, str.charCodeAt(i));
      }
    }

    // RIFF Chunk
    writeString(view, 0, "RIFF");
    view.setUint32(4, 36 + numSamples * 4, true);
    writeString(view, 8, "WAVE");

    // fmt Subchunk
    writeString(view, 12, "fmt ");
    view.setUint32(16, 16, true);
    view.setUint16(20, 1, true); // PCM format
    view.setUint16(22, 2, true); // 2 channels (Stereo)
    view.setUint32(24, sampleRate, true);
    view.setUint32(28, sampleRate * 4, true); // byte rate (SampleRate * 2 * 2)
    view.setUint16(32, 4, true); // block align (2 * 2)
    view.setUint16(34, 16, true); // 16-bit

    // data Subchunk
    writeString(view, 36, "data");
    view.setUint32(40, numSamples * 4, true);

    let offset = 44;
    for (let i = 0; i < numSamples; i++) {
      const sL = Math.max(-1, Math.min(1, left[i]));
      const sR = Math.max(-1, Math.min(1, right[i]));
      view.setInt16(offset, sL < 0 ? sL * 0x8000 : sL * 0x7FFF, true);
      view.setInt16(offset + 2, sR < 0 ? sR * 0x8000 : sR * 0x7FFF, true);
      offset += 4;
    }

    const blob = new Blob([buffer], { type: "audio/wav" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `acoustic_impulse_${this.currentChamberId}_${this.currentMaterial}.wav`;
    document.body.appendChild(a);
    a.click();
    setTimeout(() => { document.body.removeChild(a); URL.revokeObjectURL(url); }, 1000);
  }

  exportMetricsJSON() {
    const ch = this.chambers[this.currentChamberId];
    const data = {
      chamberId: ch.id,
      name: ch.namePl,
      dimensions: { lengthM: ch.L, widthM: ch.W, heightM: ch.H },
      volumeM3: ch.V,
      surfaceM2: ch.S,
      material: this.currentMaterial,
      humidityPercent: this.humidity,
      temperatureC: this.temperature,
      sabineRT60Sec: parseFloat(this.sabineAvg.toFixed(3)),
      eyringRT60Sec: parseFloat(this.eyringAvg.toFixed(3)),
      octaveBandsRT60: {
        "125Hz": parseFloat(this.rt60Bands[0].toFixed(3)),
        "250Hz": parseFloat(this.rt60Bands[1].toFixed(3)),
        "500Hz": parseFloat(this.rt60Bands[2].toFixed(3)),
        "1000Hz": parseFloat(this.rt60Bands[3].toFixed(3)),
        "2000Hz": parseFloat(this.rt60Bands[4].toFixed(3)),
        "4000Hz": parseFloat(this.rt60Bands[5].toFixed(3))
      },
      bassRatio: parseFloat(this.bassRatio.toFixed(3)),
      clarityC80dB: parseFloat(this.clarityC80.toFixed(2)),
      speechDefinitionD50Percent: parseFloat(this.speechD50.toFixed(2)),
      centerTimeTsMs: parseFloat(this.centerTimeTs.toFixed(2)),
      eigenmodesHz: ch.eigenmodes,
      timestamp: new Date().toISOString()
    };

    const blob = new Blob([JSON.stringify(data, null, 2)], { type: "application/json" });
    const url = URL.createObjectURL(blob);
    const a = document.createElement("a");
    a.href = url;
    a.download = `acoustic_metrics_${this.currentChamberId}.json`;
    document.body.appendChild(a);
    a.click();
    setTimeout(() => { document.body.removeChild(a); URL.revokeObjectURL(url); }, 1000);
  }
}

// Global Hook Callbacks for HTML Controls
function triggerAcousticImpulse() {
  if (window.acousticConvolverRack) {
    const sel = document.getElementById("acousticSignalSelect");
    const sig = sel ? sel.value : "impulse";
    window.acousticConvolverRack.playTestSignal(sig);
  }
}

function playConvolvedTestSignal() {
  if (window.acousticConvolverRack) {
    const sel = document.getElementById("acousticSignalSelect");
    const sig = sel ? sel.value : "carrier";
    window.acousticConvolverRack.playTestSignal(sig);
  }
}

function resetAcousticChamber() {
  if (window.acousticConvolverRack) {
    window.acousticConvolverRack.selectChamber("station_01");
    const hSlider = document.getElementById("acousticHumiditySlider");
    if (hSlider) { hSlider.value = "65"; updateAcousticHumidity(65); }
    const tSlider = document.getElementById("acousticTempSlider");
    if (tSlider) { tSlider.value = "14.0"; updateAcousticTemp(14.0); }
    const dwSlider = document.getElementById("acousticDryWetSlider");
    if (dwSlider) { dwSlider.value = "50"; updateAcousticDryWet(50); }
    const decSlider = document.getElementById("acousticDecaySlider");
    if (decSlider) { decSlider.value = "1.00"; updateAcousticDecayScale(1.0); }
    const pdSlider = document.getElementById("acousticPreDelaySlider");
    if (pdSlider) { pdSlider.value = "18"; updateAcousticPreDelay(18); }
  }
}

function exportImpulseResponseWAV() {
  if (window.acousticConvolverRack) {
    window.acousticConvolverRack.exportWAV();
  }
}

function exportAcousticMetricsJSON() {
  if (window.acousticConvolverRack) {
    window.acousticConvolverRack.exportMetricsJSON();
  }
}

function selectAcousticChamber(chId) {
  if (window.acousticConvolverRack) {
    window.acousticConvolverRack.selectChamber(chId);
  }
}

function updateChamberMaterial(mat) {
  if (window.acousticConvolverRack) {
    window.acousticConvolverRack.setMaterial(mat);
  }
}

function updateAcousticHumidity(val) {
  const el = document.getElementById("acousticHumidityVal");
  if (el) el.textContent = `${val}%`;
  if (window.acousticConvolverRack) {
    window.acousticConvolverRack.setHumidity(val);
  }
}

function updateAcousticTemp(val) {
  const el = document.getElementById("acousticTempVal");
  if (el) el.textContent = `${val.toFixed(1)} °C`;
  if (window.acousticConvolverRack) {
    window.acousticConvolverRack.setTemperature(val);
  }
}

function updateAcousticDryWet(val) {
  const el = document.getElementById("acousticDryWetVal");
  if (el) el.textContent = `${val}%`;
  if (window.acousticConvolverRack) {
    window.acousticConvolverRack.setDryWet(val / 100.0);
  }
}

function updateAcousticDecayScale(val) {
  const el = document.getElementById("acousticDecayVal");
  if (el) el.textContent = `${val.toFixed(2)}x`;
  if (window.acousticConvolverRack) {
    window.acousticConvolverRack.setDecayScale(val);
  }
}

function updateAcousticPreDelay(val) {
  const el = document.getElementById("acousticPreDelayVal");
  if (el) el.textContent = `${val} ms`;
  if (window.acousticConvolverRack) {
    window.acousticConvolverRack.setPreDelay(val);
  }
}

window.proceduralAudio = new WebProceduralAudio();
window.polyphonicSynth = new PolyphonicRetroSynth(window.proceduralAudio);
window.customSignalDesigner = new CustomSignalDesigner(window.proceduralAudio);
window.reelToReelTapeDeck = new ReelToReelTapeDeck(window.proceduralAudio);
window.unitraMultitrackMixer = new UnitraMultitrackMixer(window.proceduralAudio);
window.quantumFieldRack = new QuantumFieldInterferenceRack("quantumFieldCanvas", window.proceduralAudio);
window.condensationFluidRack = new CondensationFluidRack("fluidSimulationCanvas", window.proceduralAudio);
window.memorySpectrometer = new MemoryResonanceSpectrometer("spectrometerCanvas", window.proceduralAudio);
window.vacuumTubeRack = new VacuumTubeResonanceEngine("circuitSchematicCanvas", window.proceduralAudio);
window.acousticMatrixRack = new AcousticMatrixAnalyzer("acousticMatrixCanvas", window.proceduralAudio);
window.transitGridMap = new TransitGridTopologicalMap("transitMapCanvas", window.proceduralAudio);
window.safetyAuditor = new ContinuitySafetyProtocolAuditor("safetyAuditorCanvas", window.proceduralAudio);
window.acousticConvolverRack = new SpatialAcousticConvolver("acousticWaterfallCanvas", window.proceduralAudio);









