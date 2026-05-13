
const {setGlobalOptions} = require("firebase-functions");

const {onCall, HttpsError} = require("firebase-functions/https");


setGlobalOptions({maxInstances: 10});
const admin = require("firebase-admin");

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});
exports.sendNotifications = onCall({cors: [/firebase\.com$/, "https://flutter.com"]}, async (req) => {
  try {
    const promises = req.data.targetIds.map(async (id) => {
      try {
        await admin.messaging().send({
          data: {data: req.data.data},
          android: {
            notification: {
              sound: "default",
              click_action: "FLUTTER_NOTIFICATION_CLICK",
              tag: req.data.thread,
            },
          },
          apns: {
            payload: {
              aps: {
                "mutable-content": 1,
                "sound": "default",
                "thread-id": req.data.thread,
              },
            },
          },
          notification: {
            title: req.data.title,
            body: req.data.body,
          },
          token: id,
        });
      } catch (error) {
        console.error(error);
      }
    });

    await Promise.all(promises);

    // }


    return req.data;
  } catch (error) {
    console.error(error);
    throw new HttpsError("internal", "error");
  }
});
