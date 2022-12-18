import 'dart:convert';
import 'dart:io';
import 'package:ceiba_flutter/ui/db/tableSelector.dart';
import 'package:ceiba_flutter/ui/db/tableSelectorPost.dart';
import 'package:ceiba_flutter/utils/sqlDb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ceiba_flutter/utils/extension.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/dbModels/postDb.dart';
import '../models/dbModels/userDb.dart';
import '../models/post.dart';
import '../models/user.dart';
import 'myScaffold.dart';


final queryText = StateProvider<String>((ref) => "");


class ListScreen extends HookConsumerWidget{

  var users = useState<List<User>>([]);
  var usersFiltered = useState<List<User>>([]);

  final templateDb = TableSelector();
  final templateDbPosts = TableSelectorPosts();
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  List<Post> posts = [];

  ListScreen({Key? key}) : super(key: key);

  Future<void> getPosts() async{
    try{
        final response = await http.get(Uri.parse("https://jsonplaceholder.typicode.com/posts"));
        if (response.statusCode == 200){
          posts = List<Post>.from(json.decode(response.body).map( (x) => Post.fromJson(x) ));
          if(Platform.isAndroid || Platform.isIOS){
            await SqlDb.insertAll(List<PostDb>.from( posts.map((x) => x.toPostDb()) ),template: templateDbPosts);
          }
        }
        else{
          print("respuesta incorrecta");
        }
      }catch(e){
       print(e.toString());
      }
    }

  Future<bool> getUsersData(WidgetRef ref,{bool isRefresh = false}) async {
    if (isRefresh) {
      users.value = [];
    } else if (users.value.length > 20) {
        refreshController.loadNoData();
        return false;
    }
    try{
     // int a = int.parse("dj");
      final response = await http.get(
        Uri.parse("https://jsonplaceholder.typicode.com/users?_start=${users.value.length}&_limit=3")
        );
      if (response.statusCode == 200) {
        final resultUser = List<User>.from(json.decode(response.body).map( (x) => User.fromJson(x) ));
        if (isRefresh) 
          users.value = resultUser;
        else 
          users.value = users.value.addElement(resultUser);
        if (Platform.isAndroid || Platform.isIOS){
          await SqlDb.insertAll(List<UserDb>.from(resultUser.map((x) => x.toUserDb() )),template: templateDb);
        }
        getPosts();
        return true;
      } 
      return false;
    }catch(e){
      print(e.toString());
      if (Platform.isAndroid || Platform.isIOS){
        Iterable<UserDb> resultDb = [];
        resultDb = List<UserDb>.from(( await SqlDb.dbFullQuery(template: templateDb) )).where((j) => j.id>users.value.length && j.id<=users.value.length+3);
        List<User> result = List<User>.from(resultDb.map((e) => e.toUser()));
        if(result.isEmpty)return false;
        if (isRefresh) 
          users.value = result;
        else 
          users.value = users.value.addElement(result);
        return true;
      }
      return false;
    }
  }


  @override
  Widget build(BuildContext context, WidgetRef ref) {

    users.addListener;{
      var value = ref.read(queryText);
      if(value.isEmpty || value == ""){
        usersFiltered.value = users.value;
      }
      else {
        usersFiltered.value = List<User>.from(users.value.where((element) => element.name.contains(value)));
      }
    }

    return MyScaffold(
      body:Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0XFFFBFBFB),
        title: 
          TextField(
            onChanged: (value) {
              ref.read(queryText.notifier).state = value;
              if(value.isEmpty || value == ""){
                usersFiltered.value = users.value;
              }
              else {
                usersFiltered.value = List<User>.from(users.value.where((element) => element.name.contains(value)));
              }
            },
            decoration: const InputDecoration(icon:Icon(Icons.search))
          ),      
      ),
      body: SmartRefresher(
        controller: refreshController,
        enablePullUp: true,
        onRefresh: () async {
          await getUsersData(ref, isRefresh: true)? 
            refreshController.refreshCompleted(): refreshController.refreshFailed();
        },
        onLoading: () async {
          await getUsersData(ref) ?
            refreshController.loadComplete(): refreshController.loadFailed();
        },
        child: ListView.separated(
          itemBuilder: (context, index) {
            final user = usersFiltered.value[index];
            return 
            Container(
              child :Container(
                color: Color(0XFFFBFBFB),
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                
                child: GestureDetector(
                      onTap: (){
                        if (Platform.isAndroid || Platform.isIOS){
                          SqlDb.dbFullQuery(template: templateDbPosts).then((value){ 
                            Navigator.pushNamed(
                              context, "/details", 
                              arguments: List<Post>.from((List<PostDb>.from(value)).where( (j) => j.userId==user.id ).map((i) => i.toPost()))
                              );
                            }
                          );
                        }else{
                          Navigator.pushNamed(
                              context, "/details", 
                              arguments: List<Post>.from( posts.where( (j) => j.userId==user.id ))
                              );
                        }
                      },
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: const Offset(0, 3)),
                              ],
                            )   ,
                            child: Scaffold(
                                body: Container(
                                  padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                                  child:Stack(
                                    children:[
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children:[
                                          Row(
                                            children:[
                                              Text(
                                                user.name,
                                                style: const TextStyle(fontSize: 18, color: Color(0Xff285e2f)),
                                                )
                                              ]
                                            ),
                                          Row(
                                              children: [
                                                SvgPicture.asset("assets/telephone.svg", height: 25, width: 25,fit: BoxFit.scaleDown),
                                                Text(user.phone),
                                              ],
                                            ),
                                          Row(
                                              children: [
                                                SvgPicture.asset("assets/email.svg", height: 25, width: 25,fit: BoxFit.scaleDown),
                                                Text(user.email),
                                              ]
                                            ) 
                                          ]
                                      ),
                                      const Positioned(
                                        bottom: 20,
                                        right: 20,
                                        child: Text(
                                          "VER PUBLICACIONES",
                                          style: TextStyle(fontSize: 12, color: Color(0Xff285e2f)),
                                          )
                                        )
                                     ]
                                  )  
                              ),
                            )
                          ),
                        //  right: 70, child: Container(height:10, width: 10,),
                       )
                    )
            );
               
          },
          separatorBuilder: (context, index) => const SizedBox.shrink(),
          itemCount: usersFiltered.value.length,
        ),
      ),
    )
    );
  }
  
  }