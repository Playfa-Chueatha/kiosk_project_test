import 'package:flutter/material.dart';
import 'package:kiosk_project_test/data/Data_food.dart';
import 'package:kiosk_project_test/widget/left_panelMainhome.dart';
import 'package:kiosk_project_test/widget/right_panelMainhome.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  List<FoodData> selectedFoods = [];

  void handleFoodSelected(FoodData food) {
    setState(() {
      final existingIndex = selectedFoods.indexWhere((f) => f.foodId == food.foodId);

      if (existingIndex != -1) {
        
        final existingFood = selectedFoods[existingIndex];
        selectedFoods[existingIndex] = existingFood.copyWith(quantity: existingFood.quantity + 1);
      } else {
        
        selectedFoods.add(food.copyWith(quantity: 1));
      }
    });
  }

  void increaseQuantity(String foodId) {
    setState(() {
      final index = selectedFoods.indexWhere((f) => f.foodId == foodId);
      if (index != -1) {
        final food = selectedFoods[index];
        selectedFoods[index] = food.copyWith(quantity: food.quantity + 1);
      }
    });
  }

  void decreaseQuantity(String foodId) {
    setState(() {
      final index = selectedFoods.indexWhere((f) => f.foodId == foodId);
      if (index != -1) {
        final food = selectedFoods[index];
        if (food.quantity > 1) {
          selectedFoods[index] = food.copyWith(quantity: food.quantity - 1);
        } else {
          selectedFoods.removeAt(index);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isPortrait = MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: isPortrait ? 6 : 8,
            child: LeftPanel(onFoodSelected: handleFoodSelected),
          ),
          Expanded(
            flex: isPortrait ? 4 : 2,
            child: RightPanel(
              selectedFoods: selectedFoods,
              onIncrease: increaseQuantity,
              onDecrease: decreaseQuantity,
            ),
          ),
        ],
      ),
    );
  }
}
