import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:equatable/equatable.dart';

abstract class FoodCategoryEvent extends Equatable {
  const FoodCategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadFoodCategories extends FoodCategoryEvent {}

abstract class FoodCategoryState extends Equatable {
  const FoodCategoryState();

  @override
  List<Object> get props => [];
}

class FoodCategoryLoading extends FoodCategoryState {}

class FoodCategoryLoaded extends FoodCategoryState {
  final List<String> categories;
  const FoodCategoryLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class FoodCategoryError extends FoodCategoryState {
  final String message;

  const FoodCategoryError(this.message);

  @override
  List<Object> get props => [message];
}

class FoodCategoryBloc extends Bloc<FoodCategoryEvent, FoodCategoryState> {
  FoodCategoryBloc() : super(FoodCategoryLoading()) {
    on<LoadFoodCategories>(_onLoadFoodCategories);
  }

  Future<void> _onLoadFoodCategories(
      LoadFoodCategories event,
      Emitter<FoodCategoryState> emit,
      ) async {
    try {
      emit(FoodCategoryLoading());

      final String response =
          await rootBundle.loadString('assets/data/data_test.json');
      final Map<String, dynamic> decodedData = json.decode(response);

      final List<dynamic> foodCategoriesRaw = decodedData['result']['foodCategory'] as List;

      final List<String> categories =
          foodCategoriesRaw.map((item) => item['foodCatName'] as String).toList();

      emit(FoodCategoryLoaded(categories));
    } catch (e) {
      emit(
          FoodCategoryError('Failed to load food categories: ${e.toString()}'));
    }
  }
}