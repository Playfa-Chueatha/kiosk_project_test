import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_project_test/bloc/bloc_cetagoryfood.dart';
import 'package:kiosk_project_test/bloc/bloc_foodData.dart';
import 'package:kiosk_project_test/data/Data_food.dart';

class FoodListWidget extends StatelessWidget {
  final Function(FoodData) onFoodSelected;
  const FoodListWidget({super.key, required this.onFoodSelected});
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
              if (state is FoodSetLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is FoodItemLoaded) {
                final foodItem = state.foodItem;

                final Map<String, List<FoodData>> groupedFood = {};
                for (var food in foodItem) {
                  groupedFood.putIfAbsent(food.foodCatId, () => []).add(food);
                }

                return ListView(
                  padding: EdgeInsets.all(16 * scaleFactor),
                  children: groupedFood.entries.map((entry) {
                    final catId = entry.key;
                    final items = entry.value;

                    final categoryName = categoryNameMap[catId] ?? 'Unknown';

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style: TextStyle(
                            fontSize: 20 * scaleFactor,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        SizedBox(height: 8 * scaleFactor),
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: items.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 5 * scaleFactor,
                            mainAxisSpacing: 5 * scaleFactor,
                            childAspectRatio: 0.8,
                          ),
                          itemBuilder: (context, index) {
                            final food = items[index];
                            return Card(
                                color: Colors.white,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(12 * scaleFactor),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () => onFoodSelected(food),
                                  child: LayoutBuilder(
                                    builder: (context, constraints) {
                                      final double maxWidth =
                                          constraints.maxWidth;

                                      final double titleFontSize =
                                          (maxWidth * 0.12).clamp(12, 18);
                                      final double descFontSize =
                                          (maxWidth * 0.10).clamp(10, 14);
                                      final double priceFontSize =
                                          (maxWidth * 0.14).clamp(16, 22);
                                      final double iconSize = maxWidth * 0.3;

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: Image.network(
                                                food.imageName,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error,
                                                        stackTrace) =>
                                                    Icon(Icons.broken_image,
                                                        size: iconSize),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  8.0 * scaleFactor),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    food.foodName,
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: titleFontSize,
                                                      color: Colors.black,
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  SizedBox(
                                                      height: 4 * scaleFactor),
                                                  Text(
                                                    food.foodDesc,
                                                    style: TextStyle(
                                                      fontSize: descFontSize,
                                                      color: Colors.grey,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    '\$${food.foodPrice} ',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: priceFontSize,
                                                      color: Colors.grey,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                )
                              );
                          },
                        ),
                        SizedBox(height: 24 * scaleFactor),
                      ],
                    );
                  }).toList(),
                );
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
