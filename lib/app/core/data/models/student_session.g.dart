// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentSessionAdapter extends TypeAdapter<StudentSession> {
  @override
  final int typeId = 20;

  @override
  StudentSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentSession(
      id: fields[0] as int?,
      studentId: fields[1] as int?,
      classModelId: fields[2] as int?,
      academicYearId: fields[3] as int?,
      createdAt: fields[4] as String?,
      updatedAt: fields[5] as String?,
      justificatifUrl: fields[6] as String?,
      classModel: fields[7] as ClassModel?,
      academicYear: fields[8] as AcademicYear?,
    );
  }

  @override
  void write(BinaryWriter writer, StudentSession obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.studentId)
      ..writeByte(2)
      ..write(obj.classModelId)
      ..writeByte(3)
      ..write(obj.academicYearId)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.justificatifUrl)
      ..writeByte(7)
      ..write(obj.classModel)
      ..writeByte(8)
      ..write(obj.academicYear);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StudentSession _$StudentSessionFromJson(Map<String, dynamic> json) =>
    StudentSession(
      id: (json['id'] as num?)?.toInt(),
      studentId: (json['student_id'] as num?)?.toInt(),
      classModelId: (json['class_model_id'] as num?)?.toInt(),
      academicYearId: (json['academic_year_id'] as num?)?.toInt(),
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      justificatifUrl: json['justificatif_url'] as String?,
      classModel: json['class_model'] == null
          ? null
          : ClassModel.fromJson(json['class_model'] as Map<String, dynamic>),
      academicYear: json['academic_year'] == null
          ? null
          : AcademicYear.fromJson(
              json['academic_year'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StudentSessionToJson(StudentSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'student_id': instance.studentId,
      'class_model_id': instance.classModelId,
      'academic_year_id': instance.academicYearId,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'justificatif_url': instance.justificatifUrl,
      'class_model': instance.classModel,
      'academic_year': instance.academicYear,
    };
