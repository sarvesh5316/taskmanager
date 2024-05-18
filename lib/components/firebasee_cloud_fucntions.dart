// const functions = require('firebase-functions');
// const admin = require('firebase-admin');

// admin.initializeApp();

// exports.sendNotificationBeforeDeadline = functions.firestore
//   .document('tasks/{taskId}')
//   .onCreate(async (snapshot, context) => {
//     const taskData = snapshot.data();
//     const deadline = taskData.deadline.toDate(); // Convert Firestore timestamp to JavaScript Date

//     // Calculate notification time (e.g., 1 hour before deadline)
//     const notificationTime = new Date(deadline.getTime() - (1 * 60 * 60 * 1000)); // 1 hour before deadline

//     // Send notification
//     const payload = {
//       notification: {
//         title: 'Deadline approaching',
//         body: taskData.title + ' is due soon!',
//       },
//     };

//     const notificationOptions = {
//       time: notificationTime,
//     };

//     try {
//       await admin.messaging().sendToTopic('deadline_notifications', payload, notificationOptions);
//     } catch (error) {
//       console.error('Error sending notification:', error);
//     }
//   });
