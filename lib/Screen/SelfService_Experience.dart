import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(width),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: height *0.2),
                  AutoSizeText(
                    'Self-Service',
                    style: mainTextStyle(120),
                    maxLines: 1,
                    minFontSize: 20,
                  ),
                  AutoSizeText(
                    'Experience.',
                    style: mainTextStyle(120),
                    maxLines: 1,
                    minFontSize: 20,
                  ),
                  const AutoSizeText(
                    'From self-order to self-checkout',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 40,
                    ),
                    maxLines: 1,
                    minFontSize: 14,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Icon(Icons.credit_card,
                            color: const Color(0xFFEB5757),
                            size: width * 0.04),
                      ),
                      const AutoSizeText(
                        'Accept Credit Card Only',
                        style: TextStyle(
                          color: Color(0xFFEB5757),
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        minFontSize: 14,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  _buildCardRow(),
                  const Spacer(),
                  _buildFooter(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
                  MaterialPageRoute(
                      builder: (context) => const SelfService()),
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

  Widget _buildCardRow() {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Card(
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
        Card(
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
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width;

    double titleFontSize = maxWidth < 400 ? 10 : 12;
    double contentFontSize = maxWidth < 400 ? 10 : 12;
    double buttonFontSize = maxWidth < 400 ? 12 : 14;
    EdgeInsetsGeometry buttonPadding = maxWidth < 400
        ? const EdgeInsets.symmetric(vertical: 6, horizontal: 8)
        : const EdgeInsets.all(10);

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
                    padding: const EdgeInsets.only(left: 60.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: _buildContactButtons(
                        buttonFontSize: buttonFontSize,
                        buttonPadding: buttonPadding,
                      ),
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
                    height: maxWidth * 0.02,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildContactButtons({
    double buttonFontSize = 14,
    EdgeInsetsGeometry buttonPadding = const EdgeInsets.all(5),
  }) {
    return [
      DataTable(
        columns: const [
          DataColumn(
            label: Text(' ', style: TextStyle(color: Colors.white)),
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
