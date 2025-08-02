import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'parent.g.dart';

@HiveType(typeId: 17)
@JsonSerializable()
class Parent {
  @HiveField(0)
  final int? id;

  Parent({
    this.id,
  });

  factory Parent.fromJson(Map<String, dynamic> json) => _$ParentFromJson(json);
  Map<String, dynamic> toJson() => _$ParentToJson(this);
}