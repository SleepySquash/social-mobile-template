import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:social_app/core/services/locale.dart';

import '../../core/services/router.dart';
import '../../core/services/server.dart';
import '../profile/profile.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.menu)),
      body: ListView(
        children: [
          const SizedBox(height: 10),
          ListTile(
            title: Text(AppLocalizations.of(context)!.yourProfile),
            leading: const CircleAvatar(),
            onTap: () => context
                .read<RouterHistory>()
                .push(ProfileModule(context.read<Server>().user!.username!)),
          ),
          const Divider(thickness: 2),
          ListTile(
            title: Text(AppLocalizations.of(context)!.settings),
            leading: const Icon(Icons.settings),
          ),
          ExpandablePanel(
            header: ListTile(
              leading: const Icon(Icons.language),
              title: Text(LocaleProvider.toLanguage(
                  AppLocalizations.of(context)!.localeName)),
            ),
            collapsed: Container(),
            expanded: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: AppLocalizations.supportedLocales
                    .map((e) => ListTile(
                        leading: const Icon(Icons.flag),
                        title: Text(LocaleProvider.toLanguage(e.languageCode)),
                        onTap: () {
                          context
                              .read<LocaleProvider>()
                              .setLocale(e.languageCode);
                        }))
                    .toList(),
              ),
            ),
          ),
          const Divider(thickness: 2),
          ListTile(
            title: Text(AppLocalizations.of(context)!.privacy),
            leading: const Icon(Icons.privacy_tip),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.termsOfUse),
            leading: const Icon(Icons.data_usage),
          ),
          ListTile(
            title: Text(AppLocalizations.of(context)!.reportAProblem),
            leading: const Icon(Icons.report),
          ),
          const Divider(thickness: 2),
          ListTile(
            title: Text(AppLocalizations.of(context)!.logOut),
            leading: const Icon(Icons.logout),
            onTap: () => context.read<Server>().logout(),
          ),
        ],
      ),
    );
  }
}
