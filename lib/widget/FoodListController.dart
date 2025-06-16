// ignore_for_file: file_names, avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_project_test/bloc/bloc_VisibleCategory.dart';
import 'package:kiosk_project_test/bloc/bloc_cetagoryfood.dart';
import 'package:kiosk_project_test/bloc/bloc_food_data.dart';
import 'package:kiosk_project_test/data/Data_food.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class FoodListController {
  final ItemScrollController _scrollController = ItemScrollController();
  final ItemPositionsListener itemPositionsListener;
  final Map<String, int> _categoryIndexMap = {};
  List<String> _orderCategory = [];
  final Function(String)? onCategoryChanged;

  ItemScrollController get scrollController => _scrollController;
  List<String> get orderCategory => _orderCategory;


  FoodListController({
    required this.itemPositionsListener,
    this.onCategoryChanged,
  });

  void init(BuildContext context) {
   
  }

  void dispose() {
    itemPositionsListener.itemPositions.removeListener(() {});
  }

  void onScroll(BuildContext context) {
    if (itemPositionsListener.itemPositions.value.isEmpty) {
      print('DEBUG: ScrollablePositionedList: No visible items.');
      return;
    }

    if (_orderCategory.isEmpty) {
      print('DEBUG: _orderCategory is Empty. Cannot determine visible category.');
      return;
    }

    final Iterable<ItemPosition> visibleItems =
        itemPositionsListener.itemPositions.value.where((position) {
      return position.itemLeadingEdge >= 0 && position.itemLeadingEdge < 1;
    });

    if (visibleItems.isEmpty) {
      print('DEBUG: No fully visible items found.');
      return;
    }

    final firstVisiblePosition = visibleItems.reduce((a, b) =>
        a.itemLeadingEdge < b.itemLeadingEdge ||
                (a.itemLeadingEdge == b.itemLeadingEdge && a.index < b.index)
            ? a
            : b);

    final int visibleIndex = firstVisiblePosition.index;

    print('DEBUG: Scroll Detected. First visible item index: $visibleIndex');
    print('DEBUG: _orderCategory length: ${_orderCategory.length}');

    if (visibleIndex >= 0 && visibleIndex < _orderCategory.length) {
      final String visibleCategoryId = _orderCategory[visibleIndex];

      final currentBlocState = context.read<VisibleCategoryBloc>().state;

      if (currentBlocState == null ||
          currentBlocState.visibleCategoryId != visibleCategoryId) {
        print('DEBUG: Emitting UpdateVisibleCategory: $visibleCategoryId');
        context
            .read<VisibleCategoryBloc>()
            .add(UpdateVisibleCategory(visibleCategoryId));
      } else {
        print(
            'DEBUG: Visible category $visibleCategoryId already active. No emit.');
      }
    } else {
      print(
          'DEBUG: Index $visibleIndex out of bounds for _orderCategory (length ${_orderCategory.length}).');
    }
  }

  void didUpdateWidget(
    String oldSelectedFoodSetId,
    String newSelectedFoodSetId,
    String? oldSelectedFoodCatId,
    String? newSelectedFoodCatId,
    BuildContext context,
    String searchText,
  ) {
    if (newSelectedFoodSetId != oldSelectedFoodSetId) {
      
      final foodListState = context.read<FoodListBloc>().state;
      final foodCategoryState = context.read<FoodCategoryBloc>().state;

      if (foodListState is FoodItemLoaded && foodCategoryState is FoodCategoryLoaded) {
        Map<String, String> categoryNameMap = {
          for (var cat in foodCategoryState.categories)
            cat.foodCatId: cat.foodCatName
        };

        final filteredAndGroupedFood = filterAndGroupFood(
          foodListState.foodItem,
          searchText,
          newSelectedFoodSetId,
          categoryNameMap,
        );

        updateCategoryOrderAndMap(filteredAndGroupedFood);

        final firstCategoryId = filteredAndGroupedFood.isNotEmpty
            ? filteredAndGroupedFood.first.key
            : null;

        if (firstCategoryId != null && newSelectedFoodCatId != firstCategoryId) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToCategory(firstCategoryId);
            if (onCategoryChanged != null) {
              onCategoryChanged!(firstCategoryId);
            }
            context
                .read<VisibleCategoryBloc>()
                .add(UpdateVisibleCategory(firstCategoryId));
          });
        } else if (firstCategoryId != null && newSelectedFoodCatId == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context
                .read<VisibleCategoryBloc>()
                .add(UpdateVisibleCategory(firstCategoryId));
          });
        }
      }
    }

    if (newSelectedFoodCatId != null &&
        newSelectedFoodCatId != oldSelectedFoodCatId) {
      print(
          'DEBUG: Selected category ID changed to $newSelectedFoodCatId. Scrolling...');
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToCategory(newSelectedFoodCatId);
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
          'DEBUG: No index found for categoryId: $categoryId in _categoryIndexMap. _categoryIndexMap: $_categoryIndexMap');
    }
  }

  List<MapEntry<String, List<FoodData>>> filterAndGroupFood(
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

  void updateCategoryOrderAndMap(
      List<MapEntry<String, List<FoodData>>> sortedEntries) {
    _orderCategory = sortedEntries.map((entry) => entry.key).toList();
    _categoryIndexMap.clear();
    for (int i = 0; i < _orderCategory.length; i++) {
      _categoryIndexMap[_orderCategory[i]] = i;
    }
  }
}