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
    double total = widget.selectedFoods
        .fold(0, (sum, item) => sum + (item.foodPrice * item.quantity));
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    double fontsizeOrder = screenWidth * 0.02;
    double fontsizeNoOrder = screenWidth * 0.01;
    double fontsizefoodPrice = screenWidth * 0.01;
    double fontsizequantity = screenWidth * 0.01;
    double fontsizefoodDesc = screenWidth * 0.008;
    double fontsizesubtotal = screenWidth * 0.015;
    double fontsizeConfirmorder = screenWidth * 0.014;
    final buttonSizequantity = screenWidth * 0.02;
    final buttonSizeIconquantity = screenWidth * 0.01;

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

          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: Text(
              'My Order',
              style: TextStyle(
                color: const Color(0xFF4F4F4F),
                fontSize: fontsizeOrder,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
              child: const Divider(
                thickness: 2,
                color: Colors.grey,
              ),
            ),
          ),

          // Order list
          Expanded(
            child: widget.selectedFoods.isEmpty
                ? Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'No order selected',
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: fontsizeNoOrder,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: widget.selectedFoods.length,
                    itemBuilder: (context, index) {
                      final food = widget.selectedFoods[index];

                      return Container(
                        decoration: BoxDecoration(
                            color: const Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.circular(10)),
                        margin: const EdgeInsets.fromLTRB(40, 10, 30, 40),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'x${food.quantity} ${food.foodName}',
                              style: TextStyle(
                                fontSize: fontsizefoodPrice,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                            Text(
                              food.foodDesc,
                              style: TextStyle(
                                  fontSize: fontsizefoodDesc,
                                  color: Colors.grey),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  '\$${(food.foodPrice * food.quantity).toStringAsFixed(2)} ',
                                  style: TextStyle(
                                    fontSize: fontsizefoodPrice,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF7B61FF),
                                  ),
                                ),
                                Row(
                                  children: [
                                    RawMaterialButton(
                                      onPressed: () =>
                                          widget.onDecrease(food.foodId),
                                      shape: const CircleBorder(),
                                      fillColor: Colors.grey[300],
                                      constraints: BoxConstraints.tightFor(
                                          width: buttonSizequantity,
                                          height: 26),
                                      elevation: 0,
                                      child: Icon(Icons.remove,
                                          color: Colors.black,
                                          size: buttonSizeIconquantity),
                                    ),
                                    SizedBox(width: screenWidth * 0.004),
                                    Text(
                                      food.quantity.toString().padLeft(2, '0'),
                                      style:
                                          TextStyle(fontSize: fontsizequantity),
                                    ),
                                    SizedBox(width: screenWidth * 0.004),
                                    RawMaterialButton(
                                      onPressed: () =>
                                          widget.onIncrease(food.foodId),
                                      shape: const CircleBorder(),
                                      fillColor: Colors.grey[300],
                                      constraints: BoxConstraints.tightFor(
                                          width: buttonSizequantity,
                                          height: 26),
                                      elevation: 0,
                                      child: Icon(Icons.add,
                                          color: Colors.black,
                                          size: buttonSizeIconquantity),
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
          Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(40, 5, 40, 5),
              child: const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(40, 10, 40, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Subtotal:',
                    style: TextStyle(
                      fontSize: fontsizesubtotal,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4F4F4F),
                    )),
                Text('\$${total.toStringAsFixed(2)}',
                    style: TextStyle(
                        fontSize: fontsizesubtotal,
                        color: widget.selectedFoods.isEmpty
                              ?const Color(0xFF4F4F4F)
                              :const Color(0xFF7B61FF),
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
              margin: const EdgeInsets.fromLTRB(30, 5, 30, 30),
              decoration: BoxDecoration(
                color: widget.selectedFoods.isEmpty
                    ? const Color(0xFF8D8D8D)
                    : const Color(0xFF32CD32),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton.icon(
                onPressed: widget.selectedFoods.isEmpty ? null : () {},
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                label: Text(
                  'Confirm Order (${widget.selectedFoods.length})',
                  style: TextStyle(color: Colors.white, fontSize: fontsizeConfirmorder),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
