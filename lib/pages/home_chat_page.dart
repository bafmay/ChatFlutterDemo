import 'package:chat_app_flutter/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

import 'friends_chat_page.dart';

class HomeChatPage extends StatefulWidget {
  const HomeChatPage({Key key}) : super(key: key);

  @override
  _HomeChatPageState createState() => _HomeChatPageState();
}

class _HomeChatPageState extends State<HomeChatPage> {
  final _usernameController = TextEditingController();
  String _usernameError;
  bool _loading = false;

  Future<void> _onGoPressed() async {
    final username = _usernameController.text;
    if (username.isEmpty) {
      setState(() {
        _usernameError = "Username is not valid";
      });
    } else {
      final client = StreamChat.of(context).client;
      final user = client.state.user;
      if (user == null) {
        setState(() {
          _loading = true;
        });
        await client.setUser(
          User(
            id: username,
            extraData: {
              'image': DataUtils.getUserImage(username),
            },
          ),
          client.devToken(username),
        );
        setState(() {
          _loading = false;
        });
      }
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => FriendsChatPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    final client = StreamChat.of(context).client;
    final user = client.state.user;
    return Scaffold(
      appBar: AppBar(
        title: Text("Stream Chat"),
      ),
      body: Center(
        child: _loading
            ? CircularProgressIndicator()
            : Card(
                elevation: 11,
                margin: const EdgeInsets.all(15.0),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text("Welcome to the public chat"),
                      if (user == null)
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                              hintText: "Username", errorText: _usernameError),
                        )
                      else
                        Text("Username: ${user.id}"),
                      ElevatedButton(
                        onPressed: _onGoPressed,
                        child: Text("Go"),
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
