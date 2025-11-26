import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:one_music/theme/theme_extensions.dart';

class OneErrorWidget extends StatelessWidget {
  final String error;

  const OneErrorWidget({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            ":(",
            style: TextStyle(color: context.colorScheme.primary, fontSize: 40),
          ),
          SizedBox(height: 20),
          Text(
            error.tr(),
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );
  }
}
