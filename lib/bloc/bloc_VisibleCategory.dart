import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

class VisibleCategoryState extends Equatable {
  final String visibleCategoryId;
  final bool userSelectedCategory;

  final bool locked;

  const VisibleCategoryState(
    this.visibleCategoryId, {
    this.userSelectedCategory = false,
    this.locked = false,
  });

  @override
  List<Object?> get props => [visibleCategoryId, userSelectedCategory, locked];
}

class VisibleCategoryInitial extends VisibleCategoryState {
  const VisibleCategoryInitial() : super('');
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

class MouseScrollCategoryChanged extends VisibleCategoryEvent {
  final String categoryId;

  const MouseScrollCategoryChanged(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class UnlockScrollLock extends VisibleCategoryEvent {}

class VisibleCategoryBloc
    extends Bloc<VisibleCategoryEvent, VisibleCategoryState> {
  static const Duration delayLockDuration = Duration(milliseconds: 700);

  VisibleCategoryBloc() : super(const VisibleCategoryInitial()) {
    on<UpdateVisibleCategory>((event, emit) {
      print('[Bloc] UpdateVisibleCategory: ${event.categoryId}');
      if (state.visibleCategoryId == event.categoryId && state.locked) {
        print('Skip emit because same category and locked');
        return;
      }
      emit(VisibleCategoryState(
        event.categoryId,
        userSelectedCategory: true,
        locked: true,
      ));
    });

    on<UnlockScrollLock>((event, emit) {
      emit(VisibleCategoryState(
        state.visibleCategoryId,
        userSelectedCategory: state.userSelectedCategory,
        locked: false,
      ));
    });

    on<MouseScrollCategoryChanged>((event, emit) {
      if (state.locked) {
        return;
      }
      if (state.userSelectedCategory) {
        return;
      }
      if (state.visibleCategoryId != event.categoryId) {
        emit(VisibleCategoryState(
          event.categoryId,
          userSelectedCategory: false,
          locked: false,
        ));
      }
    });
  }
}
