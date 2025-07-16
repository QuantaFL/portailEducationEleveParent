import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 10)
@JsonSerializable()
class NotificationModel {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final int userId;
  @HiveField(2)
  final String type;
  @HiveField(3)
  final String message;
  @HiveField(4)
  final bool isSent;
  @HiveField(5)
  final String? sentAt;
  @HiveField(6)
  final String? createdAt;
  @HiveField(7)
  final String? updatedAt;
  @HiveField(8)
  final bool? isRead;
  @HiveField(9)
  final DateTime? readAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.message,
    required this.isSent,
    this.isRead,
    this.readAt,
    this.sentAt,
    this.createdAt,
    this.updatedAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
}
