console.log("🔄 Loading reCAPTCHA Handler...");

// Your site key
const RECAPTCHA_SITE_KEY = '6LdahBEsAAAAACU5XKjZqhMMyqT4F2e8YCQ63k2e';

let recaptchaInitialized = false;

/**
 * Must be called BEFORE any execute()
 */
function initializeRecaptcha() {
    if (typeof grecaptcha === 'undefined') {
        console.error("❌ grecaptcha not loaded");
        return;
    }

    grecaptcha.ready(() => {
        recaptchaInitialized = true;
        console.log("✅ reCAPTCHA is ready");
    });
}

/**
 * Execute reCAPTCHA v3
 */
async function executeRecaptcha(action) {
    console.log(`🤖 Executing reCAPTCHA for action: ${action}`);

    if (!recaptchaInitialized) {
        throw new Error("reCAPTCHA site key not initialized. Call initializeRecaptcha() first.");
    }

    const token = await grecaptcha.execute(RECAPTCHA_SITE_KEY, { action });
    console.log(`✅ Token: ${token.substring(0, 20)}...`);
    return token;
}

/**
 * Flutter callback wrapper
 */
function getRecaptchaToken(action, callback) {
    executeRecaptcha(action)
        .then(token => callback(true, token))
        .catch(err => callback(false, err.toString()));
}

// Expose to Flutter
window.initializeRecaptcha = initializeRecaptcha;
window.executeRecaptcha = executeRecaptcha;
window.getRecaptchaToken = getRecaptchaToken;

console.log("✅ reCAPTCHA Handler initialized");
