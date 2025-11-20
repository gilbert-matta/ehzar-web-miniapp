/**
 * QI NEO Payment Handler
 * Handles the QI NEO payment flow using my.tradePay
 */

console.log("🔄 Loading QiNeo Payment Bridge...");

// Global callback holder
let paymentResultCallback = null;

/**
 * Initialize QI NEO Payment
 * @param {string} paymentUrl
 * @param {function} callback (success, structuredResult)
 */
function initQiNeoPayment(paymentUrl, callback) {
    paymentResultCallback = callback;

    function startPayment() {
        console.log("🚀 Bridge ready. Starting payment...");

        if (typeof my === "undefined" || typeof my.tradePay !== "function") {
            console.error("❌ my.tradePay still not available.");
            handlePaymentResult(false, {
                errorType: "SDK_NOT_READY",
                message: "QI NEO SDK is not initialized"
            });
            return;
        }

        updateStatus("Initializing payment...");

        console.log("➡ Calling my.tradePay with URL:", paymentUrl);
        my.tradePay({
            paymentUrl: paymentUrl,

            success(res) {
                console.log("🟢 Payment SUCCESS:", res);
//                return result?.resultCode || result?.code;
                handlePaymentResult(true, res);
            },

            fail(err) {
                console.log("🔴 Payment FAIL:", err);
//                return result?.resultCode || result?.code;
                handlePaymentResult(false, err);
            }
        });
    }

    // Wait for environment if needed
    if (typeof my === "undefined" || !my.tradePay) {
        console.log("⏳ Waiting for AlipayJSBridgeReady for payment...");
        document.addEventListener("AlipayJSBridgeReady", startPayment, false);
    } else {
        startPayment();
    }
}

/**
 * Handle payment result and callback
 */
function handlePaymentResult(success, result) {
    console.log("=================================================================");
    console.log('[QI NEO Bridge] Payment Result Received');
    console.log("=================================================================");
    console.log('[QI NEO Bridge] Success:', success);
    console.log('[QI NEO Bridge] Result:', JSON.stringify(result, null, 2));
    
    // Extract resultCode from the response
    const resultCode = result?.resultCode || result?.code || 'UNKNOWN';
    console.log('[QI NEO Bridge] Result Code:', resultCode);
    
    // Determine if payment was successful
    const isSuccess = success && (resultCode === '9000' || resultCode === '8000' || resultCode === '6004');
    
    if (resultCode === '9000') {
        console.log('[QI NEO Bridge] ✅ Payment SUCCESSFUL (code: 9000)');
    } else if (resultCode === '8000') {
        console.log('[QI NEO Bridge] ⏳ Trade PROCESSING (code: 8000)');
    } else if (resultCode === '6004') {
        console.log('[QI NEO Bridge] ❓ Unknown result, may be success (code: 6004)');
    } else if (resultCode === '4000') {
        console.log('[QI NEO Bridge] ❌ Payment FAILED (code: 4000)');
    } else if (resultCode === '6001') {
        console.log('[QI NEO Bridge] ❌ User CANCELLED payment (code: 6001)');
    } else if (resultCode === '6002') {
        console.log('[QI NEO Bridge] ❌ Network EXCEPTION (code: 6002)');
    } else {
        console.log('[QI NEO Bridge] ⚠️ Other result code:', resultCode);
    }
    console.log("=================================================================\n");

    updateStatus(isSuccess ? "Payment processing..." : "Payment result received");

    const structured = {
        resultCode: resultCode,  // Pass resultCode to Dart
        success: isSuccess,
        rawResponse: result
    };

    console.log("[QI NEO Bridge] Calling Dart callback with:", JSON.stringify(structured, null, 2));

    if (paymentResultCallback) {
        paymentResultCallback(structured);
    }
}

/**
 * Determine result code safely
 */
function extractResultCode(result) {
    if (!result) return "UNKNOWN";

    if (result.resultCode) return result.resultCode;   // tradePay format
    if (result.code) return result.code;               // backend format
    if (result.errorType) return result.errorType;     // JS error format

    return "UNKNOWN";
}

/**
 * Full list of QI NEO + backend + JS error codes
 */
function getResultMessage(code) {
    const messages = {
        // QI NEO / Alipay result codes
        "9000": "Payment successful",
        "8000": "Payment is processing",
        "4000": "Payment failed",
        "6001": "User cancelled the payment",
        "6002": "Network error occurred",
        "6004": "Unknown payment result",

        // Backend result codes
        "2000": "Invalid parameters",
        "3000": "Backend rejected the payment",
        "4001": "Unable to create order",
        "4002": "Invalid or expired token",
        "4003": "Order has expired",
        "4004": "Payment method not supported",

        // SDK / system errors
        "SDK_NOT_READY": "Payment SDK is not initialized",
        "JS_RUNTIME_ERROR": "JavaScript runtime error occurred",

        // Default
        "UNKNOWN": "Unknown result code received"
    };

    return messages[code] || "Unrecognized response from payment system";
}

/**
 * Update status message in UI and console
 */
function updateStatus(message) {
    const el = document.getElementById("status");
    if (el) el.textContent = message;

    console.log("📢 Payment Status:", message);
}

// Expose globally to Flutter
window.initQiNeoPayment = initQiNeoPayment;

console.log("✅ QiNeo Payment Bridge initialized");
