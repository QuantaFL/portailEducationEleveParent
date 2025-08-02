// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 24;

  @override
  UserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserModel(
      id: fields[0] as int?,
      firstName: fields[1] as String?,
      lastName: fields[2] as String?,
      birthday: fields[3] as DateTime?,
      email: fields[4] as String?,
      adress: fields[5] as String?,
      phone: fields[6] as String?,
      roleId: fields[7] as int?,
      createdAt: fields[8] as DateTime?,
      updatedAt: fields[9] as DateTime?,
      profilePictureUrl: fields[10] as String?,
      nationality: fields[11] as String?,
      isFirstLogin: fields[12] as bool?,
      latestStudentSession: fields[13] as StudentSession?,
    );
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.birthday)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.adress)
      ..writeByte(6)
      ..write(obj.phone)
      ..writeByte(7)
      ..write(obj.roleId)
      ..writeByte(8)
      ..write(obj.createdAt)
      ..writeByte(9)
      ..write(obj.updatedAt)
      ..writeByte(10)
      ..write(obj.profilePictureUrl)
      ..writeByte(11)
      ..write(obj.nationality)
      ..writeByte(12)
      ..write(obj.isFirstLogin)
      ..writeByte(13)
      ..write(obj.latestStudentSession);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
      id: (json['id'] as num?)?.toInt(),
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      birthday: json['birthday'] == null
          ? null
          : DateTime.parse(json['birthday'] as String),
      email: json['email'] as String?,
      adress: json['adress'] as String?,
      phone: json['phone'] as String?,
      roleId: (json['role_id'] as num?)?.toInt(),
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.parse(json['updated_at'] as String),
      profilePictureUrl: json['profile_picture_url'] as String?,
      nationality: json['nationality'] as String?,
      isFirstLogin: json['is_first_login'] as bool?,
      latestStudentSession: json['latest_student_session'] == null
          ? null
          : StudentSession.fromJson(
              json['latest_student_session'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'birthday': instance.birthday?.toIso8601String(),
      'email': instance.email,
      'adress': instance.adress,
      'phone': instance.phone,
      'role_id': instance.roleId,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
      'profile_picture_url': instance.profilePictureUrl,
      'nationality': instance.nationality,
      'is_first_login': instance.isFirstLogin,
      'latest_student_session': instance.latestStudentSession,
    };
