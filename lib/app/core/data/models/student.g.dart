// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentAdapter extends TypeAdapter<Student> {
  @override
  final int typeId = 19;

  @override
  Student read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Student(
      id: fields[0] as int?,
      matricule: fields[1] as String?,
      createdAt: fields[2] as String?,
      updatedAt: fields[3] as String?,
      parentModelId: fields[4] as int?,
      userModelId: fields[5] as int?,
      academicRecordsUrl: fields[6] as String?,
      userModel: fields[7] as UserModel?,
      parentModel: fields[8] as Parent?,
      latestStudentSession: fields[9] as StudentSession?,
      count: fields[10] as int?,
      maleCount: fields[11] as int?,
      femaleCount: fields[12] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer
      ..writeByte(13)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.matricule)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.updatedAt)
      ..writeByte(4)
      ..write(obj.parentModelId)
      ..writeByte(5)
      ..write(obj.userModelId)
      ..writeByte(6)
      ..write(obj.academicRecordsUrl)
      ..writeByte(7)
      ..write(obj.userModel)
      ..writeByte(8)
      ..write(obj.parentModel)
      ..writeByte(9)
      ..write(obj.latestStudentSession)
      ..writeByte(10)
      ..write(obj.count)
      ..writeByte(11)
      ..write(obj.maleCount)
      ..writeByte(12)
      ..write(obj.femaleCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StudentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      id: (json['id'] as num?)?.toInt(),
      matricule: json['matricule'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      parentModelId: (json['parent_model_id'] as num?)?.toInt(),
      userModelId: (json['user_model_id'] as num?)?.toInt(),
      academicRecordsUrl: json['academic_records_url'] as String?,
      userModel: json['userModel'] == null
          ? null
          : UserModel.fromJson(json['userModel'] as Map<String, dynamic>),
      parentModel: json['parentModel'] == null
          ? null
          : Parent.fromJson(json['parentModel'] as Map<String, dynamic>),
      latestStudentSession: json['latest_student_session'] == null
          ? null
          : StudentSession.fromJson(
              json['latest_student_session'] as Map<String, dynamic>),
      count: (json['count'] as num?)?.toInt(),
      maleCount: (json['maleCount'] as num?)?.toInt(),
      femaleCount: (json['femaleCount'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'id': instance.id,
      'matricule': instance.matricule,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'parent_model_id': instance.parentModelId,
      'user_model_id': instance.userModelId,
      'academic_records_url': instance.academicRecordsUrl,
      'userModel': instance.userModel?.toJson(),
      'parentModel': instance.parentModel?.toJson(),
      'latest_student_session': instance.latestStudentSession?.toJson(),
      'count': instance.count,
      'maleCount': instance.maleCount,
      'femaleCount': instance.femaleCount,
    };
