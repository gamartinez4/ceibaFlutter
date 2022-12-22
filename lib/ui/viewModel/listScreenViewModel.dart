import 'dart:convert';
import 'dart:io';
import 'package:ceiba_flutter/constants/states.dart';
import 'package:ceiba_flutter/utils/db/tableSelector.dart';
import 'package:ceiba_flutter/utils/db/tableSelectorPost.dart';
import 'package:ceiba_flutter/utils/sqlDb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ceiba_flutter/utils/extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../injection.dart';
import '../../models/dbModels/postDb.dart';
import '../../models/dbModels/userDb.dart';
import '../../models/post.dart';
import '../../models/user.dart';



class ListScreenViewModel{

  Future<void> requestPosts() async{
    try{
        final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts/"));
        if (response.statusCode == 200){
          posts = List<Post>.from(json.decode(response.body).map( (x) => Post.fromJson(x) ));
          if(Platform.isAndroid || Platform.isIOS){
            await SqlDb.insertAll(List<PostDb>.from( posts.map((x) => x.toPostDb()) ),template: getIt<TableSelectorPosts>());
          }
        }
        else{
          print("respuesta incorrecta");
        }
      }catch(e){
       print(e.toString());
      }
    }

    Future<List<User>> requestUserWeb() async {
      try{
      final response = await http.get(
        Uri.parse("https://jsonplaceholder.typicode.com/users/")
          );
        return response.statusCode == 200? List<User>.from(json.decode(response.body).map( (x) => User.fromJson(x) )): [];
      }catch(e){
        return [];
      }
    }

  Future<bool> requestUsersData(WidgetRef ref, {bool isRefresh = false}) async {
    var usersList = users;
    if (isRefresh) {
      usersList = [];
    } else if (usersList.length > 20) {
        ref.read(refreshController).loadNoData();
        return false;
    }
    try{
     // int a = int.parse("dj");
      final response = await http.get(
        Uri.parse("https://jsonplaceholder.typicode.com/users?_start=${usersList.length}&_limit=3")
        );
      if (response.statusCode == 200) {
        if (Platform.isAndroid || Platform.isIOS){
          final resultUser = List<User>.from(json.decode(response.body).map( (x) => User.fromJson(x) ));
          usersList = isRefresh? resultUser: usersList.addElement(resultUser);
          await SqlDb.insertAll(List<UserDb>.from(resultUser.map((x) => x.toUserDb() )),template: getIt<TableSelector>());
        }else{
          usersList = List<User>.from(json.decode(response.body));
        }
        requestPosts();
        users = usersList;
        filterText(queryText, ref);
        return true;
      } 
      return false;
    }catch(e){
      if (Platform.isAndroid || Platform.isIOS){
        Iterable<UserDb> resultDb = [];
        resultDb = List<UserDb>.from(( await SqlDb.dbFullQuery(template: getIt<TableSelector>()) )).where((j) => j.id>usersList.length && j.id<=usersList.length+3);
        List<User> result = List<User>.from(resultDb.map((e) => e.toUser()));
        if(result.isEmpty)return false;
        usersList = isRefresh? result: usersList.addElement(result);
        users = usersList;
        filterText(queryText, ref);
        return true;
      }
      return false;
    }
  }


  filterText(String queryText, WidgetRef ref){
    ref.read(usersFiltered.notifier).state = (queryText.isEmpty || queryText == "")? users: 
      List<User>.from(users.where((element) => element.name.contains(queryText)));
  }

}