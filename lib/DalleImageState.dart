import 'dart:io';
import 'package:accessible_ai/dalle.dart';
import 'package:accessible_ai/main.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class DalleImage with ChangeNotifier{

  String _filepath = '';
  String _url = defaultImage;
      //'https://upload.wikimedia.org/wikipedia/commons/thumb/7/77/Google_Images_2015_logo.svg/1200px-Google_Images_2015_logo.svg.png';
  String get filepath => _filepath;
  String get url => _url;
  File filename = File('logo.png');
  Future<void> ChangePath(String newpath, String newurl) async {
    _filepath = newpath;
    var encoded = Uri.parse(newurl).toString();
    _url = encoded.substring(0,encoded.length - 3);

    Directory dir = await getApplicationDocumentsDirectory();
    String pathName = p.join(dir.path, '$_filepath.png');
    filename = File(pathName);
    SaveDalleImageInfo(_url);
    notifyListeners();
  }
}