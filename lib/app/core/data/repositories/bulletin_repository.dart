import 'package:portail_eleve/app/core/api/api_client.dart';
import 'package:portail_eleve/app/core/data/models/report_card.dart';

class BulletinRepository {
  late ApiClient apiClient;

  BulletinRepository({required this.apiClient});

  Future<List<ReportCard>> getBulletins(int studentId) async {
    final response = await apiClient.get('/students/$studentId/report-cards');
    if (response.statusCode == 200 && response.data != null) {
      // Handle the new API response structure: { "report_cards": [...] }
      if (response.data is Map<String, dynamic>) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('report_cards') && data['report_cards'] is List) {
          return (data['report_cards'] as List)
              .map((bulletin) => ReportCard.fromJson(bulletin))
              .toList();
        }
      }
      // Fallback for legacy direct array response
      else if (response.data is List) {
        return (response.data as List)
            .map((bulletin) => ReportCard.fromJson(bulletin))
            .toList();
      }

      // If neither structure matches, return empty list
      return [];
    } else {
      throw Exception('Failed to load bulletins: ${response.statusCode}');
    }
  }
}
