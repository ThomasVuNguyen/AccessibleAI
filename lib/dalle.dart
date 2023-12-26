import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> RunDalle(String hostname, String username, String password, String prompt) async {
  final client = SSHClient(
  await SSHSocket.connect(hostname, 22),
      username: username,
    onPasswordRequest: () => password
  );
  prompt = "'$prompt'";
  Map<String, String?> DalleSetting = await GetDalleSetting();
  print('cd openaiprojects && python3 dalle.py ${'$prompt'} ${DalleSetting['model']}  ${DalleSetting['size']} ${DalleSetting['quality']} ${DalleSetting['n']}');
  final url = await client.run('cd openaiprojects && python3 dalle.py $prompt ${DalleSetting['model']}  ${DalleSetting['size']} ${DalleSetting['quality']} ${DalleSetting['n']}', stderr: false);
  print(utf8.decode(url));
  //client.close();
  return utf8.decode(url).replaceAll(RegExp(r'\r'), "");
}

Future<void> SaveDalleSetting(String model, String size, String quality, String n) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('model', model);
  await prefs.setString('size', size);
  await prefs.setString('quality', quality);
  await prefs.setString('n', n);
  print('setting done');
}

Future<Map<String, String?>> GetDalleSetting() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final model = await prefs.getString('model');
  final size = await prefs.getString('size');
  final quality = await prefs.getString('quality');
  final n = await prefs.getString('n');
  print('setting retrieved');
  return {'model':model, 'size': size, 'quality': quality, 'n': n};
}

Future<void> SaveDalleImageInfo(String url) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('recenturl', url);
}

Future<String?> GetDalleImageInfo() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String? recenturl =  await prefs.getString('hostname');
  return recenturl;
}