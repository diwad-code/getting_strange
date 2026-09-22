/**
 * GETTING STRANGE — Movement & Anchor HTML5 Canvas Mini-Engine (5 Chambers)
 * Interaktywny symulator fizyki (640x360 logiczne) z profilami ruchu A/B/C, 5 komorami testowymi,
 * systemem cząsteczek, wstrząsem ekranu (screen-shake) i bezpośrednią integracją WebProceduralAudio.
 */

class GettingStrangeMiniEngine {
  constructor(canvasId) {
    this.canvas = document.getElementById(canvasId);
    if (!this.canvas) return;
    this.ctx = this.canvas.getContext('2d');

    this.logicalWidth = 640;
    this.logicalHeight = 360;

    this.currentChamber = 1;
    this.currentProfile = 'A';

    // Profiles Configuration (Strict alignment with Godot Baseline)
    this.profiles = {
      'A': {
        name: 'Profil A (Kanon Baseline)',
        moveSpeed: 160,
        accelGround: 1200,
        frictionGround: 1400,
        accelAir: 700,
        jumpForce: -340,
        gravity: 980,
        coyoteTimeMax: 0.10,
        jumpBufferMax: 0.12
      },
      'B': {
        name: 'Profil B (Ciasna Reakcja / Snappy)',
        moveSpeed: 175,
        accelGround: 1800,
        frictionGround: 2000,
        accelAir: 950,
        jumpForce: -345,
        gravity: 980,
        coyoteTimeMax: 0.12,
        jumpBufferMax: 0.14
      },
      'C': {
        name: 'Profil C (Inercyjny / Smooth)',
        moveSpeed: 150,
        accelGround: 850,
        frictionGround: 900,
        accelAir: 500,
        jumpForce: -335,
        gravity: 980,
        coyoteTimeMax: 0.09,
        jumpBufferMax: 0.10
      }
    };

    // Player state
    this.player = {
      x: 60,
      y: 280,
      width: 14,
      height: 28,
      vx: 0,
      vy: 0,
      isGrounded: false,
      coyoteTimer: 0,
      jumpBuffer: 0,
      facing: 1,
      isAnchoring: false
    };

    this.maxFallSpeed = 420;
    this.applyProfile('A');

    // Visual polish state
    this.particles = [];
    this.screenShake = 0;
    this.time = 0;

    // Level geometry & anchorables
    this.loadChamber(1);

    // Input state
    this.keys = {
      left: false,
      right: false,
      jump: false,
      anchor: false
    };

    this.lastTime = 0;
    this.stepAudioTimer = 0;
    this.isRunning = false;

    this.bindInputs();
  }

  applyProfile(profileKey) {
    if (!this.profiles[profileKey]) return;
    this.currentProfile = profileKey;
    const p = this.profiles[profileKey];
    this.moveSpeed = p.moveSpeed;
    this.accelGround = p.accelGround;
    this.frictionGround = p.frictionGround;
    this.accelAir = p.accelAir;
    this.jumpForce = p.jumpForce;
    this.gravity = p.gravity;
    this.coyoteTimeMax = p.coyoteTimeMax;
    this.jumpBufferMax = p.jumpBufferMax;
  }

