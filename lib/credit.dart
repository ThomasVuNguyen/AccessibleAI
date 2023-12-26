import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RobotIconCredit extends StatelessWidget {
  const RobotIconCredit({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () async {
      if (!await launchUrl(
      Uri.parse('https://storyset.com/technology'),
      mode: LaunchMode.externalApplication,
      )
      ) {
      throw Exception('Could not launch https://storyset.com/technology');
      }
    }, child: Text('Technology illustrations by Storyset'));
  }
}

class RPiIconCredit extends StatelessWidget {
  const RPiIconCredit({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () async {
      if (!await launchUrl(
        Uri.parse('https://iconscout.com/icons/raspberry'),
        mode: LaunchMode.externalApplication,
      )
      ) {
        throw Exception('Could not launch https://storyset.com/technology');
      }
    }, child: Text('Raspberry by Icon Mafia on IconScout'));
  }
}
