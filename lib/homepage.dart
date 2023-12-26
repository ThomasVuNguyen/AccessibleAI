import 'dart:io';

import 'package:accessible_ai/DalleImageState.dart';
import 'package:accessible_ai/credentials.dart';
import 'package:accessible_ai/setting.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:provider/provider.dart';

import 'Display.dart';
import 'dalle.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey containerKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _ScaffoldKey = GlobalKey<ScaffoldState>();
    String prompt = ' A cool looking banana';
    String hostname = ''; String username = ''; String password = '';
    String api = '';
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(_) => DalleImage())
      ],
      child: Scaffold(
        key: _ScaffoldKey,
        appBar: AppBar(
          actions: [IconButton(onPressed: () {
            _ScaffoldKey.currentState?.openEndDrawer();
          }, icon: Icon(Icons.settings),),]
        ),
        endDrawer: Drawer(
           child: Column(
             children: [
               TextField(
                 decoration: InputDecoration(
                     hintText: 'hostname'
                 ),
                 onChanged: (txt){
                   hostname = txt;
                 },
               ),

               TextField(
                 decoration: InputDecoration(
                     hintText: 'username'
                 ),
                 onChanged: (txt){
                   username = txt;
                 },
               ),

               TextField(
                 decoration: InputDecoration(
                     hintText: 'password'
                 ),
                 onChanged: (txt){
                   password = txt;
                 },
               ),

               TextField(
                 decoration: InputDecoration(
                   hintText: 'API key'
                 ),
                 onChanged: (txt){
                   api = txt;
                 },
               ),
               TextButton(onPressed: () async {
                 if(hostname!='' && username!='' && password !=''){
                   await SaveCredentials(hostname, username, password);
                 }
                 Map<String, String?> Credentials = await GetCredentials();
                 if (Credentials['hostname']==null){
                   SaveAPI(
                         hostname,
                         username,
                         password,
                         api);
                   }
                 else{
                   SaveAPI(
                         Credentials['hostname']!,
                         Credentials['username']!,
                         Credentials['password']!,
                         api);
                   }


               }, child: Text('Save'))
             ],
           ),
        ),
        body: Column(
          children: [
            Container(
              child: Image(
                image: NetworkToFileImage(
                  url: Provider.of<DalleImage>(context).filepath,
                  file: File(Provider.of<DalleImage>(context).filepath),
                ),
              )
              //Text(Provider.of<DalleImage>(context).filepath)

            ),
            TextField(
              decoration: InputDecoration(
                hintText: 'Prompt',
              ),
              onChanged: (txt){
                prompt = txt;
              },
            ),
            TextButton(onPressed: () async {
              Map<String, String?> Credentials = await GetCredentials();
              String filepath = await RunDalle(
                  Credentials['hostname']!,
                  Credentials['username']!,
                  Credentials['password']!,
                  prompt);
              String filename = await LoadImage(prompt);
              Provider.of<DalleImage>(context, listen: false).ChangePath(prompt, filepath);
            }, child: Text('Run Dalle!')),
            ExpansionTile(
                title: Text('Dalle Settings'),
                children: [Setting()]),
          ],
        ),
      ),
    );
  }
}

