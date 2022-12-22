import 'package:ceiba_flutter/ui/viewModel/listScreenViewModel.dart';
import 'package:ceiba_flutter/utils/db/tableSelector.dart';
import 'package:ceiba_flutter/utils/db/tableSelectorPost.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';

final getIt = GetIt.instance;

void setup() {
   getIt.. registerFactory<TableSelector>(() => TableSelector());
   getIt.. registerFactory<TableSelectorPosts>(() => TableSelectorPosts());
   getIt.. registerFactory<ListScreenViewModel>(() => ListScreenViewModel());
}