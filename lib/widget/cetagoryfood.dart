import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_project_test/bloc/bloc_VisibleCategory.dart';
import 'package:kiosk_project_test/bloc/bloc_cetagoryfood.dart';
import 'package:kiosk_project_test/bloc/bloc_food_data.dart';

class CategoryFood extends StatefulWidget {
  final String selectedFoodSetId;
  final String? currentVisibleCategoryId;

  const CategoryFood({
    super.key,
    required this.selectedFoodSetId,
    this.currentVisibleCategoryId,
  });

  @override
  State<CategoryFood> createState() => _CategoryFoodState();
}

class _CategoryFoodState extends State<CategoryFood> {
  double? _maxButtonWidth;
  final ScrollController _scrollController = ScrollController();

  String? currentVisibleCategoryId;
  bool _hasInitialized = false;
  bool _isManualSelection = false;

  @override
  void initState() {
    super.initState();

    BlocProvider.of<FoodCategoryBloc>(context).add(LoadFoodCategories());
    BlocProvider.of<FoodListBloc>(context).add(LoadFoodList());

    final visibleCategoryState = context.read<VisibleCategoryBloc>().state;
    currentVisibleCategoryId = visibleCategoryState.visibleCategoryId;

    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_maxButtonWidth == null || _isManualSelection) return;

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
          .toList()
        ..sort((a, b) => a.foodCatSorting.compareTo(b.foodCatSorting));

      if (visibleIndex >= 0 && visibleIndex < filteredCategories.length) {
        final visibleCategoryId = filteredCategories[visibleIndex].foodCatId;

        context
            .read<VisibleCategoryBloc>()
            .add(MouseScrollCategoryChanged(visibleCategoryId));
      }
    }
  }

  void _scrollToSelectedCategory() {
    if (_maxButtonWidth == null || currentVisibleCategoryId == null) return;

    _isManualSelection = true;

    final foodCategoryState = context.read<FoodCategoryBloc>().state;
    if (foodCategoryState is! FoodCategoryLoaded) return;

    final filteredCategories = foodCategoryState.categories.where((cat) {
      final filteredFoodList = context.read<FoodListBloc>().state;
      if (filteredFoodList is FoodItemLoaded) {
        return filteredFoodList.foodItem.any((food) =>
            food.foodSetId == widget.selectedFoodSetId &&
            food.foodCatId == cat.foodCatId);
      }
      return false;
    }).toList()
      ..sort((a, b) => a.foodCatSorting.compareTo(b.foodCatSorting));

    final selectedIndex = filteredCategories
        .indexWhere((cat) => cat.foodCatId == currentVisibleCategoryId);

    if (selectedIndex != -1) {
      final targetOffset = selectedIndex * _maxButtonWidth!;
      _scrollController
          .animateTo(
            targetOffset,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          )
          .then((_) => _isManualSelection = false);
    } else {
      _isManualSelection = false;
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

    return BlocListener<VisibleCategoryBloc, VisibleCategoryState>(
      listener: (context, newState) {
        if (!mounted) return;
        if (newState.visibleCategoryId != currentVisibleCategoryId) {
          setState(() {
            currentVisibleCategoryId = newState.visibleCategoryId;
          });

          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _scrollToSelectedCategory();
          });
        }
      },
      child: BlocBuilder<FoodListBloc, FoodSetState>(
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
                    .toList()
                  ..sort((a, b) => a.foodCatName.toLowerCase().compareTo(b.foodCatName.toLowerCase()));


                if (!_hasInitialized && filteredCategories.isNotEmpty) {
                  _hasInitialized = true;
                  if (currentVisibleCategoryId == null ||
                      !filteredCategories.any(
                          (cat) => cat.foodCatId == currentVisibleCategoryId)) {
                    currentVisibleCategoryId =
                        filteredCategories.first.foodCatId;
                    context
                        .read<VisibleCategoryBloc>()
                        .add(UpdateVisibleCategory(currentVisibleCategoryId!));
                  }

                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    _scrollToSelectedCategory();
                  });
                }

                if (_maxButtonWidth == null && filteredCategories.isNotEmpty) {
                  double maxWidth = 0;
                  for (var cat in filteredCategories) {
                    double w = _calculateTextWidth(cat.foodCatName, textStyle);
                    if (w > maxWidth) maxWidth = w;
                  }

                  SchedulerBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) return;
                    setState(() {
                      _maxButtonWidth = maxWidth + 40;
                    });
                  });
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
                          currentVisibleCategoryId == category.foodCatId;

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
                          if (!isSelected) {
                            // print('เลือกหมวดหมู่:${category.foodCatId}');
                            _isManualSelection = true;
                            context
                                .read<VisibleCategoryBloc>()
                                .add(UpdateVisibleCategory(category.foodCatId));
                            currentVisibleCategoryId = category.foodCatId;

                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              if (!mounted) return;
                              _scrollToSelectedCategory();
                            });
                          }
                        },
                        child: Container(
                          width: _maxButtonWidth,
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
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
