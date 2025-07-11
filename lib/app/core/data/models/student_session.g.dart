// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'student_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StudentSessionAdapter extends TypeAdapter<StudentSession> {
  @override
  final int typeId = 1;

  @override
  StudentSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StudentSession(
      id: fields[0] as int?,
      session: fields[1] as Session,
      student: fields[2] as Student,
      classe: fields[4] as ClassModel,
      isLeave: fields[5] as bool,
      isActive: fields[6] as bool,
      enrollDate: fields[7] as DateTime,
      status: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, StudentSession obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.session)
      ..writeByte(2)
      ..write(obj.student)
      ..writeByte(4)
      ..write(obj.classe)
      ..writeByte(5)
      ..write(obj.isLeave)
      ..writeByte(6)
      ..write(obj.isActive)
      ..writeByte(7)
      ..write(obj.enrollDate)
      ..writeByte(8)
      ..write(obj.status);
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
      session: Session.fromJson(json['session'] as Map<String, dynamic>),
      student: Student.fromJson(json['student'] as Map<String, dynamic>),
      classe: ClassModel.fromJson(json['classe'] as Map<String, dynamic>),
      isLeave: json['is_leave'] as bool,
      isActive: json['is_active'] as bool,
      enrollDate: DateTime.parse(json['enroll_date'] as String),
      status: json['status'] as String,
    );

Map<String, dynamic> _$StudentSessionToJson(StudentSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'session': instance.session.toJson(),
      'student': instance.student.toJson(),
      'classe': instance.classe.toJson(),
      'is_leave': instance.isLeave,
      'is_active': instance.isActive,
      'enroll_date': instance.enrollDate.toIso8601String(),
      'status': instance.status,
    };
