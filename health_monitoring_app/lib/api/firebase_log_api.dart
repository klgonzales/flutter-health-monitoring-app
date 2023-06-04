import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseLogAPI {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> addUser(Map<String, dynamic> user) async {
    try {
      final docRef = await db.collection("users").add(user);
      await db.collection("logs").doc(docRef.id).update({'id': docRef.id});

      return "New user was added!";
    } on FirebaseException catch (e) {
      return "Failed with error '${e.code}: ${e.message}";
    }
  }

  Stream<QuerySnapshot> getUser(userID) {
    return db.collection("logs").where("uid", isEqualTo: userID).snapshots();
  }

//collects all logs
  Stream<QuerySnapshot> getAlllogs() {
    return db.collection("logs").snapshots();
  }

  // Stream<QuerySnapshot> getUnderMonitoringlogs() {
  //   return db
  //       .collection("logs")
  //       .where("isUnderMonitoring", isEqualTo: true)
  //       .snapshots();
  // }

  // Stream<QuerySnapshot> getAllUsers() {
  //   return db
  //       .collection("log")
  //       .where("usertype", isEqualTo: "Student")
  //       .snapshots();
  // }

  // Future<String> editUnderMonitoringStatus(id, bool status) async {
  //   print(id);
  //   try {
  //     await db
  //         .collection("log")
  //         .doc(id)
  //         .update({"isUnderMonitoring": status});
  //     return "Successfully edited monitoring status!";
  //   } on FirebaseException catch (e) {
  //     return "Failed with error '${e.code}: ${e.message}";
  //   }
  // }

  // Future<String> editQuarantineStatus(id, bool status) async {
  //   print(id);
  //   try {
  //     await db.collection("users").doc(id).update({"isQuarantined": status});
  //     return "Successfully edited quarantine status!";
  //   } on FirebaseException catch (e) {
  //     return "Failed with error '${e.code}: ${e.message}";
  //   }
  // }
}