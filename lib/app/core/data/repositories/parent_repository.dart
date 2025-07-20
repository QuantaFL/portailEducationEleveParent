import 'package:portail_eleve/app/core/api/api_client.dart';
import 'package:portail_eleve/app/core/data/models/parent.dart';

import '../models/student.dart';

class ParentRepository {
  late ApiClient apiClient;
  late Parent parent;
  late List<Student> children;

  ParentRepository({required this.apiClient});
  Future<void> onInit(int id) {
    return getParent(id);
  }

  Future<void> getParent(int id) async {
    final response = await apiClient.get('/parents/$id');
    if (response.statusCode == 200) {
      parent = Parent.fromJson(response.data);
      children = (response.data['children'] as List)
          .map((child) => Student.fromJson(child))
          .toList();
    } else {
      throw Exception('Failed to load parent data');
    }
  }
}
