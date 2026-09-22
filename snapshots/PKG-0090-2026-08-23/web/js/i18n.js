/**
 * GETTING STRANGE — Internationalization & Localization Engine (i18n)
 * Supports dynamic real-time switching between Polish (PL) and English (EN).
 */

class GettingStrangeI18n {
  constructor() {
    this.currentLang = localStorage.getItem("gs_lang") || "pl";
    this.translations = {
      pl: null,
      en: null
    };
    this.listeners = [];
  }

  async init() {
    try {
      const plResp = await fetch("locales/pl.json");
      this.translations.pl = await plResp.json();
    } catch (e) {
      console.warn("Could not load pl.json, using fallback", e);
    }

    try {
      const enResp = await fetch("locales/en.json");
      this.translations.en = await enResp.json();
    } catch (e) {
      console.warn("Could not load en.json, using fallback", e);
    }

    this.applyLanguage(this.currentLang);
  }

  setLanguage(lang) {
    if (lang !== "pl" && lang !== "en") return;
    this.currentLang = lang;
    localStorage.setItem("gs_lang", lang);
    this.applyLanguage(lang);
    this.notifyListeners(lang);
  }

  addListener(fn) {
    this.listeners.push(fn);
  }

  notifyListeners(lang) {
    this.listeners.forEach(fn => {
      try {
        fn(lang);
      } catch (err) {
        console.error("i18n listener error:", err);
      }
    });
  }

  t(keyPath) {
    const dict = this.translations[this.currentLang] || this.translations.pl;
    if (!dict) return keyPath;
    const parts = keyPath.split(".");
    let current = dict;
    for (const part of parts) {
      if (current && current[part] !== undefined) {
        current = current[part];
      } else {
        return keyPath;
      }
    }
    return current;
  }

  applyLanguage(lang) {
    document.documentElement.lang = lang;

    // Update active lang buttons
    const btnPl = document.getElementById("lang-pl");
    const btnEn = document.getElementById("lang-en");
    if (btnPl && btnEn) {
      if (lang === "pl") {
        btnPl.classList.add("active");
        btnEn.classList.remove("active");
      } else {
        btnEn.classList.add("active");
        btnPl.classList.remove("active");
      }
    }

    // Translate all elements with data-i18n attribute
    document.querySelectorAll("[data-i18n]").forEach(el => {
      const key = el.getAttribute("data-i18n");
      const translation = this.t(key);
      if (typeof translation === "string") {
        if (el.tagName === "INPUT" || el.tagName === "TEXTAREA") {
          el.placeholder = translation;
        } else {
          el.innerHTML = translation;
        }
      }
    });

    // Update title
    const titleVal = this.t("appTitle");
    if (titleVal && titleVal !== "appTitle") {
      document.title = titleVal;
    }
  }
}

window.i18n = new GettingStrangeI18n();
