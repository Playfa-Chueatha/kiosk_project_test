// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:kiosk_project_test/data/Data_food.dart';

class RightPanel extends StatefulWidget {
  final List<FoodData> selectedFoods;
  final Function(String) onIncrease;
  final Function(String) onDecrease;

  const RightPanel({
    super.key,
    required this.selectedFoods,
    required this.onIncrease,
    required this.onDecrease,
  });

  @override
  State<RightPanel> createState() => _RightPanelState();
}

class _RightPanelState extends State<RightPanel> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    double total = widget.selectedFoods
        .fold(0, (sum, item) => sum + (item.foodPrice * item.quantity));
    final double screenHeight = MediaQuery.of(context).size.height;

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: screenHeight * 0.03),
          Align(
            alignment: Alignment.centerRight,
            child: PopupMenuButton<String>(
              icon: Image.asset('assets/images/flag_usa.png',
                  height: 30, width: 30),
              onSelected: (value) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('เลือก: $value')),
                );
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'English', child: Text('English')),
                PopupMenuItem(value: 'Setting', child: Text('Setting')),
                PopupMenuItem(
                    value: 'Store Management', child: Text('Store Management')),
              ],
            ),
          ),

          const Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Text(
              'My Order',
              style: TextStyle(
                color: Color(0xFF4F4F4F),
                fontSize: 34,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              height: 2,
              width: MediaQuery.of(context).size.width * 0.4,
              color: Colors.black,
            ),
          ),

          // Order list
          Expanded(
            child: ListView.builder(
                itemCount: widget.selectedFoods.length,
                itemBuilder: (context, index) {
                  final food = widget.selectedFoods[index];

                  return Container(
                    decoration: BoxDecoration(
                        color: const Color(0xFFF6F6F6),
                        borderRadius: BorderRadius.circular(10)),
                    margin: const EdgeInsetsDirectional.all(10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'x${food.quantity} ${food.foodName}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        Text(
                          food.foodDesc,
                          style:
                              const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '\$${(food.foodPrice * food.quantity).toStringAsFixed(2)} ',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF7B61FF),
                              ),
                            ),
                            Row(
                              children: [
                                RawMaterialButton(
                                  onPressed: () =>
                                      widget.onDecrease(food.foodId),
                                  shape: const CircleBorder(),
                                  fillColor: Colors.grey[300],
                                  constraints: const BoxConstraints.tightFor(
                                      width: 26, height: 26),
                                  elevation: 0,
                                  child: const Icon(Icons.remove,
                                      color: Colors.black, size: 20),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  food.quantity.toString().padLeft(2, '0'),
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                RawMaterialButton(
                                  onPressed: () =>
                                      widget.onIncrease(food.foodId),
                                  shape: const CircleBorder(),
                                  fillColor: Colors.grey[300],
                                  constraints: const BoxConstraints.tightFor(
                                      width: 26, height: 26),
                                  elevation: 0,
                                  child: const Icon(Icons.add,
                                      color: Colors.black, size: 20),
                                ),
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Subtotal:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF7B61FF),
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsetsDirectional.all(10),
              margin: const EdgeInsetsDirectional.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF32CD32),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                label: Text(
                  'Confirm Order (${widget.selectedFoods.length})',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
