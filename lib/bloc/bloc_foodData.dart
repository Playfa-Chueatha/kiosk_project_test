import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_project_test/data/Data_food.dart';

abstract class FoodListEvent {}

class LoadFoodLsit extends FoodListEvent {}

abstract class FoodSetState {}

class FoodSetLoading extends FoodSetState {}

class FoodSetError extends FoodSetState {
  final String message;
  FoodSetError(this.message);
}

class FoodItemLoaded extends FoodSetState {
  final List<FoodData> foodItem;
  FoodItemLoaded(this.foodItem);
}

class FoodListBloc extends Bloc<FoodListEvent, FoodSetState> {
  FoodListBloc() : super(FoodSetLoading()) {
    on<LoadFoodLsit>(_onLoadFoodLsit);
  }

  Future<void> _onLoadFoodLsit(
    LoadFoodLsit event,
    Emitter<FoodSetState> emit,
  ) async {
    try {
      emit(FoodSetLoading());
      print("Loading food sets...");

      final String response =
          await rootBundle.loadString('assets/data/data_test.json');
      final Map<String, dynamic> decodedData = json.decode(response);

      final List<dynamic> foodRaw = decodedData['result']['food'] as List;
      final List<FoodData> foodItems =
          foodRaw.map((item) => FoodData.fromJson(item)).toList();

      print("Loaded ${foodItems.length} items.");

      emit(FoodItemLoaded(foodItems));
    } catch (e) {
      emit(FoodSetError('Failed to load food items: ${e.toString()}'));
    }
  }
}
