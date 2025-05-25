// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'habit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$Habit {
  String get id => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  int get icon => throw _privateConstructorUsedError;
  String get frequency => throw _privateConstructorUsedError;
  int? get goal => throw _privateConstructorUsedError;
  int get streak => throw _privateConstructorUsedError;
  List<int> get onlyOn => throw _privateConstructorUsedError;
  List<DateTime> get doneOn => throw _privateConstructorUsedError;
  bool get isExpanded => throw _privateConstructorUsedError;
  bool get isDone => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  bool get isPaused => throw _privateConstructorUsedError;

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HabitCopyWith<Habit> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HabitCopyWith<$Res> {
  factory $HabitCopyWith(Habit value, $Res Function(Habit) then) =
      _$HabitCopyWithImpl<$Res, Habit>;
  @useResult
  $Res call(
      {String id,
      String description,
      String name,
      int icon,
      String frequency,
      int? goal,
      int streak,
      List<int> onlyOn,
      List<DateTime> doneOn,
      bool isExpanded,
      bool isDone,
      int duration,
      bool isPaused});
}

/// @nodoc
class _$HabitCopyWithImpl<$Res, $Val extends Habit>
    implements $HabitCopyWith<$Res> {
  _$HabitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? name = null,
    Object? icon = null,
    Object? frequency = null,
    Object? goal = freezed,
    Object? streak = null,
    Object? onlyOn = null,
    Object? doneOn = null,
    Object? isExpanded = null,
    Object? isDone = null,
    Object? duration = null,
    Object? isPaused = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as int,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      goal: freezed == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as int?,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      onlyOn: null == onlyOn
          ? _value.onlyOn
          : onlyOn // ignore: cast_nullable_to_non_nullable
              as List<int>,
      doneOn: null == doneOn
          ? _value.doneOn
          : doneOn // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
      isExpanded: null == isExpanded
          ? _value.isExpanded
          : isExpanded // ignore: cast_nullable_to_non_nullable
              as bool,
      isDone: null == isDone
          ? _value.isDone
          : isDone // ignore: cast_nullable_to_non_nullable
              as bool,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      isPaused: null == isPaused
          ? _value.isPaused
          : isPaused // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HabitImplCopyWith<$Res> implements $HabitCopyWith<$Res> {
  factory _$$HabitImplCopyWith(
          _$HabitImpl value, $Res Function(_$HabitImpl) then) =
      __$$HabitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String description,
      String name,
      int icon,
      String frequency,
      int? goal,
      int streak,
      List<int> onlyOn,
      List<DateTime> doneOn,
      bool isExpanded,
      bool isDone,
      int duration,
      bool isPaused});
}

