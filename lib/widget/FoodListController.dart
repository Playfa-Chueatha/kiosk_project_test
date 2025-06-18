// ignore_for_file: file_names

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
  String? _lastVisibleCategoryId;
  bool _isScrolling = false;
  bool _isProgrammaticScrolling = false;

  ItemScrollController get scrollController => _scrollController;
  List<String> get orderCategory => _orderCategory;

  FoodListController({
    required this.itemPositionsListener,
    this.onCategoryChanged,
  });

  void init(BuildContext context) {
    itemPositionsListener.itemPositions.addListener(() => onScroll(context));
  }

  void dispose() {}

  void onScroll(BuildContext context) {
  if (_isScrolling) return; 
  if (_isProgrammaticScrolling) return; 

  _isScrolling = true;

  Future.delayed(const Duration(milliseconds: 100), () {
    final positions = itemPositionsListener.itemPositions.value;
    if (positions.isEmpty) {
      _isScrolling = false;
      return;
    }
    if (_orderCategory.isEmpty) {
      _isScrolling = false;
      return;
    }

    final visibleItems = positions.where((position) =>
        position.itemLeadingEdge >= 0 && position.itemLeadingEdge < 1);

    if (visibleItems.isEmpty) {
      _isScrolling = false;
      return;
    }

    final firstVisiblePosition = visibleItems.reduce((a, b) =>
        a.itemLeadingEdge < b.itemLeadingEdge ||
                (a.itemLeadingEdge == b.itemLeadingEdge && a.index < b.index)
            ? a
            : b);

    final int visibleIndex = firstVisiblePosition.index;

    if (visibleIndex >= 0 && visibleIndex < _orderCategory.length) {
      final visibleCategoryId = _orderCategory[visibleIndex];

      if (_lastVisibleCategoryId != visibleCategoryId) {
        _lastVisibleCategoryId = visibleCategoryId;

        context.read<VisibleCategoryBloc>().add(UpdateVisibleCategory(visibleCategoryId));

        if (onCategoryChanged != null) {
          onCategoryChanged!(visibleCategoryId);
        }
      }
    }

    _isScrolling = false;
  });
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

      if (foodListState is FoodItemLoaded &&
          foodCategoryState is FoodCategoryLoaded) {
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

        if (firstCategoryId != null &&
            newSelectedFoodCatId != firstCategoryId) {
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
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollToCategory(newSelectedFoodCatId);
      });
    }
  }

  void _scrollToCategory(String categoryId) {
    final index = _categoryIndexMap[categoryId];
    if (index != null) {
      _isProgrammaticScrolling = true;
      _scrollController.scrollTo(
        index: index,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      ).then((_) {
        
        _isProgrammaticScrolling = false;
      });
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
    _orderCategory = sortedEntries.map((e) => e.key).toList();
    _categoryIndexMap.clear();
    for (int i = 0; i < sortedEntries.length; i++) {
      _categoryIndexMap[sortedEntries[i].key] = i;
    }
  }
}