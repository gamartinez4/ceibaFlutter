import 'dart:convert';
import 'dart:io';
import 'package:ceiba_flutter/constants/states.dart';
import 'package:ceiba_flutter/ui/layers/paginationMobile.dart';
import 'package:ceiba_flutter/ui/layers/paginationWebDesktop.dart';
import 'package:ceiba_flutter/ui/viewModel/listScreenViewModel.dart';
import 'package:ceiba_flutter/utils/db/tableSelector.dart';
import 'package:ceiba_flutter/utils/db/tableSelectorPost.dart';
import 'package:ceiba_flutter/utils/sqlDb.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ceiba_flutter/utils/extension.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../injection.dart';
import '../models/dbModels/postDb.dart';
import '../models/dbModels/userDb.dart';
import '../models/post.dart';
import '../models/user.dart';
import 'myScaffold.dart';

//final queryText = StateProvider<String>((ref) => "");
//final users = StateProvider<List<User>>((ref) => []);


class ListScreen extends HookConsumerWidget{

  final templateDb = getIt<TableSelector>();
  final templateDbPosts = getIt<TableSelectorPosts>();
  final viewModel = ListScreenViewModel();


  List<Post> posts = [];
  ListScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context, WidgetRef ref) { 
     
    return MyScaffold(
      body:Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFFFBFBFB),
        title: 
          TextField(
            onChanged: (value){
              queryText = value;
              viewModel.filterText(queryText, ref);
              },
            decoration: const InputDecoration(icon:Icon(Icons.search))
          ),  
      ),
      body:  kIsWeb || Platform.isWindows || Platform.isLinux? PaginationWebDesktop(): PaginationMobile()
    )
    );
  }
}