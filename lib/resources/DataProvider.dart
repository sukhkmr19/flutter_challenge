import 'dart:convert';

import 'package:flutter_app_challenge/constants/AppContstant.dart';
import 'package:flutter_app_challenge/models/UserData.dart';
import 'package:flutter_app_challenge/utils/Utility.dart';

class DataProvider {
  var responseData;

  Future<UserData> fetchAllUserList() async {
    var data = await parseJsonFromAssets(model2Json);
    responseData = await jsonDecode(data);
    return UserData.fromJson(responseData);
  }
}
