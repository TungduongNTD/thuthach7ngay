import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

import '../models/habit_hive_model.dart';
import '../models/habit_model.dart';

// State class
class HabitState {
  final List<Habit> habits;
  final bool isLoading;
  final String? error;

  HabitState({
    this.habits = const [],
    this.isLoading = false,
    this.error,
  });

  HabitState copyWith({
    List<Habit>? habits,
    bool? isLoading,
    String? error,
  }) {
    return HabitState(
      habits: habits ?? this.habits,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class HabitCubit extends Cubit<HabitState> {
  HabitCubit() : super(HabitState()) {
    loadHabits();
  }

  Future<void> loadHabits() async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      
      final habitBox = await Hive.openBox<HabitHive>('habits');
      final habits = habitBox.values.map((hiveHabit) => Habit.fromHive(hiveHabit)).toList();
      await habitBox.close();
      
      emit(state.copyWith(
        habits: habits,
        isLoading: false,
      ));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Lỗi khi tải danh sách thử thách: $e',
      ));
    }
  }

  Future<void> deleteHabit(String id) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      
      final habitBox = await Hive.openBox<HabitHive>('habits');
      await habitBox.delete(id);
      await habitBox.close();
      
      // Load lại danh sách thử thách từ Hive
      await loadHabits();
      
      // Hiển thị thông báo thành công
      _showSuccessMessage('Xóa thử thách thành công');
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Lỗi khi xóa thử thách: $e',
      ));
      _showErrorMessage('Lỗi khi xóa thử thách: $e');
    }
  }

  Future<void> pauseHabit(String id, bool value) async {
    try {
      emit(state.copyWith(isLoading: true, error: null));
      final habitBox = await Hive.openBox<HabitHive>('habits');
      final habit = habitBox.get(id);
      if (habit != null) {
        await habitBox.put(id, habit.copyWith(isPaused: value));
      }
      await habitBox.close();
      await loadHabits();
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        error: 'Lỗi khi tạm dừng thử thách: $e',
      ));
    }
  }

  void _showSuccessMessage(String message) {
    // Implementation sẽ được thêm sau khi có BuildContext
  }

  void _showErrorMessage(String message) {
    // Implementation sẽ được thêm sau khi có BuildContext
  }
} 