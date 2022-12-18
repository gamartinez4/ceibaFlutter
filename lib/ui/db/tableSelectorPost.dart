import '../../models/dbModels/postDb.dart';

class TableSelectorPosts{

  String dataBaseName() => "posts.db";
  String dataBaseAlias() => "posts";
  String dataBaseCreateQuery() => "CREATE TABLE posts(id INTEGER PRIMARY KEY, userId INTEGER, title TEXT, body TEXT)";
  PostDb constructor(Map<String,dynamic> map)=>
      PostDb(
        userId: map["userId"], 
        id: map["id"], 
        title: map["title"],
        body: map["body"]
      );
}