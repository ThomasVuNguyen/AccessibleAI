import 'dart:convert';

import 'package:dartssh2/dartssh2.dart';

Future<void> Setup(String hostname, String username, String password) async{
  final client = SSHClient(
      await SSHSocket.connect(hostname, 22),
      username: username,
      onPasswordRequest: () => password
  );
  final BreakPythonEnv = await client.run('echo $password | sudo rm /usr/python3.11/EXTERNALLY-MANAGED', stderr: false);
  final DownloadLibrary = await client.run('pip3 install openai && pip3 install pathlib', stderr: false);
  final clone = await client.run('git clone https://github.com/ThomasVuNguyen/openaiprojects.git', stderr: false);
  client.close();
  print(utf8.decode(BreakPythonEnv));
  print(utf8.decode(DownloadLibrary));
  print(utf8.decode(clone));
}
