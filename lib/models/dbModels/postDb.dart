import 'package:flutter/gestures.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../user.dart';

class PostDb{
  int userId;
  int id;
  String title;
  String body;

  PostDb({
    required this.userId,
    required this.id,
    required this.title,
    required this.body,
  });

  Map<String,dynamic> toMap(){
    return {
      "userId": userId,
      "id": id,
      "title": title,
      "body": body
    };
  }

  @override
  String toString(){
    return 'PostDb{userId: $userId, id: $id, title: $title, body: $body}';
  }
}