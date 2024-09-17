import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sm_chatapp/models/message.dart';

class ChatService {
// firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  //fireabse auth instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
// get user stream from firestore
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    //access the Users colection, get a stream of snapshots, then map each snapshot
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

// send message
  Future<void> sendMessage(String receiverID, message) async {
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
    //
  }

  // get message

  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // cpnstruct a charoomId for the two users
    List<String> ids = [userID, otherUserID];
    //sort to ensure chatrrom id is same for any two people
    ids.sort();

    String chatRoomID = ids.join("_");
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("timestamp", descending: false)
        .snapshots();
  }
}
