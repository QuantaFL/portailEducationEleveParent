import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'session.g.dart';

@HiveType(typeId: 0)
@JsonSerializable()
class Session {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final String session;

  @HiveField(2)
  @JsonKey(name: 'startDate')
  final DateTime startDate;

  @HiveField(3)
  @JsonKey(name: 'registration_start_date')
  final DateTime? reenrollDate;

  @HiveField(4)
  @JsonKey(name: 'endDate')
  final DateTime endDate;

  @HiveField(5)
  @JsonKey(name: 'is_active')
  final bool active;

  Session({
    this.id,
    required this.session,
    required this.startDate,
    this.reenrollDate,
    required this.endDate,
    required this.active,
  });

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  Map<String, dynamic> toJson() => _$SessionToJson(this);
}
