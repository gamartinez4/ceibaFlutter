import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ceiba_flutter/utils/extension.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../models/user.dart';
import 'myScaffold.dart';

final queryText = StateProvider<String>((ref) => "");


class ListScreen extends HookConsumerWidget{
  ListScreen({Key? key}) : super(key: key);

  var users = useState<List<User>>([]);
  var usersFiltered = useState<List<User>>([]);

  int start = 0;
  final RefreshController refreshController = RefreshController(initialRefresh: true);

  Future<bool> getUsersData(WidgetRef ref,{bool isRefresh = false}) async {
    if (isRefresh) {
      start = 0;
    } else {
      if (start > 10) {
        refreshController.loadNoData();
        return false;
      }
    }

    final response = await http.get(
      Uri.parse("https://jsonplaceholder.typicode.com/users?_start=$start&_limit=3")
      );

    if (response.statusCode == 200) {
      final result = List<User>.from(json.decode(response.body).map((x ) => User.fromJson(x) ));
      if (isRefresh) {
        users.value = result;
      }else{
        users.value = users.value.addElement(result);
        start=start+3;
      }
      return true;
    } else {
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
          final result = await getUsersData(ref,isRefresh: true);
          if (result) {
            refreshController.refreshCompleted();
          } else {
            refreshController.refreshFailed();
          }
        },
        onLoading: () async {
          final result = await getUsersData(ref);
          if (result) {
            refreshController.loadComplete();
          } else {
            refreshController.loadFailed();
          }
        },
        //Navigator.pushNamed(context, "/details", arguments: user.id);
        child: ListView.separated(
          itemBuilder: (context, index) {
            final user = usersFiltered.value[index];
            return 
            Container(
              child :Container(
                color: Color(0XFFFBFBFB),
                padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                
                child: GestureDetector(
                      onTap: () => Navigator.pushNamed(context, "/details", arguments: user.id),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 3)),
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
                                                style: TextStyle(fontSize: 18, color: Color(0Xff285e2f)),
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