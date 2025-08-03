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
  final String? rank;

  @HiveField(6)
  final DateTime? createdAt;

  @HiveField(7)
  final DateTime? updatedAt;

  @HiveField(8)
  final int? studentSessionId;

  @HiveField(9)
  final int? termId;

  const ReportCard({
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

  factory ReportCard.fromJson(Map<String, dynamic> json) =>
      _$ReportCardFromJson(json);

  Map<String, dynamic> toJson() => _$ReportCardToJson(this);

  ReportCard copyWith({
    int? id,
    double? averageGrade,
    String? honors,
    String? path,
    String? pdfUrl,
    String? rank,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? studentSessionId,
    int? termId,
  }) {
    return ReportCard(
      id: id ?? this.id,
      averageGrade: averageGrade ?? this.averageGrade,
      honors: honors ?? this.honors,
      path: path ?? this.path,
      pdfUrl: pdfUrl ?? this.pdfUrl,
      rank: rank ?? this.rank,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      studentSessionId: studentSessionId ?? this.studentSessionId,
      termId: termId ?? this.termId,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ReportCard &&
        other.id == id &&
        other.averageGrade == averageGrade &&
        other.honors == honors &&
        other.path == path &&
        other.pdfUrl == pdfUrl &&
        other.rank == rank &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.studentSessionId == studentSessionId &&
        other.termId == termId;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      averageGrade,
      honors,
      path,
      pdfUrl,
      rank,
      createdAt,
      updatedAt,
      studentSessionId,
      termId,
    );
  }

  @override
  String toString() {
    return 'ReportCard(id: $id, averageGrade: $averageGrade, honors: $honors, '
        'rank: $rank, studentSessionId: $studentSessionId, termId: $termId)';
  }
}
