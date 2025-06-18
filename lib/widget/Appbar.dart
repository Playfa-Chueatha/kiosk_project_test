
import 'package:flutter/material.dart';
import 'package:kiosk_project_test/widget/footer_sheet.dart';

class MyCustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MyCustomAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFBFBFB),
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          GestureDetector(
            onTap: () {
              FooterSheet.show(context);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 5, 20),
              child: Image.asset(
                'assets/images/Soi Siam.png',
                height: 25,
                width: 25,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              FooterSheet.show(context);
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5, 20, 20, 20),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 102, 102, 102),
                ),
              ),
            ),
          ),
        ],
      ),
      actions: [
        PopupMenuButton<String>(
          icon: Image.asset(
            'assets/images/flag_usa.png',
            height: 30,
            width: 30,
          ),
          onSelected: (String value) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('เลือก: $value')),
            );
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(
              value: 'English',
              child: Text('English'),
            ),
            const PopupMenuItem<String>(
              value: 'Setting',
              child: Text('Setting'),
            ),
            const PopupMenuItem<String>(
              value: 'Store Management',
              child: Text('Store Management'),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
