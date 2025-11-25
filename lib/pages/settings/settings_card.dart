import 'package:flutter/material.dart';
import 'package:one_music/theme/theme_extensions.dart';

class SettingsCard extends StatelessWidget {
  final void Function()? onTap;
  final Widget icon;
  final String text;
  final bool selected;
  const SettingsCard({
    super.key,
    this.onTap,
    required this.icon,
    required this.text,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: selected
            ? context.colorScheme.primary
            : context.theme.cardTheme.surfaceTintColor,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [icon, SizedBox(height: 10), Text(text)],
          ),
        ),
      ),
    );
  }
}
