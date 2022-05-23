// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qr_code/widgets/round-button.dart';
import 'package:web_socket_channel/io.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter/cupertino.dart';

//apply this class on home: attribute at MaterialApp()
class WebSocketLed extends StatefulWidget {
  WebSocketLed({Key key, @required this.text}) : super(key: key);
  final String text;
  @override
  _WebSocketLed createState() => _WebSocketLed();
}

class _WebSocketLed extends State<WebSocketLed> with TickerProviderStateMixin {
  bool ledstatus;

  IOWebSocketChannel channel;
  bool connected;
  AnimationController controller;
  bool isPlaying = false;

  String get countText {
    Duration count = controller.duration * controller.value;
    return controller.isDismissed
        ? '${controller.duration.inHours}:${(controller.duration.inMinutes % 60).toString().padLeft(2, '0')}:${(controller.duration.inSeconds % 60).toString().padLeft(2, '0')}'
        : '${count.inHours}:${(count.inMinutes % 60).toString().padLeft(2, '0')}:${(count.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  double progress = 1.0;

  void notify() {
    if (countText == '0:00:00') {
      FlutterRingtonePlayer.playNotification();
    }
  }

  @override
  void initState() {
    ledstatus = false; //initially leadstatus is off so its FALSE
    connected = false;
    int timer = int.parse(widget.text);
    controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: timer),
    );
    controller.addListener(() {
      notify();
      if (controller.isAnimating) {
        setState(() {
          progress = controller.value;
        });
      } else {
        setState(() {
          progress = 1.0;
          isPlaying = false;
        });
      }
    });
//initially connection status is "NO" so its FALSE

    Future.delayed(Duration.zero, () async {
      channelconnect(); //connect to WebSocket wth NodeMCU
    });

    super.initState();
  }

  channelconnect() {
    //function to connect
    try {
      channel = IOWebSocketChannel.connect(
          "ws://192.168.1.17:81"); //channel IP : Port
      channel.stream.listen(
        (message) {
          print(message);
          setState(() {
            if (message == "connected") {
              connected = true; //message is "connected" from NodeMCU
            } else if (message == "poweron:success") {
              ledstatus = true;
            } else if (message == "poweroff:success") {
              ledstatus = false;
            }
          });
        },
        onDone: () {
          //if WebSocket is disconnected
          print("Web socket is closed");
          setState(() {
            connected = false;
          });
        },
        onError: (error) {
          print(error.toString());
        },
      );
    } catch (_) {
      print("error on connecting to websocket.");
    }
  }

  Future<void> sendcmd(String cmd) async {
    if (connected == true && isPlaying && controller.duration != 0) {
      if (ledstatus == false && cmd != "poweron" && cmd != "poweroff") {
        print("Send the valid command");
      } else {
        channel.sink.add(cmd); //sending Command to NodeMCU
      }
    } else {
      channelconnect();
      print("Websocket is not connected.");
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                  width: 300,
                  height: 300,
                  child: controller.duration < Duration(seconds: 10)
                      ? CircularProgressIndicator(
                          color: Colors.red,
                          backgroundColor: Colors.grey.shade300,
                          value: progress,
                          strokeWidth: 6,
                        )
                      : CircularProgressIndicator(
                          color: Colors.green,
                          backgroundColor: Colors.grey.shade300,
                          value: progress,
                          strokeWidth: 6,
                        )),
              GestureDetector(
                onTap: () {
                  if (controller.isDismissed) {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => Container(
                        height: 300,
                        child: CupertinoTimerPicker(
                          initialTimerDuration: controller.duration,
                          onTimerDurationChanged: (time) {
                            setState(() {
                              controller.duration = time;
                            });
                          },
                        ),
                      ),
                    );
                  }
                },
                child: AnimatedBuilder(
                  animation: controller,
                  builder: (context, child) => Text(
                    countText,
                    style: TextStyle(
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (controller.isAnimating) {
                    controller.stop();
                    setState(() {
                      isPlaying = false;
                    });
                  } else {
                    controller.reverse(
                        from: controller.value == 0 ? 1.0 : controller.value);
                    setState(() {
                      isPlaying = true;
                    });
                  }
                },
                child: RoundButton(
                  icon: isPlaying == true ? Icons.pause : Icons.play_arrow,
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.reset();
                  setState(() {
                    isPlaying = false;
                  });
                },
                child: RoundButton(
                  icon: Icons.stop,
                ),
              ),
            ],
          ),
        ),
        Container(
            alignment: Alignment.topCenter, //inner widget alignment to center
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Container(
                    child: connected
                        ? Text("WEBSOCKET: CONNECTED")
                        : Text("DISCONNECTED")),
                Container(
                    child:
                        isPlaying ? Text("LED IS: ON") : Text("LED IS: OFF")),
                Container(
                    margin: EdgeInsets.only(top: 30),
                    child: FlatButton(
                        //button to start scanning
                        color: Colors.redAccent,
                        colorBrightness: Brightness.dark,
                        onPressed: () {
                          //on button press
                          if (ledstatus) {
                            //if ledstatus is true, then turn off the led
                            //if led is on, turn off
                            sendcmd("poweroff");
                            ledstatus = false;
                          } else {
                            //if ledstatus is false, then turn on the led
                            //if led is off, turn on
                            sendcmd("poweron");
                            ledstatus = true;
                          }
                          setState(() {});
                        },
                        child: ledstatus
                            ? Text("TURN LED OFF")
                            : Text("TURN LED ON"))),
                Text(widget.text),
              ],
            )),
      ]),
    );
  }
}
