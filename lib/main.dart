import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'pages/home_chat_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Client _client;

  @override
  void initState() {
    _client = Client('epjmmwkgtna5', logLevel: Level.INFO);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return StreamChat(child: child, client: _client);
      },
      home: HomeChatPage(),
    );
  }
}
