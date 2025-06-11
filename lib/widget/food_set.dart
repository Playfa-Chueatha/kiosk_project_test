import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_project_test/bloc/bloc_nationalcetagoryfood.dart';
import 'package:kiosk_project_test/data/Data_FoodSet.dart';



class NationalFoodCategory extends StatefulWidget {
  final void Function(FoodSet selectedFoodSet) onSelected;

  const NationalFoodCategory({super.key, required this.onSelected});

  @override
  State<NationalFoodCategory> createState() => _NationalFoodCategoryState();
}

class _NationalFoodCategoryState extends State<NationalFoodCategory> {
  String? selectedCategoryId;

  @override
  void initState() {
    super.initState();
    BlocProvider.of<FoodSetBloc>(context).add(LoadFoodSets());
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FoodSetBloc, FoodSetState>(
      builder: (context, state) {
        if (state is FoodSetLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FoodSetLoaded) {
          final foodSets = state.foodSets;

          if (selectedCategoryId == null && foodSets.isNotEmpty) {
            final defaultFoodSet = foodSets.firstWhere(
              (e) => e.foodSetName == 'Thai Menu',
              orElse: () => foodSets.first,
            );
            selectedCategoryId = defaultFoodSet.foodSetId;

            WidgetsBinding.instance.addPostFrameCallback((_) {
              widget.onSelected(defaultFoodSet);
            });
          }

          final double screenHeight = MediaQuery.of(context).size.height;
          final double screenWidth = MediaQuery.of(context).size.width;

          final double listViewAvailableHeight = (screenHeight * 0.15) - (20 * 2);
          final double targetButtonHeight = listViewAvailableHeight - (4 * 2);

          final double responsiveFontSize = 16.0 * (screenWidth / 600.0);
          final double clampedFontSize = responsiveFontSize.clamp(12.0, 20.0);

          double maxTextWidth = 0;
          for (var foodSet in foodSets) {
            final TextPainter textPainter = TextPainter(
              text: TextSpan(
                text: foodSet.foodSetName,
                style: TextStyle(fontSize: clampedFontSize),
              ),
              textDirection: TextDirection.ltr,
            )..layout(minWidth: 0, maxWidth: double.infinity);
            if (textPainter.width > maxTextWidth) {
              maxTextWidth = textPainter.width;
            }
          }

          const double buttonHorizontalPadding = 12.0 * 2;
          const double buttonPaddingAround = 8.0 * 2;
          final double minimumButtonWidth = maxTextWidth + buttonHorizontalPadding + buttonPaddingAround;

          return SizedBox(
            height: listViewAvailableHeight,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: foodSets.length,
              itemBuilder: (context, index) {
                final foodSet = foodSets[index];
                final bool isSelected = selectedCategoryId == foodSet.foodSetId;

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? const Color(0xFF673AB7) : const Color(0xFFF6F6F6),
                      padding: const EdgeInsets.all(12),
                      minimumSize: Size(minimumButtonWidth, targetButtonHeight),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(targetButtonHeight / 2),
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        selectedCategoryId = foodSet.foodSetId;
                      });
                      widget.onSelected(foodSet);
                    },
                    child: Text(
                      foodSet.foodSetName,
                      style: TextStyle(
                        fontSize: clampedFontSize,
                        color: isSelected ? Colors.white : const Color(0xFF673AB7),
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
        } else if (state is FoodSetError) {
          return Center(child: Text('เกิดข้อผิดพลาด: ${state.message}'));
        } else {
          return const Center(child: Text('ไม่มีข้อมูล'));
        }
      },
    );
  }
}
