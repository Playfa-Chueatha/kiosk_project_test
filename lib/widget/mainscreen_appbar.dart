// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBackAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onBack;

  const CustomBackAppBar({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      elevation: 0,
      centerTitle: false,
      title: TextButton.icon(
        onPressed: onBack ?? () => Navigator.pop(context),
        icon: const Icon(
          FontAwesomeIcons.chevronLeft,
          color: Colors.black,
          size: 16,
        ),
        label: const Text(
          'Back',
          style: TextStyle(color: Colors.black),
        ),
        style: TextButton.styleFrom(
          backgroundColor: const Color(0xFFF6F6F6),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          foregroundColor: Colors.black,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          elevation: 0,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
