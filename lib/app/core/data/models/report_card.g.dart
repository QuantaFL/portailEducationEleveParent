// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReportCardAdapter extends TypeAdapter<ReportCard> {
  @override
  final int typeId = 8;

  @override
  ReportCard read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReportCard(
      id: fields[0] as int,
      studentId: fields[1] as int,
      academicYear: fields[2] as String,
      period: fields[3] as String,
      averageGradeGeneral: fields[4] as double?,
      mention: fields[5] as String?,
      rank: fields[6] as int?,
      appreciation: fields[7] as String?,
      pdfPath: fields[8] as String,
      generatedAt: fields[9] as String,
      createdAt: fields[10] as String?,
      updatedAt: fields[11] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ReportCard obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.academicYear)
      ..writeByte(3)
      ..write(obj.period)
      ..writeByte(4)
      ..write(obj.averageGradeGeneral)
      ..writeByte(5)
      ..write(obj.mention)
      ..writeByte(6)
      ..write(obj.rank)
      ..writeByte(7)
      ..write(obj.appreciation)
      ..writeByte(8)
      ..write(obj.pdfPath)
      ..writeByte(9)
      ..write(obj.generatedAt)
      ..writeByte(10)
      ..write(obj.createdAt)
      ..writeByte(11)
      ..write(obj.updatedAt);
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
      id: (json['id'] as num).toInt(),
      studentId: (json['studentId'] as num).toInt(),
      academicYear: json['academicYear'] as String,
      period: json['period'] as String,
      averageGradeGeneral: (json['averageGradeGeneral'] as num?)?.toDouble(),
      mention: json['mention'] as String?,
      rank: (json['rank'] as num?)?.toInt(),
      appreciation: json['appreciation'] as String?,
      pdfPath: json['pdfPath'] as String,
      generatedAt: json['generatedAt'] as String,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$ReportCardToJson(ReportCard instance) =>
    <String, dynamic>{
      'id': instance.id,
      'studentId': instance.studentId,
      'academicYear': instance.academicYear,
      'period': instance.period,
      'averageGradeGeneral': instance.averageGradeGeneral,
      'mention': instance.mention,
      'rank': instance.rank,
      'appreciation': instance.appreciation,
      'pdfPath': instance.pdfPath,
      'generatedAt': instance.generatedAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
