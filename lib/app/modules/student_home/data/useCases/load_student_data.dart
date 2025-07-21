import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:portail_eleve/app/core/data/models/student.dart';

class LoadStudentData {
  final Box<Student> studentBox = Hive.box<Student>('students');
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<Student?> call(int studentId) async {
    final userIdStr = await _storage.read(key: 'user_id');
    if (userIdStr == null) return null;
    final userId = int.tryParse(userIdStr);
    if (userId == null) return null;
    return studentBox.get(userId);
  }
}
