import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:portail_eleve/app/core/api/api_client.dart';

class PollLatestNotes {
  final ApiClient apiClient;
  final FlutterLocalNotificationsPlugin notifications;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final String channelId = 'notes';
  final String channelName = 'Notes et évaluations';
  Timer? _timer;

  PollLatestNotes({required this.apiClient, required this.notifications});

  Future<List<int>> getLinkedStudentIds() async {
    final userIdStr = await secureStorage.read(key: 'user_id');
    if (userIdStr == null) return [];
    final userId = int.tryParse(userIdStr);
    if (userId == null) return [];
    return [userId];
  }

  Future<String?> getLastSeenNoteKey(int studentId) async {
    return await secureStorage.read(key: 'lastSeenNote_$studentId');
  }

  Future<void> setLastSeenNoteKey(int studentId, String key) async {
    await secureStorage.write(key: 'lastSeenNote_$studentId', value: key);
  }

  Future<void> poll() async {
    final studentIds = await getLinkedStudentIds();
    for (final studentId in studentIds) {
      final lastSeenKey = await getLastSeenNoteKey(studentId);
      String? lastNoteId;
      String? lastUpdatedAt;
      if (lastSeenKey != null && lastSeenKey.contains('_')) {
        final parts = lastSeenKey.split('_');
        lastNoteId = parts[0];
        lastUpdatedAt = parts[1];
      }
      final response = await apiClient.get(
        '/students/$studentId/notes/latest',
        queryParams: lastUpdatedAt != null ? {'since': lastUpdatedAt} : null,
      );
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['id'] != null) {
        final note = response.data;
        final noteId = note['id'].toString();
        final updatedAt = note['updated_at'] as String;
        final newKey = '${noteId}_$updatedAt';
        if (lastSeenKey != newKey) {
          String notifTitle = 'Nouvelle note en ${note['subject']}';
          String notifBody = '';
          if (lastSeenKey == null) {
            notifBody = 'Devoir: ${note['note_devoir'] ?? '-'}';
          } else {
            // Check for update: if note_devoir or note_exam was null before and now has value
            notifTitle = 'Mise à jour en ${note['subject']}';
            if (note['note_exam'] != null) {
              notifBody = 'Examen ajouté (${note['note_exam']})';
            } else if (note['note_devoir'] != null) {
              notifBody = 'Devoir mis à jour (${note['note_devoir']})';
            } else {
              notifBody = 'Note modifiée';
            }
          }
          await notifications.show(
            int.tryParse(noteId) ?? 0,
            notifTitle,
            notifBody,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channelId,
                channelName,
                importance: Importance.high,
                priority: Priority.high,
                playSound: true,
                enableVibration: true,
              ),
            ),
          );
          await setLastSeenNoteKey(studentId, newKey);
        }
      }
    }
  }

  void startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 30), (_) => poll());
  }

  void stopPolling() {
    _timer?.cancel();
  }
}
