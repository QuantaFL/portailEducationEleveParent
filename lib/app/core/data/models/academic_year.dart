import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'academic_year.g.dart';

@HiveType(typeId: 13)
@JsonSerializable(fieldRename: FieldRename.snake)
class AcademicYear {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  @JsonKey(name: 'label')
  final String? label;

  @HiveField(2)
  @JsonKey(name: 'start_date')
  final String? startDate;

  @HiveField(3)
  @JsonKey(name: 'end_date')
  final String? endDate;

  @HiveField(4)
  @JsonKey(name: 'status')
  final String? status;

  @HiveField(5)
  @JsonKey(name: 'created_at')
  final String? createdAt;

  @HiveField(6)
  @JsonKey(name: 'updated_at')
  final String? updatedAt;

  AcademicYear({
    this.id,
    this.label,
    this.startDate,
    this.endDate,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory AcademicYear.fromJson(Map<String, dynamic> json) =>
      _$AcademicYearFromJson(json);
  Map<String, dynamic> toJson() => _$AcademicYearToJson(this);
}
