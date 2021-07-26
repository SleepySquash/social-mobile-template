import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/services/server.dart';

class AuthModule extends StatefulWidget {
  const AuthModule({Key? key}) : super(key: key);

  @override
  State<AuthModule> createState() => _AuthModuleState();
}

class _AuthModuleState extends State<AuthModule> {
  bool _loginFetched = false;
  TextEditingController usernameController = TextEditingController(),
      passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tryLogin();
  }

  void _tryLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token != null) context.read<Server>().auth(token);
    setState(() {
      _loginFetched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Application icon and the title text
    Widget titleWidget = Column(
      children: [
        const Icon(Icons.call, size: 108),
        Text(
          'Universal Messenger',
          style: Theme.of(context).textTheme.headline4,
          textAlign: TextAlign.center,
        ),
        Text(
          'by Gapopa',
          style: Theme.of(context).textTheme.subtitle1,
          textAlign: TextAlign.center,
        )
      ],
    );

    Widget denialWidget = Container();

    // Username input text field and login button
    Widget inputWidget = Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            controller: usernameController,
            onChanged: (s) => setState(() {}),
            maxLength: 32,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(32.0)),
              ),
              filled: true,
              fillColor: Colors.white70,
              constraints: const BoxConstraints(minWidth: 100, maxWidth: 400),
              hintText: 'Username',
              hintStyle: TextStyle(color: Colors.grey[800]),
              icon: const Icon(Icons.person),
            ),
          ),
        ),
        denialWidget,
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            minimumSize: const Size(200, 60),
          ),
          onPressed: usernameController.text.isNotEmpty
              ? () => context.read<Server>().login('123', '123')
              : null,
          child: const Text('Login'),
        )
      ],
    );

    return Scaffold(
      body: Center(
        child: _loginFetched
            ? ValueListenableBuilder<Object>(
                valueListenable: context.read<Server>().authStatus,
                builder: (context, value, child) {
                  switch (value) {
                    case AuthStatus.unauthorized:
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [titleWidget, inputWidget],
                      );
                  }
                  return const Center(child: CircularProgressIndicator());
                })
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
