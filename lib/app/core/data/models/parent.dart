import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:portail_eleve/app/core/data/models/student.dart';
import 'package:portail_eleve/app/core/data/models/user.dart';

part 'parent.g.dart';

@HiveType(typeId: 2)
@JsonSerializable()
class Parent {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int userId;
  @HiveField(2)
  final List<Student> childrens;
  @HiveField(3)
  final User? user;
  @HiveField(7)
  final String? createdAt;
  @HiveField(8)
  final String? updatedAt;

  Parent({
    required this.id,
    required this.userId,
    required this.childrens,
    this.user,
    this.createdAt,
    this.updatedAt,
  });

  factory Parent.fromJson(Map<String, dynamic> json) => _$ParentFromJson(json);

  Map<String, dynamic> toJson() => _$ParentToJson(this);
}
