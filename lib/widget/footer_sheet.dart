// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterSheet {
  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      useRootNavigator: true,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Material(
              color: Colors.transparent,
              clipBehavior: Clip.antiAlias,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Container(
                width: constraints.maxWidth, 
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min, 
                    children: [
                      _buildContent(context),
                      const SizedBox(height: 30),
                      Text(
                        '© ${DateTime.now().year} SoiSiam',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Widget _buildContent(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;

    double titleFontSize = maxWidth < 400 ? 10 : 12;
    double contentFontSize = maxWidth < 400 ? 10 : 12;
    double buttonFontSize = maxWidth < 400 ? 12 : 14;
    EdgeInsetsGeometry buttonPadding = maxWidth < 400
        ? const EdgeInsets.symmetric(vertical: 6, horizontal: 8)
        : const EdgeInsets.all(10);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Contact Us',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: titleFontSize,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rattanathibech 28 Alley, Tambon Bang Kraso,\nMueang Nonthaburi District, Nonthaburi 11000',
                  style: TextStyle(
                    fontSize: contentFontSize,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.start,
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: _buildContactButtons(
                buttonFontSize: buttonFontSize,
                buttonPadding: buttonPadding,
              ),
            ),
          ),
        ),
      ],
    );
  }

  static List<Widget> _buildContactButtons({
    double buttonFontSize = 14,
    EdgeInsetsGeometry buttonPadding = const EdgeInsets.fromLTRB(20, 5, 20, 5),
  }) {
    return [
      Padding(
        padding: buttonPadding,
        child: TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.phone, color: Colors.white),
          label: Text(
            '090-890-xxxx',
            style: TextStyle(color: Colors.white, fontSize: buttonFontSize),
          ),
        ),
      ),
      Padding(
        padding: buttonPadding,
        child: TextButton.icon(
          onPressed: () {},
          icon: const Icon(FontAwesomeIcons.instagram, color: Colors.white),
          label: Text(
            'SoiSiam',
            style: TextStyle(color: Colors.white, fontSize: buttonFontSize),
          ),
        ),
      ),
      Padding(
        padding: buttonPadding,
        child: TextButton.icon(
          onPressed: () {},
          icon: const Icon(FontAwesomeIcons.youtube, color: Colors.white),
          label: Text(
            'SoiSiam Channel',
            style: TextStyle(color: Colors.white, fontSize: buttonFontSize),
          ),
        ),
      ),
      Padding(
        padding: buttonPadding,
        child: TextButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.email, color: Colors.white),
          label: Text(
            'SoiSiam@gmail.co.th',
            style: TextStyle(color: Colors.white, fontSize: buttonFontSize),
          ),
        ),
      ),
    ];
  }
}
