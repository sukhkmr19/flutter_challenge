import 'package:flutter/services.dart';

Future<String> parseJsonFromAssets(String assetsPath) async {
  return await rootBundle.loadString(assetsPath);
}
