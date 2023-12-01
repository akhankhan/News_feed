import 'package:firestore_ref/firestore_ref.dart';

class CommentModel {
  String? name;
  String? uid;
  String? comment;
  String? userProfile;
  String? dateTime;
  String? id;
  String? postId;
  dynamic timestamp;
  String? commentId;

  CommentModel({
    this.name,
    this.uid,
    this.comment,
    this.userProfile,
    this.dateTime,
    this.id,
    this.postId,
    this.timestamp,
    this.commentId,
  });

  factory CommentModel.fromJson(json) {
    return CommentModel(
      name: json['name'],
      uid: json['uid'],
      comment: json['comment'],
      dateTime: json['dateTime'],
      id: json['id'],
      userProfile: json['userProfile'],
      postId: json['postId'],
      timestamp: json['timestamp'],
      commentId: json['commentId'] ?? '',
    );
  }

  Map<String, dynamic> toJson([bool? isComment]) {
    return {
      'name': name,
      'uid': uid,
      'userProfile': userProfile,
      'comment': comment,
      'dateTime': dateTime,
      'id': id,
      'postId': postId,
      'timestamp': FieldValue.serverTimestamp(),
      if (isComment != null && isComment) 'commentId': commentId,
    };
  }
}
