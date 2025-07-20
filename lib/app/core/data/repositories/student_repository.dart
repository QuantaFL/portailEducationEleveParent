import 'package:portail_eleve/app/core/api/api_client.dart';
import 'package:portail_eleve/app/core/data/models/student.dart';

class StudentRepository {
  late ApiClient apiClient;
  late Student student;

  StudentRepository({required this.apiClient});

  Future<void> onInit(int id) {
    return getStudent(id);
  }

  Future<void> getStudent(int id) async {
    final response = await apiClient.get('/students/$id');
    if (response.statusCode == 200) {
      student = Student.fromJson(response.data);
    } else {
      throw Exception('Failed to load parent data');
    }
  }
}
