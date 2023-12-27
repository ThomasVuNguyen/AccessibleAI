import 'dart:io';

import 'package:accessible_ai/DalleImageState.dart';
import 'package:accessible_ai/credentials.dart';
import 'package:accessible_ai/credit.dart';
import 'package:accessible_ai/main.dart';
import 'package:accessible_ai/setting.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_saver/file_saver.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:network_to_file_image/network_to_file_image.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:path/path.dart' as p;
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'Display.dart';
import 'dalle.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey containerKey = GlobalKey();
  String hostname = '';
  void initState(){

  }
  @override
  Widget build(BuildContext context) {
    double ScreenWidth = MediaQuery.of(context).size.width;
    //GlobalKey<ScaffoldState> _ScaffoldKey = GlobalKey<ScaffoldState>();

    String prompt = ' A cool looking banana';
     String username = ''; String password = '';
    String api = '';
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create:(_) => DalleImage())
      ],
      child: Scaffold(
        //key: _ScaffoldKey,
        appBar: AppBar(
          //Text('OpenAI on RPi!'),
          actions: [Builder(builder: (context){
            return IconButton(onPressed: () {
              //_ScaffoldKey.currentState?.openEndDrawer();
              Scaffold.of(context).openEndDrawer();
            }, icon: Icon(Icons.settings),);
          })]
        ),
        endDrawer: SafeArea(
          child: Drawer(
             child: Padding(
               padding: const EdgeInsets.all(10.0),
               child: Column(
                 children: [
                   Column(
                     children: [
                       TextField(
                         decoration: const InputDecoration(
                             hintText: 'hostname'
                         ),
                         onChanged: (txt){
                           hostname = txt;
                         },textInputAction: TextInputAction.next,
                       ),
                       TextField(
                         decoration: InputDecoration(
                             hintText: 'username'
                         ),
                         onChanged: (txt){
                           username = txt;
                         },textInputAction: TextInputAction.next,
                       ),
                       TextField(
                         decoration: InputDecoration(
                             hintText: 'password'
                         ),
                         onChanged: (txt){
                           password = txt;
                         },textInputAction: TextInputAction.next,
                       ),
                       TextField(
                         decoration: InputDecoration(
                           hintText: 'API key'
                         ),
                         onChanged: (txt){
                           api = txt;
                         },textInputAction: TextInputAction.next,
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
                         Navigator.pop(context);


                       }, child: Text('Save'))
                     ],
                   ),
                   Spacer(),
                   TextButton(onPressed: (){
                     showDialog(context: context, builder: (BuildContext context){
                       return AlertDialog(
                         content: Column(
                           children: [
                             RobotIconCredit(),
                             RPiIconCredit()
                           ],
                         )
                       );
                     });
                   }, child: Text('Credit'))
                 ],
               ),
             ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: ScreenWidth * 0.7,
                        height: ScreenWidth *0.2,
                        child:
                          Image(
                            image: NetworkToFileImage(
                              url: Provider.of<DalleImage>(context).url,
                            ),
                          )
                      ),
                      TextButton(
                        onPressed: () async {
                        //var client = http.Client();
                        final response = await http.get(Uri.parse(Provider.of<DalleImage>(context, listen: false).url));
                        final bytes = response.bodyBytes;
                        await FileSaver.instance.saveFile(
                            name: '${Provider.of<DalleImage>(context, listen: false).filepath}.png',
                          bytes: bytes,
                        );
                        SnackBar snackBar = SnackBar(content: Text('Image downloaded'));
                        final directory = await getApplicationDocumentsDirectory();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        final file = File('${directory.path}/${Provider.of<DalleImage>(context, listen: false).filepath}.png');
                        await file.writeAsBytes(bytes);
                        OpenFile.open('${directory.path}/${Provider.of<DalleImage>(context, listen: false).filepath}.png');
                        print('Image downloaded to: ${file.path}');
                        if (!await launchUrl(
                            Uri.parse(Provider.of<DalleImage>(context, listen: false).url),
                          mode: LaunchMode.externalApplication,
                        )
                        ) {
                          throw Exception('Could not launch ${Provider.of<DalleImage>(context, listen: false).url}');
                        }
                      },
                        child: Container(
                          child: (Provider.of<DalleImage>(context).url == defaultImage)? null :Text('download'),
                        ),
                      )
                    ],
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Prompt',
                  ),
                  onChanged: (txt){
                    prompt = txt;
                  },
                ),
                TextButton(onPressed: () async {
                  Map<String, String?> Credentials = await GetCredentials();
                  SnackBar snackBar = SnackBar(content: Text('Generating image, wait...'));
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  String url = await RunDalle(
                      Credentials['hostname']!,
                      Credentials['username']!,
                      Credentials['password']!,
                      prompt);
                  Provider.of<DalleImage>(context, listen: false).ChangePath(prompt, url);

                    Directory dir = await getApplicationDocumentsDirectory();


                }, child: Text('Run Dalle!')),
                ExpansionTile(
                    title: Text('Dalle Settings'),
                    children: [Setting()]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SettingButton extends StatelessWidget {
  const SettingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
