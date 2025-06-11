import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_project_test/bloc/bloc_cetagoryfood.dart';

class CategoryFood extends StatefulWidget {
  const CategoryFood({super.key});

  @override
  State<CategoryFood> createState() => _CategoryFoodState();
}

class _CategoryFoodState extends State<CategoryFood> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<FoodCategoryBloc>(context).add(LoadFoodCategories());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodCategoryBloc, FoodCategoryState>(
      builder: (context, state) {
        if (state is FoodCategoryLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FoodCategoryLoaded) {
          final double screenHeight = MediaQuery.of(context).size.height;
          final double screenWidth = MediaQuery.of(context).size.width;

          final double listViewAvailableHeight = (screenHeight * 0.15) - (20 * 2);
          final double targetButtonHeight = listViewAvailableHeight - (4 * 2);

          final double responsiveFontSize = 16.0 * (screenWidth / 600.0);
          final double clampedFontSize = responsiveFontSize.clamp(12.0, 20.0);

          double maxTextWidth = 0;
          for (var category in state.categories) {
            final TextPainter textPainter = TextPainter(
              text: TextSpan(
                text: category.foodCatName,
                style: TextStyle(fontSize: clampedFontSize),
              ),
              textDirection: TextDirection.ltr,
            )..layout(minWidth: 0, maxWidth: double.infinity);
            maxTextWidth = max(maxTextWidth, textPainter.width);
          }

          const double buttonHorizontalPadding = 12.0 * 2;
          const double buttonPaddingAround = 8.0 * 2;

          final double minimumButtonWidth = maxTextWidth + buttonHorizontalPadding + buttonPaddingAround;

          return SizedBox(
            height: listViewAvailableHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: state.categories.length,
              itemBuilder: (context, index) {
                final category = state.categories[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF6F6F6),
                      padding: const EdgeInsetsDirectional.all(12),
                      minimumSize: Size(minimumButtonWidth, targetButtonHeight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(targetButtonHeight / 2),
                      ),
                    ),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('เลือก: ${category.foodCatName}')),
                      );
                    },
                    child: Text(
                      category.foodCatName,
                      style: TextStyle(
                        fontSize: clampedFontSize,
                        color: const Color(0xFF673AB7),
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
  }
}
