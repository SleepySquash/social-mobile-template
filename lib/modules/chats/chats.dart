import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:social_app/modules/chats/messages.dart';

import '../../core/services/router.dart';

class ChatsScreen extends StatefulWidget {
  const ChatsScreen({Key? key}) : super(key: key);

  @override
  State<ChatsScreen> createState() => _ChatsScreenState();
}

class _ChatsScreenState extends State<ChatsScreen>
    with AutomaticKeepAliveClientMixin {
  late List<String> chatList;

  @override
  void initState() {
    super.initState();
    chatList = List.generate(20, (index) => '$index');
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    Widget chats = ListView(
      children: chatList
          .map(
            (e) => ListTile(
              title: Text(e),
              subtitle: const Text(
                  'Placeholder message message message message message message message message message...',
                  overflow: TextOverflow.ellipsis),
              leading: const CircleAvatar(
                backgroundImage: NetworkImage('https://picsum.photos/200'),
              ),
              onTap: () {
                setState(() {
                  context
                      .read<RouterHistory>()
                      .replace(MessagesScreen(e, key: ValueKey(e)));
                });
              },
            ),
          )
          .toList(),
    );

    return Scaffold(
      key: const ValueKey<int>(0),
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.chats)),
      body: chats,
    );
  }
}
