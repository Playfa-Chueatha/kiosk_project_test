import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_project_test/bloc/bloc_cetagoryfood.dart';
import 'package:kiosk_project_test/bloc/loc_food_data.dart';

class CategoryFood extends StatefulWidget {
  final String selectedFoodSetId;
  final ValueChanged<String> onCategorySelected;

  const CategoryFood({
    super.key,
    required this.selectedFoodSetId,
    required this.onCategorySelected,
  });

  @override
  State<CategoryFood> createState() => _CategoryFoodState();
}

class _CategoryFoodState extends State<CategoryFood> {
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FoodCategoryBloc>(context).add(LoadFoodCategories());
    BlocProvider.of<FoodListBloc>(context).add(LoadFoodLsit());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodListBloc, FoodSetState>(
      builder: (context, foodState) {
        if (foodState is FoodItemLoaded) {
          final allFood = foodState.foodItem;

          final filteredFood = allFood
              .where((food) => food.foodSetId == widget.selectedFoodSetId)
              .toList();

          final usedCategoryIds =
              filteredFood.map((food) => food.foodCatId).toSet();

          return BlocBuilder<FoodCategoryBloc, FoodCategoryState>(
            builder: (context, state) {
              if (state is FoodCategoryLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FoodCategoryLoaded) {
                final filteredCategories = state.categories
                    .where((cat) => usedCategoryIds.contains(cat.foodCatId))
                    .toList();

                final screenHeight = MediaQuery.of(context).size.height;
                final screenWidth = MediaQuery.of(context).size.width;
                final double baseHeight = screenHeight * 0.1;
                final double listViewHeight = baseHeight.clamp(60.0, 100.0);
                final double clampedFontSize =
                    (16.0 * (screenWidth / 600.0)).clamp(12.0, 20.0);

                return SizedBox(
                  height: listViewHeight,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final category = filteredCategories[index];
                      final bool isSelected =
                          selectedCategoryId == category.foodCatId;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategoryId = category.foodCatId;
                          });
                          widget.onCategorySelected(category.foodCatId);
                          print('CatID: $selectedCategoryId');
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF02CCFE)
                                : const Color(0xFFF6F6F6),
                            borderRadius:
                                BorderRadius.circular(isSelected ? 12 : 0),
                          ),
                          child: Center(
                            child: Text(
                              category.foodCatName,
                              style: TextStyle(
                                fontSize: clampedFontSize,
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              } else if (state is FoodCategoryError) {
                return Center(child: Text('เกิดข้อผิดพลาด: ${state.message}'));
              } else {
                return const Center(child: Text('ไม่มีข้อมูล'));
              }
            },
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
