import '../../models/dbModels/postDb.dart';

class TableSelectorPosts{

  String dataBaseName() => "posts.db";
  String dataBaseAlias() => "posts";
  String dataBaseCreateQuery() => "CREATE TABLE posts(userId INTEGER PRIMARY KEY, id INTEGER, title TEXT, body TEXT)";
  PostDb constructor(Map<String,dynamic> map)=>
      PostDb(
        userId: map["userId"], 
        id: map["id"], 
        title: map["title"],
        body: map["body"]
      );
}