import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';

import '../api/api_client.dart';
import '../data/models/report_card.dart';
import '../data/models/student.dart';
import '../data/models/user_model.dart';
import '../data/repositories/bulletin_repository.dart';

class ParentService extends GetxService {
  late final ApiClient _apiClient;
  late final BulletinRepository _bulletinRepository;
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  final Logger _logger = Logger();

  static const String _parentBoxName = 'parent_data';
  static const String _childrenBoxName = 'children_data';
  static const String _childrenUsersBoxName = 'children_users_data';
  static const String _bulletinsBoxName = 'bulletins_data';

  @override
  void onInit() {
    super.onInit();
    _apiClient = Get.find<ApiClient>();
    _bulletinRepository = Get.find<BulletinRepository>();
  }

  /// Gets current parent user data with Hive fallback
  Future<UserModel> getCurrentParent() async {
    try {
      final userId = await _storage.read(key: 'user_id');
      _logger.d('🔍 Chargement des données parent (ID: $userId)...');

      final response = await _apiClient.get('/parents/$userId');
      final parentUser = UserModel.fromJson(response.data['userModel']);

      await _saveParentToHive(parentUser);
      _logger.i('✅ Données parent chargées et sauvées');

      return parentUser;
    } catch (e) {
      _logger.w('⚠️ Erreur réseau, fallback vers Hive: $e');
      return await _getParentFromHive();
    }
  }

  /// Gets children with Hive fallback
  Future<List<Student>> getChildren() async {
    try {
      final userId = await _storage.read(key: 'user_id');
      _logger.d('🔍 Chargement des enfants...');

      final response = await _apiClient.get('/parents/$userId/children');
      final children = (response.data as List)
          .map((json) => Student.fromJson(json))
          .toList();

      await _saveChildrenToHive(children);
      _logger.i('✅ ${children.length} enfants chargés et sauvés');

      return children;
    } catch (e) {
      _logger.w('⚠️ Erreur réseau, fallback vers Hive: $e');
      return await _getChildrenFromHive();
    }
  }

  /// Gets children users with Hive fallback
  Future<List<UserModel>> getChildrenUsers() async {
    try {
      final userId = await _storage.read(key: 'user_id');
      _logger.d('🔍 Chargement des données utilisateurs des enfants...');

      final response = await _apiClient.get('/parents/$userId/children');
      final List<UserModel> childrenUsers = [];

      for (final childData in response.data) {
        if (childData['userModel'] != null) {
          childrenUsers.add(UserModel.fromJson(childData['userModel']));
        }
      }

      // Save to Hive for offline access
      await _saveChildrenUsersToHive(childrenUsers);
      _logger.i(
        '✅ ${childrenUsers.length} données utilisateurs enfants sauvées',
      );

      return childrenUsers;
    } catch (e) {
      _logger.w('⚠️ Erreur réseau, fallback vers Hive: $e');
      return await _getChildrenUsersFromHive();
    }
  }

  /// Gets bulletins for a specific child with Hive fallback
  Future<List<ReportCard>> getBulletinsForChild(int studentId) async {
    try {
      _logger.d('🔍 Chargement des bulletins pour l\'enfant $studentId...');
      final bulletins = await _bulletinRepository.getBulletins(studentId);

      await _saveBulletinsToHive(studentId, bulletins);

      _logger.i(
        '✅ ${bulletins.length} bulletins chargés et sauvés pour l\'enfant $studentId',
      );
      return bulletins;
    } catch (e) {
      _logger.w(
        '⚠️ Erreur réseau, fallback vers Hive pour enfant $studentId: $e',
      );
      return await _getBulletinsFromHive(studentId);
    }
  }

  /// Downloads a bulletin
  Future<String?> downloadBulletin(int bulletinId, String studentName) async {
    try {
      _logger.d(
        '📥 Téléchargement du bulletin $bulletinId pour $studentName...',
      );
      final downloadPath =
          '/storage/emulated/0/Download/bulletin_${studentName}_$bulletinId.pdf';
      await _bulletinRepository.downloadBulletin(bulletinId, downloadPath);
      _logger.i('✅ Bulletin téléchargé: $downloadPath');
      return downloadPath;
    } catch (e) {
      _logger.e('❌ Erreur téléchargement bulletin $bulletinId: $e');
      throw Exception('Impossible de télécharger le bulletin');
    }
  }

