const functions = require('firebase-functions');
const admin = require('firebase-admin');
const { topic } = require('firebase-functions/lib/providers/pubsub');
admin.initializeApp();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.onGroupPrayerCreated = functions.firestore
    .document('/groups/{groupId}/groupPrayers/{prayerId}')
    .onCreate((snapshot, context) => {
      const prayerId = context.params.prayerId;
      const groupId = context.params.groupId;
      console.log("Group Got A New Prayer For Group: " + groupId + " PrayerId: " + prayerId);

      const prayerTitle = snapshot.get("title");
      const prayerCreator = snapshot.get("creatorUID");
      const creatorDisplayName = snapshot.get("creatorDisplayName");

      const titleString = 'Prayer pals - Group Prayer Created:';
      const bodyString = prayerTitle;
      const topicString = groupId + '-GroupCampaign_Created';
      
      const payload = {
        notification: {
            title: titleString,
            body: bodyString,
        },
        android: {
            data: {
                creatorId: prayerCreator,
                creatorDisplayName: creatorDisplayName,
                groupId: groupId,
                id: prayerId,
                type: 'groupPrayerCreated',
                title: titleString,
                body: bodyString,
                "click_action": "FLUTTER_NOTIFICATION_CLICK",
                "priority": "high",
            },
        },
        data: {
            creatorId: prayerCreator,
            creatorDisplayName: creatorDisplayName,
            groupId: groupId,
            id: prayerId,
            type: 'groupPrayerCreated',
            title: titleString,
            body: bodyString,
        },
        topic: topicString,
    };

      console.log("PN: For Group Prayer: " + topicString + " - " + bodyString);
      return admin.messaging().send(payload)
      .then((response) => {
        // Response is a message ID string.
        console.log('Successfully sent message:', response);
      })
      .catch((error) => {
        console.log('Error sending message:', error);
      });
    }
    );
