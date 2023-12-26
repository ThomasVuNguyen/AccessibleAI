import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> SaveCredentials(String hostname, String username, String password) async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('hostname', hostname);
  await prefs.setString('username', username);
  await prefs.setString('password', password);
  print('done');
}

Future<Map<String, String?>> GetCredentials() async{
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  Map<String, String?> Credentials = {};
  final String? hostname = prefs.getString('hostname');
  Credentials['hostname'] = hostname;
  final String? username = prefs.getString('username');
  Credentials['username'] = username;
  final String? password = prefs.getString('password');
  Credentials['password'] = password;
  print(Credentials.toString());
  return Credentials;
}

Future<void> SaveAPI(String hostname, String username, String password, String api) async{
  final client = SSHClient(
      await SSHSocket.connect(hostname, 22),
      username: username,
      onPasswordRequest: () => password
  );
  final url = await client.run('cd openaiprojects && echo $password | sudo echo $api > API.txt', stderr: false);
  client.close();
  print(utf8.decode(url));
}