// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeacherAdapter extends TypeAdapter<Teacher> {
  @override
  final int typeId = 22;

  @override
  Teacher read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Teacher(
      id: fields[0] as int?,
      hireDate: fields[1] as DateTime?,
      createdAt: fields[2] as DateTime?,
      updatedAt: fields[3] as DateTime?,
      userModelId: fields[4] as int?,
      count: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Teacher obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.hireDate)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.userModelId)
      ..writeByte(5)
      ..write(obj.count);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeacherAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Teacher _$TeacherFromJson(Map<String, dynamic> json) => Teacher(
      id: (json['id'] as num?)?.toInt(),
      hireDate: json['hire_date'] == null
          ? null
          : DateTime.parse(json['hire_date'] as String),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      userModelId: (json['user_model_id'] as num?)?.toInt(),
      count: (json['count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$TeacherToJson(Teacher instance) => <String, dynamic>{
      'id': instance.id,
      'hire_date': instance.hireDate?.toIso8601String(),
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'user_model_id': instance.userModelId,
      'count': instance.count,
    };
