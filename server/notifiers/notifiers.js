"use strict";

const apn = require('apn');

let Notifiers = {
    notifyMatching: (apnProvider, deviceToken, post) => {
        let bodyTxt = `${post.creator.username} also wants to eat ${post.cuisine} food. Send a request to eat together. `;
        let notification = new apn.Notification({
            title: "We've found a hungry pal for you.",
            body: bodyTxt,
            sound: "default",
            contentAvailable: 1,
            badge: 1,
            mutableContent: 1,
            topic: "edu.uw.ischool.loners.HungryPals",
            payload: {
              "sender": "node-apn",
              "post": post,
              "subject": "MATCH"
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

    notifyRequest: (apnProvider, deviceToken, post) => {
        let requester = post.requestedBy.username;
        let titleTxt = `${requester} wants to eat with you. `;
        let bodyTxt = `Let ${requester} know if you would love to eat ${post.cuisine} food together. `;
        let notification = {
            "aps": {
                title: titleTxt,
                body: bodyTxt,
                sound: "default",
                contentAvailable: 1,
                badge: 1,
                mutableContent: 1,
                topic: "edu.uw.ischool.loners.HungryPals",
            },
              "sender": "node-apn",
              "post": post,
              "subject": "REQUEST"
        };

        apnProvider.send(notification, deviceToken).then( (result) => {
            if (result.failed.length == 0) {
                console.log("notification successfully sent.")
            } else {
                console.log(result)
            }
        });
    },

    notifyResponse: (apnProvider, deviceToken, titleTxt, bodyTxt, post) => {
        let notification = new apn.Notification({
            title: titleTxt,
            body: bodyTxt,
            sound: "default",
            contentAvailable: 1,
            badge: 1,
            mutableContent: 1,
            topic: "edu.uw.ischool.loners.HungryPals",
            payload: {
              "sender": "node-apn",
              "post": post,
              "subject": "RESPONSE"
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

module.exports = Notifiers;