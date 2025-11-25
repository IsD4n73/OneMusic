import 'package:flutter/material.dart';
import 'package:one_music/theme/theme_extensions.dart';

class OneAppBar extends StatelessWidget {
  final void Function()? onTap;
  final IconData? rightIcon;
  final String? textOne, textTwo;
  const OneAppBar({
    super.key,
    this.onTap,
    this.rightIcon,
    this.textOne,
    this.textTwo,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: true,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            textOne != null && textTwo != null
                ? Row(
                    children: [
                      Text("$textOne ", style: TextStyle(fontSize: 20)),
                      Text(
                        textTwo!,
                        style: TextStyle(
                          color: context.colorScheme.primary,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Text("One ", style: TextStyle(fontSize: 20)),
                      Text(
                        "Music",
                        style: TextStyle(
                          color: context.colorScheme.primary,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
            Text("⁺"),
            Spacer(),
            rightIcon == null
                ? SizedBox.shrink()
                : InkWell(onTap: onTap, child: Icon(rightIcon)),
          ],
        ),
      ),
    );
  }
}
