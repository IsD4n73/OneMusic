import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final String subtitle;
  const SettingsTile({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text(title.tr(), style: TextStyle(fontSize: 20)),
        Divider(),
        Text(subtitle.tr(), style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
