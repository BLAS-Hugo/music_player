import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:music_player/widget/CustomText.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';


class Home extends StatefulWidget {
  Home({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {


  final API_KEY = '6991ab6b84803c30ad9b5640b386b03d';
  final URL = 'https://ws.audioscrobbler.com';
  String url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3';
  String musicUrl;
  String imageUrl;
  final ARTIST = 'Reh Hot Chili Peppers';
  final TITLE = 'Californication';
  bool playing = false;
  Duration position = new Duration(seconds: 0);
  Duration duration = new Duration(seconds: 10);
  AudioPlayer audioPlayer = AudioPlayer();
  PlayerState audioPlayerState = PlayerState.PAUSED;

  void getTrack() async{
    Response response = await get(Uri.parse(URL + '/2.0/?method=track.getInfo&api_key=$API_KEY&artist=$ARTIST&track=$TITLE&format=json'));
    Map data = jsonDecode(response.body);
    Map tracks = data['track'];
    musicUrl = tracks['url'];
    imageUrl = tracks['album']['image'][2]['#text'];
    duration = new Duration(milliseconds: int.parse(tracks['duration']));
    print(tracks);
  }

  @override
  void initState() {
    getTrack();
    super.initState();

    audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      setState(() {
        audioPlayerState = state;
      });
    });

    audioPlayer.setUrl(url);
    audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        audioDuration = duration.inSeconds;
      });
    });
    audioPlayer.onAudioPositionChanged.listen((Duration position) async {
      setState(() {
        timeProgress = position.inSeconds;
      });
    });

  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0.0,
            title: CustomText('Ma musique', color: Colors.grey[200]),
            centerTitle: true,
            backgroundColor: Colors.grey[900]
        ),
        body: Center(
            child: Column(
                children: <Widget>[
            Padding(padding: EdgeInsets.all(1.5.h)),
        SizedBox(
            height: 30.0.h,
            width: 50.0.w,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(imageUrl)
              ),
            )
        ),
        Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.all(1.0.h)),
            CustomText(TITLE, fontWeight: FontWeight.w700, fontSize: 20.0),
            Padding(padding: EdgeInsets.all(0.3.h)),
            CustomText(ARTIST, fontWeight: FontWeight.w400, fontSize: 15.0, color: Colors.grey[600]),
            Padding(padding: EdgeInsets.all(0.2.h)),
            CustomText('24 bits / 192KHz', fontWeight: FontWeight.w300, fontSize: 10.0, color: Colors.grey[600])
          ],
        ),
        Padding(padding: EdgeInsets.all(2.0.h)),
        Container(
            child:  Column(
                children: <Widget>[
                  Slider(
                      min: 0.0,
                      max: 30.0,
                      activeColor: Colors.grey[400],
                      inactiveColor: Colors.grey[700],
                      value: position.inSeconds.toDouble(),
                      onChanged: (double d) {
                        setState(() {
                          Duration newDuration = new Duration(seconds: d.toInt());
                          position = newDuration;
                        });
                      }
                  ),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        CustomText(getTimeString(duration.inSeconds), color: Colors.grey[600], fontWeight: FontWeight.w300, fontSize: 12.0),
                        Padding(padding: EdgeInsets.only(right: 6.0.w))
                      ]
                  )
                ])),
        Padding(padding: EdgeInsets.all(1.0.h)),
        ElevatedButton(
            onPressed: () => {
            setState(() => {
            audioPlayerState == PlayerState.PLAYING ? audioPlayerPause() : audioPlayerPlay()
            })},
            child: Icon(audioPlayerState == PlayerState.PLAYING ? Icons.play_arrow : Icons.pause, color: Colors.grey[900], size: 45),
            style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            padding: EdgeInsets.all(6.0),
            primary: Colors.grey[200],
            )
            ),
            Padding(padding: EdgeInsets.only(top: 14.0.h)),
            Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
            Container(
            child: Column(
            children: <Widget>[
            Icon(CupertinoIcons.music_albums_fill, color: Colors.grey[600]),
            CustomText('Musique', color: Colors.grey[600], fontWeight: FontWeight.w300, fontSize: 10.0)
            ]
            )
            ),
            Container(
            child: Column(
            children: <Widget>[
            ElevatedButton(
            onPressed: () => {
            setState(() => {
            if(playing) {
            playing = false,
            audioPlayerPause()
            } else if (!playing) {
            playing = true,
            audioPlayerPlay()
            }
            })
            },
            child: Icon(playing == false ? Icons.play_arrow : Icons.pause, color: Colors.grey[900], size: 15),
            style: ElevatedButton.styleFrom(
            shape: CircleBorder(),
            primary: Colors.grey[200],
            )
            ),
            ]
            )
            ),
            Container(
            child: Column(
            children: <Widget>[
            Icon(CupertinoIcons.music_house_fill, color: Colors.grey[600]),
            CustomText('Multiroom', color: Colors.grey[600], fontWeight: FontWeight.w300, fontSize: 10.0)
            ]
            )
            )
            ],
            )
            ]
        )
    ),

    );
    }

    String getTimeString(int seconds) {
    String minuteString =
    '${(seconds / 60).floor() < 10 ? 0 : ''}${(seconds / 60).floor()}';
    String secondString = '${seconds % 60 < 10 ? 0 : ''}${seconds % 60}';
    return '$minuteString:$secondString';
    }

    void seekToSec(int sec) {
    Duration newPos = Duration(seconds: sec);
    audioPlayer.seek(newPos);
    }

    audioPlayerPlay() async {
    await audioPlayer.play(url);
    }

    audioPlayerPause() async {
    await audioPlayer.pause();
    }

    int timeProgress = 0;
    int audioDuration = 0;

    Widget slider() {
    return Container(
    width: 300.0,
    child: Slider.adaptive(
    value: timeProgress.toDouble(),
    max: audioDuration.toDouble(),
    onChanged: (value) {
    seekToSec(value.toInt());
    }),
    );
    }
  }