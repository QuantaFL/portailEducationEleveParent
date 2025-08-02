import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'role.g.dart';

@HiveType(typeId: 1)
@JsonSerializable(fieldRename: FieldRename.snake)
class Role {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;

  Role({required this.id, required this.name});

  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  Map<String, dynamic> toJson() => _$RoleToJson(this);
}
