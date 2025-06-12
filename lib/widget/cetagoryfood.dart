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
  double? maxButtonWidth;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FoodCategoryBloc>(context).add(LoadFoodCategories());
    BlocProvider.of<FoodListBloc>(context).add(LoadFoodLsit());
  }

  @override
  void didUpdateWidget(covariant CategoryFood oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedFoodSetId != oldWidget.selectedFoodSetId) {
      setState(() {
        selectedCategoryId = null;
        maxButtonWidth = null; // รีเซ็ตความกว้างเมื่อเปลี่ยน foodSet
      });
      BlocProvider.of<FoodCategoryBloc>(context).add(LoadFoodCategories());
      BlocProvider.of<FoodListBloc>(context).add(LoadFoodLsit());
    }
  }

  double calculateTextWidth(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: double.infinity);
    return textPainter.size.width;
  }

  void _scrollToIndex(int index) {
    if (maxButtonWidth == null) return;
    final targetOffset = index * maxButtonWidth!;
    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
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

                if (selectedCategoryId == null &&
                    filteredCategories.isNotEmpty) {
                  selectedCategoryId = filteredCategories.first.foodCatId;
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    widget.onCategorySelected(selectedCategoryId!);
                  });
                }

                if (maxButtonWidth == null && filteredCategories.isNotEmpty) {
                  double maxWidth = 0;
                  for (var cat in filteredCategories) {
                    double w = calculateTextWidth(cat.foodCatName, textStyle);
                    if (w > maxWidth) maxWidth = w;
                  }
                  maxWidth += 40;
                  maxButtonWidth = maxWidth;
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
                          selectedCategoryId == category.foodCatId;

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategoryId = category.foodCatId;
                          });
                          widget.onCategorySelected(category.foodCatId);
                          _scrollToIndex(index);
                        },
                        child: Container(
                          width: maxButtonWidth,
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
