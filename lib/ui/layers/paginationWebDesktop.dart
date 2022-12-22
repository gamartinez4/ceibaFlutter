
import 'dart:convert';
import 'dart:io';
import 'package:ceiba_flutter/models/user.dart';
import 'package:ceiba_flutter/ui/listScreen.dart';
import 'package:ceiba_flutter/utils/db/tableSelector.dart';
import 'package:ceiba_flutter/utils/db/tableSelectorPost.dart';
import 'package:ceiba_flutter/utils/sqlDb.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ceiba_flutter/utils/extension.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../constants/states.dart';
import '../../injection.dart';
import '../../models/dbModels/postDb.dart';
import '../../models/post.dart';
import '../ListScreen.dart';
import '../viewModel/listScreenViewModel.dart';


class PaginationWebDesktop extends HookConsumerWidget {

  final viewModel = getIt<ListScreenViewModel>();

  PaginationWebDesktop({Key? key}) : super(key: key);


  @override
    Widget build(BuildContext context, WidgetRef ref) {

      return
        Center(
          child: FutureBuilder <List<User>>(
            future: viewModel.requestUserWeb(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<User>? data = snapshot.data;
                return 
                  ListView.separated(
                    itemCount: data!.length,
                    separatorBuilder: (context, index) => const SizedBox.shrink(),
                    itemBuilder: (BuildContext context, int index) {
                    final user = data[index];
                    return Container(
                        color: const Color(0XFFFBFBFB),
                        padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        
                        child: GestureDetector(
                              onTap: (){    
                                viewModel.requestPosts().then((_) => {
                                  Navigator.pushNamed(
                                      context, "/details", 
                                      arguments: List<Post>.from(posts.where((element) => element.userId == user.id))
                                    )
                                  }
                                );
                               
                              },
                              child:  Expanded(child: Container(
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
                  }
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return const CircularProgressIndicator();
            },
          )
        );
    }
  }
  