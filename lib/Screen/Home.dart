// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kiosk_project_test/Screen/main_screen.dart';
import 'package:kiosk_project_test/widget/footer_sheet.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextStyle mainTextStyle(double fontSize) {
    return TextStyle(
      fontSize: fontSize,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;
    final double screenHeight = size.height;
    final double screenWidth = size.width;
    final double textSize = screenWidth;

    final width = MediaQuery.of(context).size.width;

    TextStyle textStlye(double fontSize) {
      return TextStyle(
          fontSize: fontSize * textSize,
          color: Colors.black,
          fontWeight: FontWeight.bold);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      body: Column(
        children: [
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
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
                    child: const Padding(
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
                  ),
                ],
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(10,5,10,5),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: PopupMenuButton<String>(
                      icon: Image.asset('assets/images/flag_usa.png',
                          height: 30, width: 30),
                      onSelected: (value) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('เลือก: \$value')),
                        );
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'English', child: Text('English')),
                        PopupMenuItem(value: 'Setting', child: Text('Setting')),
                        PopupMenuItem(
                            value: 'Store Management',
                            child: Text('Store Management')),
                      ],
                    ),
                  )),
            ],
          ),
          Expanded(
            child: isPortrait
                ? Stack(
                    children: [
                      Positioned.fill(
                        child: Column(
                          children: [
                            const Expanded(flex: 1, child: SizedBox()),
                            SizedBox(
                              width: screenWidth,
                              height: screenHeight * 0.5,
                              child: Image.asset(
                                'assets/images/ani_welcome_3.gif',
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Container(
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage('assets/images/BG02.png'),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Center(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
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
                                    const SizedBox(height: 10),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Icon(Icons.credit_card,
                                                color: const Color(0xFFEB5757),
                                                size: width * 0.04)),
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
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.all(10),
                                      child: OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF496EE2),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MainScreen()),
                                          );
                                        },
                                        child: const Padding(
                                          padding:
                                              EdgeInsetsDirectional.all(20),
                                          child: Text('Tap to Order',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 50,
                                                  
                                                  
                                              )),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const Expanded(flex: 1, child: SizedBox()),
                        ],
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        width: size.width * 0.4,
                        height: size.height,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/BG01.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AutoSizeText('Self-Service',
                                style: mainTextStyle(124),
                                maxLines: 1,
                                minFontSize: 36),
                            AutoSizeText('Experience.',
                                style: mainTextStyle(124),
                                maxLines: 1,
                                minFontSize: 36),
                            const SizedBox(height: 20),
                            const AutoSizeText(
                              'From self-order to self-checkout',
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 34),
                              maxLines: 1,
                              minFontSize: 16,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Icon(Icons.credit_card,
                                        color: const Color(0xFFEB5757),
                                        size: width * 0.025)),
                                const AutoSizeText(
                                  'Accept Credit Card Only',
                                  style: TextStyle(
                                      color: Color(0xFFEB5757),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 34),
                                  minFontSize: 16,
                                  maxLines: 1,
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.all(10),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: const Color(0xFF496EE2),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MainScreen()));
                                },
                                child: const Padding(
                                  padding: EdgeInsetsDirectional.all(20),
                                  child: Text('Tap to Order',
                                      style: TextStyle(color: Colors.white)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.6,
                        height: size.height,
                        child: Image.asset('assets/images/ani_welcome_3.gif',
                            fit: BoxFit.cover),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
