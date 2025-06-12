// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:kiosk_project_test/data/Data_food.dart';

class RightPanel extends StatelessWidget {
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
  Widget build(BuildContext context) {
    double total = selectedFoods.fold(0, (sum, item) => sum + (item.foodPrice * item.quantity));
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
        children: [
          SizedBox(height: screenHeight * 0.03),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'My Order',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                PopupMenuButton<String>(
                  icon: Image.asset('assets/images/flag_usa.png',
                      height: 30, width: 30),
                  onSelected: (value) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('เลือก: $value')),
                    );
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                        value: 'English', child: Text('English')),
                    const PopupMenuItem(
                        value: 'Setting', child: Text('Setting')),
                    const PopupMenuItem(
                        value: 'Store Management',
                        child: Text('Store Management')),
                  ],
                ),
              ],
            ),
          ),
          // Order list
          Expanded(
            child: ListView.builder(
                itemCount: selectedFoods.length,
                itemBuilder: (context, index) {
                  final food = selectedFoods[index];

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'x${food.quantity} ${food.foodName}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          food.foodDesc,
                          style:
                              const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
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
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () => onDecrease(food.foodId),
                                ),
                                Text('${food.quantity}',
                                    style: const TextStyle(fontSize: 16)),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () => onIncrease(food.foodId),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Divider(),
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
                const Text('Total:',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text('\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18)),
              ],
            ),
          ),
          Padding(padding: const EdgeInsetsDirectional.all(20),
            child: OutlinedButton.icon(
              onPressed: (){}, 
              icon: const Icon(Icons.shopping_cart),
              label: const Text('Confirm Order')
            )
          )
        ],
      ),
    );
  }
}
