// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'new_habit_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$NewHabit {
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  int get iconCodePoint => throw _privateConstructorUsedError;
  int get daysCompleted => throw _privateConstructorUsedError;
  int get duration => throw _privateConstructorUsedError;
  bool get enableNotification => throw _privateConstructorUsedError;
  String get notificationTime => throw _privateConstructorUsedError;

  /// Create a copy of NewHabit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NewHabitCopyWith<NewHabit> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NewHabitCopyWith<$Res> {
  factory $NewHabitCopyWith(NewHabit value, $Res Function(NewHabit) then) =
      _$NewHabitCopyWithImpl<$Res, NewHabit>;
  @useResult
  $Res call(
      {String name,
      String description,
      int iconCodePoint,
      int daysCompleted,
      int duration,
      bool enableNotification,
      String notificationTime});
}

/// @nodoc
class _$NewHabitCopyWithImpl<$Res, $Val extends NewHabit>
    implements $NewHabitCopyWith<$Res> {
  _$NewHabitCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NewHabit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? iconCodePoint = null,
    Object? daysCompleted = null,
    Object? duration = null,
    Object? enableNotification = null,
    Object? notificationTime = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      iconCodePoint: null == iconCodePoint
          ? _value.iconCodePoint
          : iconCodePoint // ignore: cast_nullable_to_non_nullable
              as int,
      daysCompleted: null == daysCompleted
          ? _value.daysCompleted
          : daysCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      enableNotification: null == enableNotification
          ? _value.enableNotification
          : enableNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationTime: null == notificationTime
          ? _value.notificationTime
          : notificationTime // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NewHabitImplCopyWith<$Res>
    implements $NewHabitCopyWith<$Res> {
  factory _$$NewHabitImplCopyWith(
          _$NewHabitImpl value, $Res Function(_$NewHabitImpl) then) =
      __$$NewHabitImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String description,
      int iconCodePoint,
      int daysCompleted,
      int duration,
      bool enableNotification,
      String notificationTime});
}

/// @nodoc
class __$$NewHabitImplCopyWithImpl<$Res>
    extends _$NewHabitCopyWithImpl<$Res, _$NewHabitImpl>
    implements _$$NewHabitImplCopyWith<$Res> {
  __$$NewHabitImplCopyWithImpl(
      _$NewHabitImpl _value, $Res Function(_$NewHabitImpl) _then)
      : super(_value, _then);

  /// Create a copy of NewHabit
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? description = null,
    Object? iconCodePoint = null,
    Object? daysCompleted = null,
    Object? duration = null,
    Object? enableNotification = null,
    Object? notificationTime = null,
  }) {
    return _then(_$NewHabitImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      iconCodePoint: null == iconCodePoint
          ? _value.iconCodePoint
          : iconCodePoint // ignore: cast_nullable_to_non_nullable
              as int,
      daysCompleted: null == daysCompleted
          ? _value.daysCompleted
          : daysCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      duration: null == duration
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as int,
      enableNotification: null == enableNotification
          ? _value.enableNotification
          : enableNotification // ignore: cast_nullable_to_non_nullable
              as bool,
      notificationTime: null == notificationTime
          ? _value.notificationTime
          : notificationTime // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$NewHabitImpl with DiagnosticableTreeMixin implements _NewHabit {
  const _$NewHabitImpl(
      {required this.name,
      required this.description,
      required this.iconCodePoint,
      this.daysCompleted = 0,
      this.duration = 0,
      this.enableNotification = false,
      this.notificationTime = '08:00'});

  @override
  final String name;
  @override
  final String description;
  @override
  final int iconCodePoint;
  @override
  @JsonKey()
  final int daysCompleted;
  @override
  @JsonKey()
  final int duration;
  @override
  @JsonKey()
  final bool enableNotification;
  @override
  @JsonKey()
  final String notificationTime;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'NewHabit(name: $name, description: $description, iconCodePoint: $iconCodePoint, daysCompleted: $daysCompleted, duration: $duration, enableNotification: $enableNotification, notificationTime: $notificationTime)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'NewHabit'))
      ..add(DiagnosticsProperty('name', name))
      ..add(DiagnosticsProperty('description', description))
      ..add(DiagnosticsProperty('iconCodePoint', iconCodePoint))
      ..add(DiagnosticsProperty('daysCompleted', daysCompleted))
      ..add(DiagnosticsProperty('duration', duration))
      ..add(DiagnosticsProperty('enableNotification', enableNotification))
      ..add(DiagnosticsProperty('notificationTime', notificationTime));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NewHabitImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.iconCodePoint, iconCodePoint) ||
                other.iconCodePoint == iconCodePoint) &&
            (identical(other.daysCompleted, daysCompleted) ||
                other.daysCompleted == daysCompleted) &&
            (identical(other.duration, duration) ||
                other.duration == duration) &&
            (identical(other.enableNotification, enableNotification) ||
                other.enableNotification == enableNotification) &&
            (identical(other.notificationTime, notificationTime) ||
                other.notificationTime == notificationTime));
  }

  @override
  int get hashCode => Object.hash(runtimeType, name, description, iconCodePoint,
      daysCompleted, duration, enableNotification, notificationTime);

  /// Create a copy of NewHabit
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NewHabitImplCopyWith<_$NewHabitImpl> get copyWith =>
      __$$NewHabitImplCopyWithImpl<_$NewHabitImpl>(this, _$identity);
}

abstract class _NewHabit implements NewHabit {
  const factory _NewHabit(
      {required final String name,
      required final String description,
      required final int iconCodePoint,
      final int daysCompleted,
      final int duration,
      final bool enableNotification,
      final String notificationTime}) = _$NewHabitImpl;

  @override
  String get name;
  @override
  String get description;
  @override
  int get iconCodePoint;
  @override
  int get daysCompleted;
  @override
  int get duration;
  @override
  bool get enableNotification;
  @override
  String get notificationTime;

  /// Create a copy of NewHabit
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NewHabitImplCopyWith<_$NewHabitImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