/// @nodoc
class __$$HabitImplCopyWithImpl<$Res>
    extends _$HabitCopyWithImpl<$Res, _$HabitImpl>
    implements _$$HabitImplCopyWith<$Res> {
  __$$HabitImplCopyWithImpl(
      _$HabitImpl _value, $Res Function(_$HabitImpl) _then)
      : super(_value, _then);

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? description = null,
    Object? name = null,
    Object? icon = null,
    Object? frequency = null,
    Object? goal = freezed,
    Object? streak = null,
    Object? onlyOn = null,
    Object? doneOn = null,
    Object? isExpanded = null,
    Object? isDone = null,
    Object? duration = null,
    Object? isPaused = null,
  }) {
    return _then(_$HabitImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      icon: null == icon
          ? _value.icon
          : icon // ignore: cast_nullable_to_non_nullable
              as int,
      frequency: null == frequency
          ? _value.frequency
          : frequency // ignore: cast_nullable_to_non_nullable
              as String,
      goal: freezed == goal
          ? _value.goal
          : goal // ignore: cast_nullable_to_non_nullable
              as int?,
      streak: null == streak
          ? _value.streak
          : streak // ignore: cast_nullable_to_non_nullable
              as int,
      onlyOn: null == onlyOn
          ? _value._onlyOn
          : onlyOn // ignore: cast_nullable_to_non_nullable
              as List<int>,
      doneOn: null == doneOn
          ? _value._doneOn
          : doneOn // ignore: cast_nullable_to_non_nullable
              as List<DateTime>,
      isExpanded: null == isExpanded
          ? _value.isExpanded
          : isExpanded // ignore: cast_nullable_to_non_nullable
              as bool,
      isDone: null == isDone
          ? _value.isDone
          : isDone // ignore: cast_nullable_to_non_nullable
              as bool,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      isPaused: null == isPaused
          ? _value.isPaused
          : isPaused // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc

class _$HabitImpl implements _Habit {
  const _$HabitImpl(
      {required this.id,
      required this.description,
      required this.name,
      required this.icon,
      required this.frequency,
      required this.goal,
      required this.streak,
      required final List<int> onlyOn,
      required final List<DateTime> doneOn,
      required this.isExpanded,
      required this.isDone,
      required this.duration,
      required this.isPaused})
      : _onlyOn = onlyOn,
        _doneOn = doneOn;

  @override
  final String id;
  @override
  final String description;
  @override
  final String name;
  @override
  final int icon;
  @override
  final String frequency;
  @override
  final int? goal;
  @override
  final int streak;
  final List<int> _onlyOn;
  @override
  List<int> get onlyOn {
    if (_onlyOn is EqualUnmodifiableListView) return _onlyOn;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_onlyOn);
  }

  final List<DateTime> _doneOn;
  @override
  List<DateTime> get doneOn {
    if (_doneOn is EqualUnmodifiableListView) return _doneOn;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_doneOn);
  }

  @override
  final bool isExpanded;
  @override
  final bool isDone;
  @override
  final int duration;
  @override
  final bool isPaused;

  @override
  String toString() {
    return 'Habit(id: $id, description: $description, name: $name, icon: $icon, frequency: $frequency, goal: $goal, streak: $streak, onlyOn: $onlyOn, doneOn: $doneOn, isExpanded: $isExpanded, isDone: $isDone, duration: $duration, isPaused: $isPaused)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HabitImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.icon, icon) || other.icon == icon) &&
            (identical(other.frequency, frequency) ||
                other.frequency == frequency) &&
            (identical(other.goal, goal) || other.goal == goal) &&
            (identical(other.streak, streak) || other.streak == streak) &&
            const DeepCollectionEquality().equals(other._onlyOn, _onlyOn) &&
            const DeepCollectionEquality().equals(other._doneOn, _doneOn) &&
            (identical(other.isExpanded, isExpanded) ||
                other.isExpanded == isExpanded) &&
            (identical(other.isDone, isDone) || other.isDone == isDone) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.isPaused, isPaused) ||
                other.isPaused == isPaused));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      description,
      name,
      icon,
      frequency,
      goal,
      streak,
      const DeepCollectionEquality().hash(_onlyOn),
      const DeepCollectionEquality().hash(_doneOn),
      isExpanded,
      isDone,
      duration,
      isPaused);

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HabitImplCopyWith<_$HabitImpl> get copyWith =>
      __$$HabitImplCopyWithImpl<_$HabitImpl>(this, _$identity);
}

abstract class _Habit implements Habit {
  const factory _Habit(
      {required final String id,
      required final String description,
      required final String name,
      required final int icon,
      required final String frequency,
      required final int? goal,
      required final int streak,
      required final List<int> onlyOn,
      required final List<DateTime> doneOn,
      required final bool isExpanded,
      required final bool isDone,
      required final int duration,
      required final bool isPaused}) = _$HabitImpl;

  @override
  String get id;
  @override
  String get description;
  @override
  String get name;
  @override
  int get icon;
  @override
  String get frequency;
  @override
  int? get goal;
  @override
  int get streak;
  @override
  List<int> get onlyOn;
  @override
  List<DateTime> get doneOn;
  @override
  bool get isExpanded;
  @override
  bool get isDone;
  @override
  int get duration;
  @override
  bool get isPaused;

  /// Create a copy of Habit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HabitImplCopyWith<_$HabitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
