import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:social_app/core/services/router.dart';
import 'package:social_app/modules/profile/profile.dart';

class ContactsModule extends StatefulWidget {
  const ContactsModule({Key? key}) : super(key: key);

  @override
  State<ContactsModule> createState() => _ContactsModuleState();
}

class _ContactsModuleState extends State<ContactsModule>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final List<String> contactsList = List.generate(20, (i) => '$i');

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.contacts)),
      body: ListView(
          children: contactsList
              .map((e) => ListTile(
                    title: Text(e),
                    subtitle: const Text('Status'),
                    leading: const CircleAvatar(),
                    onTap: () => context
                        .read<RouterHistory>()
                        .replace(ProfileModule(e, key: ValueKey(e))),
                  ))
              .toList()),
    );
  }
}