  /// Save parent data to Hive
  Future<void> _saveParentToHive(UserModel parent) async {
    try {
      final box = await Hive.openBox<Map>(_parentBoxName);
      await box.put('current_parent', parent.toJson());
      await box.close();
    } catch (e) {
      _logger.e('❌ Erreur sauvegarde parent vers Hive: $e');
    }
  }

  /// Get parent data from Hive
  Future<UserModel> _getParentFromHive() async {
    try {
      final box = await Hive.openBox<Map>(_parentBoxName);
      final parentData = box.get('current_parent');
      await box.close();

      if (parentData != null) {
        _logger.i('✅ Données parent récupérées depuis Hive');
        return UserModel.fromJson(Map<String, dynamic>.from(parentData));
      }
    } catch (e) {
      _logger.e('❌ Erreur lecture parent depuis Hive: $e');
    }

    throw Exception('Aucune donnée parent disponible hors ligne');
  }

  /// Save children to Hive
  Future<void> _saveChildrenToHive(List<Student> children) async {
    try {
      final box = await Hive.openBox<List>(_childrenBoxName);
      await box.put('children_list', children.map((c) => c.toJson()).toList());
      await box.close();
    } catch (e) {
      _logger.e('❌ Erreur sauvegarde enfants vers Hive: $e');
    }
  }

  /// Get children from Hive
  Future<List<Student>> _getChildrenFromHive() async {
    try {
      final box = await Hive.openBox<List>(_childrenBoxName);
      final childrenData = box.get('children_list');
      await box.close();

      if (childrenData != null) {
        _logger.i('✅ ${childrenData.length} enfants récupérés depuis Hive');
        return childrenData
            .map((data) => Student.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      }
    } catch (e) {
      _logger.e('❌ Erreur lecture enfants depuis Hive: $e');
    }

    return [];
  }

  /// Save children users to Hive
  Future<void> _saveChildrenUsersToHive(List<UserModel> childrenUsers) async {
    try {
      final box = await Hive.openBox<List>(_childrenUsersBoxName);
      await box.put(
        'children_users_list',
        childrenUsers.map((u) => u.toJson()).toList(),
      );
      await box.close();
    } catch (e) {
      _logger.e('❌ Erreur sauvegarde utilisateurs enfants vers Hive: $e');
    }
  }

  /// Get children users from Hive
  Future<List<UserModel>> _getChildrenUsersFromHive() async {
    try {
      final box = await Hive.openBox<List>(_childrenUsersBoxName);
      final usersData = box.get('children_users_list');
      await box.close();

      if (usersData != null) {
        _logger.i(
          '✅ ${usersData.length} utilisateurs enfants récupérés depuis Hive',
        );
        return usersData
            .map((data) => UserModel.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      }
    } catch (e) {
      _logger.e('❌ Erreur lecture utilisateurs enfants depuis Hive: $e');
    }

    return [];
  }

  /// Save bulletins to Hive
  Future<void> _saveBulletinsToHive(
    int studentId,
    List<ReportCard> bulletins,
  ) async {
    try {
      final box = await Hive.openBox<List>(_bulletinsBoxName);
      await box.put(
        'bulletins_list_$studentId',
        bulletins.map((b) => b.toJson()).toList(),
      );
      await box.close();
    } catch (e) {
      _logger.e('❌ Erreur sauvegarde bulletins vers Hive: $e');
    }
  }

  /// Get bulletins from Hive
  Future<List<ReportCard>> _getBulletinsFromHive(int studentId) async {
    try {
      final box = await Hive.openBox<List>(_bulletinsBoxName);
      final bulletinsData = box.get('bulletins_list_$studentId');
      await box.close();

      if (bulletinsData != null) {
        _logger.i('✅ ${bulletinsData.length} bulletins récupérés depuis Hive');
        return bulletinsData
            .map((data) => ReportCard.fromJson(Map<String, dynamic>.from(data)))
            .toList();
      }
    } catch (e) {
      _logger.e('❌ Erreur lecture bulletins depuis Hive: $e');
    }

    return [];
  }
}
