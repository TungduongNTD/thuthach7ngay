import 'package:bloc/bloc.dart';
import 'package:thuthach7ngay/models/habit_hive_model.dart';
import 'package:thuthach7ngay/models/habit_model.dart';
import 'package:thuthach7ngay/models/selected_day_model.dart';
import 'package:thuthach7ngay/repositories/habit_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class SelectedDayCubit extends Cubit<SelectedDay> {
  SelectedDayCubit()
      : super(SelectedDay(selectedDay: DateTime.now(), habits: [])) {
    changeSelectedDay(
      DateTime.utc(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
    );
  }
  Future<void> changeSelectedDay(DateTime newDay) async {
    List<Habit> habits = [];
    Box<HabitHive> box = await Hive.openBox('habits');
    try {
      habits = HabitRepository(box).getHabitsForDate(newDay);
      emit(state.copyWith(selectedDay: newDay, habits: habits));
    } catch (e) {
      // Ném lại exception để xử lý ở UI nếu cần
      rethrow;
    } finally {
      await box.close();
    }
  }

  void changeHabitExpanded(int index) {
    List<Habit> newHabits = state.habits.toList();
    Habit habit =
        newHabits[index].copyWith(isExpanded: !newHabits[index].isExpanded);
    newHabits[index] = habit;
    if (newHabits != state.habits) {
      emit(state.copyWith(habits: newHabits));
    }
  }

  Future<void> changeHabitDone(int index) async {
    List<Habit> newHabits = state.habits.toList();
    Habit habit = newHabits[index].copyWith(
      isDone: !newHabits[index].isDone,
    );
    Box<HabitHive> box = await Hive.openBox('habits');
    try {
      HabitHive? oldHabit = box.get(habit.id);
      if (oldHabit == null) return;
      List<DateTime> doneOn = oldHabit.doneOn.toList();
      if (habit.isDone) {
        doneOn.add(state.selectedDay);
      } else {
        doneOn.remove(state.selectedDay);
      }

      // Tính toán streak
      int streak = 0;
      if (doneOn.isNotEmpty) {
        // Sắp xếp các ngày đã hoàn thành theo thứ tự tăng dần
        doneOn.sort((a, b) => a.compareTo(b));
        
        // Tính streak từ ngày gần nhất
        DateTime currentDate = DateTime.now();
        DateTime checkDate = currentDate;
        
        while (true) {
          // Kiểm tra xem ngày này có trong danh sách doneOn không
          bool isDone = doneOn.any((date) => 
            date.year == checkDate.year && 
            date.month == checkDate.month && 
            date.day == checkDate.day
          );
          
          if (isDone) {
            streak++;
            checkDate = checkDate.subtract(const Duration(days: 1));
          } else {
            break;
          }
        }
      }

      await HabitRepository(box).updateHabit(
        habit.id,
        oldHabit.copyWith(
          doneOn: doneOn,
          streak: streak,
          updatedAt: DateTime.now(),
        ),
      );
      habit = habit.copyWith(
        doneOn: doneOn,
        streak: streak,
      );
      newHabits[index] = habit;
    } catch (e) {
      // add error handling to crashlytics
    } finally {
      await box.close();
    }
    if (newHabits != state.habits) {
      emit(state.copyWith(habits: newHabits));
    }
  }
}
