const admin = require("firebase-admin");

// Initialize the Firebase Admin SDK
admin.initializeApp({
  credential: admin.credential.cert("private-key.json"),
  databaseURL: "https://gluc-safe.firebaseio.com",
});

// async function deleteDocs(idList) {
//   const db = admin.firestore();
//   const GlucoseCollection = db.collection("glucose");
//   const MedHistoryCollection = db.collection("medHistory");
//   const MedicationCollection = db.collection("medication");
//   const usersCollection = db.collection("users");
//   const weightCollection = db.collection("weight");
//   const workoutCollection = db.collection("workout");
//   const bolusCollection = db.collection("bolus");
//   const userTokensCollection = db.collection("userTokens");

//   idList.forEach((id) => {
//     workoutCollection
//       .doc(id)
//       .delete()
//       .then((_) => {
//         console.log(`doc deleted id: ${id}`);
//       });
//     GlucoseCollection.doc(id)
//       .delete()
//       .then((_) => {
//         console.log(`doc deleted id: ${id}`);
//       });
//     MedHistoryCollection.doc(id)
//       .delete()
//       .then((_) => {
//         console.log(`doc deleted id: ${id}`);
//       });
//     MedicationCollection.doc(id)
//       .delete()
//       .then((_) => {
//         console.log(`doc deleted id: ${id}`);
//       });
//     usersCollection
//       .doc(id)
//       .delete()
//       .then((_) => {
//         console.log(`doc deleted id: ${id}`);
//       });
//     weightCollection
//       .doc(id)
//       .delete()
//       .then((_) => {
//         console.log(`doc deleted id: ${id}`);
//       });
//     bolusCollection
//       .doc(id)
//       .delete()
//       .then((_) => {
//         console.log(`doc deleted id: ${id}`);
//       });
//     userTokensCollection
//       .doc(id)
//       .delete()
//       .then((_) => {
//         console.log(`doc deleted id: ${id}`);
//       });
//   });
// }

// Calculate the number of milliseconds until the next minute
const now = new Date();
const millisUntilNextMinute =
  (60 - now.getSeconds()) * 1000 - now.getMilliseconds();

// Schedule the first call to the function
setTimeout(() => {
  getDataFromFirestore();

  // Schedule subsequent calls to the function every minute
  setInterval(getDataFromFirestore, 60 * 1000);
}, millisUntilNextMinute);

// Get a reference to the Firestore database
async function getDataFromFirestore() {
  const db = admin.firestore();

  // Get data from medication collection
  const collectionRef = db.collection("medication");

  const snapshot = await collectionRef.get();

  console.log("======== Snapshot ========");
  console.log(snapshot);
  console.log("==========================");

  snapshot.forEach(async (doc) => {
    console.log(`======== Document ID: ${doc.id}========`);
    console.log(doc);
    console.log("==========================");

    const user_id = doc.id; // saving user id to get his device token
    const data = doc.data();
    const userMedicationRecords = data.medication_records; // saving user's medication data
    const medication_and_reminders = {};
    userMedicationRecords.forEach((record) => {
      console.log("======== Record ========");
      console.log(record);
      console.log("========================");

      medication_and_reminders[record.medicationName] = {};

      record.reminders.forEach(async (reminder) => {
        reminder.Time = createTimeObject(reminder.Time);

        console.log("======== Reminder ========");
        console.log(reminder);
        console.log("========================");

        let day = covertDayNameToNumber(reminder.Day);
        let time = reminder.Time;
        let numOfPills = record.numOfPills;

        let currentTime = new Date();

        try {
          console.log(
            `Current Time: ${currentTime.getHours()}:${currentTime.getMinutes()}:${currentTime.getSeconds()}`
          );
          if (compareTimeToCurrent(time) == 0 && currentTime.getDay() == day) {
            console.log("The medication reminder time is now");

            let userToken = await getUserToken(user_id);

            let notificationMessage = `Time take your medication: ${record.medicationName} - ${numOfPills} Pill(s)`;
            console.log(notificationMessage);
            sendScheduledNotification(userToken, notificationMessage);
          } else {
            console.log("The medication reminder time is not now");
          }
        } catch (err) {
          console.log(
            `Something went wrong on building and sending the notification for user id : ${user_id}`
          );
        }
      });
    });
  });
}

async function getUserToken(userId) {
  const db = admin.firestore();
  const userTokensDocRef = db.collection("userTokens").doc(userId);
  const userTokensDoc = await userTokensDocRef.get();
  if (userTokensDoc.exists) {
    return userTokensDoc.data().token;
  } else {
    console.log("User tokens not found for document ID:", doc.id);
  }
}

function createTimeObject(timeString) {
  try {
    const [hours, minutes] = timeString.split(":");
    const dateObj = new Date();

    dateObj.setHours(parseInt(hours));
    dateObj.setMinutes(parseInt(minutes));
    return {
      hours: dateObj.getHours(),
      minutes: dateObj.getMinutes(),
    };
  } catch (e) {
    console.log(`Error creating time object from:`);
    console.log(timeString);
  }
}

function covertDayNameToNumber(day) {
  switch (day) {
    case "Sunday":
      return 0;
    case "Monday":
      return 1;
    case "Tuesday":
      return 2;
    case "Wednesday":
      return 3;
    case "Thursday":
      return 4;
    case "Friday":
      return 5;
    case "Saturday":
      return 6;
  }
}

function compareTimeToCurrent(timeObject) {
  const currentDateObj = new Date();
  const currentHours = currentDateObj.getHours();
  const currentMinutes = currentDateObj.getMinutes();
  if (timeObject.hours > currentHours) {
    return 1; // Time is later than current time
  } else if (timeObject.hours < currentHours) {
    return -1; // Time is earlier than current time
  } else {
    if (timeObject.minutes > currentMinutes) {
      return 1;
    } else if (timeObject.minutes < currentMinutes) {
      return -1;
    } else {
      return 0; // Time is the same as current time
    }
  }
}

async function sendScheduledNotification(userToken, notificationMessage) {
  const notification_options = {
    priority: "high",
    timeToLive: 60 * 60 * 24,
  };
  const message = {
    notification: {
      title: "Gluc-Safe - Medication Reminder",
      body: notificationMessage,
      alert: "true",
      channel_id: "gluc-safe-notification",
      android_channel_id: "gluc-safe-notification",
    },
  };

  admin
    .messaging()
    .sendToDevice(userToken, message, notification_options)
    .then((response) => {
      console.log("Successfully sent message:", response);
    })
    .catch((error) => {
      console.log("Error sending message:", error);
    });
}
