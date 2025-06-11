// Events
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk_project_test/data/Data_FoodSet.dart';

abstract class FoodSetEvent extends Equatable {
  const FoodSetEvent();

  @override
  List<Object> get props => [];
}

class LoadFoodSets extends FoodSetEvent {}

// States
abstract class FoodSetState extends Equatable {
  const FoodSetState();

  @override
  List<Object> get props => [];
}

class FoodSetLoading extends FoodSetState {}

class FoodSetLoaded extends FoodSetState {
  final List<FoodSet> foodSets;

  const FoodSetLoaded(this.foodSets);

  @override
  List<Object> get props => [foodSets];
}

class FoodSetError extends FoodSetState {
  final String message;

  const FoodSetError(this.message);

  @override
  List<Object> get props => [message];
}

// Bloc
class FoodSetBloc extends Bloc<FoodSetEvent, FoodSetState> {
  FoodSetBloc() : super(FoodSetLoading()) {
    on<LoadFoodSets>(_onLoadFoodSets);
  }

  Future<void> _onLoadFoodSets(
      LoadFoodSets event,
      Emitter<FoodSetState> emit,
      ) async {
    try {
      emit(FoodSetLoading());

      final String response =
          await rootBundle.loadString('assets/data/data_test.json');
      final Map<String, dynamic> decodedData = json.decode(response);

      final List<dynamic> foodSetRaw = decodedData['result']['foodSet'] as List;

      final List<FoodSet> foodSets =
          foodSetRaw.map((item) => FoodSet.fromJson(item)).toList();

      emit(FoodSetLoaded(foodSets));
    } catch (e) {
      emit(
          FoodSetError('Failed to load food categories: ${e.toString()}'));
    }
  }
}