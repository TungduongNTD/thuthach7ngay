import 'package:bloc/bloc.dart';
import 'package:thuthach7ngay/models/habit_hive_model.dart';
import 'package:thuthach7ngay/models/new_habit_model.dart';
import 'package:thuthach7ngay/repositories/habit_repository.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NewHabitCubit extends Cubit<NewHabit> {
  NewHabitCubit()
      : super(const NewHabit(
          name: '',
          description: '',
          iconCodePoint: 57825,
          enableNotification: false,
          notificationTime: '08:00',
        ));

  setNewHabitName(String name) {
    emit(state.copyWith(name: name));
  }

  setNewHabitDescription(String description) {
    emit(state.copyWith(description: description));
  }

  setNewHabitIconCodePoint(int iconCodePoint) {
    emit(state.copyWith(iconCodePoint: iconCodePoint));
  }

  setEnableNotification(bool value) {
    emit(state.copyWith(enableNotification: value));
  }

  setNotificationTime(String value) {
    emit(state.copyWith(notificationTime: value));
  }

  Future<void> getHabitToEdit(String id) async {
    Box<HabitHive> box = await Hive.openBox('habits');
    try {
      HabitHive? habit = box.get(id);
      if (habit == null) return;
      emit(
        state.copyWith(
          name: habit.name,
          description: habit.description,
          iconCodePoint: habit.icon,
          // Nếu bạn lưu enableNotification và notificationTime trong Hive, hãy lấy ở đây
          // enableNotification: habit.enableNotification,
          // notificationTime: habit.notificationTime,
        ),
      );
    } catch (e) {
      // add error handling to crashlytics
    } finally {
      await box.close();
    }
  }

  Future<void> addNewHabit(
    String name,
    String description,
    int iconCodePoint,
    bool enableNotification,
    String notificationTime,
    int duration,
  ) async {
    Box<HabitHive> box = await Hive.openBox('habits');
    try {
      final DateTime now = DateTime.now();
      await HabitRepository(box).addHabit(
        now.millisecondsSinceEpoch.toString(),
        HabitHive(
          name: name,
          description: description,
          icon: iconCodePoint,
          frequency: 'daily',
          goal: null,
          streak: 0,
          onlyOn: [],
          doneOn: [],
          createdAt: now,
          updatedAt: now,
          enableNotification: enableNotification,
          notificationTime: notificationTime,
          duration: duration,
        ),
      );
      // Reset state sau khi thêm thành công
      emit(const NewHabit(
        name: '',
        description: '',
        iconCodePoint: 57825,
        enableNotification: false,
        notificationTime: '08:00',
      ));
    } catch (e) {
      rethrow; // Ném lại exception để xử lý ở UI
    } finally {
      await box.close();
    }
  }

  Future<void> updateHabit(
    String id,
    String name,
    String description,
    int iconCodePoint,
    bool enableNotification,
    String notificationTime,
    int duration,
  ) async {
    Box<HabitHive> box = await Hive.openBox('habits');
    try {
      final DateTime now = DateTime.now();
      HabitHive prevHabit = box.get(id)!;
      await HabitRepository(box).updateHabit(
        id,
        prevHabit.copyWith(
          name: name,
          description: description,
          icon: iconCodePoint,
          updatedAt: now,
          enableNotification: enableNotification,
          notificationTime: notificationTime,
          duration: duration,
        ),
      );
    } catch (e) {
      // add error handling to crashlytics
    } finally {
      await box.close();
    }
  }

  Future<void> deleteHabit(String id) async {
    Box<HabitHive> box = await Hive.openBox('habits');
    try {
      await HabitRepository(box).deleteHabit(id);
      // Reset state sau khi xóa thành công
      emit(const NewHabit(
        name: '',
        description: '',
        iconCodePoint: 57825,
        enableNotification: false,
        notificationTime: '08:00',
      ));
    } catch (e) {
      // add error handling to crashlytics
      rethrow; // Ném lại exception để xử lý ở UI
    } finally {
      await box.close();
    }
  }
}
