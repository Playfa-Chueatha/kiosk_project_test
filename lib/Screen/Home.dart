// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:kiosk_project_test/Screen/SelfService_Experience.dart';
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

    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isPortrait = screenHeight > screenWidth;
    final double baseSize = isPortrait ? screenWidth : screenHeight;

    final double iconSoiSiam = baseSize * 0.03;

    double maintext = baseSize * 0.1;
    double taptoorderSize = baseSize * 0.03;
    double selfCheckout = baseSize * 0.03;
    double soisiamrestaurant = baseSize * 0.04;

    final width = MediaQuery.of(context).size.width;

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
                        padding: EdgeInsets.fromLTRB(
                          screenWidth * 0.02,
                          screenHeight * 0.04,
                          screenWidth * 0.01,
                          screenHeight * 0.01,
                        ),
                        child: Image.asset(
                          'assets/images/Soi Siam.png',
                          height: iconSoiSiam,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        FooterSheet.show(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          screenWidth * 0.00,
                          screenHeight * 0.04,
                          screenWidth * 0.02,
                          screenHeight * 0.01,
                        ),
                        child: Text(
                          'Soi Siam',
                          style: TextStyle(
                            fontSize: iconSoiSiam,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 102, 102, 102),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(
                    screenWidth * 0.00,
                    screenHeight * 0.04,
                    screenWidth * 0.02,
                    screenHeight * 0.01,
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: PopupMenuButton<String>(
                      icon: Image.asset('assets/images/flag_usa.png',
                          height: iconSoiSiam),
                      onSelected: (value) {
                        if (value == 'English') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('เลือก: English')),
                          );
                        } else if (value == 'Setting') {
                          Future.microtask(() {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SelfService()),
                            );
                          });
                        } else if (value == 'Store Management') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('เลือก: Store Management')),
                          );
                        }
                      },
                      itemBuilder: (context) => const [
                        PopupMenuItem(value: 'English', child: Text('English')),
                        PopupMenuItem(value: 'Setting', child: Text('Setting')),
                        PopupMenuItem(
                            value: 'Store Management',
                            child: Text('Store Management')),
                      ],
                    ),
                  ),
                ),
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
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.71,
                          left: -30,
                          right: 0,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/Soi SiamW.png',
                                height: soisiamrestaurant,
                              ),
                              Text(
                                'Soi Siam',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: soisiamrestaurant,
                                ),
                              ),
                              Text(
                                'Restaurant',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: soisiamrestaurant,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                              padding: const EdgeInsets.all(10),
                                              child: Icon(Icons.credit_card,
                                                  color:
                                                      const Color(0xFFEB5757),
                                                  size: width * 0.04)),
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
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth * 0.08,
                                          vertical: screenHeight * 0.02,
                                        ),
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
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: screenWidth * 0.07,
                                              vertical: screenHeight * 0.02,
                                            ),
                                            child: Text('Tap to Order',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: taptoorderSize,
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
                                          size: width * 0.025)),
                                  Text(
                                    'Accept Credit Card Only',
                                    style: TextStyle(
                                        color: const Color(0xFFEB5757),
                                        fontWeight: FontWeight.bold,
                                        fontSize: selfCheckout),
                                  )
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05,
                                  vertical: screenHeight * 0.04,
                                ),
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
                                              const MainScreen()),
                                    );
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.06,
                                      vertical: screenHeight * 0.04,
                                    ),
                                    child: Text('Tap to Order',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: taptoorderSize,
                                        )),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(
                          width: size.width * 0.6,
                          height: size.height,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset('assets/images/ani_welcome_3.gif',
                                  fit: BoxFit.cover),
                              Align(
                                alignment: const Alignment(-0.08, 0.3),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/images/Soi SiamW.png',
                                      height: soisiamrestaurant,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'Soi Siam',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: soisiamrestaurant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ));
  }
}
