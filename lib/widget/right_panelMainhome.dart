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
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    final bool isLargeScreen = screenHeight > 1000;

    double fontsizeOrder = screenWidth * 0.02;
    double fontsizeNoOrder = screenWidth * 0.01 ;
    double fontsizefoodPrice = screenWidth * 0.009 ;
    double fontsizequantity = screenWidth * 0.01 ;
    double fontsizefoodDesc = screenWidth * 0.008 ;
    double fontsizesubtotal = screenWidth * 0.01 ;
    double fontsizeConfirmorder =
        screenWidth * 0.01 * (isLargeScreen ? 1 : 1.0);

    final buttonSizequantity = screenWidth * 0.01 ;
    final buttonSizeIconquantity =
        screenWidth * 0.01 ;

    final EdgeInsets contentPadding = isLargeScreen
        ? const EdgeInsets.fromLTRB(60, 20, 60, 20)
        : const EdgeInsets.fromLTRB(40, 10, 40, 10);

    double total = widget.selectedFoods
        .fold(0, (sum, item) => sum + (item.foodPrice * item.quantity));

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
                  height: 30 * (isLargeScreen ? 1.2 : 1.0),
                  width: 30 * (isLargeScreen ? 1.2 : 1.0)),
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
            padding: contentPadding,
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
              padding: EdgeInsets.fromLTRB(
                  contentPadding.left, 5, contentPadding.right, 5),
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
                        margin: EdgeInsets.fromLTRB(
                          screenWidth * 0.02,
                          screenHeight * 0.01,
                          screenWidth * 0.02,
                          screenHeight * 0.01,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.02,
                          vertical: screenHeight * 0.01,
                        ),
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
                            SizedBox(height: screenHeight * 0.008),
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
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    RawMaterialButton(
                                      onPressed: () =>
                                          widget.onDecrease(food.foodId),
                                      shape: const CircleBorder(),
                                      fillColor: Colors.grey[300],
                                      constraints: BoxConstraints.tightFor(
                                        width: buttonSizequantity,
                                      ),
                                      elevation: 0,
                                      child: Icon(Icons.remove,
                                          color: Colors.black,
                                          size: buttonSizeIconquantity),
                                    ),
                                    Text(
                                      food.quantity.toString().padLeft(2, '0'),
                                      style:
                                          TextStyle(fontSize: fontsizequantity),
                                    ),
                                    RawMaterialButton(
                                      onPressed: () =>
                                          widget.onIncrease(food.foodId),
                                      shape: const CircleBorder(),
                                      fillColor: Colors.grey[300],
                                      constraints: BoxConstraints.tightFor(
                                        width: buttonSizequantity,
                                      ),
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
              padding: EdgeInsets.fromLTRB(
                  contentPadding.left * 0.6, 5, contentPadding.right * 0.6, 5),
              child: const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
          ),

          Padding(
            padding: contentPadding,
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
                            ? const Color(0xFF4F4F4F)
                            : const Color(0xFF7B61FF),
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.02,
                screenHeight * 0.02,
                screenWidth * 0.02,
                screenHeight * 0.02,
              ),
              margin: EdgeInsets.fromLTRB(
                screenWidth * 0.02,
                screenHeight * 0.001,
                screenWidth * 0.02,
                screenHeight * 0.03,
              ),
              decoration: BoxDecoration(
                color: widget.selectedFoods.isEmpty
                    ? const Color(0xFF8D8D8D)
                    : const Color(0xFF32CD32),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.shopping_cart, color: Colors.white),
                label: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Confirm Order (${widget.selectedFoods.length})',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontsizeConfirmorder,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
