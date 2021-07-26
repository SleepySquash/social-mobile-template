import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/server.dart';
import '../modules/auth/auth.dart';
import '../modules/home/home.dart';

class AppRouter extends StatelessWidget {
  const AppRouter({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: context.read<Server>().authStatus,
      builder: (_, AuthStatus value, child) {
        switch (value) {
          case AuthStatus.authorized:
            return const HomeModule();
          default:
            return const AuthModule();
        }
      },
    );
  }
}
