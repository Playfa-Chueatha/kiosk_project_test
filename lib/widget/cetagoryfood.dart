import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_project_test/bloc/bloc_cetagoryfood.dart';
import 'package:kiosk_project_test/bloc/bloc_food_data.dart';

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
  double? _maxButtonWidth;
  final ScrollController _scrollController = ScrollController();

  bool _didCallInitialCategoryCallback = false;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FoodCategoryBloc>(context).add(LoadFoodCategories());
    BlocProvider.of<FoodListBloc>(context).add(LoadFoodList());

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_maxButtonWidth == null) return;

    final offset = _scrollController.offset;
    final visibleIndex = (offset / _maxButtonWidth!).round();

    final foodCategoryState = context.read<FoodCategoryBloc>().state;
    final foodListState = context.read<FoodListBloc>().state;

    if (foodCategoryState is FoodCategoryLoaded &&
        foodListState is FoodItemLoaded) {
      final filteredFood = foodListState.foodItem
          .where((food) => food.foodSetId == widget.selectedFoodSetId)
          .toList();

      final usedCategoryIds =
          filteredFood.map((food) => food.foodCatId).toSet();

      final filteredCategories = foodCategoryState.categories
          .where((cat) => usedCategoryIds.contains(cat.foodCatId))
          .toList();

      filteredCategories
          .sort((a, b) => a.foodCatSorting.compareTo(b.foodCatSorting));

      if (visibleIndex >= 0 && visibleIndex < filteredCategories.length) {
        final visibleCategoryId = filteredCategories[visibleIndex].foodCatId;

        if (visibleCategoryId != widget.currentVisibleCategoryId) {
          widget.onVisibleCategoryChanged(visibleCategoryId);
        }
      }
    }
  }

  void _scrollToSelectedCategory() {
    if (_maxButtonWidth == null || widget.currentVisibleCategoryId == null)
      return;

    final foodCategoryState = context.read<FoodCategoryBloc>().state;
    if (foodCategoryState is! FoodCategoryLoaded) return;

    final foodListState = context.read<FoodListBloc>().state;
    Set<String> usedCategoryIds = {};
    if (foodListState is FoodItemLoaded) {
      final filteredFood = foodListState.foodItem
          .where((food) => food.foodSetId == widget.selectedFoodSetId)
          .toList();
      usedCategoryIds = filteredFood.map((food) => food.foodCatId).toSet();
    } else {
      return;
    }

    final filteredCategories = foodCategoryState.categories
        .where((cat) => usedCategoryIds.contains(cat.foodCatId))
        .toList();

    filteredCategories
        .sort((a, b) => a.foodCatSorting.compareTo(b.foodCatSorting));

    final selectedIndex = filteredCategories
        .indexWhere((cat) => cat.foodCatId == widget.currentVisibleCategoryId);

    if (selectedIndex != -1) {
      final targetOffset = selectedIndex * _maxButtonWidth!;
      _scrollController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
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

  @override
  void didUpdateWidget(covariant CategoryFood oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.currentVisibleCategoryId != oldWidget.currentVisibleCategoryId &&
        widget.currentVisibleCategoryId != null) {
      print(
          'currentVisibleCategoryId changed: ${widget.currentVisibleCategoryId}');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedCategory();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(
        'CategoryFood build: selectedFoodSetId=${widget.selectedFoodSetId}, currentVisibleCategoryId=${widget.currentVisibleCategoryId}');
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
        if (foodState is! FoodItemLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final allFood = foodState.foodItem;
        final filteredFood = allFood
            .where((food) => food.foodSetId == widget.selectedFoodSetId)
            .toList();

        final usedCategoryIds =
            filteredFood.map((food) => food.foodCatId).toSet();

        return BlocBuilder<FoodCategoryBloc, FoodCategoryState>(
          builder: (context, catState) {
            if (catState is FoodCategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (catState is FoodCategoryLoaded) {
              final filteredCategories = catState.categories
                  .where((cat) => usedCategoryIds.contains(cat.foodCatId))
                  .toList();

              filteredCategories.sort((a, b) => a.foodCatName
                  .toLowerCase()
                  .compareTo(b.foodCatName.toLowerCase()));

              if (!_didCallInitialCategoryCallback &&
                  filteredCategories.isNotEmpty) {
                _didCallInitialCategoryCallback = true;
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  widget.onCategorySelected(filteredCategories.first.foodCatId);
                  widget.onVisibleCategoryChanged(
                      filteredCategories.first.foodCatId);
                });
              }

              if (_maxButtonWidth == null && filteredCategories.isNotEmpty) {
                double maxWidth = 0;
                for (var cat in filteredCategories) {
                  double w = _calculateTextWidth(cat.foodCatName, textStyle);
                  if (w > maxWidth) maxWidth = w;
                }
                // ตั้งค่า width และ rebuild
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _maxButtonWidth = maxWidth + 40;
                  });
                });
              } else if (filteredCategories.isEmpty) {
                _maxButtonWidth = 0;
              }

              if (filteredCategories.isEmpty) {
                return const Center(
                    child: Text('ไม่มีหมวดหมู่สำหรับชุดอาหารนี้'));
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
                        widget.currentVisibleCategoryId == category.foodCatId;

                    final borderRadius = BorderRadius.only(
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
                    );

                    return GestureDetector(
                      onTap: () {
                        if (widget.currentVisibleCategoryId !=
                            category.foodCatId) {
                          widget.onCategorySelected(category.foodCatId);
                          widget.onVisibleCategoryChanged(category.foodCatId);
                          _scrollToSelectedCategory();
                        }
                      },
                      child: Container(
                        width: _maxButtonWidth,
                        margin: const EdgeInsets.symmetric(horizontal: 2.0),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF02CCFE)
                              : const Color(0xFFF6F6F6),
                          borderRadius: borderRadius,
                        ),
                        child: Text(
                          category.foodCatName,
                          style: textStyle.copyWith(
                              color:
                                  isSelected ? Colors.white : Colors.black87),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (catState is FoodCategoryError) {
              return Center(
                  child: Text(
                      'เกิดข้อผิดพลาดในการโหลดหมวดหมู่: ${catState.message}'));
            } else {
              return const Center(child: Text('ไม่มีข้อมูลหมวดหมู่'));
            }
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
