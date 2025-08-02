
import 'package:portail_eleve/app/core/api/api_client.dart';
import 'package:portail_eleve/app/core/data/models/report_card.dart';

class BulletinRepository {
  late ApiClient apiClient;

  BulletinRepository({required this.apiClient});

  Future<List<ReportCard>> getBulletins(int studentId) async {
    final response = await apiClient.get('/students/$studentId/report-cards');
    if (response.statusCode == 200) {
      return (response.data as List)
          .map((bulletin) => ReportCard.fromJson(bulletin))
          .toList();
    } else {
      throw Exception('Failed to load bulletins');
    }
  }
}
