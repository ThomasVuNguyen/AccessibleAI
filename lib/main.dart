import 'package:accessible_ai/DalleImageState.dart';
import 'package:accessible_ai/setup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'credentials.dart';
import 'homepage.dart';
String defaultImage = 'https://github.com/ThomasVuNguyen/AccessibleAI/blob/main/assets/logo.png?raw=true';
Future<void> main() async {
  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create:(_) => DalleImage())
  ],
          child: MyApp()));

  Map<String, String?> Credentials = await GetCredentials();
  Setup(
    Credentials['hostname']!,
    Credentials['username']!,
    Credentials['password']!
  );

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}


