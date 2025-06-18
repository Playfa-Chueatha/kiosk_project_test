// ignore_for_file: file_names

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kiosk_project_test/Screen/main_screen.dart';

class SelfService extends StatefulWidget {
  const SelfService({super.key});

  @override
  State<SelfService> createState() => _SelfServiceState();
}

class _SelfServiceState extends State<SelfService> {
  TextStyle mainTextStyle(double fontSize) {
    return TextStyle(
      fontSize: fontSize,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isPortrait = screenHeight > screenWidth;

    final double baseSize = isPortrait ? screenWidth : screenHeight;


    double maintext = baseSize * 0.1;
    double selfCheckout = baseSize * 0.03;

    return Scaffold(
        backgroundColor: const Color(0xFFFBFBFB),
        body: isPortrait
            ? SafeArea(
                child: Column(
                  children: [
                    _buildHeader(screenWidth),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Self-Service',
                              style: TextStyle(fontSize: maintext)),
                          Text('Experience.',
                              style: TextStyle(fontSize: maintext)),
                          Padding(
                              padding: EdgeInsets.fromLTRB(
                                screenWidth * 0.02,
                                screenHeight * 0.03,
                                screenWidth * 0.02,
                                screenHeight * 0.005,
                              ),
                              child: Text(
                                'From self-order to self-checkout',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: selfCheckout,
                                ),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Icon(Icons.credit_card,
                                      color: const Color(0xFFEB5757),
                                      size: screenWidth * 0.04)),
                              Text(
                                'Accept Credit Card Only',
                                style: TextStyle(
                                  color: const Color(0xFFEB5757),
                                  fontSize: selfCheckout,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          _buildCardRow(context),
                          const Spacer(),
                          _buildFooter(context),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                children: [
                  Expanded(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Self-Service',
                              style: TextStyle(fontSize: maintext)),
                          Text(
                            'Experience.',
                            style: TextStyle(
                              fontSize: maintext,
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(
                                screenWidth * 0.02,
                                screenHeight * 0.03,
                                screenWidth * 0.02,
                                screenHeight * 0.005,
                              ),
                              child: Text(
                                'From self-order to self-checkout',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: selfCheckout,
                                ),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(5),
                                  child: Icon(Icons.credit_card,
                                      color: const Color(0xFFEB5757),
                                      size: screenWidth * 0.025)),
                              Text(
                                'Accept Credit Card Only',
                                style: TextStyle(
                                    color: const Color(0xFFEB5757),
                                    fontWeight: FontWeight.bold,
                                    fontSize: selfCheckout),
                              )
                            ],
                          ),
                        ],
                      ),
                      _buildCardRow(context),
                    ],
                  )),
                  _buildFooter(context),
                ],
              ));
  }

  Widget _buildHeader(double width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 5, 20),
              child: Image.asset(
                'assets/images/Soi Siam.png',
                height: 25,
                width: 25,
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(5, 20, 20, 20),
              child: Text(
                'Soi Siam',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 102, 102, 102),
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
          child: PopupMenuButton<String>(
            icon: Image.asset('assets/images/flag_usa.png',
                height: 30, width: 30),
            onSelected: (value) {
              if (value == 'English') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('เลือก: English')),
                );
              } else if (value == 'Setting') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SelfService()),
                );
              } else if (value == 'Store Management') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('เลือก: Store Management')),
                );
              }
            },
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'English', child: Text('English')),
              PopupMenuItem(value: 'Setting', child: Text('Setting')),
              PopupMenuItem(
                  value: 'Store Management', child: Text('Store Management')),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCardRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
          child: const Card(
            color: Color(0xFF496EE2),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: Image(
                    image: AssetImage('assets/images/ani_to_stay.gif'),
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'To Stay',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MainScreen()),
            );
          },
          child: const Card(
            color: Color(0xFFFAA21C),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: Image(
                    image: AssetImage('assets/images/ani_welcome_3.gif'),
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Center(
                    child: Text(
                      'Togo Walk-in',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final Orientation orientation = MediaQuery.of(context).orientation;
    final bool isPortrait = orientation == Orientation.portrait;

    final double baseSize = isPortrait ? screenWidth : screenHeight;

    double titleFontSize = baseSize * 0.02;
    double contentFontSize = baseSize * 0.015;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: Colors.black,
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                  Icon(Icons.phone,
                                      color: Colors.white, size: titleFontSize),
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
                                      color: Colors.white, size: titleFontSize),
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
                                      color: Colors.white, size: titleFontSize),
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
                                  Icon(Icons.email,
                                      color: Colors.white, size: titleFontSize),
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
            ),
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
                    height: screenWidth * 0.02,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
