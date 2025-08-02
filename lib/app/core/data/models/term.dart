import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'term.g.dart';

@HiveType(typeId: 23)
@JsonSerializable(fieldRename: FieldRename.snake)
class Term {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final DateTime? createdAt;

  @HiveField(3)
  final DateTime? updatedAt;

  @HiveField(4)
  final int? academicYearId;

  Term({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.academicYearId,
  });

  factory Term.fromJson(Map<String, dynamic> json) => _$TermFromJson(json);
  Map<String, dynamic> toJson() => _$TermToJson(this);
}
