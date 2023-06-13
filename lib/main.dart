import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';

enum BeatType { snare, hi_tom, mid_tom, floor_tom, kick, hi_hat, crash, ride }

enum ControlCommand { play, stop }

String beatTypeName(BeatType beatType) {
  switch (beatType) {
    case BeatType.snare:
      return "snare";
    case BeatType.hi_tom:
      return "hi-tom";
    case BeatType.mid_tom:
      return "mid-tom";
    case BeatType.floor_tom:
      return "floor-tom";
    case BeatType.kick:
      return "kick";
    case BeatType.hi_hat:
      return "hi-hat";
    case BeatType.crash:
      return "crash";
    case BeatType.ride:
      return "ride";
  }
}

// final player = AudioPlayer();
// final hiHatPlayer = AudioPlayer();
// final crashPlayer = AudioPlayer();
// final ridePlayer = AudioPlayer();
final snarePlayer = AudioPlayer();
final hiTomPlayer = AudioPlayer();
final midTomPlayer = AudioPlayer();
final floorTomPlayer = AudioPlayer();
final kickPlayer = AudioPlayer();
final hiHatPlayer = AudioPlayer();
final crashPlayer = AudioPlayer();
final ridePlayer = AudioPlayer();

AudioPlayer playerByBeatType(BeatType beatType) {
  switch (beatType) {
    case BeatType.snare:
      return snarePlayer;
    case BeatType.hi_tom:
      return hiTomPlayer;
    case BeatType.mid_tom:
      return midTomPlayer;
    case BeatType.floor_tom:
      return floorTomPlayer;
    case BeatType.kick:
      return kickPlayer;
    case BeatType.hi_hat:
      return hiHatPlayer;
    case BeatType.crash:
      return crashPlayer;
    case BeatType.ride:
      return ridePlayer;
  }
}

// AudioPlayer playerByBeatType(BeatType beatType) {
//   switch (beatType) {
//     case BeatType.snare:
//       return player;
//     case BeatType.hi_tom:
//       return player;
//     case BeatType.mid_tom:
//       return player;
//     case BeatType.floor_tom:
//       return player;
//     case BeatType.kick:
//       return player;
//     case BeatType.hi_hat:
//       return hiHatPlayer;
//     case BeatType.crash:
//       return crashPlayer;
//     case BeatType.ride:
//       return ridePlayer;
//   }
// }

AssetSource assetByBeatType(BeatType beatType) {
  switch (beatType) {
    case BeatType.snare:
      return AssetSource('kit/real-01BB1-snare-R2M.wav');
    case BeatType.hi_tom:
      return AssetSource('kit/real-03.TOM2C-L.wav');
    case BeatType.mid_tom:
      return AssetSource('kit/real-03.TOM3C-L.wav');
    case BeatType.floor_tom:
      return AssetSource('kit/real-08.TOM4M.wav');
    case BeatType.kick:
      return AssetSource('kit/real-kick-F039.wav');
    case BeatType.hi_hat:
      return AssetSource('kit/real-01L2.UF-HiHat-M.wav');
    case BeatType.crash:
      return AssetSource('kit/real-01CH12ACSM.wav');
    case BeatType.ride:
      return AssetSource('kit/real-02BL20RKRM.wav');
  }
}

final List<int> loop = List.filled(16, 0, growable: false);

void setBeatInLoop(BeatType beatType, int index) {
  var bitmask = 1 << beatType.index;
  loop[index] = loop[index] ^ bitmask;
}

int bpm = 120;
int _loopIndex = 0;

// Iterable<int> _loopStream() sync* {
//   while (true) {
//     yield loop[_loopIndex];
//     if (_loopIndex == 15) {
//       _loopIndex = 0;
//     } else {
//       _loopIndex++;
//     }
//   }
// }

// Future<void> playLoop() async {
//   for (final beats in _loopStream()) {

//   }
// }

// Future<void> initPlayer() async {
// await Future.forEach(BeatType.values,
//     (beatType) => player.setSource(assetByBeatType(beatType)));
// await player.setPlayerMode(PlayerMode.lowLatency);
// await player.setReleaseMode(ReleaseMode.stop);
// await crashPlayer.setPlayerMode(PlayerMode.lowLatency);
// await crashPlayer.setReleaseMode(ReleaseMode.stop);
// await ridePlayer.setPlayerMode(PlayerMode.lowLatency);
// await ridePlayer.setReleaseMode(ReleaseMode.stop);
// await hiHatPlayer.setPlayerMode(PlayerMode.lowLatency);
// await hiHatPlayer.setReleaseMode(ReleaseMode.stop);
// }

Future<void> initPlayer() async {
  await snarePlayer.setSource(AssetSource('kit/real-01BB1-snare-R2M.wav'));
  await snarePlayer.setPlayerMode(PlayerMode.lowLatency);
  await hiTomPlayer.setSource(AssetSource('kit/real-03.TOM2C-L.wav'));
  await hiTomPlayer.setPlayerMode(PlayerMode.lowLatency);
  await midTomPlayer.setSource(AssetSource('kit/real-03.TOM3C-L.wav'));
  await midTomPlayer.setPlayerMode(PlayerMode.lowLatency);
  await floorTomPlayer.setSource(AssetSource('kit/real-08.TOM4M.wav'));
  await floorTomPlayer.setPlayerMode(PlayerMode.lowLatency);
  await kickPlayer.setSource(AssetSource('kit/real-kick-F039.wav'));
  await kickPlayer.setPlayerMode(PlayerMode.lowLatency);
  await hiHatPlayer.setSource(AssetSource('kit/real-01L2.UF-HiHat-M.wav'));
  await hiHatPlayer.setPlayerMode(PlayerMode.lowLatency);
  await crashPlayer.setSource(AssetSource('kit/real-01CH12ACSM.wav'));
  await crashPlayer.setPlayerMode(PlayerMode.lowLatency);
  await ridePlayer.setSource(AssetSource('kit/real-02BL20RKRM.wav'));
  await ridePlayer.setPlayerMode(PlayerMode.lowLatency);
}

