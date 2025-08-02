import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive/hive.dart';
import 'package:portail_eleve/app/core/api/api_client.dart';
import 'package:portail_eleve/app/core/data/models/next_class.dart';
import 'package:portail_eleve/app/core/data/models/student.dart';

class StudentRepository {
  late ApiClient? apiClient;
  late Student student;

  StudentRepository({this.apiClient});

  Future<void> onInit(int id) {
    return getStudent(id);
  }

  Future<void> getStudent(int id) async {
    final response = await apiClient?.get('/students/$id');
    if (response?.statusCode == 200) {
      student = Student.fromJson(response?.data);
    } else {
      throw Exception('Failed to load parent data');
    }
  }

  Future<void> getStudentFromHive(int id) async {
    var box = await Hive.openBox<Student>('students');
    if (box.containsKey(id)) {
      student = box.get(id)!;
    } else {
      throw Exception('Student not found in Hive');
    }
  }

  Future<void> saveStudentToHive(Student student) async {
    var box = await Hive.openBox<Student>('students');
    await box.put(student.id, student);
  }

  /// Fetches detailed student info from the backend using user_model_id.
  /// Returns a Student object with all nested data populated.
  Future<Student> getStudentDetails(int studentId) async {
    final storage = const FlutterSecureStorage();
    final studentId = await storage.read(key: 'studentId');
    if (studentId == null) {
      throw Exception('No student ID found in secure storage');
    }
    try {
      await getStudentFromHive(int.parse(studentId));
      return student;
    } catch (e) {
      final response = await apiClient?.get('/students/$studentId/details');

      if (response?.statusCode == 200) {
        final detailedStudent = Student.fromJson(response?.data);
        await saveStudentToHive(detailedStudent);
        return detailedStudent;
      } else {
        throw Exception('Failed to load student details');
      }
    }
  }

  /// Fetches the next 3 classes for a student with Hive fallback and secure storage.
  /// First attempts to load from API, if fails, loads from Hive cache.
  /// Uses secure storage to get the current student ID.
  Future<List<NextClass>> fetchNextClasses() async {
    const storage = FlutterSecureStorage();

    try {
      // Get student ID from secure storage
      final studentIdStr = await storage.read(key: 'studentId');
      if (studentIdStr == null) {
        print('❌ No student ID found in secure storage');
        throw Exception('No student ID found in secure storage');
      }

      final studentId = int.parse(studentIdStr);
      print('📱 Fetching next classes for student ID: $studentId');

      // Try to fetch from API first
      try {
        print('🌐 Making API call to: /students/$studentId/next-classes');
        final response = await apiClient?.get(
          '/students/$studentId/next-classes',
        );

        print(
          '📡 API Response - Status: ${response?.statusCode}, Data type: ${response?.data.runtimeType}',
        );

        if (response?.statusCode == 200 && response?.data is List) {
          final nextClasses = (response?.data as List)
              .map((e) => NextClass.fromJson(Map<String, dynamic>.from(e)))
              .toList();

          print(
            '✅ Successfully fetched ${nextClasses.length} classes from API',
          );

          // Cache the result in Hive for offline access
          await _saveNextClassesToHive(studentId, nextClasses);

          return nextClasses;
        } else {
          print('⚠️ API call unsuccessful, trying Hive fallback');
          // API call failed, try Hive fallback
          return await _getNextClassesFromHive(studentId);
        }
      } catch (apiError) {
        // Network or API error, fallback to Hive
        print('❌ API error, falling back to Hive: $apiError');
        return await _getNextClassesFromHive(studentId);
      }
    } catch (e) {
      print('❌ Error fetching next classes: $e');
      return [];
    }
  }

  /// Saves next classes to Hive for offline access.
  Future<void> _saveNextClassesToHive(
    int studentId,
    List<NextClass> nextClasses,
  ) async {
    try {
      final box = await Hive.openBox<List>('next_classes');
      await box.put(studentId, nextClasses.map((nc) => nc.toJson()).toList());
    } catch (e) {
      print('Error saving next classes to Hive: $e');
    }
  }

  /// Retrieves next classes from Hive cache.
  Future<List<NextClass>> _getNextClassesFromHive(int studentId) async {
    try {
      final box = await Hive.openBox<List>('next_classes');
      final cached = box.get(studentId);

      if (cached != null) {
        return cached
            .map((e) => NextClass.fromJson(Map<String, dynamic>.from(e)))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error loading next classes from Hive: $e');
      return [];
    }
  }

  /// Legacy method for backward compatibility - fetches next classes with student ID parameter.
  @Deprecated('Use fetchNextClasses() without parameters instead')
  Future<List<NextClass>> fetchNextClassesById(int studentId) async {
    final response = await apiClient?.get('/students/$studentId/next-classes');
    if (response?.statusCode == 200 && response?.data is List) {
      return (response?.data as List)
          .map((e) => NextClass.fromJson(Map<String, dynamic>.from(e)))
          .toList();
    } else {
      return [];
    }
  }
}
