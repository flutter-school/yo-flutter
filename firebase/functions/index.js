const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

exports.sendYo = functions.https.onRequest((request, response) => {
    let refPeople = admin.firestore().collection(`/people`);
    let refTokens = admin.firestore().collection(`/tokens`);
    let toUid = request.query.toUid;
    let fromUid = request.query.fromUid;

    return refPeople.doc(fromUid).get().then(snapshot => {
        return snapshot.data().name;
    }).then((senderName) => {
        return refTokens.doc(toUid).get().then(snapshot => {
            response.send('Yo!');
            return sendMessage('Yo!', `From ${senderName}.`, snapshot.data().token);
         });
    });
});

function sendMessage(msgTitle, msgBody, deviceToken) {
    if (deviceToken === null) return 0;

    let message = {
        token: deviceToken,
        notification: {
            title: msgTitle,
            body: msgBody
        },
        data: {
            click_action: 'FLUTTER_NOTIFICATION_CLICK'
        },
        apns: {
            headers: {
                "apns-expiration": "0"
            }
        },
        android: {
            ttl: 0
        }
    };

    return admin.messaging().send(message);
}
