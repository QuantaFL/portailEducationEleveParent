```dart
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'academic_year.g.dart';

@HiveType(typeId: 13)
@JsonSerializable()
class AcademicYear {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  @JsonKey(name: 'label')
  final String? label;

  @HiveField(2)
  @JsonKey(name: 'start_date')
  final DateTime? startDate;

  @HiveField(3)
  @JsonKey(name: 'end_date')
  final DateTime? endDate;

  @HiveField(4)
  @JsonKey(name: 'status')
  final String? status;

  @HiveField(5)
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @HiveField(6)
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  AcademicYear({
    this.id,
    this.label,
    this.startDate,
    this.endDate,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory AcademicYear.fromJson(Map<String, dynamic> json) => _$AcademicYearFromJson(json);
  Map<String, dynamic> toJson() => _$AcademicYearToJson(this);
}
```

```dart
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'assignment.g.dart';

@HiveType(typeId: 14)
@JsonSerializable()
class Assignment {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @HiveField(2)
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @HiveField(3)
  @JsonKey(name: 'teacher_id')
  final int? teacherId;

  @HiveField(4)
  @JsonKey(name: 'class_model_id')
  final int? classModelId;

  @HiveField(5)
  @JsonKey(name: 'subject_id')
  final int? subjectId;

  @HiveField(6)
  @JsonKey(name: 'term_id')
  final int? termId;

  @HiveField(7)
  @JsonKey(name: 'day_of_week')
  final String? dayOfWeek;

  @HiveField(8)
  @JsonKey(name: 'start_time')
  final String? startTime;

  @HiveField(9)
  @JsonKey(name: 'end_time')
  final String? endTime;

  Assignment({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.teacherId,
    this.classModelId,
    this.subjectId,
    this.termId,
    this.dayOfWeek,
    this.startTime,
    this.endTime,
  });

  factory Assignment.fromJson(Map<String, dynamic> json) => _$AssignmentFromJson(json);
  Map<String, dynamic> toJson() => _$AssignmentToJson(this);
}
```

```dart
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'class_model.g.dart';

@HiveType(typeId: 15)
@JsonSerializable()
class ClassModel {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  @JsonKey(name: 'name')
  final String? name;

  @HiveField(2)
  @JsonKey(name: 'level')
  final String? level;

  @HiveField(3)
  @JsonKey(name: 'count')
  final int? count;

  @HiveField(4)
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @HiveField(5)
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  ClassModel({
    this.id,
    this.name,
    this.level,
    this.count,
    this.createdAt,
    this.updatedAt,
  });

  factory ClassModel.fromJson(Map<String, dynamic> json) => _$ClassModelFromJson(json);
  Map<String, dynamic> toJson() => _$ClassModelToJson(this);
}
```

```dart
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'grade.g.dart';

@HiveType(typeId: 16)
@JsonSerializable()
class Grade {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  @JsonKey(name: 'mark')
  final double? mark;

  @HiveField(2)
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @HiveField(3)
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @HiveField(4)
  @JsonKey(name: 'assignement_id')
  final int? assignementId;

  @HiveField(5)
  @JsonKey(name: 'student_session_id')
  final int? studentSessionId;

  @HiveField(6)
  @JsonKey(name: 'term_id')
  final int? termId;

  Grade({
    this.id,
    this.mark,
    this.createdAt,
    this.updatedAt,
    this.assignementId,
    this.studentSessionId,
    this.termId,
  });

  factory Grade.fromJson(Map<String, dynamic> json) => _$GradeFromJson(json);
  Map<String, dynamic> toJson() => _$GradeToJson(this);
}
```

```dart
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
```

```dart
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report_card.g.dart';

@HiveType(typeId: 18)
@JsonSerializable()
class ReportCard {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  @JsonKey(name: 'average_grade')
  final double? averageGrade;

  @HiveField(2)
  @JsonKey(name: 'honors')
  final String? honors;

  @HiveField(3)
  @JsonKey(name: 'path')
  final String? path;

  @HiveField(4)
  @JsonKey(name: 'pdf_url')
  final String? pdfUrl;

  @HiveField(5)
  @JsonKey(name: 'rank')
  final int? rank;

  @HiveField(6)
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @HiveField(7)
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @HiveField(8)
  @JsonKey(name: 'student_session_id')
  final int? studentSessionId;

  @HiveField(9)
  @JsonKey(name: 'term_id')
  final int? termId;

  ReportCard({
    this.id,
    this.averageGrade,
    this.honors,
    this.path,
    this.pdfUrl,
    this.rank,
    this.createdAt,
    this.updatedAt,
    this.studentSessionId,
    this.termId,
  });

  factory ReportCard.fromJson(Map<String, dynamic> json) => _$ReportCardFromJson(json);
  Map<String, dynamic> toJson() => _$ReportCardToJson(this);
}
```

