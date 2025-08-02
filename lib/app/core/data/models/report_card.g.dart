// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportCardAdapter extends TypeAdapter<ReportCard> {
  @override
  final int typeId = 18;

  @override
  ReportCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportCard(
      id: fields[0] as int?,
      averageGrade: fields[1] as double?,
      honors: fields[2] as String?,
      path: fields[3] as String?,
      pdfUrl: fields[4] as String?,
      rank: fields[5] as int?,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
      studentSessionId: fields[8] as int?,
      termId: fields[9] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, ReportCard obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.averageGrade)
      ..writeByte(2)
      ..write(obj.honors)
      ..writeByte(3)
      ..write(obj.path)
      ..writeByte(4)
      ..write(obj.pdfUrl)
      ..writeByte(5)
      ..write(obj.rank)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.studentSessionId)
      ..writeByte(9)
      ..write(obj.termId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReportCardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportCard _$ReportCardFromJson(Map<String, dynamic> json) => ReportCard(
      id: (json['id'] as num?)?.toInt(),
      averageGrade: (json['average_grade'] as num?)?.toDouble(),
      honors: json['honors'] as String?,
      path: json['path'] as String?,
      pdfUrl: json['pdf_url'] as String?,
      rank: (json['rank'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      studentSessionId: (json['student_session_id'] as num?)?.toInt(),
      termId: (json['term_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReportCardToJson(ReportCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'average_grade': instance.averageGrade,
      'honors': instance.honors,
      'path': instance.path,
      'pdf_url': instance.pdfUrl,
      'rank': instance.rank,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'student_session_id': instance.studentSessionId,
      'term_id': instance.termId,
    };
