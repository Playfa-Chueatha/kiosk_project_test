import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_project_test/bloc/bloc_cetagoryfood.dart';
import 'package:kiosk_project_test/bloc/bloc_food_data.dart';
import 'package:kiosk_project_test/data/Data_food.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:kiosk_project_test/bloc/bloc_VisibleCategory.dart';

class CategoryFood extends StatefulWidget {
  final String selectedFoodSetId;
  final ValueChanged<String> onCategorySelected;
  final String? currentVisibleCategoryId;
  final ValueChanged<String> onVisibleCategoryChanged;

  const CategoryFood({
    super.key,
    required this.selectedFoodSetId,
    required this.onCategorySelected,
    this.currentVisibleCategoryId,
    required this.onVisibleCategoryChanged,
  });

  @override
  State<CategoryFood> createState() => _CategoryFoodState();
}

class _CategoryFoodState extends State<CategoryFood> {
  String? _selectedCategoryIdInternal;
  double? _maxButtonWidth;
  List<FoodData> currentFoodList = [];

  final ScrollController _scrollController = ScrollController();
  final ItemPositionsListener itemPositionsListener = ItemPositionsListener.create();

  void _onScrollChanged() {
    final positions = itemPositionsListener.itemPositions.value;

    if (positions.isNotEmpty && currentFoodList.isNotEmpty) {
      final firstVisible = positions
          .where((p) => p.itemLeadingEdge >= 0)
          .reduce((a, b) => a.itemLeadingEdge < b.itemLeadingEdge ? a : b);

      final index = firstVisible.index;

      if (index < currentFoodList.length) {
        final foodItem = currentFoodList[index];
        final currentVisibleCategoryId = foodItem.foodCatId;

        context.read<VisibleCategoryBloc>().add(UpdateVisibleCategory(currentVisibleCategoryId));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    itemPositionsListener.itemPositions.addListener(_onScrollChanged);
    context.read<FoodCategoryBloc>().add(LoadFoodCategories());
    context.read<FoodListBloc>().add(LoadFoodList());
  }

  @override
  void didUpdateWidget(covariant CategoryFood oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedFoodSetId != oldWidget.selectedFoodSetId) {
      setState(() {
        _selectedCategoryIdInternal = null;
        _maxButtonWidth = null;
      });
    }

    if (widget.currentVisibleCategoryId != oldWidget.currentVisibleCategoryId &&
        widget.currentVisibleCategoryId != null) {
      setState(() {
        _selectedCategoryIdInternal = widget.currentVisibleCategoryId;
      });
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedCategory();
      });
    }
  }

  double _calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }

  void _scrollToSelectedCategory() {
    if (_maxButtonWidth == null || _selectedCategoryIdInternal == null) return;

    final foodCategoryState = context.read<FoodCategoryBloc>().state;
    if (foodCategoryState is! FoodCategoryLoaded) return;

    final foodListState = context.read<FoodListBloc>().state;
    if (foodListState is! FoodItemLoaded) return;

    final filteredFood = foodListState.foodItem
        .where((food) => food.foodSetId == widget.selectedFoodSetId)
        .toList();

    final usedCategoryIds = filteredFood.map((food) => food.foodCatId).toSet();

    final filteredCategories = foodCategoryState.categories
        .where((cat) => usedCategoryIds.contains(cat.foodCatId))
        .toList();

    filteredCategories
        .sort((a, b) => a.foodCatSorting.compareTo(b.foodCatSorting));

    final selectedIndex = filteredCategories
        .indexWhere((cat) => cat.foodCatId == _selectedCategoryIdInternal);

    if (selectedIndex != -1) {
      final targetOffset = selectedIndex * _maxButtonWidth!;
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final baseHeight = screenHeight * 0.1;
    final listViewHeight = baseHeight.clamp(60.0, 100.0);
    final fontSize = (16.0 * (screenWidth / 600.0)).clamp(12.0, 20.0);

    final textStyle = TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
    );

    return BlocBuilder<FoodListBloc, FoodSetState>(
      builder: (context, foodState) {
        if (foodState is FoodItemLoaded) {
          final allFood = foodState.foodItem;

          final filteredFood = allFood
              .where((food) => food.foodSetId == widget.selectedFoodSetId)
              .toList();
          currentFoodList = filteredFood;
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

                filteredCategories.sort(
                    (a, b) => a.foodCatSorting.compareTo(b.foodCatSorting));

                if (_selectedCategoryIdInternal == null &&
                    filteredCategories.isNotEmpty) {
                  _selectedCategoryIdInternal =
                      filteredCategories.first.foodCatId;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    widget.onCategorySelected(_selectedCategoryIdInternal!);
                  });
                }

                if (_maxButtonWidth == null && filteredCategories.isNotEmpty) {
                  double maxWidth = 0;
                  for (var cat in filteredCategories) {
                    double w = _calculateTextWidth(cat.foodCatName, textStyle);
                    if (w > maxWidth) maxWidth = w;
                  }
                  maxWidth += 40;
                  _maxButtonWidth = maxWidth;
                }

                return SizedBox(
                  height: listViewHeight,
                  child: ListView.builder(
                    controller: _scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: filteredCategories.length,
                    itemBuilder: (context, index) {
                      final category = filteredCategories[index];
                      final isSelected =
                          _selectedCategoryIdInternal == category.foodCatId;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedCategoryIdInternal = category.foodCatId;
                          });
                          widget.onCategorySelected(category.foodCatId);
                          _scrollToSelectedCategory();
                        },
                        child: Container(
                          width: _maxButtonWidth,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF02CCFE)
                                : const Color(0xFFF6F6F6),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  index == 0 ? 12 : (isSelected ? 12 : 0)),
                              bottomLeft: Radius.circular(
                                  index == 0 ? 12 : (isSelected ? 12 : 0)),
                              topRight: Radius.circular(
                                  index == filteredCategories.length - 1
                                      ? 12
                                      : (isSelected ? 12 : 0)),
                              bottomRight: Radius.circular(
                                  index == filteredCategories.length - 1
                                      ? 12
                                      : (isSelected ? 12 : 0)),
                            ),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            category.foodCatName,
                            style: textStyle.copyWith(
                              color: isSelected ? Colors.white : Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
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