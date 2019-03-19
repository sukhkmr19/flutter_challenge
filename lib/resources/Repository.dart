import 'package:flutter_app_challenge/models/UserData.dart';
import 'package:flutter_app_challenge/resources/DataProvider.dart';

class Repository {
  final userDataProvider = DataProvider();

  Future<UserData> fetchAllData() => userDataProvider.fetchAllUserList();
}
