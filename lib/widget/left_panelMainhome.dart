import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kiosk_project_test/data/Data_food.dart';
import 'package:kiosk_project_test/widget/Food.dart';
import 'package:kiosk_project_test/widget/Nationnalfoodcetagory.dart';
import 'package:kiosk_project_test/widget/cetagoryfood.dart';



class LeftPanel extends StatelessWidget {
  final void Function(FoodData) onFoodSelected;
  const LeftPanel({super.key, required this.onFoodSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    FontAwesomeIcons.chevronLeft,
                    color: Colors.black,
                    size: 24,
                  ),
                  label: const Text(
                    'Back',
                    style: TextStyle(color: Colors.black, fontSize: 24),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFF6F6F6),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    foregroundColor: Colors.black,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    elevation: 0,
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.black,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.15,
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: NationalFoodCategory(),
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.15,
            child: const Padding(
              padding: EdgeInsets.all(20),
              child: CategoryFood(),
            ),
          ),
           Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: FoodListWidget(onFoodSelected: onFoodSelected,),
            ),
          )
        ],
        
      ),
    );
  }
}
