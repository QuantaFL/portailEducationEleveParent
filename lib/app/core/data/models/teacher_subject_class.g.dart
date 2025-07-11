// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'teacher_subject_class.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TeacherSubjectClassAdapter extends TypeAdapter<TeacherSubjectClass> {
  @override
  final int typeId = 6;

  @override
  TeacherSubjectClass read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TeacherSubjectClass(
      teacherId: fields[0] as int,
      subjectId: fields[1] as int,
      classId: fields[2] as int,
      createdAt: fields[3] as String?,
      updatedAt: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, TeacherSubjectClass obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.teacherId)
      ..writeByte(1)
      ..write(obj.subjectId)
      ..writeByte(2)
      ..write(obj.classId)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TeacherSubjectClassAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TeacherSubjectClass _$TeacherSubjectClassFromJson(Map<String, dynamic> json) =>
    TeacherSubjectClass(
      teacherId: (json['teacherId'] as num).toInt(),
      subjectId: (json['subjectId'] as num).toInt(),
      classId: (json['classId'] as num).toInt(),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$TeacherSubjectClassToJson(
  TeacherSubjectClass instance,
) => <String, dynamic>{
  'teacherId': instance.teacherId,
  'subjectId': instance.subjectId,
  'classId': instance.classId,
  'createdAt': instance.createdAt,
  'updatedAt': instance.updatedAt,
};
