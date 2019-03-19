import 'dart:async';
import 'dart:io' as Io;

import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';

class SaveFile {
  Future<String> get _localPath async {
    final directory = await getTemporaryDirectory();

    return directory.path;
  }

  Future<Io.File> saveImage(Io.File file) async {
    //retrieve local path for device
    var path = await _localPath;
    Image image = decodeImage(file.readAsBytesSync());

    Image thumbnail = copyResize(image, 200);

    // Save the thumbnail as a PNG.
    return new Io.File('$path/${DateTime.now().toUtc().toIso8601String()}.png')
      ..writeAsBytesSync(encodePng(thumbnail));
  }
}
