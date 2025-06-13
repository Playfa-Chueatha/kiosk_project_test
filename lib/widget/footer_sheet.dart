// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterSheet {
  static void show(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

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
              child: Container(
                width: constraints.maxWidth,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildContent(context),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            '© Copyright 2022 | Powered by',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white54,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(5),
                            child: Image.asset(
                              'assets/images/logo.png',
                              height: width * 0.02,
                            ),
                          )
                        ],
                      )
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
            alignment: Alignment.center,
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
            padding: const EdgeInsets.only(left: 60.0),
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
    EdgeInsetsGeometry buttonPadding = const EdgeInsets.fromLTRB(5, 5, 5, 5),
  }) {
    return [
      DataTable(
        columns: const [
          DataColumn(
            label: Text(
              ' ',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
        rows: const [
          DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    Icon(Icons.phone, color: Colors.white),
                    SizedBox(width: 10),
                    Text('090-890-xxxx', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    Icon(FontAwesomeIcons.instagram, color: Colors.white),
                    SizedBox(width: 10),
                    Text('SoiSiam', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    Icon(FontAwesomeIcons.youtube, color: Colors.white),
                    SizedBox(width: 10),
                    Text('SoiSiam Channel',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
          DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    Icon(Icons.email, color: Colors.white),
                    SizedBox(width: 10),
                    Text('SoiSiam@gmail.co.th',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ];
  }
}
