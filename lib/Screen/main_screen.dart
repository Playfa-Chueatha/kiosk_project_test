import 'package:flutter/material.dart';
import 'package:kiosk_project_test/widget/left_panelMainhome.dart';
import 'package:kiosk_project_test/data/Data_food.dart';
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
      final existing = selectedFoods.firstWhere(
        (f) => f.foodId == food.foodId,
        orElse: () => FoodData(
          // ใส่ข้อมูลเปล่า เพราะต้อง return บางอย่าง
          foodId: '',
          foodName: '',
          foodNameAlt: '',
          foodPrice: 0,
          foodDesc: '',
          foodSorting: 0,
          active: false,
          foodSetId: '',
          foodCatId: '',
          revenueClassId: '',
          taxRateId: '',
          taxRate2Id: '',
          priority: false,
          printSingle: false,
          isCommand: false,
          foodShowOption: false,
          foodPDANumber: '',
          modifyOn: DateTime.now(),
          createOn: DateTime.now(),
          pureImageName: '',
          imageName: '',
          qtyLimit: 0,
          isLimit: false,
          productId: '',
          isOutStock: false,
          isFree: false,
          isShow: false,
          isShowInstruction: false,
          imageNameString: '',
          thirdPartyGroupId: 0,
          foodBaseId: '',
          isThirdParty: false,
          imageThirdParty: '',
        ),
      );

      if (existing.foodId != '') {
        existing.quantity += 1;
      } else {
        final newFood = food;
        newFood.quantity = 1;
        selectedFoods.add(newFood);
      }
    });
  }

  void increaseQuantity(String foodId) {
    setState(() {
      final food = selectedFoods.firstWhere((f) => f.foodId == foodId);
      food.quantity++;
    });
  }

  void decreaseQuantity(String foodId) {
    setState(() {
      final food = selectedFoods.firstWhere((f) => f.foodId == foodId);
      if (food.quantity > 1) {
        food.quantity--;
      } else {
        selectedFoods.removeWhere((f) => f.foodId == foodId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 8,
            child: LeftPanel(onFoodSelected: handleFoodSelected),
          ),
          Expanded(
            flex: 2,
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
