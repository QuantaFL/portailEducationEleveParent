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
      password: fields[6] as String,
      roleId: fields[10] as int,
      address: fields[7] as String,
      dateOfBirth: fields[8] as String,
      gender: fields[9] as String,
      role: fields[11] as Role?,
      rememberToken: fields[12] as String?,
      createdAt: fields[13] as String?,
      updatedAt: fields[14] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(14)
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
      ..write(obj.password)
      ..writeByte(7)
      ..write(obj.address)
      ..writeByte(8)
      ..write(obj.dateOfBirth)
      ..writeByte(9)
      ..write(obj.gender)
      ..writeByte(10)
      ..write(obj.roleId)
      ..writeByte(11)
      ..write(obj.role)
      ..writeByte(12)
      ..write(obj.rememberToken)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
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
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      roleId: (json['roleId'] as num).toInt(),
      address: json['address'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      gender: json['gender'] as String,
      role: json['role'] == null
          ? null
          : Role.fromJson(json['role'] as Map<String, dynamic>),
      rememberToken: json['rememberToken'] as String?,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'phone': instance.phone,
      'password': instance.password,
      'address': instance.address,
      'dateOfBirth': instance.dateOfBirth,
      'gender': instance.gender,
      'roleId': instance.roleId,
      'role': instance.role,
      'rememberToken': instance.rememberToken,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
