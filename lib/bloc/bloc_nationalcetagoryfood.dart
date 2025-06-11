import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:equatable/equatable.dart';

abstract class FoodSetEvent extends Equatable {
  const FoodSetEvent();

  @override
  List<Object> get props => [];
}

class LoadFoodSets extends FoodSetEvent {}

abstract class FoodSetState extends Equatable {
  const FoodSetState();

  @override
  List<Object> get props => [];
}

class FoodSetLoading extends FoodSetState {}

class FoodSetLoaded extends FoodSetState {
  final List<String> categories;

  const FoodSetLoaded(this.categories);

  @override
  List<Object> get props => [categories];
}

class FoodSetError extends FoodSetState {
  final String message;

  const FoodSetError(this.message);

  @override
  List<Object> get props => [message];
}

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

      
      final List<String> categories =
          foodSetRaw.map((item) => item['foodSetName'] as String).toList();

      emit(FoodSetLoaded(categories));
    } catch (e) {
      emit(
          FoodSetError('Failed to load food categories: ${e.toString()}'));
    }
  }
}

