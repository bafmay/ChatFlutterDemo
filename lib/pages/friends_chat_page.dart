import 'package:chat_app_flutter/pages/channel_page.dart';
import 'package:chat_app_flutter/utils/data_utils.dart';
import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';

class FriendsChatPage extends StatefulWidget {
  const FriendsChatPage({Key key}) : super(key: key);

  @override
  _FriendsChatPageState createState() => _FriendsChatPageState();
}

class _FriendsChatPageState extends State<FriendsChatPage> {
  final _keyChannels = GlobalKey<ChannelsBlocState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Public Chat")),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _onCreateChannel(context),
        label: Text("Create Channel"),
      ),
      body: ChannelsBloc(
        key: _keyChannels,
        child: ChannelListView(
          channelWidget: ChannelPage(),
        ),
      ),
    );
  }

  Future<void> _onCreateChannel(context) async {
    final result = await showDialog(
      context: context,
      builder: (_) {
        final _channelController = TextEditingController();
        return AlertDialog(
          title: Text("Create Channel"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _channelController,
                decoration: InputDecoration(
                  hintText: "Channel name",
                ),
              ),
              ElevatedButton(
                onPressed: () =>
                    Navigator.of(context).pop(_channelController.text),
                child: Text("Go"),
              )
            ],
          ),
        );
      },
    );
    if (result != null) {
      final client = StreamChat.of(context).client;
      final channel = client.channel(
        "messaging",
        id: result,
        extraData: {"image": DataUtils.getChannelImage()},
      );
      await channel.create();
      _keyChannels.currentState.queryChannels();
    }
  }
}
