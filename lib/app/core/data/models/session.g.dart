// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SessionAdapter extends TypeAdapter<Session> {
  @override
  final int typeId = 0;

  @override
  Session read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Session(
      id: fields[0] as int?,
      session: fields[1] as String,
      startDate: fields[2] as DateTime,
      reenrollDate: fields[3] as DateTime?,
      endDate: fields[4] as DateTime,
      active: fields[5] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Session obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.session)
      ..writeByte(2)
      ..write(obj.startDate)
      ..writeByte(3)
      ..write(obj.reenrollDate)
      ..writeByte(4)
      ..write(obj.endDate)
      ..writeByte(5)
      ..write(obj.active);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
  id: (json['id'] as num?)?.toInt(),
  session: json['session'] as String,
  startDate: DateTime.parse(json['startDate'] as String),
  reenrollDate: json['registration_start_date'] == null
      ? null
      : DateTime.parse(json['registration_start_date'] as String),
  endDate: DateTime.parse(json['endDate'] as String),
  active: json['is_active'] as bool,
);

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
  'id': instance.id,
  'session': instance.session,
  'startDate': instance.startDate.toIso8601String(),
  'registration_start_date': instance.reenrollDate?.toIso8601String(),
  'endDate': instance.endDate.toIso8601String(),
  'is_active': instance.active,
};
