import 'package:flutter/material.dart';

class RightPanel extends StatelessWidget {
  const RightPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3), 
            spreadRadius: 4,
            blurRadius: 10, 
            offset: const Offset(0, 3), 
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 10,
            right: 10,
            child: PopupMenuButton<String>(
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
          ),
          const Center(
            child: Text(
              'My Order',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
