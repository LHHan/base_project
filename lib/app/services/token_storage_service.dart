import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../core/utils/app_log.dart';
import '../data/models/token_model.dart';

/// Persists auth tokens in the platform secure store (Keychain / EncryptedSharedPreferences).
///
/// Migrates legacy plain-text keys from [GetStorage] on first run.
class TokenStorageService extends GetxService {
  static const _kTokenJson = 'auth_token_json';

  final FlutterSecureStorage _secure = const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: const IOSOptions(
      accessibility: KeychainAccessibility.first_unlock_this_device,
    ),
  );

  Future<TokenStorageService> init() async {
    await _migrateFromGetStorageIfNeeded();
    return this;
  }

  Future<void> _migrateFromGetStorageIfNeeded() async {
    final existing = await _secure.read(key: _kTokenJson);
    if (existing != null && existing.isNotEmpty) {
      return;
    }

    final box = GetStorage();

    if (box.hasData(Token.localKey)) {
      final raw = box.read(Token.localKey);
      if (raw is Map<String, dynamic>) {
        await persistToken(Token.fromJson(raw));
        box.remove(Token.localKey);
        if (kDebugMode) {
          logger.i('Migrated auth token from GetStorage (${Token.localKey})');
        }
        return;
      }
    }

    final String? access = box.read<String>('accessToken');
    final String? refresh = box.read<String>('refreshToken');
    if ((access != null && access.isNotEmpty) ||
        (refresh != null && refresh.isNotEmpty)) {
      await persistToken(
        Token(
          tokenType: 'Bearer',
          expiresIn: -1,
          accessToken: access ?? '',
          refreshToken: refresh ?? '',
        ),
      );
      box.remove('accessToken');
      box.remove('refreshToken');
      if (kDebugMode) {
        logger.i('Migrated access/refresh tokens from GetStorage');
      }
    }
  }

  Future<Token?> readToken() async {
    final s = await _secure.read(key: _kTokenJson);
    if (s == null || s.isEmpty) {
      return null;
    }
    try {
      return Token.fromJson(jsonDecode(s) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<String?> readAccessToken() async {
    final t = await readToken();
    if (t == null || t.accessToken.isEmpty) {
      return null;
    }
    return t.accessToken;
  }

  Future<String?> readRefreshToken() async {
    final t = await readToken();
    if (t == null || t.refreshToken.isEmpty) {
      return null;
    }
    return t.refreshToken;
  }

  Future<void> persistToken(Token token) async {
    await _secure.write(
      key: _kTokenJson,
      value: jsonEncode(token.toJson()),
    );
  }

  Future<void> saveTokensFromStrings({
    required String accessToken,
    required String refreshToken,
  }) async {
    final existing = await readToken();
    await persistToken(
      Token(
        tokenType: existing?.tokenType ?? 'Bearer',
        expiresIn: existing?.expiresIn ?? -1,
        accessToken: accessToken,
        refreshToken: refreshToken,
      ),
    );
  }

  Future<void> clearAuth() async {
    await _secure.delete(key: _kTokenJson);
  }

  static TokenStorageService get I => Get.find<TokenStorageService>();
}
