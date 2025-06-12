// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:kiosk_project_test/bloc/bloc_cetagoryfood.dart';
import 'package:kiosk_project_test/bloc/loc_food_data.dart';
import 'package:kiosk_project_test/data/Data_food.dart';

class FoodListWidget extends StatefulWidget {
  final Function(FoodData) onFoodSelected;
  final String searchText;
  final String selectedFoodSetId;
  final String? selectedFoodCatId;
  final Function(String)? onCategoryChanged;

  const FoodListWidget({
    super.key,
    required this.onFoodSelected,
    required this.searchText,
    required this.selectedFoodSetId,
    required this.selectedFoodCatId,
    this.onCategoryChanged,
  });

  @override
  State<FoodListWidget> createState() => _FoodListWidgetState();
}

class _FoodListWidgetState extends State<FoodListWidget> {
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final Map<String, int> _categoryIndexMap = {};

  @override
  void didUpdateWidget(FoodListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final foodListState = context.read<FoodListBloc>().state;

    if (widget.selectedFoodSetId != oldWidget.selectedFoodSetId) {
      if (foodListState is FoodItemLoaded) {
        final filteredFood = foodListState.foodItem.where((food) {
          final matchSearch = widget.searchText.isEmpty ||
              food.foodName
                  .toLowerCase()
                  .contains(widget.searchText.toLowerCase());
          final matchSetId = widget.selectedFoodSetId.isEmpty ||
              food.foodSetId == widget.selectedFoodSetId;
          return matchSearch && matchSetId;
        }).toList();

        final firstCategoryId =
            filteredFood.isNotEmpty ? filteredFood.first.foodCatId : null;

        if (firstCategoryId != null &&
            widget.selectedFoodCatId != firstCategoryId) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToCategory(firstCategoryId);

            
            if (widget.onCategoryChanged != null) {
              widget.onCategoryChanged!(firstCategoryId);
            }
          });
        }
      }
    }

    if (widget.selectedFoodCatId != null &&
        widget.selectedFoodCatId != oldWidget.selectedFoodCatId) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollToCategory(widget.selectedFoodCatId!);
      });
    }
  }

  void _scrollToCategory(String categoryId) {
    final index = _categoryIndexMap[categoryId];
    if (index != null) {
      _scrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      print('ไม่พบ index สำหรับ categoryId: $categoryId');
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

                  return matchSearch && matchSetId;
                }).toList();

                final Map<String, List<FoodData>> groupedFood = {};
                for (var food in filteredFood) {
                  groupedFood.putIfAbsent(food.foodCatId, () => []).add(food);
                }

                final sortedEntries = groupedFood.entries.toList()
                  ..sort((a, b) {
                    final nameA = categoryNameMap[a.key] ?? 'Unknown';
                    final nameB = categoryNameMap[b.key] ?? 'Unknown';

                    if (nameA == 'Unknown' && nameB == 'Unknown') return 0;
                    if (nameA == 'Unknown') return 1;
                    if (nameB == 'Unknown') return -1;
                    return nameA.compareTo(nameB);
                  });

                for (int i = 0; i < sortedEntries.length; i++) {
                  _categoryIndexMap[sortedEntries[i].key] = i;
                }

                return ScrollablePositionedList.builder(
                  itemScrollController: _scrollController,
                  itemPositionsListener: _itemPositionsListener,
                  itemCount: sortedEntries.length,
                  itemBuilder: (context, index) {
                    final entry = sortedEntries[index];
                    final categoryId = entry.key;
                    final categoryName =
                        categoryNameMap[categoryId] ?? 'Unknown';
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
                            final isOutOfStock = food.isOutStock;

                            return Opacity(
                              opacity: isOutOfStock ? 0.5 : 1.0,
                              child: Stack(
                                children: [
                                  Card(
                                    color: Colors.white,
                                    elevation: 4,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    clipBehavior: Clip.antiAlias,
                                    child: InkWell(
                                      onTap: isOutOfStock
                                          ? null
                                          : () => widget.onFoodSelected(food),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            flex: 5,
                                            child: Stack(
                                              children: [
                                                Container(
                                                  color: Colors.white,
                                                  child: Image.network(
                                                    food.imageName,
                                                    fit: BoxFit.cover,
                                                    width: double.infinity,
                                                    errorBuilder: (context,
                                                            error,
                                                            stackTrace) =>
                                                        const Icon(
                                                            Icons.broken_image),
                                                  ),
                                                ),
                                                if (isOutOfStock)
                                                  Positioned.fill(
                                                    child: Container(
                                                      color: Colors.white
                                                          .withOpacity(0.4),
                                                      child: const Center(
                                                        child: Text(
                                                          'OUT OF STOCK',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 28,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            letterSpacing: 1.5,
                                                          ),
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                          Expanded(
                                            flex: 4,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    food.foodName,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF4F4F4F),
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const SizedBox(height: 4),
                                                  Text(
                                                    food.foodDesc,
                                                    style: const TextStyle(
                                                        color:
                                                            Color(0xFF828282)),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                    '\$${food.foodPrice}',
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        SizedBox(height: 24 * scaleFactor),
                      ],
                    );
                  },
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
