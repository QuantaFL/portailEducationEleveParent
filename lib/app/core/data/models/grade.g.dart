// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'grade.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GradeAdapter extends TypeAdapter<Grade> {
  @override
  final int typeId = 16;

  @override
  Grade read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Grade(
      id: fields[0] as int?,
      mark: fields[1] as double?,
      createdAt: fields[2] as DateTime?,
      updatedAt: fields[3] as DateTime?,
      assignementId: fields[4] as int?,
      studentSessionId: fields[5] as int?,
      termId: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Grade obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.mark)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.assignementId)
      ..writeByte(5)
      ..write(obj.studentSessionId)
      ..writeByte(6)
      ..write(obj.termId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Grade _$GradeFromJson(Map<String, dynamic> json) => Grade(
      id: (json['id'] as num?)?.toInt(),
      mark: (json['mark'] as num?)?.toDouble(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      assignementId: (json['assignement_id'] as num?)?.toInt(),
      studentSessionId: (json['student_session_id'] as num?)?.toInt(),
      termId: (json['term_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GradeToJson(Grade instance) => <String, dynamic>{
      'id': instance.id,
      'mark': instance.mark,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'assignement_id': instance.assignementId,
      'student_session_id': instance.studentSessionId,
      'term_id': instance.termId,
    };
