// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_project_test/bloc/bloc_cetagoryfood.dart';
import 'package:kiosk_project_test/bloc/loc_food_data.dart';
import 'package:kiosk_project_test/data/Data_food.dart';

class FoodListWidget extends StatelessWidget {
  final Function(FoodData) onFoodSelected;
  final String searchText;
  final String selectedFoodSetId;
  const FoodListWidget({
    super.key,
    required this.onFoodSelected,
    required this.searchText,
    required this.selectedFoodSetId,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 600;

    return BlocBuilder<FoodCategoryBloc, FoodCategoryState>(
      builder: (context, catState) {
        if (catState is FoodCategoryLoaded) {
          final Map<String, String> categoryNameMap = {
            for (var cat in catState.categories) cat.foodCatId: cat.foodCatName
          };

          return BlocBuilder<FoodListBloc, FoodSetState>(
            builder: (context, state) {
              if (state is FoodItemLoaded) {
                final allFood = state.foodItem;

                final filteredFood = allFood.where((food) {
                  final matchSearch = searchText.isEmpty ||
                      food.foodName.toLowerCase().contains(searchText);
                  final matchSetId = selectedFoodSetId.isEmpty ||
                      food.foodSetId == selectedFoodSetId;
                  return matchSearch && matchSetId;
                }).toList();

                final Map<String, List<FoodData>> groupedFood = {};
                for (var food in filteredFood) {
                  groupedFood.putIfAbsent(food.foodCatId, () => []).add(food);
                }

                return ListView(
                  padding: EdgeInsets.all(16 * scaleFactor),
                  children: groupedFood.entries.map((entry) {
                    final categoryName =
                        categoryNameMap[entry.key] ?? 'Unknown';
                    final items = entry.value;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: TextStyle(
                            fontSize: 20 * scaleFactor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: items.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: screenWidth < 600 ? 2 : 4,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            childAspectRatio: 0.8,
                          ),
                          itemBuilder: (context, index) {
                            final food = items[index];
                            return Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: InkWell(
                                onTap: () => onFoodSelected(food),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Image.network(
                                        food.imageName,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(Icons.broken_image),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 4,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              food.foodName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              food.foodDesc,
                                              style: const TextStyle(
                                                  color: Colors.grey),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const Spacer(),
                                            Text(
                                              '\$${food.foodPrice}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 24 * scaleFactor),
                      ],
                    );
                  }).toList(),
                );
              } else if (state is FoodSetLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FoodSetError) {
                return Center(child: Text('เกิดข้อผิดพลาด: ${state.message}'));
              } else {
                return const Center(child: Text('ไม่มีข้อมูลอาหาร'));
              }
            },
          );
        } else if (catState is FoodCategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return const Center(child: Text('ไม่มีข้อมูลหมวดหมู่'));
        }
      },
    );
  }
}
