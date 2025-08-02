import 'package:hive_flutter/adapters.dart';
import 'package:portail_eleve/app/core/data/models/academic_year.dart';
import 'package:portail_eleve/app/core/data/models/class_model.dart';
import 'package:portail_eleve/app/core/data/models/parent.dart';

import '../core/data/models/role.dart';
import '../core/data/models/student.dart';
import '../core/data/models/student_session.dart';
import '../core/data/models/user.dart';
import '../core/data/models/user_model.dart';

class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(RoleAdapter());
    Hive.registerAdapter(StudentAdapter());
    Hive.registerAdapter(UserAdapter());
    Hive.registerAdapter(ParentAdapter());
    Hive.registerAdapter(StudentSessionAdapter());
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ClassModelAdapter());
    Hive.registerAdapter(AcademicYearAdapter());
    await Hive.openBox<User>('users');
    await Hive.openBox<Student>('students');
    await Hive.openBox<Role>('roles');
    await Hive.openBox<Parent>('parents');
    await Hive.openBox<StudentSession>('student_sessions');
    await Hive.openBox<UserModel>('user_models');
    await Hive.openBox<ClassModel>('class_models');
    await Hive.openBox<AcademicYear>('academic_years');
  }
}