```dart
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student.g.dart';

@HiveType(typeId: 19)
@JsonSerializable()
class Student {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  @JsonKey(name: 'matricule')
  final String? matricule;

  @HiveField(2)
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @HiveField(3)
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @HiveField(4)
  @JsonKey(name: 'parent_model_id')
  final int? parentModelId;

  @HiveField(5)
  @JsonKey(name: 'user_model_id')
  final int? userModelId;

  @HiveField(6)
  @JsonKey(name: 'count')
  final int? count;

  @HiveField(7)
  @JsonKey(name: 'maleCount')
  final int? maleCount;

  @HiveField(8)
  @JsonKey(name: 'femaleCount')
  final int? femaleCount;

  @HiveField(9)
  @JsonKey(name: 'academic_records_url')
  final String? academicRecordsUrl;

  Student({
    this.id,
    this.matricule,
    this.createdAt,
    this.updatedAt,
    this.parentModelId,
    this.userModelId,
    this.count,
    this.maleCount,
    this.femaleCount,
    this.academicRecordsUrl,
  });

  factory Student.fromJson(Map<String, dynamic> json) => _$StudentFromJson(json);
  Map<String, dynamic> toJson() => _$StudentToJson(this);
}
```

```dart
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'student_session.g.dart';

@HiveType(typeId: 20)
@JsonSerializable()
class StudentSession {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  @JsonKey(name: 'student_id')
  final int? studentId;

  @HiveField(2)
  @JsonKey(name: 'class_model_id')
  final int? classModelId;

  @HiveField(3)
  @JsonKey(name: 'academic_year_id')
  final int? academicYearId;

  @HiveField(4)
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @HiveField(5)
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @HiveField(6)
  @JsonKey(name: 'justificatif_url')
  final String? justificatifUrl;

  StudentSession({
    this.id,
    this.studentId,
    this.classModelId,
    this.academicYearId,
    this.createdAt,
    this.updatedAt,
    this.justificatifUrl,
  });

  factory StudentSession.fromJson(Map<String, dynamic> json) => _$StudentSessionFromJson(json);
  Map<String, dynamic> toJson() => _$StudentSessionToJson(this);
}
```

```dart
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subject.g.dart';

@HiveType(typeId: 21)
@JsonSerializable()
class Subject {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  @JsonKey(name: 'name')
  final String? name;

  @HiveField(2)
  @JsonKey(name: 'level')
  final String? level;

  @HiveField(3)
  @JsonKey(name: 'coefficient')
  final int? coefficient;

  @HiveField(4)
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @HiveField(5)
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  Subject({
    this.id,
    this.name,
    this.level,
    this.coefficient,
    this.createdAt,
    this.updatedAt,
  });

  factory Subject.fromJson(Map<String, dynamic> json) => _$SubjectFromJson(json);
  Map<String, dynamic> toJson() => _$SubjectToJson(this);
}
```

```dart
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'teacher.g.dart';

@HiveType(typeId: 22)
@JsonSerializable()
class Teacher {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  @JsonKey(name: 'hire_date')
  final DateTime? hireDate;

  @HiveField(2)
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @HiveField(3)
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @HiveField(4)
  @JsonKey(name: 'user_model_id')
  final int? userModelId;

  @HiveField(5)
  @JsonKey(name: 'count')
  final int? count;

  Teacher({
    this.id,
    this.hireDate,
    this.createdAt,
    this.updatedAt,
    this.userModelId,
    this.count,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) => _$TeacherFromJson(json);
  Map<String, dynamic> toJson() => _$TeacherToJson(this);
}
```

```dart
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'term.g.dart';

@HiveType(typeId: 23)
@JsonSerializable()
class Term {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  @JsonKey(name: 'name')
  final String? name;

  @HiveField(2)
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @HiveField(3)
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @HiveField(4)
  @JsonKey(name: 'academic_year_id')
  final int? academicYearId;

  Term({
    this.id,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.academicYearId,
  });

  factory Term.fromJson(Map<String, dynamic> json) => _$TermFromJson(json);
  Map<String, dynamic> toJson() => _$TermToJson(this);
}
```

```dart
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@HiveType(typeId: 24)
@JsonSerializable()
class UserModel {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  @JsonKey(name: 'first_name')
  final String? firstName;

  @HiveField(2)
  @JsonKey(name: 'last_name')
  final String? lastName;

  @HiveField(3)
  @JsonKey(name: 'birthday')
  final DateTime? birthday;

  @HiveField(4)
  @JsonKey(name: 'email')
  final String? email;

  @HiveField(5)
  @JsonKey(name: 'adress')
  final String? adress;

  @HiveField(6)
  @JsonKey(name: 'phone')
  final String? phone;

  @HiveField(7)
  @JsonKey(name: 'role_id')
  final int? roleId;

  @HiveField(8)
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;

  @HiveField(9)
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @HiveField(10)
  @JsonKey(name: 'profile_picture_url')
  final String? profilePictureUrl;

  @HiveField(11)
  @JsonKey(name: 'nationality')
  final String? nationality;

  @HiveField(12)
  @JsonKey(name: 'isFirstLogin')
  final bool? isFirstLogin;

  UserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.birthday,
    this.email,
    this.adress,
    this.phone,
    this.roleId,
    this.createdAt,
    this.updatedAt,
    this.profilePictureUrl,
    this.nationality,
    this.isFirstLogin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
```
