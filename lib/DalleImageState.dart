import 'package:flutter/foundation.dart';

class DalleImage with ChangeNotifier{
  String _filepath = '';
  String _url = '';
  String get filepath => _filepath;
  String get url => _url;

  void ChangePath(String newpath, String newurl){
    _filepath = newpath;
    _url = newurl;
    notifyListeners();
  }
}