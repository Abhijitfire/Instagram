import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:instagram/models/user.dart' as model;

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// user details
  Future<model.User> getUserDetails() async {
    User? currentUser = _auth.currentUser;

    DocumentSnapshot snap =
        await _firestore.collection("users").doc(currentUser!.uid).get();

    return model.User.fromSnap(snap);
  }

  // Signup User
  Future<String> signupUser({
    required String email,
    required String password,
    required String username,
    required String bio,
    required Uint8List file,
  }) async {
    String res = "Some error Occured";

    try {
      if (email.isNotEmpty ||
          password.isNotEmpty ||
          username.isNotEmpty ||
          bio.isNotEmpty ||
          file != null) {
        // register user
        UserCredential cred = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        print(cred.user!.uid);

        String photoUrl = await StorageMethod()
            .uploadImageToFirebaseStorage("profilePics", file, false);

        // add user to database

        model.User _user = model.User(
          username: username,
          uid: cred.user!.uid,
          email: email,
          bio: bio,
          photoUrl: photoUrl,
          followers: [],
          following: [],
        );

        _firestore.collection('users').doc(cred.user!.uid).set(
              _user.toJson(),
            );
        res = 'SUCCESS';
      } else {
        res = "Please enter all fields";
      }
      // } on FirebaseAuthException catch (err) {
      //   if (err.code == "invalid-email") {
      //     res = 'Enter a valid email';
      //   } else if (err.code == 'weak-password') {
      //     res = 'password should be more than 6 character';
      //   }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  // logging users
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";

    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter email and password";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
