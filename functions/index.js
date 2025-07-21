/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {setGlobalOptions} = require("firebase-functions");

const {onRequest} = require("firebase-functions/https");
const logger = require("firebase-functions/logger");

// For cost control, you can set the maximum number of containers that can be
// running at the same time. This helps mitigate the impact of unexpected
// traffic spikes by instead downgrading performance. This limit is a
// per-function limit. You can override the limit for each function using the
// `maxInstances` option in the function's options, e.g.
// `onRequest({ maxInstances: 5 }, (req, res) => { ... })`.
// NOTE: setGlobalOptions does not apply to functions using the v1 API. V1
// functions should each use functions.runWith({ maxInstances: 10 }) instead.
// In the v1 API, each function can only serve one request per container, so
// this will be the maximum concurrent request count.
setGlobalOptions({ maxInstances: 10 });

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const { onSchedule } = require("firebase-functions/v2/scheduler");
const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.deleteExpiredChatsAndEvents = onSchedule("every 24 hours", async (event) => {
  const now = Date.now();

  // --- Видалення чатів ---
  const chatsSnapshot = await admin.firestore().collection('chats').get();
  const batch = admin.firestore().batch();
  let deletedChats = 0;

  chatsSnapshot.forEach(doc => {
    const data = doc.data();
    let eventEndTime = data.eventEndTime;
    if (!eventEndTime) return;

    if (eventEndTime.toDate) {
      eventEndTime = eventEndTime.toDate();
    } else {
      eventEndTime = new Date(eventEndTime);
    }

    const expiry = new Date(eventEndTime.getTime() + 7 * 24 * 60 * 60 * 1000);
    if (expiry < new Date(now)) {
      batch.delete(doc.ref);
      deletedChats++;
    }
  });

  // --- Видалення івентів ---
  const eventsSnapshot = await admin.firestore().collection('events').get();
  let deletedEvents = 0;

  eventsSnapshot.forEach(doc => {
    const data = doc.data();
    let eventEndTime = data.eventEndTime;
    if (!eventEndTime) return;

    if (eventEndTime.toDate) {
      eventEndTime = eventEndTime.toDate();
    } else {
      eventEndTime = new Date(eventEndTime);
    }

    const expiry = new Date(eventEndTime.getTime() + 7 * 24 * 60 * 60 * 1000);
    if (expiry < new Date(now)) {
      batch.delete(doc.ref);
      deletedEvents++;
    }
  });

  if (deletedChats + deletedEvents > 0) {
    await batch.commit();
    console.log(`Deleted ${deletedChats} expired chats and ${deletedEvents} expired events.`);
  } else {
    console.log('No expired chats or events to delete.');
  }
  return null;
});