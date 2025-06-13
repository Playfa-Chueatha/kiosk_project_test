import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:kiosk_project_test/data/Data_food.dart';

abstract class FoodListEvent extends Equatable {
  const FoodListEvent();

  @override
  List<Object> get props => [];
}

class LoadFoodList extends FoodListEvent {}

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

class FoodListBloc extends Bloc<FoodListEvent, FoodSetState> {
  FoodListBloc() : super(FoodSetLoading()) {
    on<LoadFoodList>(_onLoadFoodList);
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
      final List<FoodData> foodItems =
          foodRaw.map((item) => FoodData.fromJson(item)).toList();

      emit(FoodItemLoaded(foodItems));
    } catch (e) {
      emit(FoodSetError('Failed to load food items: ${e.toString()}'));
    }
  }
}