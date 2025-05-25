import 'package:freezed_annotation/freezed_annotation.dart';
import 'habit_hive_model.dart';

part 'habit_model.freezed.dart';

@freezed
class Habit with _$Habit {
  const factory Habit({
    required String id,
    required String description,
    required String name,
    required int icon,
    required String frequency,
    required int? goal,
    required int streak,
    required List<int> onlyOn,
    required List<DateTime> doneOn,
    required bool isExpanded,
    required bool isDone,
    required int duration,
    required bool isPaused,
  }) = _Habit;

  // Thêm phương thức fromHive để chuyển đổi từ HabitHive sang Habit
  static Habit fromHive(HabitHive hive) {
    return Habit(
      id: hive.createdAt.millisecondsSinceEpoch.toString(),
      name: hive.name,
      description: hive.description,
      icon: hive.icon,
      frequency: hive.frequency,
      goal: hive.goal,
      streak: hive.streak,
      onlyOn: hive.onlyOn,
      doneOn: hive.doneOn,
      isExpanded: false,
      isDone: false,
      duration: hive.duration,
      isPaused: hive.isPaused,
    );
  }
}
