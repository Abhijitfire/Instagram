import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:instagram/models/post.dart';
import 'package:instagram/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirebaseMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // upload post
  Future<String> uploadPost(
    String uid,
    String description,
    Uint8List file,
    String username,
    String profImage,
  ) async {
    String res = "some err occ";

    try {
      String photoUrl = await StorageMethod()
          .uploadImageToFirebaseStorage("posts", file, true);

      String postId = const Uuid().v1();

      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        datePublished: DateTime.now(),
        postUrl: photoUrl,
        profImage: profImage,
        postId: postId,
        likes: [],
      );
      _firestore.collection('posts').doc(postId).set(post.toJson());
      res = "success";
    } catch (e) {
      res = e.toString();
    }
    return res;
  }

  Future<void> likePost(String postId, String uid, List likes) async {
    try {
      if (likes.contains(uid)) {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([uid]),
        });
      } else {
        await _firestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([uid]),
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occured";
    try {
      if (text.isNotEmpty) {
        String commentId = const Uuid().v1();
        await _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          "profilePic": profilePic,
          "username": name,
          "uid": uid,
          "text": text,
          "commentId": commentId,
          "datePublished": DateTime.now(),
        });
        res = "success";
      } else {
        print('text is empty');
        res = "Please enter a comment";
      }
    } catch (e) {
      print(e.toString());
      res = e.toString();
    }
    return res;
  }

  // delete post------------------------

  Future<void> deletePost(String postId) async {
    try {
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> followUsers(
    String uid,
    String followId,
  ) async {
    try {
      DocumentSnapshot snap =
          await _firestore.collection('users').doc(uid).get();
      List following = (snap.data()! as dynamic)['following'];

      if (following.contains(followId)) {
        await _firestore.collection("users").doc(followId).update({
          'followers': FieldValue.arrayRemove([uid])
        });
        await _firestore.collection("users").doc(followId).update({
          'following': FieldValue.arrayRemove([followId])
        });
      } else {
        await _firestore.collection("users").doc(followId).update({
          'followers': FieldValue.arrayUnion([uid])
        });
        await _firestore.collection("users").doc(followId).update({
          'followers': FieldValue.arrayUnion([followId])
        });
      }
    } catch (e) {}
  }
}
