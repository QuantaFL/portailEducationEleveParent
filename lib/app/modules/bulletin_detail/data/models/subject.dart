import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subject.g.dart';

@HiveType(typeId: 5)
@JsonSerializable()
class Subject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;
  @HiveField(2)
  final double coefficient;
  @HiveField(3)
  final String? level;
  @HiveField(4)
  final String? createdAt;
  @HiveField(5)
  final String? updatedAt;

  Subject({
    required this.id,
    required this.name,
    required this.coefficient,
    this.level,
    this.createdAt,
    this.updatedAt,
  });

  factory Subject.fromJson(Map<String, dynamic> json) =>
      _$SubjectFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectToJson(this);
}
