import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:portail_eleve/app/core/data/models/student.dart';
import 'package:portail_eleve/app/core/data/models/user_model.dart';

part 'parent.g.dart';

@HiveType(typeId: 17)
@JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
class Parent {
  @HiveField(0)
  final int? id;
  @HiveField(1)
  final UserModel? userModel;
  @HiveField(2)
  @JsonKey(defaultValue: [])
  List<Student> children = [];
  Parent({this.id, this.userModel});

  factory Parent.fromJson(Map<String, dynamic> json) => _$ParentFromJson(json);
  Map<String, dynamic> toJson() => _$ParentToJson(this);
}
