import 'dart:convert';

import 'package:flutter/material.dart';

class OneImage extends StatelessWidget {
  final String? picture;
  final OneImageSize size;
  const OneImage({super.key, required this.picture, required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.value,
      height: size.value,
      child: picture != null
          ? picture!.startsWith("http")
                ? Image.network(
                    picture!,
                    width: size.value,
                    height: size.value,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      "assets/images/icon.png",
                      width: size.value,
                      height: size.value,
                    ),
                  )
                : Image.memory(
                    base64Decode(picture!),
                    width: size.value,
                    height: size.value,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      "assets/images/icon.png",
                      width: size.value,
                      height: size.value,
                    ),
                  )
          : Image.asset(
              "assets/images/icon.png",
              width: size.value,
              height: size.value,
            ),
    );
  }
}

enum OneImageSize {
  small(50),
  medium(150),
  big(300);

  const OneImageSize(this.value);
  final double value;
}
