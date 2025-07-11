// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeacherAdapter extends TypeAdapter<Teacher> {
  @override
  final int typeId = 3;

  @override
  Teacher read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Teacher(
      id: fields[0] as int,
      userId: fields[1] as int,
      hireDate: fields[6] as String,
      user: fields[7] as User?,
      createdAt: fields[8] as String?,
      updatedAt: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Teacher obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(6)
      ..write(obj.hireDate)
      ..writeByte(7)
      ..write(obj.user)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt);
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
  id: (json['id'] as num).toInt(),
  userId: (json['userId'] as num).toInt(),
  hireDate: json['hireDate'] as String,
  user: json['user'] == null
      ? null
      : User.fromJson(json['user'] as Map<String, dynamic>),
  createdAt: json['createdAt'] as String?,
  updatedAt: json['updatedAt'] as String?,
);

Map<String, dynamic> _$TeacherToJson(Teacher instance) => <String, dynamic>{
  'id': instance.id,
  'userId': instance.userId,
  'hireDate': instance.hireDate,
  'user': instance.user,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