// void playAudio((SendPort, RootIsolateToken) initParams) async {
//   BackgroundIsolateBinaryMessenger.ensureInitialized(initParams.$2);
//   ReceivePort audioReceivePort = ReceivePort();
//   initParams.$1.send(audioReceivePort.sendPort);
//   await for (var message in audioReceivePort) {
//     if (message is BeatType) {
//       var as = assetSourceByType[message];
//       if (as != null) {
//         await player.play(as);
//       }
//     } else if (message is ControlCommand) {
//       switch (message) {
//         case ControlCommand.play:
//           // start playng loop
//           break;
//         case ControlCommand.stop:
//           // stop playing loop
//           break;
//       }
//     } else if (message is (BeatType, int)) {
//       setBeatInLoop(message.$1, message.$2);
//     }
//   }
// }

late SendPort audioSendPort;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  RootIsolateToken rootIsolateToken = RootIsolateToken.instance!;
  await initPlayer();
  BackgroundIsolateBinaryMessenger.ensureInitialized(rootIsolateToken);
  runApp(const Drumbox());
}

class Drumbox extends StatelessWidget {
  const Drumbox({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drumbox',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.blue, brightness: Brightness.dark),
        useMaterial3: true,
      ),
      home: const MainContainer(title: 'Drumbox'),
    );
  }
}

class MainContainer extends StatelessWidget {
  const MainContainer({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Tempo(bpm: bpm, click: true),
            KitPart(beatType: BeatType.snare, amount: 16),
            KitPart(beatType: BeatType.hi_tom, amount: 16),
            KitPart(beatType: BeatType.mid_tom, amount: 16),
            KitPart(beatType: BeatType.floor_tom, amount: 16),
            KitPart(beatType: BeatType.kick, amount: 16),
            KitPart(beatType: BeatType.hi_hat, amount: 16),
            KitPart(beatType: BeatType.crash, amount: 16),
            KitPart(beatType: BeatType.ride, amount: 16),
          ],
        ),
      ),
    );
  }
}

class Tempo extends StatefulWidget {
  final int bpm;
  final bool click;

  Tempo({super.key, required this.bpm, this.click = false});

  @override
  State<Tempo> createState() => _TempoState();
}

class _TempoState extends State<Tempo> {
  final _bpmController = TextEditingController();
  late int _bpm;
  late bool _click;

  @override
  void initState() {
    super.initState();
    _bpm = widget.bpm;
    _click = widget.click;
    _bpmController.value = TextEditingValue(text: _bpm.toString());
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _bpmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var clickIcon = Icons.check_box_outline_blank;
    if (_click) {
      clickIcon = Icons.check_box;
    }
    return Row(
      children: <Widget>[
        const Text("bpm"),
        SizedBox(
            width: 60.0,
            child: TextField(
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly
              ],
              controller: _bpmController,
            )),
        const Text("click"),
        IconButton(
          icon: Icon(clickIcon),
          color: Colors.white,
          iconSize: 24.0,
          onPressed: () {
            setState(() {
              _click = !_click;
            });
          },
        )
      ],
    );
  }
}

class KitPart extends StatefulWidget {
  final BeatType beatType;
  final int amount;

  KitPart({super.key, required this.beatType, this.amount = 16});

  @override
  State<KitPart> createState() => _KitPartState();
}

class _KitPartState extends State<KitPart> {
  late BeatType _beatType;
  late int _beatAmount;

  @override
  void initState() {
    super.initState();
    _beatType = widget.beatType;
    _beatAmount = widget.amount;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> beats = List<Widget>.generate(
        _beatAmount, (index) => Beat(beatType: _beatType, index: index));

    return Row(
      children: <Widget>[
        SizedBox(width: 120.0, child: Text(beatTypeName(_beatType))),
        Row(
          children: beats,
        )
      ],
    );
  }
}

class Beat extends StatefulWidget {
  final BeatType beatType;
  final int index;

  const Beat({super.key, required this.beatType, required this.index});

  @override
  State<Beat> createState() => _BeatState();
}

class _BeatState extends State<Beat> {
  late BeatType _beatType;
  late int _index;
  bool _active = false;

  @override
  void initState() {
    super.initState();
    _beatType = widget.beatType;
    _index = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    var activeIcon = Icons.check_box_outline_blank;
    if (_active) {
      activeIcon = Icons.check_box;
    }
    return IconButton(
      icon: Icon(activeIcon),
      color: Colors.white,
      iconSize: 24.0,
      onPressed: () async {
        var player = playerByBeatType(_beatType);
        // var assetSource = assetByBeatType(_beatType);
        // await player.stop();
        // await player.play(assetSource);
        // var assetSource = assetByBeatType(_beatType);
        await player.stop();
        await player.resume();
        // await player.play(assetSource);
        setState(() {
          _active = !_active;
        });
      },
    );
  }
}
