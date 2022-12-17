// ignore: file_names
import 'package:ceiba_flutter/models/dbModels/postDb.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/post.dart';
import 'dart:convert';

import 'myScaffold.dart';

class DetailsScreen extends StatelessWidget{
  
  const DetailsScreen({Key? key}) : super(key: key);

  Future <List<Post>> fetchData(BuildContext context) async {
    //print(ModalRoute.of(context)!.settings.arguments! );
    //  List<Post> postsDb = List<Post>.from(ModalRoute.of(context)!.settings.arguments.);
      return [];
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
        body: Center(
          child: FutureBuilder <List<Post>>(
            future: fetchData(context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Post>? data = snapshot.data;
                return 
                  ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return 
                      Container(
                        alignment: Alignment.center,
                        child: Text(data[index].body),
                        height: 150,
                        padding: const EdgeInsets.fromLTRB(20.0, 0, 0, 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 3)),
                              ],
                            )  ,
                      );
                  }
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default show a loading spinner.
              return const CircularProgressIndicator();
            },
          ),
        ),
      );
  }
}


