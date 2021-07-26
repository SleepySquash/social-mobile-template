import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:social_app/core/services/router.dart';

import '../../core/services/server.dart';

/// Users screen shows the list of online users
///
/// {@category UI}
class ProfileModule extends StatelessWidget {
  const ProfileModule(this.username, {Key? key, this.isPlaceholder = false})
      : super(key: key);
  final String? username;
  final bool isPlaceholder;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: username == null ? AppBar() : null,
      body: username == null
          ? Center(
              child: Text(AppLocalizations.of(context)!.selectAUser),
            )
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  leading: isPlaceholder
                      ? null
                      : IconButton(
                          onPressed: () => context.read<RouterHistory>().pop(),
                          icon: const Icon(Icons.arrow_back),
                        ),
                  expandedHeight: MediaQuery.of(context).size.height * 0.6,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      fit: StackFit.passthrough,
                      alignment: Alignment.center,
                      children: [
                        Image.network(
                          'https://picsum.photos/900/500/?blur',
                          fit: BoxFit.cover,
                        ),
                        Image.network(
                          'https://picsum.photos/900/500',
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildListDelegate.fixed(
                    [
                      Align(
                        alignment: Alignment.center,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 500),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              ListTile(
                                title: Text(
                                  username!,
                                  style: Theme.of(context).textTheme.headline5,
                                ),
                                trailing: const Icon(Icons.edit),
                              ),
                              const ListTile(title: Text('dev')),
                              const Divider(thickness: 2),
                              const ListTile(title: Text('Gapopa ID')),
                              const Divider(thickness: 2),
                              ListTile(
                                title: Text(AppLocalizations.of(context)!
                                    .writeAMessage),
                                leading: const Icon(Icons.message),
                              ),
                              ListTile(
                                title: Text(
                                    AppLocalizations.of(context)!.audioCall),
                                leading: const Icon(Icons.call),
                              ),
                              ListTile(
                                title: Text(
                                    AppLocalizations.of(context)!.videoCall),
                                leading: const Icon(Icons.video_call),
                              ),
                              const Divider(thickness: 2),
                              ListTile(
                                title: Text(AppLocalizations.of(context)!
                                    .removeFromContacts),
                                leading: const Icon(Icons.contact_page),
                              ),
                              ListTile(
                                title: Text(AppLocalizations.of(context)!
                                    .removeFromFavorites),
                                leading: const Icon(Icons.star_outline),
                              ),
                              const Divider(thickness: 2),
                              ListTile(
                                title: Text(
                                    AppLocalizations.of(context)!.createGroup),
                                leading: const Icon(Icons.group),
                              ),
                              const Divider(thickness: 2),
                              ListTile(
                                title: Text(
                                    AppLocalizations.of(context)!.muteUser),
                                leading: const Icon(Icons.disabled_by_default),
                              ),
                              ListTile(
                                title: Text(
                                    AppLocalizations.of(context)!.blockUser),
                                leading: const Icon(Icons.block),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
