import 'package:hive/hive.dart';

part 'habit_hive_model.g.dart';

@HiveType(typeId: 0)
class HabitHive extends HiveObject {
  @HiveField(0)
  String name;
  @HiveField(1)
  String description;
  @HiveField(2)
  int icon;
  @HiveField(3)
  String frequency;
  @HiveField(4)
  int? goal;
  @HiveField(5)
  int streak;
  @HiveField(6)
  List<int> onlyOn;
  @HiveField(7)
  List<DateTime> doneOn;
  @HiveField(8)
  DateTime createdAt;
  @HiveField(9)
  DateTime updatedAt;
  @HiveField(10)
  bool enableNotification;
  @HiveField(11)
  String notificationTime;
  @HiveField(12)
  int duration;
  @HiveField(13)
  bool isPaused;

  HabitHive({
    required this.name,
    required this.description,
    required this.icon,
    required this.frequency,
    this.goal,
    this.streak = 0,
    List<int>? onlyOn,
    List<DateTime>? doneOn,
    required this.createdAt,
    required this.updatedAt,
    this.enableNotification = false,
    this.notificationTime = '08:00',
    this.duration = 7,
    this.isPaused = false,
  })  : onlyOn = onlyOn ?? [],
        doneOn = doneOn ?? [];

  HabitHive copyWith({
    String? name,
    String? description,
    int? icon,
    String? frequency,
    int? goal,
    int? streak,
    List<int>? onlyOn,
    List<DateTime>? doneOn,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? enableNotification,
    String? notificationTime,
    int? duration,
    bool? isPaused,
  }) {
    return HabitHive(
      name: name ?? this.name,
      description: description ?? this.description,
      icon: icon ?? this.icon,
      frequency: frequency ?? this.frequency,
      goal: goal ?? this.goal,
      streak: streak ?? this.streak,
      onlyOn: onlyOn ?? List<int>.from(this.onlyOn),
      doneOn: doneOn ?? List<DateTime>.from(this.doneOn),
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      enableNotification: enableNotification ?? this.enableNotification,
      notificationTime: notificationTime ?? this.notificationTime,
      duration: duration ?? this.duration,
      isPaused: isPaused ?? this.isPaused,
    );
  }
}