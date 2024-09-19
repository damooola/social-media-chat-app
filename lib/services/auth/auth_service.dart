import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
//firebase instance
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

//signin/login
  Future<UserCredential> logIn(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      //save user credentilas in separate doc if it doesn't already exist
      // sets allows to manually set a doc with a specific ID, create or overwrite
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {"uid": userCredential.user!.uid, "email": userCredential.user!.email},
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

//sign up
  Future<UserCredential> signUp(String email, password) async {
    try {
      // create new user
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      //save user in separate doc
      _firestore.collection("Users").doc(userCredential.user!.uid).set(
        {"uid": userCredential.user!.uid, "email": email},
      );

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

// sign out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }
}
