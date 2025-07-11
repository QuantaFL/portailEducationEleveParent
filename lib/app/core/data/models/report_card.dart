import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_card.g.dart';

@HiveType(typeId: 8)
@JsonSerializable()
class ReportCard {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int studentId;
  @HiveField(2)
  final String academicYear;
  @HiveField(3)
  final String period;
  @HiveField(4)
  final double? averageGradeGeneral;
  @HiveField(5)
  final String? mention;
  @HiveField(6)
  final int? rank;
  @HiveField(7)
  final String? appreciation;
  @HiveField(8)
  final String pdfPath;
  @HiveField(9)
  final String generatedAt;
  @HiveField(10)
  final String? createdAt;
  @HiveField(11)
  final String? updatedAt;

  ReportCard({
    required this.id,
    required this.studentId,
    required this.academicYear,
    required this.period,
    this.averageGradeGeneral,
    this.mention,
    this.rank,
    this.appreciation,
    required this.pdfPath,
    required this.generatedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory ReportCard.fromJson(Map<String, dynamic> json) =>
      _$ReportCardFromJson(json);

  Map<String, dynamic> toJson() => _$ReportCardToJson(this);
}
