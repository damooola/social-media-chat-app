import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sm_chatapp/models/message.dart';

class ChatService extends ChangeNotifier {
  // firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // fireabse auth instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // get user stream from firestore
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    // access the Users colection, get a stream of snapshots, then map each snapshot
    // .map allows us to tansform data of any type to a specific type we want
    return _firestore.collection("Users").snapshots().map((snapshot) {
      // for each snapshot, map the document to a list of user data
      return snapshot.docs.map((doc) {
        //go through each individual user
        final user = doc.data();
        //return user
        return user;
      }).toList();
    });
  }

  // get userstream except blocked user
  Stream<List<Map<String, dynamic>>> getUsersStreamExcludingBlocked() {
    final currentUser = _firebaseAuth.currentUser;
    return _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .snapshots()
        // async map allows to make async queries inside the map function
        .asyncMap((snapshot) async {
      final blockedUserIDs = snapshot.docs.map((doc) => doc.id).toList();
      //get all users
      final userSnapShot = await _firestore.collection("Users").get();

      // return as a stream list
      return userSnapShot.docs
          .where((doc) =>
              doc.data()["email"] != currentUser.email &&
              !blockedUserIDs.contains(doc.id))
          .map(
            (doc) => doc.data(),
          )
          .toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverID, String message) async {
    // get currrent user info
    final currrentUserID = _firebaseAuth.currentUser!.uid;
    final currrentUserEmail = _firebaseAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    //create a new message
    Message newMessage = Message(
        senderID: currrentUserID,
        senderEmail: currrentUserEmail,
        receiverID: receiverID,
        message: message,
        timestamp: timestamp);

    //construct chat room id for the two users (sorted)
    List<String> ids = [currrentUserID, receiverID];
    ids.sort(); // ensures the chatroom id is same for any two people
    String chatRoomID = ids.join("_");

    //add new message to database
    _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(newMessage.toMap());
  }

  // get message
  Stream<QuerySnapshot> getMessages(String userID, String otherUserID) {
    // cpnstruct a charoomId for the two users
    List<String> ids = [userID, otherUserID];
    //sort to ensure chatrrom id is same for any two people
    ids.sort(); // join the two ids with an underscore to create a new unique chat room id
    String chatRoomID = ids.join("_");
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }

  // report user
  Future<void> reportUser(String messageID, String userID) async {
    final currentUser = _firebaseAuth.currentUser;
    final report = {
      "reported by": currentUser!.uid,
      "messageID": messageID,
      "messageOwnerID": userID,
      "timestamp": FieldValue.serverTimestamp(),
    };
    await _firestore.collection("Reports").add(report);
  }

  // block user
  Future<void> blockUser(String userID) async {
    final currentUser = _firebaseAuth.currentUser;
    await _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .doc(userID)
        .set({});
    notifyListeners();
  }

  // unblock user
  Future<void> unblockUser(String blockedUserID) async {
    final currentUser = _firebaseAuth.currentUser;
    await _firestore
        .collection("Users")
        .doc(currentUser!.uid)
        .collection("BlockedUsers")
        .doc(blockedUserID)
        .delete();
  }

  // get blocked list
  Stream<List<Map<String, dynamic>>> getBlockedUserstream(String userID) {
    return _firestore
        .collection("Users")
        .doc(userID)
        .collection("BlockedUsers")
        .snapshots()
        .asyncMap(
      (snapshot) async {
        // get a list of blocked user IDs
        final blockedUserIDs = snapshot.docs.map((doc) => doc.id).toList();
        // gets all blocked users with their given ids using the uers collection
        //future.wait allows for parallel execution
        final blockedUserDocs = await Future.wait(blockedUserIDs
            .map((id) => _firestore.collection("Users").doc(id).get()));

        return blockedUserDocs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList();
      },
    );
  }
}
