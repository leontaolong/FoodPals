"use strict";

const apn = require('apn');

let Notifier = {
    notifyMatching: (apnProvider, deviceToken, post) => {
        let notification = new apn.Notification({
            title: "Hello, world!",
            body: post,
            sound: "default",
            contentAvailable: 1,
            badge: 1,
            mutableContent: 1,
            topic: "edu.uw.ischool.loners.HungryPals",
            payload: {
              "sender": "node-apn",
            },
        });

        apnProvider.send(notification, deviceToken).then( (result) => {
            if (result.failed.length == 0) {
                console.log("notification successfully sent.")
            } else {
                console.log(result)
            }
        });     
    },

    notifyInvite: (apnProvider, deviceToken, inviter) => {
        let notification = new apn.Notification({
            title: "Let's eat together!",
            body: inviter,
            sound: "default",
            contentAvailable: 1,
            badge: 1,
            mutableContent: 1,
            topic: "edu.uw.ischool.loners.HungryPals",
            payload: {
              "sender": "node-apn",
            },
        });

        apnProvider.send(notification, deviceToken).then( (result) => {
            if (result.failed.length == 0) {
                console.log("notification successfully sent.")
            } else {
                console.log(result)
            }
        });
    },

    notifyConfirmed: (apnProvider, deviceToken, post) => {
        let notification = new apn.Notification({
            title: "Let's eat together!",
            body: post,
            sound: "default",
            contentAvailable: 1,
            badge: 1,
            mutableContent: 1,
            topic: "edu.uw.ischool.loners.HungryPals",
            payload: {
              "sender": "node-apn",
            },
        });

        apnProvider.send(notification, deviceToken).then( (result) => {
            if (result.failed.length == 0) {
                console.log("notification successfully sent.")
            } else {
                console.log(result)
            }
        });
    },

    notifyRejected: (apnProvider, deviceToken, post) => {
        let notification = new apn.Notification({
            title: "Let's eat together!",
            body: post,
            sound: "default",
            contentAvailable: 1,
            badge: 1,
            mutableContent: 1,
            topic: "edu.uw.ischool.loners.HungryPals",
            payload: {
              "sender": "node-apn",
            },
        });

        apnProvider.send(notification, deviceToken).then( (result) => {
            if (result.failed.length == 0) {
                console.log("notification successfully sent.")
            } else {
                console.log(result)
            }
        });
    }
}

module.exports = Notifier;