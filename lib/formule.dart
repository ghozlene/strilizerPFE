// @dart=2.9
library lite_rolling_switch;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

import 'package:qr_code/websocketLed.dart';

class MyFlutterForm extends StatefulWidget {
  @override
  _MyFlutterFormState createState() => _MyFlutterFormState();
}

class _MyFlutterFormState extends State<MyFlutterForm> {
  //form key here
  final _formKey = GlobalKey<FormState>();
  // variable to enable auto validating of theform
  bool _autoValidate = true;
  // variable to enable toggling between showing and hiding password
  var distController = TextEditingController();
  var outPutController = TextEditingController();
  var dosageController = TextEditingController();
  var exposureController = TextEditingController();
  var lengthController = TextEditingController();

  bool value = true;
  var pi = 3.143;
  static const IconData calculate =
      IconData(0xe121, fontFamily: 'MaterialIcons');

  static const IconData access_time_outlined =
      IconData(0xee2d, fontFamily: 'MaterialIcons');
  static const IconData lightbulb_outline =
      IconData(0xe37c, fontFamily: 'MaterialIcons');
  static const IconData power = IconData(0xe4e0, fontFamily: 'MaterialIcons');
  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    distController.dispose();
    outPutController.dispose();
    dosageController.dispose();
    exposureController.dispose();
    lengthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Builder(
        builder: (context) => Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/images/background.png'),
                  fit: BoxFit.fill)),
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 30),
          alignment: Alignment.center,
          child: Container(
            child: Form(
                key: _formKey,
                child: Container(
                  padding: EdgeInsets.only(
                    right: 20.0,
                    left: 20.0,
                    top: 30,
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    child: !value
                        ? (Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              buildSwitch(),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                cursorColor: Colors.blue,
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 3, 95, 253)),
                                  ),
                                  suffix: Text('cm'),
                                  suffixStyle:
                                      const TextStyle(color: Colors.green),
                                  labelText: 'Distance',
                                ),
                                controller: distController,
                                keyboardType: TextInputType.number,
                                validator: validateFloat,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[. 0-9]'))
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius:
                                          new BorderRadius.circular(25.0),
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 3, 95, 253)),
                                    ),
                                    suffix: Text('W'),
                                    suffixIcon: Icon(Icons.power),
                                    suffixStyle:
                                        const TextStyle(color: Colors.green),
                                    labelText: 'Output power'),
                                controller: outPutController,
                                keyboardType: TextInputType.number,
                                validator: validateFloat,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[. 0-9]'))
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 3, 95, 253)),
                                  ),
                                  suffix: Text('J/cm^2'),
                                  suffixStyle:
                                      const TextStyle(color: Colors.green),
                                  labelText: 'Required dosage',
                                ),
                                controller: dosageController,
                                keyboardType: TextInputType.number,
                                validator: validateFloat,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[. 0-9]'))
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 3, 95, 253)),
                                  ),
                                  suffixStyle:
                                      const TextStyle(color: Colors.green),
                                  suffix: Text('cm'),
                                  suffixIcon: Icon(Icons.lightbulb_rounded),
                                  labelText: 'Length of the lamp',
                                ),
                                controller: lengthController,
                                keyboardType: TextInputType.number,
                                validator: validateFloat,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[. 0-9]'))
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Text('Exposure Time=' + exposureController.text,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'Raleway',
                                    fontStyle: FontStyle.italic,
                                    fontSize: 22.0,
                                  )),
                              SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: RaisedButton.icon(
                                  icon: Icon(Icons.calculate),
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                  color: Color.fromARGB(255, 45, 159, 253),
                                  onPressed: () {
                                    if (exposureController.text != "" ||
                                        exposureController.text == '') {
                                      setState(() {
                                        distController = distController;
                                        dosageController = dosageController;
                                        outPutController = outPutController;
                                        lengthController = lengthController;
                                        if (distController.text != '' &&
                                            dosageController.text != '' &&
                                            outPutController.text != '' &&
                                            lengthController.text != '')
                                          exposureController.text = ((2 *
                                                      pi *
                                                      double.parse(
                                                          lengthController
                                                              .text) *
                                                      double.parse(
                                                          distController.text) *
                                                      double.parse(
                                                          dosageController
                                                              .text)) /
                                                  double.parse(
                                                      outPutController.text))
                                              .toStringAsFixed(2);
                                      });
                                    }
                                    if (_formKey.currentState.validate()) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text('Form Validated, No errors'),
                                      ));
                                    } else {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                            'Form is not valid, verify errors'),
                                      ));
                                    }
                                  },
                                  textColor: Colors.white,
                                  elevation: 2.0,
                                  padding: EdgeInsets.all(20.0),
                                  label: Text(
                                    'Calculate exposure time',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Raleway',
                                      fontStyle: FontStyle.italic,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: RaisedButton(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                  onPressed: () =>
                                      {_sendDataToWebSocketScreen(context)},
                                  color: Color.fromARGB(255, 45, 159, 253),
                                  textColor: Colors.white,
                                  elevation: 2.0,
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    'Start sterilizing',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Raleway',
                                      fontStyle: FontStyle.italic,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ))
                        : (Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              buildSwitch(),
                              SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                    borderRadius:
                                        new BorderRadius.circular(25.0),
                                    borderSide: BorderSide(
                                        color: Color.fromARGB(255, 3, 95, 253)),
                                  ),
                                  suffixStyle:
                                      const TextStyle(color: Colors.green),
                                  suffixIcon: Icon(Icons.timer_outlined),
                                  suffix: Text('min'),
                                  labelText: 'Exposure time',
                                ),
                                controller: exposureController,
                                keyboardType: TextInputType.number,
                                validator: validateFloat,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp('[. 0-9]'))
                                ],
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: RaisedButton(
                                  shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                  onPressed: () =>
                                      {_sendDataToWebSocketScreen(context)},
                                  color: Color.fromARGB(255, 45, 159, 253),
                                  textColor: Colors.white,
                                  elevation: 2.0,
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    'Start sterilizing',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Raleway',
                                      fontStyle: FontStyle.italic,
                                      fontSize: 22.0,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          )),
                  ),
                )),
          ),
        ),
      ),
    );
  }

// regex method to validate user phone number
  String validateFloat(String value) {
    String pattern = r'^[+-]?([0-9]+([.][0-9]*)?|[.][0-9]+)$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return 'Please enter a number';
    } else if (!regExp.hasMatch(value)) {
      return 'Please enter valid a number';
    }
    return null;
  }

  Widget buildSwitch() => Transform.scale(
      scale: 2,
      child: Switch.adaptive(
          activeColor: Colors.green,
          inactiveThumbColor: Colors.red,
          trackColor: MaterialStateProperty.all(Colors.grey[400]),

          // activeColor: Colors.blueAccent,
          // activeTrackColor: Colors.blue.withOpacity(0.4),
          // inactiveThumbColor: Colors.orange,
          // inactiveTrackColor: Colors.black87,
          splashRadius: 50,
          value: value,
          onChanged: (value) => setState(() {
                this.value = value;
              })));

  void _sendDataToWebSocketScreen(BuildContext context) {
    String textToSend = exposureController.text;
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => WebSocketLed(text: textToSend),
        ));
  }
}
