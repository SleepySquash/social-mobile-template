import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../config/constraints.dart';
import '../../core/services/router.dart';
import '../../core/services/server.dart';
import '../../utils/ui/my_indexed_stack.dart';
import '../menu/menu.dart';
import '../chats/messages.dart';
import '../chats/chats.dart';
import '../profile/profile.dart';
import '../contacts/contacts.dart';

/// Home page controls which screen to show by listening to the server's status
///
/// {@category UI}
class HomeModule extends StatefulWidget {
  const HomeModule({Key? key}) : super(key: key);

  @override
  State<HomeModule> createState() => _HomeModuleState();
}

class _HomeModuleState extends State<HomeModule> {
  int _currentPage = 1;
  late PageController _pageController;
  List<RouterHistory> routers = [];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentPage, keepPage: true);

    routers.add(RouterHistory(
      root: const ContactsModule(),
      placeholder: const ProfileModule(null),
    ));
    routers.add(RouterHistory(
      root: const ChatsScreen(),
      placeholder: const MessagesScreen(null),
    ));
    routers.add(RouterHistory(
      root: const MenuScreen(),
      placeholder: ProfileModule(
        context.read<Server>().user!.username!,
        isPlaceholder: true,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Widget? navigation = BottomNavigationBar(
      currentIndex: _currentPage,
      onTap: (i) => _pageController.jumpToPage(i),
      items: [
        BottomNavigationBarItem(
          icon: const Icon(Icons.contacts),
          label: AppLocalizations.of(context)!.contacts,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.message),
          label: AppLocalizations.of(context)!.messages,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person),
          label: AppLocalizations.of(context)!.menu,
        ),
      ],
    );

    Widget _layout = Builder(
      builder: (context) {
        RouterHistory e = context.read<RouterHistory>();
        return ValueListenableBuilder(
          valueListenable: e.history,
          builder: (context, List<Widget> history, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                bool isMobile =
                    ConfigConstraints.isMobile(constraints.maxWidth);
                Widget placeholder = isMobile
                    ? const Scaffold(backgroundColor: Colors.transparent)
                    : e.placeholder ?? Container();

                return Stack(
                  children: [
                    Row(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: ConfigConstraints.maxSideBarWidth(
                                constraints.maxWidth),
                          ),
                          child: Scaffold(
                            body: e.root,
                            bottomNavigationBar: navigation,
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                    Row(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: isMobile && history.isNotEmpty
                                ? 0
                                : ConfigConstraints.maxSideBarWidth(
                                    constraints.maxWidth),
                          ),
                          child: Container(),
                        ),
                        Expanded(
                          child: Scaffold(
                            backgroundColor: Colors.transparent,
                            body: MyIndexedStack(
                              index: e.length,
                              children: [placeholder, ...history],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            );
          },
        );
      },
    );

    return PageView(
      controller: _pageController,
      onPageChanged: (p) => setState(() => _currentPage = p),
      physics: const NeverScrollableScrollPhysics(),
      children: routers
          .map(
            (e) => ChangeNotifierProvider.value(
              value: e,
              builder: (context, child) => _layout,
            ),
          )
          .toList(),
    );
  }
}
