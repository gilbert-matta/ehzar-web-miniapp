//// Import the Firebase scripts needed for background messaging
//importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js');
//importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js');
//
//// Initialize the Firebase app in the service worker by passing in the messagingSenderId
//firebase.initializeApp({
//  apiKey: "AIzaSyAIMkqBCpHzBd067LXF37JMOuYh_zv87no",
//      authDomain: "ihzar-8294a.firebaseapp.com",
//      projectId: "ihzar-8294a",
//      storageBucket: "ihzar-8294a.firebasestorage.app",
//      messagingSenderId: "340567392458",
//      appId: "1:340567392458:web:e08a5cf5dfaaf0fd813433"
//});
//
//// Retrieve an instance of Firebase Messaging to handle background messages
//const messaging = firebase.messaging();
//
//messaging.onBackgroundMessage(function(payload) {
//  console.log('[firebase-messaging-sw.js] Received background message ', payload);
//  const notificationTitle = payload.notification.title;
//  const notificationOptions = {
//    body: payload.notification.body,
//    icon: '/icons/Icon-192.png'
//  };
//
//  self.registration.showNotification(notificationTitle, notificationOptions);
//});
