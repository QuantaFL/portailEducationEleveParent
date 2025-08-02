// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parent.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParentAdapter extends TypeAdapter<Parent> {
  @override
  final int typeId = 17;

  @override
  Parent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Parent(
      id: fields[0] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Parent obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.id);
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
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ParentToJson(Parent instance) => <String, dynamic>{
      'id': instance.id,
    };
