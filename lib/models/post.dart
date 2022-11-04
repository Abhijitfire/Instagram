import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String description;
  final String uid;
  final String username;
  final String postId;
  final DateTime datePublished;
  final String postUrl;
  final String profImage;
  final likes;

  Post({
    required this.description,
    required this.uid,
    required this.username,
    required this.datePublished,
    required this.postUrl,
    required this.profImage,
    required this.likes,
    required this.postId,
  });

  Map<String, dynamic> toJson() => {
        "username": username,
        "description": description,
        "uid": uid,
        "postId": postId,
        "datePublished": datePublished,
        "profImage": profImage,
        "likes": likes,
        "postUrl": postUrl,
      };

  static Post fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return Post(
      description: snapshot['description'],
      uid: snapshot['uid'],
      username: snapshot['username'],
      postId: snapshot['postId'],
      datePublished: snapshot['datePublished'],
      profImage: snapshot['profImage'],
      postUrl: snapshot['postUrl'],
      likes: snapshot['likes'],
    );
  }
}
