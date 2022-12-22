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
      return ModalRoute.of(context)!.settings.arguments! as List<Post> ;
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
                        height:220,
                        padding: const EdgeInsets.fromLTRB(30.0, 0, 30, 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: const Offset(0, 3)),
                              ],
                            )  ,
                        child: 
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children:
                            [
                              Text(
                                data[index].title,
                                 style: const TextStyle(fontSize: 18, color: Color(0Xff285e2f))
                                ),
                              const SizedBox(height:15),
                              Text(data[index].body)
                              ]
                            ),
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


