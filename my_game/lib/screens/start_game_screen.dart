import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class StartGame extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _StartGameState();
  }
}

class _StartGameState extends State<StartGame> {
  var icon = Icons.volume_up;
  bool playing = true;
  final assetAudioPlayer = AssetsAudioPlayer();

  @override
  void initState() {
    assetAudioPlayer.open('audios/main_theme.mp3');
    assetAudioPlayer.loop = true;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
              icon: Icon(icon, color: Theme.of(context).primaryColor,),
              onPressed: () {
                if (!playing) {
                  setState(() {
                    assetAudioPlayer.play();
                    icon = Icons.volume_up;
                    playing = true;
                  });
                } else {
                  setState(() {
                    assetAudioPlayer.pause();
                    icon = Icons.volume_off;
                    playing = false;
                  });
                }
              }),
        ],
      ),
      body: Container(
        width: double.infinity,
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              margin: EdgeInsets.all(30),
              padding: EdgeInsets.all(0),
              height: 400,
              child: Image.asset(
                'images/pacman.png',
                fit: BoxFit.contain,
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: RaisedButton.icon(
                    clipBehavior: Clip.hardEdge,
                    color: Colors.yellowAccent,
                    onPressed: () {},
                    icon: Icon(Icons.play_arrow),
                    label: Text('Start Game'))),
          ],
        ),
      ),
    );
  }
}
