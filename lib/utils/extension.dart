

import 'package:ceiba_flutter/models/dbModels/postDb.dart';
import 'package:ceiba_flutter/models/dbModels/userDb.dart';

import '../models/post.dart';
import '../models/user.dart';

extension NumberParsing on List<User> {
  List<User> addElement(List<User> toAdd){
    List<User> list = List<User>.from(map((x) => x) );
    list.addAll(toAdd);
    return list;
  }
}

extension dataBaseModelToUser on UserDb{
  User toUser() => User(id: this.id, name: this.name, phone: this.phone, email: this.email);
}

extension UserModelTodataBase on User{
  UserDb toUserDb() => UserDb(id: this.id, name: this.name, phone: this.phone, email: this.email);
}

extension  dataBaseModelToPost on PostDb{
  Post toPost() => Post(userId: this.userId, id: this.id, title: this.title, body: this.body);
}

extension PostModelTodataBase on Post{
  PostDb toPostDb() => PostDb(userId: this.userId, id: this.id, title: this.title, body: this.body);
}