import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
part 'new_habit_model.freezed.dart';
// Nếu bạn dùng json_serializable, thêm dòng sau:
// part 'new_habit_model.g.dart';

@freezed
class NewHabit with _$NewHabit {
  const factory NewHabit({
    required String name,
    required String description,
    required int iconCodePoint,
    @Default(0) int daysCompleted,
    @Default(0) int duration,
    @Default(false) bool enableNotification,
    @Default('08:00') String notificationTime,
  }) = _NewHabit;
}
