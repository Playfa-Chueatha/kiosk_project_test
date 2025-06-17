import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kiosk_project_test/data/Data_food.dart';

// Events
abstract class FoodListEvent extends Equatable {
  const FoodListEvent();

  @override
  List<Object> get props => [];
}

class LoadFoodList extends FoodListEvent {}

class FilterFoodByCategory extends FoodListEvent {
  final String categoryId;

  const FilterFoodByCategory(this.categoryId);

  @override
  List<Object> get props => [categoryId];
}


class ClearFoodFilter extends FoodListEvent {}


abstract class FoodSetState extends Equatable {
  const FoodSetState();

  @override
  List<Object> get props => [];
}

class FoodSetLoading extends FoodSetState {}

class FoodSetError extends FoodSetState {
  final String message;

  const FoodSetError(this.message);

  @override
  List<Object> get props => [message];
}

class FoodItemLoaded extends FoodSetState {
  final List<FoodData> foodItem;

  const FoodItemLoaded(this.foodItem);

  @override
  List<Object> get props => [foodItem];
}

// Bloc
class FoodListBloc extends Bloc<FoodListEvent, FoodSetState> {
  List<FoodData> _allFoodItems = [];

  FoodListBloc() : super(FoodSetLoading()) {
    on<LoadFoodList>(_onLoadFoodList);
    on<FilterFoodByCategory>(_onFilterFoodByCategory);
    on<ClearFoodFilter>(_onClearFoodFilter);
  }

  Future<void> _onLoadFoodList(
    LoadFoodList event,
    Emitter<FoodSetState> emit,
  ) async {
    try {
      emit(FoodSetLoading());

      final String response =
          await rootBundle.loadString('assets/data/data_test.json');
      final Map<String, dynamic> decodedData = json.decode(response);

      final List<dynamic> foodRaw = decodedData['result']['food'] as List;
      _allFoodItems = foodRaw.map((item) => FoodData.fromJson(item)).toList();

      emit(FoodItemLoaded(List<FoodData>.from(_allFoodItems)));
    } catch (e) {
      emit(FoodSetError('Failed to load food items: ${e.toString()}'));
    }
  }

  void _onFilterFoodByCategory(
    FilterFoodByCategory event,
    Emitter<FoodSetState> emit,
  ) {
    if (_allFoodItems.isEmpty) {
      emit(const FoodSetError('No food items loaded'));
      return;
    }

    
    if (event.categoryId.isEmpty || event.categoryId == 'all') {
      emit(FoodItemLoaded(List<FoodData>.from(_allFoodItems)));
      return;
    }

    final filteredItems = _allFoodItems
        .where((food) => food.foodCatId == event.categoryId)
        .toList();

    emit(FoodItemLoaded(filteredItems));
  }

  void _onClearFoodFilter(
    ClearFoodFilter event,
    Emitter<FoodSetState> emit,
  ) {
    
    emit(FoodItemLoaded(List<FoodData>.from(_allFoodItems)));
  }
}
