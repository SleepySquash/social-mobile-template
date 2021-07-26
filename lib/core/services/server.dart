import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/server.dart';
import '../models/user.dart';

/// Connection status.
enum ServerConnectionStatus { disconnected, connecting, connected, authorized }
enum AuthStatus { unauthorized, authorizing, authorized }

/// Serves connection to the Signaling server.
///
/// {@category API}
class Server {
  /// Status is [ValueNotifier] of [ServerConnectionStatus]
  ValueNotifier<ServerConnectionStatus> connectionStatus =
      ValueNotifier<ServerConnectionStatus>(
          ServerConnectionStatus.disconnected);

  /// Status is [ValueNotifier] of [AuthStatus]
  ValueNotifier<AuthStatus> authStatus =
      ValueNotifier<AuthStatus>(AuthStatus.unauthorized);

  User? user;

  Server() {
    connect(ConfigServer.url);
  }

  Future<void> connect(String url) async {
    if (connectionStatus.value != ServerConnectionStatus.connected) {
      connectionStatus.value = ServerConnectionStatus.connecting;
      await Future.delayed(const Duration(milliseconds: 100));
      connectionStatus.value = ServerConnectionStatus.connected;
    }
  }

  Future<void> auth(String token) async {
    authStatus.value = AuthStatus.authorizing;
    await Future.delayed(const Duration(seconds: 1));

    user = User(username: '123');
    authStatus.value = AuthStatus.authorized;
  }

  Future<void> login(String username, String password) async {
    authStatus.value = AuthStatus.authorizing;
    await Future.delayed(const Duration(seconds: 1));

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', '123');
    user = User(username: '123');
    authStatus.value = AuthStatus.authorized;
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    user = null;

    authStatus.value = AuthStatus.unauthorized;
  }
}
