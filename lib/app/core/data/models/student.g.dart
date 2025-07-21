// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentAdapter extends TypeAdapter<Student> {
  @override
  final int typeId = 2;

  @override
  Student read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Student(
      id: fields[0] as int,
      userId: fields[1] as int,
      user: fields[6] as User?,
      classModel: fields[7] as ClassModel?,
      enrollmentDate: fields[2] as String,
      classId: fields[3] as int,
      parentUserId: fields[4] as int?,
      studentIdNumber: fields[5] as String,
      createdAt: fields[8] as String?,
      updatedAt: fields[9] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.enrollmentDate)
      ..writeByte(3)
      ..write(obj.classId)
      ..writeByte(4)
      ..write(obj.parentUserId)
      ..writeByte(5)
      ..write(obj.studentIdNumber)
      ..writeByte(6)
      ..write(obj.user)
      ..writeByte(7)
      ..write(obj.classModel)
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
      other is StudentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Student _$StudentFromJson(Map<String, dynamic> json) => Student(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      classModel: json['class_model'] == null
          ? null
          : ClassModel.fromJson(json['class_model'] as Map<String, dynamic>),
      enrollmentDate: json['enrollment_date'] as String,
      classId: (json['class_id'] as num).toInt(),
      parentUserId: (json['parent_user_id'] as num?)?.toInt(),
      studentIdNumber: json['student_id_number'] as String,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'enrollment_date': instance.enrollmentDate,
      'class_id': instance.classId,
      'parent_user_id': instance.parentUserId,
      'student_id_number': instance.studentIdNumber,
      'user': instance.user,
      'class_model': instance.classModel,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
