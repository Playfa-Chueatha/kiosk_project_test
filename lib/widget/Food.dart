// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_project_test/bloc/bloc_VisibleCategory.dart';
import 'package:kiosk_project_test/bloc/bloc_food_data.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:kiosk_project_test/bloc/bloc_cetagoryfood.dart';
import 'package:kiosk_project_test/data/Data_food.dart';

class FoodListWidget extends StatefulWidget {
  final Function(FoodData) onFoodSelected;
  final String searchText;
  final String selectedFoodSetId;
  final String? selectedFoodCatId;
  final Function(String)? onCategoryChanged;
  final Function(String)? onVisibleCategoryChanged;

  const FoodListWidget(
      {super.key,
      required this.onFoodSelected,
      required this.searchText,
      required this.selectedFoodSetId,
      required this.selectedFoodCatId,
      this.onCategoryChanged,
      this.onVisibleCategoryChanged});

  @override
  State<FoodListWidget> createState() => _FoodListWidgetState();
}

class _FoodListWidgetState extends State<FoodListWidget> {
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener _itemPositionsListener =
      ItemPositionsListener.create();
  final Map<String, int> _categoryIndexMap = {};
  String? currentVisibleCategoryId;
  final List<String> _orderCategory = [];

  @override
  void initState() {
    super.initState();
    _itemPositionsListener.itemPositions.addListener(_onScroll);
    context.read<FoodListBloc>().add(LoadFoodList());
    
  }

  @override
  void dispose() {
    _itemPositionsListener.itemPositions.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    if (_itemPositionsListener.itemPositions.value.isEmpty) {
      print('DEBUG: ScrollablePositionedList: No visible items.');
      return;
    }

    if (_orderCategory.isEmpty) {
      print('DEBUG: _orderCategory is Empty');
      return;
    }

    final firstVisiblePosition = _itemPositionsListener.itemPositions.value.first;
    final int visibleIndex = firstVisiblePosition.index;

    print('DEBUG: Scroll Detected. First visible item index: $visibleIndex');
    print('DEBUG: _orderedCategoryIds length: ${_orderCategory.length}');

    if (visibleIndex >= 0 && visibleIndex < _orderCategory.length) {
      final String visibleCategoryId = _orderCategory[visibleIndex];

      final currentBlocState = context.read<VisibleCategoryBloc>().state;

      if (currentBlocState == null ||
          currentBlocState.visibleCategoryId != visibleCategoryId) {
        print('DEBUG: Emitting UpdateVisibleCategory: $visibleCategoryId');
        context
            .read<VisibleCategoryBloc>()
            .add(UpdateVisibleCategory(visibleCategoryId));

        if (widget.onVisibleCategoryChanged != null) {
          widget.onVisibleCategoryChanged!(visibleCategoryId);
        }
      } else {
        print(
            'DEBUG: Visible category $visibleCategoryId already active. No emit.');
      }
    } else {
      print(
          'DEBUG: Index $visibleIndex out of bounds for _orderedCategoryIds (length ${_orderCategory.length}).');
    }
  }

  @override
  void didUpdateWidget(FoodListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final foodListState = context.read<FoodListBloc>().state;

    if (widget.selectedFoodSetId != oldWidget.selectedFoodSetId) {
      if (foodListState is FoodItemLoaded) {
        final foodCategoryState = context.read<FoodCategoryBloc>().state;
        Map<String, String> categoryNameMap = {};
        if (foodCategoryState is FoodCategoryLoaded) {
          categoryNameMap = {
            for (var cat in foodCategoryState.categories)
              cat.foodCatId: cat.foodCatName
          };
        }

        final filteredAndGroupedFood = _filterAndGroupFood(
          foodListState.foodItem,
          widget.searchText,
          widget.selectedFoodSetId,
          categoryNameMap,
        );

        final firstCategoryId = filteredAndGroupedFood.isNotEmpty
            ? filteredAndGroupedFood.first.key
            : null;

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
      print(
          'DEBUG: Selected category ID changed to ${widget.selectedFoodCatId}. Scrolling...');
      Future.delayed(const Duration(milliseconds: 300), () {
        _scrollToCategory(widget.selectedFoodCatId!);
      });
    }
  }

  void _scrollToCategory(String categoryId) {
    final index = _categoryIndexMap[categoryId];
    if (index != null) {
      print('DEBUG: Scrolling to category $categoryId at index $index');
      _scrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    } else {
      print(
          'DEBUG: No index found for categoryId: $categoryId in _categoryIndexMap.');
    }
  }

  List<MapEntry<String, List<FoodData>>> _filterAndGroupFood(
    List<FoodData> foodItems,
    String searchText,
    String selectedFoodSetId,
    Map<String, String> categoryNameMap,
  ) {
    final filteredFood = foodItems.where((food) {
      final matchSearch = searchText.isEmpty ||
          food.foodName.toLowerCase().contains(searchText.toLowerCase());
      final matchSetId =
          selectedFoodSetId.isEmpty || food.foodSetId == selectedFoodSetId;
      return matchSearch && matchSetId;
    }).toList();

    final Map<String, List<FoodData>> groupedFood = {};
    for (var food in filteredFood) {
      groupedFood.putIfAbsent(food.foodCatId, () => []).add(food);
    }

    final sortedEntries = groupedFood.entries.toList()
      ..sort((a, b) {
        final nameA = categoryNameMap[a.key] ?? 'Other';
        final nameB = categoryNameMap[b.key] ?? 'Other';

        if (nameA == 'Other' && nameB == 'Other') return 0;
        if (nameA == 'Other') return 1;
        if (nameB == 'Other') return -1;
        return nameA.compareTo(nameB);
      });
    return sortedEntries;
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
                    final nameA = categoryNameMap[a.key] ?? 'Orther';
                    final nameB = categoryNameMap[b.key] ?? 'Orther';

                    if (nameA == 'Orther' && nameB == 'Orther') return 0;
                    if (nameA == 'Orther') return 1;
                    if (nameB == 'Orther') return -1;
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
                    final categoryName = categoryNameMap[categoryId] ?? 'Other';
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
                                                          const SizedBox(
                                                            child: Center(
                                                              child: Icon(
                                                                Icons
                                                                    .broken_image,
                                                                color:
                                                                    Colors.grey,
                                                              ),
                                                            ),
                                                          )),
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
                                                    isOutOfStock
                                                        ? 'Out of Stock'
                                                        : '\$${food.foodPrice}',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: isOutOfStock
                                                          ? Colors.red
                                                          : Colors.black,
                                                      fontSize: 16,
                                                      decoration: isOutOfStock
                                                          ? TextDecoration
                                                              .underline
                                                          : TextDecoration.none,
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
