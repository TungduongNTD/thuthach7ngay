import 'package:hive/hive.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: 1)
class UserHive extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String? photoUrl;

  @HiveField(4)
  final String loginMethod;

  @HiveField(5)
  final int? age;

  @HiveField(6)
  final int? height;

  @HiveField(7)
  final String? goals;

  @HiveField(8)
  final DateTime createdAt;

  @HiveField(9)
  final DateTime? lastUpdated;

  UserHive({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.loginMethod,
    this.age,
    this.height,
    this.goals,
    DateTime? createdAt,
    this.lastUpdated,
  }) : createdAt = createdAt ?? DateTime.now();

  UserHive copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    String? loginMethod,
    int? age,
    int? height,
    String? goals,
    DateTime? lastUpdated,
  }) {
    return UserHive(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      loginMethod: loginMethod ?? this.loginMethod,
      age: age ?? this.age,
      height: height ?? this.height,
      goals: goals ?? this.goals,
      createdAt: this.createdAt,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'loginMethod': loginMethod,
      'age': age,
      'height': height,
      'goals': goals,
      'createdAt': createdAt.toIso8601String(),
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  factory UserHive.fromJson(Map<String, dynamic> json) {
    return UserHive(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
      loginMethod: json['loginMethod'] as String,
      age: json['age'] as int?,
      height: json['height'] as int?,
      goals: json['goals'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'] as String)
          : null,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserHive &&
        other.id == id &&
        other.name == name &&
        other.email == email &&
        other.photoUrl == photoUrl &&
        other.loginMethod == loginMethod &&
        other.age == age &&
        other.height == height &&
        other.goals == goals;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      email,
      photoUrl,
      loginMethod,
      age,
      height,
      goals,
    );
  }
}