import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:social_app/modules/profile/profile.dart';

import '../../core/services/router.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen(this._selectedChat, {Key? key}) : super(key: key);
  final String? _selectedChat;

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with AutomaticKeepAliveClientMixin {
  TextEditingController messageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  late List<String> chatMessages;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    chatMessages =
        List.generate(20, (index) => 'fqwl;f fjqwlk fjqwlk  gjkleqjgq');
  }

  @override
  Widget build(BuildContext context) {
    Widget messages = ListView(
      controller: scrollController,
      children: chatMessages
          .map(
            (e) => ListTile(
              title: Text(e),
              onTap: () => context.read<RouterHistory>().pop,
            ),
          )
          .toList(),
    );

    return Scaffold(
      appBar: widget._selectedChat == null
          ? AppBar()
          : AppBar(
              title: Text(widget._selectedChat!),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => {context.read<RouterHistory>().pop()},
              ),
              actions: [
                TextButton(
                  child: const CircleAvatar(),
                  onPressed: () => context
                      .read<RouterHistory>()
                      .push(ProfileModule(widget._selectedChat!)),
                )
              ],
            ),
      body: widget._selectedChat == null
          ? Center(child: Text(AppLocalizations.of(context)!.selectAChat))
          : messages,
      bottomNavigationBar: widget._selectedChat == null
          ? null
          : SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: messageController,
                      decoration: InputDecoration(
                        hintText:
                            AppLocalizations.of(context)!.emptyMessageField,
                      ),
                      onFieldSubmitted: (s) {
                        if (s.isNotEmpty) {
                          setState(
                              () => chatMessages.add(messageController.text));
                          messageController.clear();
                          Future.delayed(Duration.zero, () {
                            setState(() => scrollController.jumpTo(
                                scrollController.position.maxScrollExtent));
                          });
                        }
                      },
                      onChanged: (s) => setState(() {}),
                    ),
                  ),
                  IconButton(
                    onPressed: messageController.text.isEmpty
                        ? null
                        : () {
                            setState(
                                () => chatMessages.add(messageController.text));
                            messageController.clear();
                            Future.delayed(Duration.zero, () {
                              setState(() => scrollController.jumpTo(
                                  scrollController.position.maxScrollExtent));
                            });
                          },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
    );
  }
}
