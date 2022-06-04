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
  final double text;
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
      sendcmd("poweroff");
      FlutterRingtonePlayer.playNotification();
    }
  }

  String etatCapteur() {
    if (ledstatus == false) {
      if (controller.isAnimating) {
        setState(() {
          controller.stop();
        });
      }
      sendcmd("poweroff");
      FlutterRingtonePlayer.playNotification();
    }

    return countText;
  }

  @override
  void initState() {
    ledstatus = false; //initially leadstatus is off so its FALSE
    connected = false;
    double timer = widget.text;
    controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: timer.toInt()),
    );
    controller.addListener(() {
      etatCapteur();
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
          "ws://192.168.1.18:81"); //channel IP : Port
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
    if (connected == true) {
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
      body: Builder(
        builder: (context) => Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill)),
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 30),
          alignment: Alignment.center,
          child: Column(children: [
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
                            decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
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
                        ledstatus
                            ? etatCapteur()
                            : countText == '00:00:00'
                                ? {sendcmd("poweroff")}
                                : countText,
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
                          sendcmd("poweroff");
                          Scaffold.of(context).showSnackBar(SnackBar(
                            duration: Duration(milliseconds: 500),
                            backgroundColor: Colors.red.withOpacity(0.8),
                            content: Row(children: <Widget>[
                              Icon(
                                Icons.lightbulb,
                                color: Colors.white,
                              ),
                              Text(
                                'led is OFF',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18.0,
                                ),
                              )
                            ]),
                          ));
                          isPlaying = false;
                        });
                      } else {
                        controller.reverse(
                            from:
                                controller.value == 0 ? 1.0 : controller.value);
                        setState(() {
                          sendcmd("poweron");
                          Scaffold.of(context).showSnackBar(SnackBar(
                            duration: Duration(milliseconds: 500),
                            backgroundColor: Colors.green.withOpacity(0.8),
                            content: Row(children: <Widget>[
                              Icon(
                                Icons.lightbulb,
                                color: Colors.yellow,
                              ),
                              Text(
                                'led is ON',
                                textAlign: TextAlign.justify,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 18.0,
                                ),
                              )
                            ]),
                          ));
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
                        Scaffold.of(context).showSnackBar(SnackBar(
                          duration: Duration(milliseconds: 500),
                          backgroundColor: Colors.orange.withOpacity(0.8),
                          content: Row(children: <Widget>[
                            Icon(
                              Icons.lightbulb,
                              color: Colors.white,
                            ),
                            Text(
                              'Reset has been clicked',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                                fontSize: 18.0,
                              ),
                            )
                          ]),
                        ));
                        ledstatus = false;
                        sendcmd("poweroff");
                        isPlaying = false;
                      });
                    },
                    child: RoundButton(
                      icon: Icons.stop_sharp,
                    ),
                  ),
                ],
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
