import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:portail_eleve/app/core/api/api_client.dart';
import 'package:portail_eleve/app/core/data/models/report_card.dart';

class PollLatestBulletins {
  final ApiClient apiClient;
  final FlutterLocalNotificationsPlugin notifications;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  final String channelId = 'bulletins';
  final String channelName = 'Documents disponibles';
  Timer? _timer;

  PollLatestBulletins({required this.apiClient, required this.notifications});

  Future<List<int>> getLinkedStudentIds() async {
    final userIdStr = await secureStorage.read(key: 'user_id');
    if (userIdStr == null) return [];
    final userId = int.tryParse(userIdStr);
    if (userId == null) return [];
    return [userId];
  }

  Future<DateTime?> getLastCheckedTimestamp(int studentId) async {
    final tsStr = await secureStorage.read(
      key: 'lastCheckedBulletinTimestamp_$studentId',
    );
    if (tsStr == null) return null;
    final ts = int.tryParse(tsStr);
    return ts != null ? DateTime.fromMillisecondsSinceEpoch(ts) : null;
  }

  Future<void> setLastCheckedTimestamp(
    int studentId,
    DateTime timestamp,
  ) async {
    await secureStorage.write(
      key: 'lastCheckedBulletinTimestamp_$studentId',
      value: timestamp.millisecondsSinceEpoch.toString(),
    );
  }

  Future<void> poll() async {
    final studentIds = await getLinkedStudentIds();
    for (final studentId in studentIds) {
      final lastChecked = await getLastCheckedTimestamp(studentId);
      final since = lastChecked?.toIso8601String() ?? '';
      final response = await apiClient.get(
        '/students/$studentId/bulletins/latest',
        queryParams: {'since': since},
      );
      if (response.statusCode == 200 &&
          response.data != null &&
          response.data['report_card'] != null) {
        final reportCard = ReportCard.fromJson(response.data['report_card']);
        // Download the file if needed
        // await downloadFile(reportCard.fileUrl);
        await showBulletinNotification(studentId, reportCard);
        await setLastCheckedTimestamp(studentId, DateTime.now());
      } else {
        // No bulletin found, do nothing
      }
    }
  }

  Future<void> showBulletinNotification(
    int studentId,
    ReportCard reportCard,
  ) async {
    String studentName = 'Votre enfant';
    final title = 'Nouveau bulletin disponible';
    final body =
        'Le bulletin de $studentName du(${reportCard.academicYear}) est maintenant accessible.';
    await notifications.show(
      reportCard.id,
      title,
      body,
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
  }

  void startPolling() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 2), (_) => poll());
  }

  void stopPolling() {
    _timer?.cancel();
  }
}
