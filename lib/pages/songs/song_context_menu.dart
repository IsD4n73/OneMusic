import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_context_menu/flutter_context_menu.dart';
import 'package:get/get.dart' hide Trans;

class SongContextMenu {
  static void show(
    void Function() onEditMeta,
    void Function() onDelete,
    Offset offset,
  ) {
    final entries = <ContextMenuEntry>[
      MenuHeader(text: "song_menu".tr()),
      MenuItem(
        label: Text('edit_meta'.tr()),
        icon: Icon(Icons.edit),
        onSelected: (value) {
          onEditMeta();
        },
      ),
      MenuItem(
        label: Text('delete'.tr()),
        icon: Icon(Icons.delete),
        onSelected: (value) {
          onDelete();
        },
      ),
    ];

    final menu = ContextMenu(entries: entries, position: offset);

    showContextMenu(Get.context!, contextMenu: menu);
  }
}
