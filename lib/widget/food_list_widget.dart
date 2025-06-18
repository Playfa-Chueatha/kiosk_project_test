// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_project_test/widget/FoodListController.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:kiosk_project_test/bloc/bloc_VisibleCategory.dart';
import 'package:kiosk_project_test/bloc/bloc_food_data.dart';
import 'package:kiosk_project_test/bloc/bloc_cetagoryfood.dart';
import 'package:kiosk_project_test/data/Data_food.dart';

class FoodList extends StatefulWidget {
  final Function(FoodData) onFoodSelected;
  final String searchText, selectedFoodSetId;
  final String? selectedFoodCatId;
  final Function(String)? onCategoryChanged;
  final Function(String)? onVisibleCategoryChanged;

  const FoodList({
    super.key,
    required this.onFoodSelected,
    required this.searchText,
    required this.selectedFoodSetId,
    this.selectedFoodCatId,
    this.onCategoryChanged,
    this.onVisibleCategoryChanged,
  });

  @override
  State<FoodList> createState() => _FoodListWidgetState();
}

class _FoodListWidgetState extends State<FoodList> {
  late final FoodListController _controller = FoodListController(
    itemPositionsListener: ItemPositionsListener.create(),
    onCategoryChanged: widget.onCategoryChanged,
  );

  @override
  void initState() {
    super.initState();
    _controller.init(context);
    _controller.itemPositionsListener.itemPositions
        .addListener(() => _controller.onScroll(context));
    context.read<FoodListBloc>().add(LoadFoodList());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(FoodList oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.didUpdateWidget(
      oldWidget.selectedFoodSetId,
      widget.selectedFoodSetId,
      oldWidget.selectedFoodCatId,
      widget.selectedFoodCatId,
      context,
      widget.searchText,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final scaleFactor = screenWidth / 600;

    return BlocBuilder<FoodCategoryBloc, FoodCategoryState>(
      builder: (context, catState) {
        if (catState is! FoodCategoryLoaded) {
          return const Center(child: CircularProgressIndicator());
        }

        final categoryNameMap = {
          for (var cat in catState.categories) cat.foodCatId: cat.foodCatName
        };

        return BlocBuilder<FoodListBloc, FoodSetState>(
          builder: (context, state) {
            if (state is! FoodItemLoaded) {
              if (state is FoodSetLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is FoodSetError) {
                return Center(child: Text('เกิดข้อผิดพลาด: ${state.message}'));
              }
              return const Center(child: Text('ไม่มีข้อมูลอาหาร'));
            }

            final sortedEntries = _controller.filterAndGroupFood(
              state.foodItem,
              widget.searchText,
              widget.selectedFoodSetId,
              categoryNameMap,
            );
            _controller.updateCategoryOrderAndMap(sortedEntries);

            if (_controller.orderCategory.isNotEmpty &&
                widget.selectedFoodCatId == null) {
              final initialId = _controller.orderCategory.first;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                context
                    .read<VisibleCategoryBloc>()
                    .add(UpdateVisibleCategory(initialId));
                widget.onCategoryChanged?.call(initialId);
              });
            }

            return ScrollablePositionedList.builder(
              itemScrollController: _controller.scrollController,
              itemPositionsListener: _controller.itemPositionsListener,
              itemCount: sortedEntries.length,
              itemBuilder: (context, index) {
                final entry = sortedEntries[index];
                final items = entry.value;
                final categoryName = categoryNameMap[entry.key] ?? 'Other';

                return Column(
                  key: ValueKey(entry.key),
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 4.0),
                      child: Text(
                        categoryName,
                        style: TextStyle(
                            fontSize: 20 * scaleFactor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: items.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _getCrossAxisCount(
                            screenWidth, MediaQuery.of(context).orientation),
                        crossAxisSpacing: 5,
                        mainAxisSpacing: 5,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) => FoodCard(
                        food: items[index],
                        onSelected: widget.onFoodSelected,
                      ),
                    ),
                    SizedBox(height: 24 * scaleFactor),
                  ],
                );
              },
            );
          },
        );
      },
    );
  }

  int _getCrossAxisCount(double width, Orientation orientation) {
    if (width >= 1200) {
      return orientation == Orientation.portrait ? 2 : 4;
    } else if (width >= 600) {
      return orientation == Orientation.portrait ? 2 : 3;
    } else {
      return 2;
    }
  }
}

class FoodCard extends StatelessWidget {
  final FoodData food;
  final Function(FoodData) onSelected;

  const FoodCard({super.key, required this.food, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final isOut = food.isOutStock;
    return Opacity(
      opacity: isOut ? 0.5 : 1.0,
      child: Card(
        color: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: isOut ? null : () => onSelected(food),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    SizedBox.expand(
                      child: Image.network(
                        food.imageName,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            const Center(
                                child: Icon(Icons.broken_image,
                                    color: Colors.grey)),
                      ),
                    ),
                    if (isOut)
                      Positioned.fill(
                        child: Container(
                          color: Colors.white.withOpacity(0.4),
                          child: const Center(
                            child: Text(
                              'Out of Stock',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                              textAlign: TextAlign.center,
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
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food.foodName,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4F4F4F)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        food.foodDesc,
                        style: const TextStyle(color: Color(0xFF828282)),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Text(
                        isOut ? 'Out of Stock' : '\$${food.foodPrice}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isOut ? Colors.red : Colors.black,
                          fontSize: 16,
                          decoration: isOut
                              ? TextDecoration.underline
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
    );
  }
}
