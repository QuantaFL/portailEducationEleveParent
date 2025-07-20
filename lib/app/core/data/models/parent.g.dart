// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParentAdapter extends TypeAdapter<Parent> {
  @override
  final int typeId = 2;

  @override
  Parent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Parent(
      id: fields[0] as int,
      userId: fields[1] as int,
      childrens: (fields[2] as List).cast<Student>(),
      user: fields[3] as User?,
      createdAt: fields[7] as String?,
      updatedAt: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Parent obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.childrens)
      ..writeByte(3)
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
      other is ParentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Parent _$ParentFromJson(Map<String, dynamic> json) => Parent(
      id: (json['id'] as num).toInt(),
      userId: (json['userId'] as num).toInt(),
      childrens: (json['childrens'] as List<dynamic>)
          .map((e) => Student.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: json['user'] == null
          ? null
          : User.fromJson(json['user'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$ParentToJson(Parent instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'childrens': instance.childrens,
      'user': instance.user,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
