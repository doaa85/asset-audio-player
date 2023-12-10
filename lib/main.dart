import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isPlaying = false;
  final AssetsAudioPlayer _player = AssetsAudioPlayer();
  Color bgColor = const Color.fromRGBO(255, 152, 0, 1);

  @override
  void initState() {
    _player.open(Playlist(audios: [Audio('assets/sounds/')]), autoStart: false);
    _player.playlistFinished.listen((event) {
      print('<<<<<<<<<<<<<<DDDDD');
      isPlaying = false;
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Audios'),
        ),
        body: FutureBuilder<String>(
          future:
              DefaultAssetBundle.of(context).loadString('AssetMainfest.json'),
          builder: (context, item) {
            if (item.hasData) {
              Map? jsonMap = json.decode(item.data!);
              List? sounds = jsonMap?.keys.toList();
              return ListView.builder(
                  itemCount: sounds?.length,
                  itemBuilder: (context, index) {
                    var path = sounds![index].toString();
                    var title = path.split('/').last.toString(); //get file name
                    title = title.replaceAll('%20', ''); //remove %20 characters
                    title = title.split('.').first;
                    return Container(
                      margin: const EdgeInsets.only(
                          top: 10, left: 15.0, right: 15.0),
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(
                              color: Colors.white70,
                              width: 1.0,
                              style: BorderStyle.solid)),
                      child: ListTile(
                        textColor: Colors.white,
                        title: Text(title),
                        subtitle: Text(
                          'path:$path',
                          style: const TextStyle(
                              color: Colors.white70, fontSize: 12),
                        ),
                        leading: IconButton(
                          icon: Icon(Icons.play_arrow),
                          iconSize: 20,
                          onPressed: () async {
                            toast(context,
                                'you selected:$title'); //play this song

                            await _player.play();
                            await _player.setAsset(path);
                          },
                        ),
                      ),
                    );
                  });

              // List? sounds = jsonMap?.keys.where((element) => element.endswith('.mp3'));
            } else {
              return const Center(
                child: Text('No songs in the Assets'),
              );
            }
          },
        ));
  }

//toast method.
  void toast(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        text,
        textAlign: TextAlign.center,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0)),
    ));
  }
}
