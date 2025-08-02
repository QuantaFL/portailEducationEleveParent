// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 0;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      id: fields[0] as int,
      firstName: fields[2] as String,
      lastName: fields[3] as String,
      phone: fields[5] as String,
      email: fields[4] as String,
      roleId: fields[9] as int,
      address: fields[6] as String,
      dateOfBirth: fields[7] as String,
      gender: fields[8] as String,
      isFirstLogin: fields[11] as bool,
      profilePictureUrl: fields[12] as String?,
      role: fields[10] as Role?,
      rememberToken: fields[13] as String?,
      createdAt: fields[14] as String?,
      updatedAt: fields[15] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.firstName)
      ..writeByte(3)
      ..write(obj.lastName)
      ..writeByte(4)
      ..write(obj.email)
      ..writeByte(5)
      ..write(obj.phone)
      ..writeByte(6)
      ..write(obj.address)
      ..writeByte(7)
      ..write(obj.dateOfBirth)
      ..writeByte(8)
      ..write(obj.gender)
      ..writeByte(9)
      ..write(obj.roleId)
      ..writeByte(10)
      ..write(obj.role)
      ..writeByte(11)
      ..write(obj.isFirstLogin)
      ..writeByte(12)
      ..write(obj.profilePictureUrl)
      ..writeByte(13)
      ..write(obj.rememberToken)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: (json['id'] as num).toInt(),
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      roleId: (json['role_id'] as num).toInt(),
      address: json['address'] as String,
      dateOfBirth: json['date_of_birth'] as String,
      gender: json['gender'] as String,
      isFirstLogin: json['is_first_login'] as bool,
      profilePictureUrl: json['profile_picture_url'] as String?,
      role: json['role'] == null
          ? null
          : Role.fromJson(json['role'] as Map<String, dynamic>),
      rememberToken: json['remember_token'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'date_of_birth': instance.dateOfBirth,
      'gender': instance.gender,
      'role_id': instance.roleId,
      'role': instance.role?.toJson(),
      'is_first_login': instance.isFirstLogin,
      'profile_picture_url': instance.profilePictureUrl,
      'remember_token': instance.rememberToken,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
    };