  loadChamber(chamberIndex) {
    this.currentChamber = chamberIndex;
    this.resetPlayer();
    this.particles = [];

    if (chamberIndex === 1) {
      // Chamber 1: Movement Lab Baseline
      this.platforms = [
        { x: 0, y: 320, width: 640, height: 40, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'bridge1',
          x: 160,
          y: 240,
          baseY: 240,
          width: 80,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 60,
          speed: 1.8,
          phase: 0,
          color: '#d39a62'
        },
        {
          id: 'lift2',
          x: 310,
          y: 190,
          baseY: 190,
          width: 90,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 70,
          speed: 2.2,
          phase: Math.PI / 2,
          color: '#d39a62'
        },
        { x: 470, y: 200, width: 154, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 570, y: 140, width: 44, height: 60, isReached: false, label: 'IKP GOAL' };
      this.wave = { x: -80, width: 30, speed: 110, active: true };
    } else if (chamberIndex === 2) {
      // Chamber 2: Vertical Shift & Multi-Elevator
      this.platforms = [
        { x: 0, y: 320, width: 220, height: 40, isStatic: true, color: '#16242e' },
        { x: 420, y: 320, width: 220, height: 40, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'liftA',
          x: 230,
          y: 220,
          baseY: 220,
          width: 70,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 80,
          speed: 2.5,
          phase: 0,
          color: '#d39a62'
        },
        {
          id: 'liftB',
          x: 330,
          y: 160,
          baseY: 160,
          width: 70,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 90,
          speed: 2.8,
          phase: Math.PI,
          color: '#d39a62'
        },
        { x: 440, y: 120, width: 184, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 570, y: 60, width: 44, height: 60, isReached: false, label: 'ŚLUZA 02' };
      this.wave = { x: -80, width: 35, speed: 130, active: true };
    } else if (chamberIndex === 3) {
      // Chamber 3: High Pressure Podstruktura Conduit
      this.platforms = [
        { x: 0, y: 320, width: 140, height: 40, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'p1',
          x: 160,
          y: 260,
          baseY: 260,
          width: 60,
          height: 12,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 50,
          speed: 3.0,
          phase: 0,
          color: '#d39a62'
        },
        {
          id: 'p2',
          x: 270,
          y: 200,
          baseY: 200,
          width: 65,
          height: 12,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 60,
          speed: 3.2,
          phase: 1.5,
          color: '#d39a62'
        },
        {
          id: 'p3',
          x: 380,
          y: 150,
          baseY: 150,
          width: 65,
          height: 12,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 70,
          speed: 3.4,
          phase: 3.0,
          color: '#d39a62'
        },
        { x: 490, y: 110, width: 134, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 570, y: 50, width: 44, height: 60, isReached: false, label: 'PODSTRUKTURA' };
      this.wave = { x: -80, width: 40, speed: 150, active: true };
    } else if (chamberIndex === 4) {
      // Chamber 4: Punkt Zgodności 6 & Biometric Gate
      this.platforms = [
        { x: 0, y: 320, width: 640, height: 40, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'cart1',
          x: 180,
          y: 280,
          baseY: 280,
          width: 50,
          height: 40,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 40,
          speed: 1.5,
          phase: 0,
          color: '#5da398'
        },
        {
          id: 'gatePlatform',
          x: 320,
          y: 220,
          baseY: 220,
          width: 100,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 50,
          speed: 2.0,
          phase: 1.2,
          color: '#d39a62'
        },
        { x: 470, y: 180, width: 154, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 570, y: 120, width: 44, height: 60, isReached: false, label: 'GABINET UCP' };
      this.wave = { x: -80, width: 35, speed: 120, active: true };
    } else if (chamberIndex === 5) {
      // Chamber 5: Maszynownia Linii 4 & Dual-Rail Switch
      this.platforms = [
        { x: 0, y: 320, width: 640, height: 40, isStatic: true, color: '#10171a' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'tramCart',
          x: 170,
          y: 250,
          baseY: 250,
          width: 75,
          height: 20,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 65,
          speed: 2.4,
          phase: 0,
          color: '#e2b060'
        },
        {
          id: 'railBridge',
          x: 310,
          y: 190,
          baseY: 190,
          width: 85,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 75,
          speed: 2.0,
          phase: Math.PI / 2,
          color: '#d39a62'
        },
        {
          id: 'upperTrack',
          x: 450,
          y: 140,
          baseY: 140,
          width: 70,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 45,
          speed: 2.8,
          phase: Math.PI,
          color: '#5da398'
        },
        { x: 540, y: 110, width: 84, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 565, y: 50, width: 44, height: 60, isReached: false, label: 'LINIA 4' };
      this.wave = { x: -80, width: 45, speed: 140, active: true };
    } else if (chamberIndex === 6) {
      // Chamber 6: Sala Modeli & Interactive Scale Scaffolding
      this.platforms = [
        { x: 0, y: 320, width: 640, height: 40, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'modelCrane',
          x: 150,
          y: 220,
          baseY: 220,
          width: 75,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 55,
          speed: 2.1,
          phase: 0,
          color: '#d39a62'
        },
        {
          id: 'modelPillar',
          x: 270,
          y: 160,
          baseY: 160,
          width: 80,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 70,
          speed: 1.8,
          phase: 1.2,
          color: '#5da398'
        },
        {
          id: 'upperGantry',
          x: 395,
          y: 210,
          baseY: 210,
          width: 75,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 60,
          speed: 2.6,
          phase: 2.5,
          color: '#d39a62'
        },
        { x: 515, y: 140, width: 109, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 565, y: 80, width: 44, height: 60, isReached: false, label: 'SALA MODELI' };
      this.wave = { x: -80, width: 40, speed: 135, active: true };
    } else if (chamberIndex === 7) {
      // Chamber 7: Szyb Podstruktury (-40 m) & High Draft Chasm
      this.platforms = [
        { x: 0, y: 320, width: 160, height: 40, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'shaftElevatorA',
          x: 185,
          y: 250,
          baseY: 250,
          width: 65,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 75,
          speed: 3.2,
          phase: 0,
          color: '#c65d58'
        },
        {
          id: 'shaftElevatorB',
          x: 295,
          y: 180,
          baseY: 180,
          width: 65,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 85,
          speed: 2.8,
          phase: 1.8,
          color: '#e2b060'
        },
        {
          id: 'shaftElevatorC',
          x: 405,
          y: 120,
          baseY: 120,
          width: 65,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 65,
          speed: 3.4,
          phase: 3.2,
          color: '#5da398'
        },
        { x: 505, y: 90, width: 119, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 565, y: 30, width: 44, height: 60, isReached: false, label: 'RDZEŃ -40M' };
      this.wave = { x: -80, width: 50, speed: 155, active: true };
    } else if (chamberIndex === 8) {
      // Chamber 8: Komora Rezonansu Ciągłości / Reaktor Centralny (-85 m)
      this.platforms = [
        { x: 0, y: 320, width: 140, height: 40, isStatic: true, color: '#10171a' },
        { x: 270, y: 320, width: 90, height: 40, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'reactorGateA',
          x: 155,
          y: 240,
          baseY: 240,
          width: 70,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 70,
          speed: 2.4,
          phase: 0,
          color: '#5da398'
        },
        {
          id: 'reactorCorePlatform',
          x: 265,
          y: 170,
          baseY: 170,
          width: 100,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 80,
          speed: 3.0,
          phase: 1.5,
          color: '#c65d58'
        },
        {
          id: 'upperHarmonicGantry',
          x: 400,
          y: 120,
          baseY: 120,
          width: 80,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 65,
          speed: 2.6,
          phase: Math.PI,
          color: '#e2b060'
        },
        { x: 510, y: 80, width: 114, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 565, y: 20, width: 44, height: 60, isReached: false, label: 'REAKTOR -85M' };
      this.wave = { x: -80, width: 55, speed: 165, active: true };
    } else if (chamberIndex === 9) {
      // Chamber 9: Maszynownia Rozjazdu Linii 4 (Dual-Track Crossover)
      this.platforms = [
        { x: 0, y: 320, width: 180, height: 40, isStatic: true, color: '#10171a' },
        { x: 440, y: 320, width: 200, height: 40, isStatic: true, color: '#10171a' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'switchTrackA',
          x: 190,
          y: 260,
          baseY: 260,
          width: 80,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 60,
          speed: 2.5,
          phase: 0,
          color: '#e2b060'
        },
        {
          id: 'tramCart105',
          x: 290,
          y: 200,
          baseY: 200,
          width: 90,
          height: 18,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 75,
          speed: 2.2,
          phase: 1.4,
          color: '#5da398'
        },
        {
          id: 'crossoverGantry',
          x: 400,
          y: 150,
          baseY: 150,
          width: 75,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 65,
          speed: 3.0,
          phase: Math.PI,
          color: '#d39a62'
        },
        { x: 500, y: 110, width: 124, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 565, y: 50, width: 44, height: 60, isReached: false, label: 'ROZJAZD L4' };
      this.wave = { x: -80, width: 45, speed: 145, active: true };
    } else if (chamberIndex === 10) {
      // Chamber 10: Sfera Pęknięcia Czasoprzestrzeni (Zero-Point Quantum Rift)
      this.platforms = [
        { x: 0, y: 320, width: 130, height: 40, isStatic: true, color: '#090d12' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'zeroMonolith1',
          x: 145,
          y: 250,
          baseY: 250,
          width: 60,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 80,
          speed: 3.2,
          phase: 0,
          color: '#c65d58'
        },
        {
          id: 'zeroMonolith2',
          x: 235,
          y: 190,
          baseY: 190,
          width: 65,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 90,
          speed: 2.8,
          phase: 1.2,
          color: '#5da398'
        },
        {
          id: 'zeroMonolith3',
          x: 330,
          y: 130,
          baseY: 130,
          width: 70,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 75,
          speed: 3.5,
          phase: 2.4,
          color: '#e2b060'
        },
        {
          id: 'riftBridge',
          x: 430,
          y: 170,
          baseY: 170,
          width: 80,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 60,
          speed: 2.0,
          phase: Math.PI,
          color: '#75c7c3'
        },
        { x: 530, y: 90, width: 94, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 565, y: 30, width: 44, height: 60, isReached: false, label: 'ZERO POINT' };
      this.wave = { x: -80, width: 55, speed: 170, active: true };
    } else if (chamberIndex === 11) {
      // Chamber 11: Węzeł Zwrotniczy Sektora 4 (Dual-Track Switch Array)
      this.platforms = [
        { x: 0, y: 320, width: 160, height: 40, isStatic: true, color: '#10171a' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'switchRail1',
          x: 170,
          y: 250,
          baseY: 250,
          width: 75,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 55,
          speed: 2.3,
          phase: 0,
          color: '#e2b060'
        },
        {
          id: 'switchRail2',
          x: 275,
          y: 190,
          baseY: 190,
          width: 80,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 65,
          speed: 2.7,
          phase: 1.6,
          color: '#5da398'
        },
        {
          id: 'crossoverGantry',
          x: 390,
          y: 130,
          baseY: 130,
          width: 75,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 50,
          speed: 2.0,
          phase: Math.PI,
          color: '#d39a62'
        },
        { x: 495, y: 90, width: 129, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 565, y: 30, width: 44, height: 60, isReached: false, label: 'ZWROTNICA S4' };
      this.wave = { x: -80, width: 50, speed: 150, active: true };
    } else if (chamberIndex === 12) {
      // Chamber 12: Basen Sedacyjny (Substructure Sedation Pool)
      this.platforms = [
        { x: 0, y: 320, width: 130, height: 40, isStatic: true, color: '#090d12' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'sedationFilterA',
          x: 145,
          y: 260,
          baseY: 260,
          width: 70,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 45,
          speed: 1.6,
          phase: 0,
          color: '#75c7c3'
        },
        {
          id: 'sedationFilterB',
          x: 245,
          y: 200,
          baseY: 200,
          width: 80,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 55,
          speed: 2.0,
          phase: 1.2,
          color: '#5da398'
        },
        {
          id: 'sedationFilterC',
          x: 355,
          y: 150,
          baseY: 150,
          width: 75,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 40,
          speed: 2.4,
          phase: 2.5,
          color: '#c65d58'
        },
        { x: 470, y: 100, width: 154, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 565, y: 40, width: 44, height: 60, isReached: false, label: 'BASEN SEDACJI' };
      this.wave = { x: -80, width: 45, speed: 135, active: true };
    } else if (chamberIndex === 13) {
      // Chamber 13: Szyb Podwójnej Nośnej (Dual-Carrier Resonant Shaft)
      this.platforms = [
        { x: 0, y: 320, width: 140, height: 40, isStatic: true, color: '#10171a' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'carrierLiftA',
          x: 160,
          y: 220,
          baseY: 220,
          width: 65,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 85,
          speed: 2.8,
          phase: 0,
          color: '#5da398'
        },
        {
          id: 'carrierLiftB',
          x: 255,
          y: 220,
          baseY: 220,
          width: 65,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 85,
          speed: 2.8,
          phase: Math.PI,
          color: '#e2b060'
        },
        {
          id: 'midDock',
          x: 350,
          y: 150,
          baseY: 150,
          width: 75,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 45,
          speed: 2.1,
          phase: Math.PI / 2,
          color: '#c65d58'
        },
        {
          id: 'upperShaftGantry',
          x: 445,
          y: 100,
          baseY: 100,
          width: 65,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 35,
          speed: 3.0,
          phase: 0,
          color: '#75c7c3'
        },
        { x: 530, y: 80, width: 94, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 565, y: 20, width: 44, height: 60, isReached: false, label: 'PODWÓJNA NOŚNA' };
      this.wave = { x: -80, width: 55, speed: 160, active: true };
    } else if (chamberIndex === 14) {
      // Chamber 14: Komora Rezonansowa Słońca 1978 (Optical Quartz Resonance)
      this.platforms = [
        { x: 0, y: 320, width: 140, height: 40, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'sunPrism1',
          x: 160,
          y: 240,
          baseY: 240,
          width: 70,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 60,
          speed: 2.2,
          phase: 0,
          color: '#e2b060'
        },
        {
          id: 'sunPrism2',
          x: 265,
          y: 175,
          baseY: 175,
          width: 75,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 70,
          speed: 2.6,
          phase: 1.4,
          color: '#e2b060'
        },
        {
          id: 'sunPrism3',
          x: 375,
          y: 120,
          baseY: 120,
          width: 70,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 55,
          speed: 3.1,
          phase: 2.8,
          color: '#d39a62'
        },
        { x: 485, y: 80, width: 139, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 565, y: 20, width: 44, height: 60, isReached: false, label: 'SŁOŃCE 1978' };
      this.wave = { x: -80, width: 50, speed: 165, active: true };
    } else if (chamberIndex === 15) {
      // Chamber 15: Stacja Tranzytowa Północ (North Terminal Evacuation Gate)
      this.platforms = [
        { x: 0, y: 320, width: 150, height: 40, isStatic: true, color: '#10171a' },
        { x: 230, y: 250, width: 80, height: 16, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'trainCarA',
          x: 145,
          y: 280,
          baseY: 280,
          width: 75,
          height: 16,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 45,
          speed: 1.9,
          phase: 0,
          color: '#5da398'
        },
        {
          id: 'trainCarB',
          x: 320,
          y: 190,
          baseY: 190,
          width: 80,
          height: 16,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 60,
          speed: 2.4,
          phase: 1.2,
          color: '#e2b060'
        },
        {
          id: 'shuttleLift',
          x: 420,
          y: 130,
          baseY: 130,
          width: 70,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 50,
          speed: 2.9,
          phase: Math.PI,
          color: '#c65d58'
        },
        { x: 505, y: 80, width: 119, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 565, y: 20, width: 44, height: 60, isReached: false, label: 'STACJA PÓŁNOC' };
      this.wave = { x: -80, width: 60, speed: 175, active: true };
    } else if (chamberIndex === 16) {
      // Chamber 16: Komora Prędkości Fazowej (Phase Velocity Chamber)
      this.platforms = [
        { x: 0, y: 320, width: 140, height: 40, isStatic: true, color: '#10171a' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'phasePrism1',
          x: 155,
          y: 250,
          baseY: 250,
          width: 75,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 65,
          speed: 3.4,
          phase: 0,
          color: '#75c7c3'
        },
        {
          id: 'phaseWaveguide',
          x: 260,
          y: 195,
          baseY: 195,
          width: 80,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 70,
          speed: 2.8,
          phase: 1.5,
          color: '#5da398'
        },
        {
          id: 'refractiveEmitter',
          x: 375,
          y: 140,
          baseY: 140,
          width: 70,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 55,
          speed: 3.2,
          phase: 3.0,
          color: '#e2b060'
        },
        { x: 480, y: 90, width: 144, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 565, y: 30, width: 44, height: 60, isReached: false, label: 'PRĘDKOŚĆ FAZOWA' };
      this.wave = { x: -80, width: 55, speed: 170, active: true };
    } else if (chamberIndex === 17) {
      // Chamber 17: Wirówka Osadu Pamięciowego (Memory Sediment Centrifuge)
      this.platforms = [
        { x: 0, y: 320, width: 130, height: 40, isStatic: true, color: '#090d12' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'centrifugeDrumA',
          x: 150,
          y: 260,
          baseY: 260,
          width: 65,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 80,
          speed: 3.6,
          phase: 0,
          color: '#c65d58'
        },
        {
          id: 'isotopeRotor',
          x: 245,
          y: 180,
          baseY: 180,
          width: 80,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 60,
          speed: 2.5,
          phase: 1.8,
          color: '#d39a62'
        },
        {
          id: 'sedimentGantry',
          x: 360,
          y: 130,
          baseY: 130,
          width: 75,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 70,
          speed: 3.0,
          phase: 3.2,
          color: '#5da398'
        },
        { x: 470, y: 85, width: 154, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 565, y: 25, width: 44, height: 60, isReached: false, label: 'WIRÓWKA OSADU' };
      this.wave = { x: -80, width: 60, speed: 160, active: true };
    } else if (chamberIndex === 18) {
      // Chamber 18: Rdzeń Wieloszczelinowy (Multi-Slit Quantum Interference Core)
      this.platforms = [
        { x: 0, y: 320, width: 140, height: 40, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'slitBarrier1',
          x: 160,
          y: 240,
          baseY: 240,
          width: 60,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 50,
          speed: 2.2,
          phase: 0,
          color: '#5da398'
        },
        {
          id: 'fringeB',
          x: 250,
          y: 180,
          baseY: 180,
          width: 75,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 75,
          speed: 3.1,
          phase: 1.4,
          color: '#75c7c3'
        },
        {
          id: 'observerGateC',
          x: 360,
          y: 120,
          baseY: 120,
          width: 75,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 60,
          speed: 2.6,
          phase: 2.8,
          color: '#e2b060'
        },
        { x: 475, y: 80, width: 149, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 565, y: 20, width: 44, height: 60, isReached: false, label: 'RDZEŃ SZCZELIN' };
      this.wave = { x: -80, width: 50, speed: 175, active: true };
    } else if (chamberIndex === 19) {
      // Chamber 19: Most Kwantowy Rówień Północ (Rówień North Quantum Bridge)
      this.platforms = [
        { x: 0, y: 320, width: 130, height: 40, isStatic: true, color: '#10171a' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'entangledTetherA',
          x: 150,
          y: 230,
          baseY: 230,
          width: 70,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 85,
          speed: 2.6,
          phase: 0,
          color: '#e2b060'
        },
        {
          id: 'entangledTetherB',
          x: 250,
          y: 230,
          baseY: 230,
          width: 70,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 85,
          speed: 2.6,
          phase: Math.PI,
          color: '#75c7c3'
        },
        {
          id: 'nonLocalBridge',
          x: 355,
          y: 150,
          baseY: 150,
          width: 80,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 50,
          speed: 2.0,
          phase: 1.2,
          color: '#5da398'
        },
        {
          id: 'gantryNorth',
          x: 450,
          y: 100,
          baseY: 100,
          width: 65,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 40,
          speed: 3.0,
          phase: 0,
          color: '#c65d58'
        },
        { x: 535, y: 75, width: 89, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 565, y: 15, width: 44, height: 60, isReached: false, label: 'MOST PÓŁNOC' };
      this.wave = { x: -80, width: 55, speed: 165, active: true };
    } else if (chamberIndex === 20) {
      // Chamber 20: Strefa Stabilizacji Finałowej 42A/B/C (Final Stabilization Triad)
      this.platforms = [
        { x: 0, y: 320, width: 140, height: 40, isStatic: true, color: '#090d12' },
        { x: 0, y: 0, width: 640, height: 24, isStatic: true, color: '#16242e' },
        { x: 0, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        { x: 624, y: 0, width: 16, height: 360, isStatic: true, color: '#16242e' },
        {
          id: 'attractorReturn',
          x: 160,
          y: 250,
          baseY: 250,
          width: 70,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 60,
          speed: 2.0,
          phase: 0,
          color: '#75c7c3'
        },
        {
          id: 'attractorReconcil',
          x: 265,
          y: 180,
          baseY: 180,
          width: 75,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 70,
          speed: 2.5,
          phase: 1.8,
          color: '#e2b060'
        },
        {
          id: 'attractorTestimony',
          x: 375,
          y: 120,
          baseY: 120,
          width: 75,
          height: 14,
          isAnchorable: true,
          isAnchored: false,
          amplitude: 55,
          speed: 3.0,
          phase: 3.2,
          color: '#5da398'
        },
        { x: 485, y: 80, width: 139, height: 16, isStatic: true, color: '#243a47' }
      ];
      this.goal = { x: 565, y: 20, width: 44, height: 60, isReached: false, label: 'TRIADA 42A/B/C' };
      this.wave = { x: -80, width: 65, speed: 180, active: true };
    }
  }

  bindInputs() {
    window.addEventListener('keydown', (e) => {
      if (['ArrowLeft', 'KeyA'].includes(e.code)) this.keys.left = true;
      if (['ArrowRight', 'KeyD'].includes(e.code)) this.keys.right = true;
      if (['ArrowUp', 'KeyW', 'Space'].includes(e.code)) {
        this.keys.jump = true;
        this.player.jumpBuffer = this.jumpBufferMax;
      }
      if (['KeyC', 'ShiftLeft', 'ShiftRight', 'KeyE'].includes(e.code)) {
        this.toggleNearestAnchor();
      }
      if (['KeyR'].includes(e.code)) {
        this.resetPlayer();
        if (window.proceduralAudio) window.proceduralAudio.playSwitchSound();
      }
    });

    window.addEventListener('keyup', (e) => {
      if (['ArrowLeft', 'KeyA'].includes(e.code)) this.keys.left = false;
      if (['ArrowRight', 'KeyD'].includes(e.code)) this.keys.right = false;
      if (['ArrowUp', 'KeyW', 'Space'].includes(e.code)) this.keys.jump = false;
    });

    // Touch & Click on Canvas for quick interaction
    this.canvas.addEventListener('pointerdown', (e) => {
      const rect = this.canvas.getBoundingClientRect();
      const scaleX = this.logicalWidth / rect.width;
      const scaleY = this.logicalHeight / rect.height;
      const clickX = (e.clientX - rect.left) * scaleX;
      const clickY = (e.clientY - rect.top) * scaleY;

      // Check if clicked near an anchorable platform
      for (const p of this.platforms) {
        if (p.isAnchorable) {
          if (clickX >= p.x - 20 && clickX <= p.x + p.width + 20 &&
              clickY >= p.y - 20 && clickY <= p.y + p.height + 20) {
            p.isAnchored = !p.isAnchored;
            this.spawnAnchorParticles(p.x + p.width/2, p.y + p.height/2, p.isAnchored ? '#5da398' : '#d39a62');
            this.screenShake = 3;
            if (window.proceduralAudio) {
              if (p.isAnchored) window.proceduralAudio.playAnchorSound();
              else window.proceduralAudio.playUnanchorSound();
            }
            return;
          }
        }
      }
    });
  }

  toggleNearestAnchor() {
    let nearest = null;
    let minDist = 140;

    for (const p of this.platforms) {
      if (p.isAnchorable) {
        const dx = (p.x + p.width / 2) - (this.player.x + this.player.width / 2);
        const dy = (p.y + p.height / 2) - (this.player.y + this.player.height / 2);
        const dist = Math.sqrt(dx * dx + dy * dy);
        if (dist < minDist) {
          minDist = dist;
          nearest = p;
        }
      }
    }

    if (nearest) {
      nearest.isAnchored = !nearest.isAnchored;
      this.spawnAnchorParticles(nearest.x + nearest.width / 2, nearest.y + nearest.height / 2, nearest.isAnchored ? '#5da398' : '#d39a62');
      this.screenShake = 4;
      if (window.proceduralAudio) {
        if (nearest.isAnchored) window.proceduralAudio.playAnchorSound();
        else window.proceduralAudio.playUnanchorSound();
      }
    } else {
      // Toggle all if none near
      let stateToSet = !this.platforms.some(p => p.isAnchorable && p.isAnchored);
      this.platforms.forEach(p => {
        if (p.isAnchorable) {
          p.isAnchored = stateToSet;
          this.spawnAnchorParticles(p.x + p.width / 2, p.y + p.height / 2, stateToSet ? '#5da398' : '#d39a62');
        }
      });
      this.screenShake = 3;
      if (window.proceduralAudio) {
        if (stateToSet) window.proceduralAudio.playAnchorSound();
        else window.proceduralAudio.playUnanchorSound();
      }
    }
  }

  spawnAnchorParticles(x, y, color) {
    for (let i = 0; i < 16; i++) {
      const angle = (Math.PI * 2 * i) / 16;
      const speed = 40 + Math.random() * 80;
      this.particles.push({
        x: x,
        y: y,
        vx: Math.cos(angle) * speed,
        vy: Math.sin(angle) * speed,
        life: 0.35 + Math.random() * 0.2,
        maxLife: 0.5,
        color: color,
        size: 2 + Math.random() * 2
      });
    }
  }

  resetPlayer() {
    this.player.x = 40;
    this.player.y = 280;
    this.player.vx = 0;
    this.player.vy = 0;
    this.player.isGrounded = false;
    this.player.coyoteTimer = 0;
    this.player.jumpBuffer = 0;
    this.player.facing = 1;
    if (this.wave) this.wave.x = -80;
    if (this.goal) this.goal.isReached = false;
  }

  start() {
    this.isRunning = true;
    this.lastTime = performance.now();
    requestAnimationFrame((t) => this.loop(t));
  }

  loop(currentTime) {
    if (!this.isRunning) return;

    const dt = Math.min((currentTime - this.lastTime) / 1000, 0.05);
    this.lastTime = currentTime;
    this.time += dt;

    this.update(dt);
    this.render();

    requestAnimationFrame((t) => this.loop(t));
  }

  update(dt) {
    // 1. Moving Anchorable Platforms
    for (const p of this.platforms) {
      if (p.isAnchorable && !p.isAnchored) {
        p.y = p.baseY + Math.sin(this.time * p.speed + p.phase) * p.amplitude;
      }
    }

    // 2. Correction Wave Update
    if (this.wave && this.wave.active) {
      this.wave.x += this.wave.speed * dt;
      if (this.wave.x > this.logicalWidth + 100) {
        this.wave.x = -120;
      }

      // Check if wave catches player
      if (this.player.x < this.wave.x + this.wave.width && this.player.x + this.player.width > this.wave.x) {
        this.screenShake = 6;
        if (window.proceduralAudio) window.proceduralAudio.playCorrectionWaveSound();
        this.resetPlayer();
      }
    }

    // 3. Horizontal Physics
    let targetVx = 0;
    if (this.keys.left) {
      targetVx -= this.moveSpeed;
      this.player.facing = -1;
    }
    if (this.keys.right) {
      targetVx += this.moveSpeed;
      this.player.facing = 1;
    }

    const accel = this.player.isGrounded ? this.accelGround : this.accelAir;
    const friction = this.player.isGrounded ? this.frictionGround : this.accelAir;

    if (targetVx !== 0) {
      if (Math.sign(this.player.vx) !== Math.sign(targetVx) && this.player.vx !== 0) {
        this.player.vx += Math.sign(targetVx) * friction * dt;
      } else {
        this.player.vx += Math.sign(targetVx) * accel * dt;
        if (Math.abs(this.player.vx) > this.moveSpeed) {
          this.player.vx = Math.sign(targetVx) * this.moveSpeed;
        }
      }
    } else {
      const decel = friction * dt;
      if (Math.abs(this.player.vx) <= decel) {
        this.player.vx = 0;
      } else {
        this.player.vx -= Math.sign(this.player.vx) * decel;
      }
    }

    // Footstep audio cadence when running on ground
    if (this.player.isGrounded && Math.abs(this.player.vx) > 30) {
      this.stepAudioTimer += dt;
      if (this.stepAudioTimer > 0.32) {
        this.stepAudioTimer = 0;
        if (window.proceduralAudio) window.proceduralAudio.playFootstepSound();
      }
    } else {
      this.stepAudioTimer = 0.25;
    }

    // 4. Vertical Physics & Coyote Time
    if (this.player.isGrounded) {
      this.player.coyoteTimer = this.coyoteTimeMax;
    } else {
      this.player.coyoteTimer = Math.max(0, this.player.coyoteTimer - dt);
    }

    if (this.player.jumpBuffer > 0) {
      this.player.jumpBuffer -= dt;
    }

    // Jump execution
    if (this.player.jumpBuffer > 0 && this.player.coyoteTimer > 0) {
      this.player.vy = this.jumpForce;
      this.player.jumpBuffer = 0;
      this.player.coyoteTimer = 0;
      this.player.isGrounded = false;
      if (window.proceduralAudio) window.proceduralAudio.playJumpSound();
      // Jump dust particles
      for (let i = 0; i < 6; i++) {
        this.particles.push({
          x: this.player.x + this.player.width / 2 + (Math.random() - 0.5) * 12,
          y: this.player.y + this.player.height,
          vx: (Math.random() - 0.5) * 50,
          vy: -Math.random() * 30,
          life: 0.2 + Math.random() * 0.1,
          maxLife: 0.3,
          color: '#5da398',
          size: 2
        });
      }
    }

    // Gravity
    this.player.vy += this.gravity * dt;
    if (this.player.vy > this.maxFallSpeed) {
      this.player.vy = this.maxFallSpeed;
    }

    // 5. Integrate & Collide
    this.player.x += this.player.vx * dt;
    this.collideHorizontal();

    this.player.y += this.player.vy * dt;
    this.player.isGrounded = false;
    this.collideVertical();

    // Kill zone bottom
    if (this.player.y > this.logicalHeight + 40) {
      this.resetPlayer();
      if (window.proceduralAudio) window.proceduralAudio.playDimensionalClashSound();
    }

    // Goal zone check
    if (this.goal && !this.goal.isReached) {
      if (this.player.x + this.player.width > this.goal.x &&
          this.player.x < this.goal.x + this.goal.width &&
          this.player.y + this.player.height > this.goal.y &&
          this.player.y < this.goal.y + this.goal.height) {
        this.goal.isReached = true;
        this.screenShake = 6;
        if (window.proceduralAudio) {
          window.proceduralAudio.playClinicChimeSound();
        }
        // Advance to next chamber after 1 sec
        setTimeout(() => {
          const nextChamber = (this.currentChamber % 15) + 1;
          const buttons = document.querySelectorAll('.sandbox-toolbar .tool-btn');
          this.loadChamber(nextChamber);
          // Sync toolbar UI
          const chamberButtons = document.querySelectorAll('.sandbox-toolbar .toolbar-group:first-child .tool-btn');
          chamberButtons.forEach((b, idx) => {
            b.classList.toggle('active', idx + 1 === nextChamber);
          });
        }, 800);
      }
    }

    // 6. Particle Updates
    for (let i = this.particles.length - 1; i >= 0; i--) {
      const p = this.particles[i];
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      p.life -= dt;
      if (p.life <= 0) {
        this.particles.splice(i, 1);
      }
    }

    // Screen Shake decay
    if (this.screenShake > 0) {
      this.screenShake = Math.max(0, this.screenShake - dt * 15);
    }
  }

  collideHorizontal() {
    for (const p of this.platforms) {
      if (this.checkAABB(this.player, p)) {
        if (this.player.vx > 0) {
          this.player.x = p.x - this.player.width;
          this.player.vx = 0;
        } else if (this.player.vx < 0) {
          this.player.x = p.x + p.width;
          this.player.vx = 0;
        }
      }
    }
  }

  collideVertical() {
    for (const p of this.platforms) {
      if (this.checkAABB(this.player, p)) {
        if (this.player.vy > 0) {
          // Landing on top of platform
          this.player.y = p.y - this.player.height;
          this.player.vy = 0;
          this.player.isGrounded = true;
        } else if (this.player.vy < 0) {
          // Hitting ceiling
          this.player.y = p.y + p.height;
          this.player.vy = 0;
        }
      }
    }
  }

  checkAABB(r1, r2) {
    return (
      r1.x < r2.x + r2.width &&
      r1.x + r1.width > r2.x &&
      r1.y < r2.y + r2.height &&
      r1.y + r1.height > r2.y
    );
  }

  render() {
    const ctx = this.ctx;
    ctx.save();

    // Apply screen shake
    if (this.screenShake > 0) {
      const sx = (Math.random() - 0.5) * this.screenShake * 2;
      const sy = (Math.random() - 0.5) * this.screenShake * 2;
      ctx.translate(sx, sy);
    }

    // 1. Background Fill & Grid
    ctx.fillStyle = '#05080c';
    ctx.fillRect(0, 0, this.logicalWidth, this.logicalHeight);

    // Architectural grid lines
    ctx.strokeStyle = 'rgba(22, 36, 46, 0.4)';
    ctx.lineWidth = 1;
    for (let x = 0; x < this.logicalWidth; x += 40) {
      ctx.beginPath();
      ctx.moveTo(x, 0);
      ctx.lineTo(x, this.logicalHeight);
      ctx.stroke();
    }
    for (let y = 0; y < this.logicalHeight; y += 40) {
      ctx.beginPath();
      ctx.moveTo(0, y);
      ctx.lineTo(this.logicalWidth, y);
      ctx.stroke();
    }

    // 2. Goal Zone
    if (this.goal) {
      ctx.fillStyle = this.goal.isReached ? 'rgba(93, 163, 152, 0.5)' : 'rgba(93, 163, 152, 0.15)';
      ctx.strokeStyle = '#5da398';
      ctx.lineWidth = 2;
      ctx.fillRect(this.goal.x, this.goal.y, this.goal.width, this.goal.height);
      ctx.strokeRect(this.goal.x, this.goal.y, this.goal.width, this.goal.height);

      ctx.fillStyle = '#75c7c3';
      ctx.font = '9px monospace';
      ctx.textAlign = 'center';
      ctx.fillText(this.goal.label || 'ŚLUZA', this.goal.x + this.goal.width / 2, this.goal.y + 24);
      ctx.fillText(this.goal.isReached ? 'OK' : '▶▶', this.goal.x + this.goal.width / 2, this.goal.y + 42);
    }

    // 3. Platforms & Anchorables
    for (const p of this.platforms) {
      ctx.fillStyle = p.color || '#16242e';
      ctx.fillRect(p.x, p.y, p.width, p.height);

      if (p.isAnchorable) {
        ctx.strokeStyle = p.isAnchored ? '#5da398' : '#d39a62';
        ctx.lineWidth = 2;
        ctx.strokeRect(p.x, p.y, p.width, p.height);

        // Anchor status badge / glyph
        ctx.fillStyle = p.isAnchored ? '#5da398' : '#d39a62';
        ctx.font = '9px monospace';
        ctx.textAlign = 'center';
        const glyph = p.isAnchored ? '◆ ANCHORED' : '◇ UNANCHORED';
        ctx.fillText(glyph, p.x + p.width / 2, p.y + p.height / 2 + 3);

        // Guide trajectory rail
        if (!p.isAnchored && p.amplitude) {
          ctx.strokeStyle = 'rgba(211, 154, 98, 0.2)';
          ctx.setLineDash([3, 3]);
          ctx.beginPath();
          ctx.moveTo(p.x + p.width / 2, p.baseY - p.amplitude);
          ctx.lineTo(p.x + p.width / 2, p.baseY + p.amplitude);
          ctx.stroke();
          ctx.setLineDash([]);
        }
      } else {
        ctx.strokeStyle = '#243a47';
        ctx.lineWidth = 1;
        ctx.strokeRect(p.x, p.y, p.width, p.height);
      }
    }

    // 4. Correction Wave
    if (this.wave && this.wave.active) {
      const grad = ctx.createLinearGradient(this.wave.x, 0, this.wave.x + this.wave.width, 0);
      grad.addColorStop(0, 'rgba(198, 93, 88, 0.0)');
      grad.addColorStop(0.7, 'rgba(198, 93, 88, 0.25)');
      grad.addColorStop(1, 'rgba(222, 117, 112, 0.6)');

      ctx.fillStyle = grad;
      ctx.fillRect(this.wave.x, 0, this.wave.width, this.logicalHeight);

      ctx.strokeStyle = '#de7570';
      ctx.lineWidth = 2;
      ctx.beginPath();
      ctx.moveTo(this.wave.x + this.wave.width, 0);
      ctx.lineTo(this.wave.x + this.wave.width, this.logicalHeight);
      ctx.stroke();
    }

    // 5. Particles
    for (const p of this.particles) {
      const alpha = p.life / p.maxLife;
      ctx.fillStyle = p.color;
      ctx.globalAlpha = alpha;
      ctx.fillRect(p.x - p.size / 2, p.y - p.size / 2, p.size, p.size);
    }
    ctx.globalAlpha = 1.0;

    // 6. Player (Lena Wolska)
    const pl = this.player;
    ctx.fillStyle = '#e6f0f5'; // White/Cyan Lena silhouette
    ctx.fillRect(pl.x, pl.y, pl.width, pl.height);

    // Accent lab coat collar
    ctx.fillStyle = '#5da398';
    ctx.fillRect(pl.x + (pl.facing > 0 ? 8 : 2), pl.y + 4, 4, 6);

    // Dark belt/trousers
    ctx.fillStyle = '#16242e';
    ctx.fillRect(pl.x, pl.y + pl.height - 8, pl.width, 8);

    // Eye visor / gaze
    ctx.fillStyle = '#75c7c3';
    const eyeX = pl.facing > 0 ? pl.x + pl.width - 4 : pl.x + 2;
    ctx.fillRect(eyeX, pl.y + 4, 2, 2);

    // HUD Telemetry overlay in top-left
    ctx.fillStyle = 'rgba(5, 8, 12, 0.8)';
    ctx.fillRect(16, 12, 260, 42);
    ctx.strokeStyle = '#243a47';
    ctx.strokeRect(16, 12, 260, 42);

    ctx.fillStyle = '#75c7c3';
    ctx.font = '10px monospace';
    ctx.textAlign = 'left';
    ctx.fillText(`KOMORA: 0${this.currentChamber}/07 | PROFIL: ${this.currentProfile}`, 24, 26);
    ctx.fillStyle = '#6b8291';
    ctx.fillText(`X:${Math.round(pl.x)} Y:${Math.round(pl.y)} VX:${Math.round(pl.vx)} VY:${Math.round(pl.vy)} | FL:${pl.isGrounded ? 'TAK' : 'NIE'}`, 24, 42);

    ctx.restore();
  }

  toggleFullscreen() {
    const heroSandbox = document.querySelector('.hero-sandbox');
    if (!heroSandbox) return;
    const isFull = heroSandbox.classList.toggle('fullscreen-mode');
    if (window.proceduralAudio) window.proceduralAudio.playSwitchSound();
    return isFull;
  }
}

window.GettingStrangeMiniEngine = GettingStrangeMiniEngine;

