import 'dart:developer';
import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code/formule.dart';
import 'package:toggle_switch/toggle_switch.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  Barcode? result;
  var clicked = 0;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => Container(
          child: (result != null)
              ? result!.code ==
                      'https://www.3dwave.tech/?fbclid=IwAR2WwicJr5W6n3LQCc9ep8IdvTaBg5k4jqdIFgVzfO6gpbdinatkJU-YP6g'
                  ? Container(
                      color: Colors.black.withOpacity(0.8),
                      child: Center(
                        child: Expanded(
                          child: Stack(alignment: Alignment.center, children: [
                            Positioned(
                                child: Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    child: Stack(
                                      overflow: Overflow.visible,
                                      alignment: Alignment.topCenter,
                                      children: [
                                        Container(
                                          height: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 70, 10, 10),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'success !!!',
                                                  style: TextStyle(
                                                      color: Colors.green,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'valid code',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                RaisedButton(
                                                  onPressed: () {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              MyFlutterForm(),
                                                        ));
                                                  },
                                                  color: Colors.green,
                                                  child: Text(
                                                    'Okay',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            top: -60,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.green,
                                              radius: 60,
                                              child: Icon(
                                                Icons.check_outlined,
                                                color: Colors.white,
                                                size: 70,
                                              ),
                                            )),
                                      ],
                                    ))),
                          ]),
                        ),
                      ),
                    )
                  : Container(
                      color: Colors.black.withOpacity(0.8),
                      child: Center(
                        child: Expanded(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Positioned(
                                child: Dialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(4.0)),
                                    child: Stack(
                                      overflow: Overflow.visible,
                                      alignment: Alignment.topCenter,
                                      children: [
                                        Container(
                                          height: 200,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                10, 70, 10, 10),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'fail !!!',
                                                  style: TextStyle(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  'Wrong code',
                                                  style:
                                                      TextStyle(fontSize: 20),
                                                ),
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                RaisedButton(
                                                  onPressed: () {
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              QRViewExample(),
                                                        ));
                                                  },
                                                  color: Colors.redAccent,
                                                  child: Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                            top: -60,
                                            child: CircleAvatar(
                                              backgroundColor: Colors.redAccent,
                                              radius: 60,
                                              child: Icon(
                                                Icons.close,
                                                color: Colors.white,
                                                size: 70,
                                              ),
                                            )),
                                      ],
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(flex: 4, child: _buildQrView(context)),
                    Expanded(
                      flex: 1,
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            if (result != null)
                              Text('ok')
                            else
                              const Text('Scan a code'),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  margin: const EdgeInsets.all(8),
                                  child: ToggleSwitch(
                                    changeOnTap: true,
                                    minWidth: 90.0,
                                    minHeight: 70.0,
                                    initialLabelIndex: 0,
                                    cornerRadius: 20.0,
                                    activeFgColor: Colors.white,
                                    inactiveBgColor: Colors.grey,
                                    inactiveFgColor: Colors.white,
                                    totalSwitches: 2,
                                    icons: [
                                      FontAwesomeIcons.lightbulb,
                                      FontAwesomeIcons.solidLightbulb,
                                    ],
                                    iconSize: 30.0,
                                    activeBgColors: [
                                      [Colors.black45, Colors.black26],
                                      [Colors.yellow, Colors.orange]
                                    ],
                                    animate:
                                        true, // with just animate set to true, default curve = Curves.easeIn
                                    curve: Curves.bounceInOut,
                                    // animate must be set to true when using custom curve
                                    onToggle: (index) async {
                                      if (index == 0) {
                                        if (clicked == 1) {
                                          clicked = 0;
                                          await controller?.toggleFlash();
                                        }
                                      } else {
                                        if (clicked == 0) {
                                          clicked = clicked + 1;
                                          await controller?.toggleFlash();
                                        }
                                      }
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 500 ||
            MediaQuery.of(context).size.height < 500)
        ? 250.0
        : 300.0;
    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
      });
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget showErrorSnackBar(BuildContext context) {
    return SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.error_outline, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              'This a valid code',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.green,
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.fixed,
    );
  }
}

class AdvanceCustomAlert extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                child: Column(
                  children: [
                    Text(
                      'success !!!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'valid code',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      color: Colors.redAccent,
                      child: Text(
                        'Okay',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: -60,
                child: CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 60,
                  child: Icon(
                    Icons.assistant_photo,
                    color: Colors.white,
                    size: 50,
                  ),
                )),
          ],
        ));
  }
}

class AdvanceCustomAlertWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
        child: Stack(
          overflow: Overflow.visible,
          alignment: Alignment.topCenter,
          children: [
            Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                child: Column(
                  children: [
                    Text(
                      'wrong !!!',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'wrong code',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      color: Colors.redAccent,
                      child: Text(
                        'Okay',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: -60,
                child: CircleAvatar(
                  backgroundColor: Colors.redAccent,
                  radius: 60,
                  child: Icon(
                    Icons.assistant_photo,
                    color: Colors.white,
                    size: 50,
                  ),
                )),
          ],
        ));
  }
}

void showAlert(BuildContext context) {
  showDialog(
      context: context,
      builder: (context) => Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
          child: Stack(
              overflow: Overflow.visible,
              alignment: Alignment.topCenter,
              children: [
                Container(
                  height: 200,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 70, 10, 10),
                    child: Column(
                      children: [
                        Text(
                          'success !!!',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          'valid code',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        RaisedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          color: Colors.green,
                          child: Text(
                            'Okay',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                    top: -60,
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 60,
                      child: Icon(
                        Icons.assistant_photo,
                        color: Colors.white,
                        size: 50,
                      ),
                    )),
              ])));
}
