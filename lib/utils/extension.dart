

import '../models/user.dart';

extension NumberParsing on List<User> {
  List<User> addElement(List<User> toAdd){
    List<User> list = List<User>.from(map((x) => x) );
    list.addAll(toAdd);
    return list;
  }
}