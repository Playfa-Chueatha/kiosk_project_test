// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_project_test/bloc/bloc_cetagoryfood.dart';
import 'package:kiosk_project_test/bloc/loc_food_data.dart';
import 'package:kiosk_project_test/data/Data_food.dart';

class FoodListWidget extends StatefulWidget {
  final Function(FoodData) onFoodSelected;
  final String searchText;
  final String selectedFoodSetId;
  final String? selectedFoodCatId;

  const FoodListWidget({
    super.key,
    required this.onFoodSelected,
    required this.searchText,
    required this.selectedFoodSetId,
    required this.selectedFoodCatId,
  });

  @override
  State<FoodListWidget> createState() => _FoodListWidgetState();
}

class _FoodListWidgetState extends State<FoodListWidget> {
  final ScrollController _scrollController = ScrollController();

  final Map<String, GlobalKey> _categoryKeys = {};

  List<String> _currentCategoryIds = [];

  @override
  void didUpdateWidget(FoodListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.searchText != oldWidget.searchText ||
        widget.selectedFoodSetId != oldWidget.selectedFoodSetId) {
      _categoryKeys.clear();
    }

    if (widget.selectedFoodCatId != null &&
        widget.selectedFoodCatId != oldWidget.selectedFoodCatId) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(const Duration(milliseconds: 200), () {
          _scrollToCategory(widget.selectedFoodCatId!);
        });
      });
    }
  }

  void _scrollToCategory(String categoryId) {
    final keyContext = _categoryKeys[categoryId]?.currentContext;
    if (keyContext != null) {
      print('Scrolling to category: $categoryId');
      Scrollable.ensureVisible(
        keyContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      print('Category $categoryId not found in _categoryKeys');
      print('Available keys: ${_categoryKeys.keys.toList()}');
    }
  }

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
                  final matchSearch = widget.searchText.isEmpty ||
                      food.foodName
                          .toLowerCase()
                          .contains(widget.searchText.toLowerCase());
                  final matchSetId = widget.selectedFoodSetId.isEmpty ||
                      food.foodSetId == widget.selectedFoodSetId;

                  
                  final matchCatId = widget.selectedFoodCatId == null ||
                      food.foodCatId == widget.selectedFoodCatId;

                  return matchSearch && matchSetId && matchCatId;
                }).toList();

                
                final Map<String, List<FoodData>> groupedFood = {};
                for (var food in filteredFood) {
                  groupedFood.putIfAbsent(food.foodCatId, () => []).add(food);
                }

                
                final sortedEntries = groupedFood.entries.toList()
                  ..sort((a, b) {
                    final nameA = categoryNameMap[a.key] ?? '';
                    final nameB = categoryNameMap[b.key] ?? '';
                    return nameA.compareTo(nameB);
                  });

                
                _currentCategoryIds = sortedEntries.map((e) => e.key).toList();

                
                for (var catId in _currentCategoryIds) {
                  _categoryKeys.putIfAbsent(catId, () => GlobalKey());
                }

                return ListView(
                  controller: _scrollController,
                  padding: EdgeInsets.all(16 * scaleFactor),
                  children: sortedEntries.map((entry) {
                    final categoryId = entry.key;
                    final categoryName = categoryNameMap[categoryId] ?? 'Unknown';
                    final items = entry.value;
                    final key = _categoryKeys[categoryId]!;

                    return Column(
                      key: key,
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
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: () {
                              final orientation =
                                  MediaQuery.of(context).orientation;
                              final isTabletPortrait = screenWidth >= 600 &&
                                  orientation == Orientation.portrait;

                              if (isTabletPortrait) {
                                return 2;
                              } else if (screenWidth >= 1000) {
                                return 4;
                              } else if (screenWidth >= 600) {
                                return 3;
                              } else {
                                return 2;
                              }
                            }(),
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
                                onTap: () => widget.onFoodSelected(food),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Image.network(
                                        food.imageName,
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                        errorBuilder: (context, error, stackTrace) =>
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
