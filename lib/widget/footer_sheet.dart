// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FooterSheet {
  static void show(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;

    final double baseSize = isPortrait ? screenWidth : screenHeight;
    double copyright = baseSize * 0.02;

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
                      Padding(
                          padding: EdgeInsets.fromLTRB(
                            screenWidth * 0.02,
                            screenHeight * 0.01,
                            screenWidth * 0.02,
                            screenHeight * 0.001,
                          ),
                          child: Align(
                              alignment: AlignmentDirectional.centerEnd,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '© Copyright 2022 | Powered by',
                                    style: TextStyle(
                                      fontSize: copyright,
                                      color: Colors.white54,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Image.asset(
                                      'assets/images/logo.png',
                                      height: screenWidth * 0.025,
                                    ),
                                  )
                                ],
                              ))),
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
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;

    final double baseSize = isPortrait ? screenWidth : screenHeight;

    double titleFontSize = baseSize * 0.02;
    double contentFontSize = baseSize * 0.015;

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
            padding: const EdgeInsets.only(left: 70.0),
            child: DataTable(
              dataRowMinHeight: 30,
              dataRowMaxHeight: 30,
              columnSpacing: 0,
              columns: const [
                DataColumn(
                  label: Text(
                    '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 0.1,
                    ),
                  ),
                ),
              ],
              rows: [
                DataRow(
                  cells: [
                    DataCell(
                      Row(
                        children: [
                          Icon(Icons.phone, color: Colors.white,size: titleFontSize),
                          const SizedBox(width: 10),
                          Text(
                            '090-890-xxxx',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleFontSize,
                            ),
                          ),
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
                          Icon(FontAwesomeIcons.instagram,
                              color: Colors.white,size: titleFontSize),
                          const SizedBox(width: 10),
                          Text(
                            'SoiSiam',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleFontSize,
                            ),
                          ),
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
                          Icon(FontAwesomeIcons.youtube,
                              color: Colors.white,
                              size: titleFontSize),
                          const SizedBox(width: 10),
                          Text(
                            'SoiSiam Channel',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleFontSize,
                            ),
                          ),
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
                          Icon(Icons.email, color: Colors.white, size: titleFontSize),
                          const SizedBox(width: 10),
                          Text(
                            'SoiSiam@gmail.co.th',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: titleFontSize,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
