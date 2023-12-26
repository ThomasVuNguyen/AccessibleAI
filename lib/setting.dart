import 'package:accessible_ai/dalle.dart';
import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Map<String, String?> DalleSetting  = {};
  String? model = 'dall-e-2';
  String? quality = 'standard';
  String? size = '1024x1024';
  @override
  void initState(){
    AssignSetting();
    super.initState();
  }

  Future<void> AssignSetting() async{
    DalleSetting = await GetDalleSetting();
    model = (DalleSetting['model'] == null)? 'dall-e-2' : DalleSetting['model'];
    quality = (DalleSetting['quality'] == null)? 'standard' :DalleSetting['quality'];
    size = (DalleSetting['size']  == null)? '1024x1024' :DalleSetting['size'];
    setState(() {
    });
  }
  @override
  Widget build(BuildContext context) {

    return Center(
      child: Column(
        children: [
          Row(
            children: [
              const Text('Model'),
              DropdownButton(
                value: model,
                  items: const [
                DropdownMenuItem(
                  value: 'dall-e-2',
                    child: Text('dall-e-2')),
                DropdownMenuItem(
                  value: 'dall-e-3',
                    child: Text('dall-e-3')),
              ], onChanged: (val){
                setState(() {
                  model = val!;
                  print(val);
                  print(model);
                });
              }),

            ],
          ),
          Row(
            children: [
              Text('Quality'),
              DropdownButton(
                value: quality,
                  items: const [
                DropdownMenuItem(
                    value: 'standard',
                    child: Text('standard')),
                DropdownMenuItem(
                    value: 'hd',
                    child: Text('hd')),
              ], onChanged: (value){
                setState(() {
                  quality = value;
                });
              }),
            ],
          ),

          Row(
            children: [
              Text('Resolution'),
              DropdownButton(
                value: size,
                  items: const [
                DropdownMenuItem(
                    value: '256x256',
                    child: Text('256x256')),
                DropdownMenuItem(
                    value: '512x512',
                    child: Text('512x512')),
                DropdownMenuItem(
                    value: '1024x1024',
                    child: Text('1024x1024')),
                DropdownMenuItem(
                    value: '1024x1792',
                    child: Text('1024x1792')),
                DropdownMenuItem(
                    value: '1792x1024',
                    child: Text('1792x1024')),
              ], onChanged: (value){
                setState(() {
                  size = value;
                });
              }),

            ],
          ),
          TextButton(onPressed: (){
            SaveDalleSetting(model!, size!, quality!, '1');
          }, child: Text('Save Setting'))
        ],
      ),
    );
  }
}
