// ignore_for_file: file_names, depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:kiosk_project_test/Screen/main_screen.dart';
import 'package:kiosk_project_test/widget/Appbar.dart';

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

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const MyCustomAppBar(title: 'Soi Siam'),
      body: isPortrait
          ? Stack(
              children: [
                
                Positioned.fill(
                  child: Column(
                    children: [
                      const Expanded(
                          flex: 1, child: SizedBox()), 
                      Expanded(
                        flex: 1,
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
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AutoSizeText(
                                'Self-Service',
                                style: mainTextStyle(48),
                                maxLines: 1,
                                minFontSize: 20,
                              ),
                              AutoSizeText(
                                'Experience.',
                                style: mainTextStyle(48),
                                maxLines: 1,
                                minFontSize: 20,
                              ),
                              const SizedBox(height: 10),
                              const AutoSizeText(
                                'From self-order to self-checkout',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                                maxLines: 1,
                                minFontSize: 14,
                              ),
                              const SizedBox(height: 10),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.credit_card,
                                      color: Color(0xFFEB5757), size: 24),
                                  SizedBox(width: 10),
                                  AutoSizeText(
                                    'Accept Credit Card Only',
                                    style: TextStyle(
                                      color: Color(0xFFEB5757),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    maxLines: 1,
                                    minFontSize: 14,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.all(10),
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Color(0xFF496EE2),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
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
                                    padding: EdgeInsetsDirectional.all(20),
                                    child: Text(
                                      'Tap to Order',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
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
                      AutoSizeText(
                        'Self-Service',
                        style: mainTextStyle(124),
                        maxLines: 1,
                        minFontSize: 36,
                      ),
                      AutoSizeText(
                        'Experience.',
                        style: mainTextStyle(124),
                        maxLines: 1,
                        minFontSize: 36,
                      ),
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
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.credit_card,
                              color: Color(0xFFEB5757), size: 34),
                          SizedBox(width: 10),
                          AutoSizeText(
                            'Accept Credit Card Only',
                            style: TextStyle(
                                color: Color(0xFFEB5757),
                                fontSize: 34,
                                fontWeight: FontWeight.bold),
                            maxLines: 1,
                            minFontSize: 16,
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsetsDirectional.all(10),
                          child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: const Color(0xFF496EE2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
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
                                child: Text(
                                  'Tap to Order',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              )))
                    ],
                  ),
                ),
                SizedBox(
                  width: size.width * 0.6,
                  height: size.height,
                  child: Image.asset(
                    'assets/images/ani_welcome_3.gif',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
    );
  }
}
