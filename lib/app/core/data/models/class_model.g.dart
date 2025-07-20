// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassModelAdapter extends TypeAdapter<ClassModel> {
  @override
  final int typeId = 4;

  @override
  ClassModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassModel(
      id: fields[0] as int,
      name: fields[1] as String,
      academicYear: fields[2] as String,
      createdAt: fields[3] as String?,
      updatedAt: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ClassModel obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.academicYear)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClassModel _$ClassModelFromJson(Map<String, dynamic> json) => ClassModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      academicYear: json['academicYear'] as String,
      createdAt: json['createdAt'] as String?,
      updatedAt: json['updatedAt'] as String?,
    );

Map<String, dynamic> _$ClassModelToJson(ClassModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'academicYear': instance.academicYear,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
