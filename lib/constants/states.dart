import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/post.dart';
import '../models/user.dart';

final usersFiltered = StateProvider<List<User>>((ref) => []);
final refreshController = StateProvider((ref)=>RefreshController(initialRefresh: true));
List<Post> posts = [];
String queryText = "";
List<User> users = [];