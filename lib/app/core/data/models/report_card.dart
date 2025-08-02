import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_card.g.dart';

@HiveType(typeId: 18)
@JsonSerializable(fieldRename: FieldRename.snake)
class ReportCard {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final double? averageGrade;

  @HiveField(2)
  final String? honors;

  @HiveField(3)
  final String? path;

  @HiveField(4)
  final String? pdfUrl;

  @HiveField(5)
  final int? rank;

  @HiveField(6)
  final DateTime? createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  @HiveField(8)
  final int? studentSessionId;

  @HiveField(9)
  final int? termId;

  ReportCard({
    this.id,
    this.averageGrade,
    this.honors,
    this.path,
    this.pdfUrl,
    this.rank,
    this.createdAt,
    this.updatedAt,
    this.studentSessionId,
    this.termId,
  });

  factory ReportCard.fromJson(Map<String, dynamic> json) => _$ReportCardFromJson(json);
  Map<String, dynamic> toJson() => _$ReportCardToJson(this);
}