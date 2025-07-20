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
      enrollmentDate: fields[2] as String,
      classId: fields[3] as int,
      parentUserId: fields[4] as int?,
      studentIdNumber: fields[5] as String,
      createdAt: fields[7] as String?,
      updatedAt: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer
      ..writeByte(9)
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
      ..write(obj.createdAt)
      ..writeByte(8)
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
      userId: (json['userId'] as num).toInt(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      classModel: json['classModel'] == null
          ? null
          : ClassModel.fromJson(json['classModel'] as Map<String, dynamic>),
      enrollmentDate: json['enrollmentDate'] as String,
      classId: (json['classId'] as num).toInt(),
      parentUserId: (json['parentUserId'] as num?)?.toInt(),
      studentIdNumber: json['studentIdNumber'] as String,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$StudentToJson(Student instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'enrollmentDate': instance.enrollmentDate,
      'classId': instance.classId,
      'parentUserId': instance.parentUserId,
      'studentIdNumber': instance.studentIdNumber,
      'user': instance.user,
      'classModel': instance.classModel,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
