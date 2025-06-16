// ignore_for_file: file_names

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class VisibleCategoryState extends Equatable {
  final String visibleCategoryId;

  const VisibleCategoryState(this.visibleCategoryId);

  @override
  List<Object?> get props => [visibleCategoryId];
}

abstract class VisibleCategoryEvent extends Equatable {
  const VisibleCategoryEvent();
  @override
  List<Object?> get props => [];
}

class UpdateVisibleCategory extends VisibleCategoryEvent {
  final String categoryId;
  const UpdateVisibleCategory(this.categoryId);
  

  @override
  List<Object?> get props => [categoryId];
}

class VisibleCategoryBloc extends Bloc<VisibleCategoryEvent, VisibleCategoryState?> {
  VisibleCategoryBloc() : super(null) {
    on<UpdateVisibleCategory>((event, emit) {
      emit(VisibleCategoryState(event.categoryId));
    });
  }
}
