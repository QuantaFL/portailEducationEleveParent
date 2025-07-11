import 'package:hive_flutter/adapters.dart';

import '../core/data/models/role.dart';
import '../core/data/models/student.dart';
import '../core/data/models/user.dart';

class HiveService {
  Future<void> init() async {
    await Hive.initFlutter();

    Hive.registerAdapter(RoleAdapter());
    Hive.registerAdapter(StudentAdapter());
    Hive.registerAdapter(UserAdapter());
    await Hive.openBox<User>('users');
    await Hive.openBox<Student>('students');
    await Hive.openBox<Role>('roles');
  }
}
