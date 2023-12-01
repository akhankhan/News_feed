class Post {
  String? id;
  String? title;
  String? image;
  String? dateTime;
  String? userName;
  String? userPicture;
  bool? isLiked;
  String? uid;
  int? totalLikes;

  Post({
    this.id,
    this.uid,
    this.title,
    this.image,
    this.dateTime,
    this.userName,
    this.userPicture,
    this.isLiked,
    this.totalLikes,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json["id"],
      title: json['title'],
      dateTime: json['dateTime'],
      image: json['image'],
      uid: json['uid'],
      userName: json['userName'],
      userPicture: json['userPicture'],
      isLiked: false,
      totalLikes: (json['likes'] as List<dynamic>?)?.length ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dateTime': dateTime,
      'image': image,
      'uid': uid,
      'userName': userName,
      'userPicture': userPicture,
    };
  }
}
