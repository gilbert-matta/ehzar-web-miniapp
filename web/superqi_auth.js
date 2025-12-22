<script src="https://cdn.marmot-cloud.com/npm/hylid-bridge/2.10.0/index.js"></script>

    // --- SuperQi Authorization Bridge ---
    window.superQiAuth = {
  async getAuthCodeAndToken(BASE_URL) {
    return new Promise((resolve, reject) => {
      function startAuth() {
        console.log('[Bridge] Ready:', typeof my.getAuthCode);
        my.getAuthCode({
          scopes: ['auth_user', 'USER_ID'],
          success: async (res) => {
            console.log('[Bridge] Auth code:', res.authCode);
            const endpoint = `${BASE_URL}/api/v1/auth/apply-token`;
            try {
              const resp = await fetch(endpoint, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ auth_code: res.authCode }),
              });
              const data = await resp.json();
              console.log('[Bridge] Backend response:', data);
              resolve(data);
            } catch (err) {
              console.error('[Bridge] applyToken error:', err);
              reject(err);
            }
          },
          fail: (err) => {
            console.error('[Bridge] getAuthCode failed:', err);
            reject(err);
          },
        });
      }

      if (typeof my === 'undefined' || !my.getAuthCode) {
        console.log('[Bridge] Waiting for AlipayJSBridgeReady...');
        document.addEventListener('AlipayJSBridgeReady', startAuth, false);
      } else {
        startAuth();
      }
    });
  },
};