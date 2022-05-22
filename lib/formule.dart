// @dart=2.9
library lite_rolling_switch;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

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
      body: Builder(
        builder: (context) => Container(
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
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
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
                                    border: OutlineInputBorder(),
                                    suffix: Text('W'),
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
                                  border: OutlineInputBorder(),
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
                                  border: OutlineInputBorder(),
                                  suffixStyle:
                                      const TextStyle(color: Colors.green),
                                  suffix: Text('cm'),
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
                              TextFormField(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  suffixStyle:
                                      const TextStyle(color: Colors.green),
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
                                  color: Colors.blue,
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
                                              .toString();
                                      });
                                    }
                                    if (_formKey.currentState.validate()) {
                                      Scaffold.of(context)
                                          .showSnackBar(SnackBar(
                                        content:
                                            Text('Form Validated, No errors'),
                                      ));
                                    }
                                  },
                                  textColor: Colors.white,
                                  elevation: 2.0,
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    'Calculate exposure time',
                                    style: TextStyle(
                                      fontSize: 18.0,
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
                                  onPressed: () => {},
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  elevation: 2.0,
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    'Start sterilizer',
                                    style: TextStyle(
                                      fontSize: 18.0,
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
                                  border: OutlineInputBorder(),
                                  suffixStyle:
                                      const TextStyle(color: Colors.green),
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
                                  onPressed: () => {},
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                  elevation: 2.0,
                                  padding: EdgeInsets.all(20.0),
                                  child: Text(
                                    'Start sterilizer',
                                    style: TextStyle(
                                      fontSize: 18.0,
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
          trackColor: MaterialStateProperty.all(Colors.orange),

          // activeColor: Colors.blueAccent,
          // activeTrackColor: Colors.blue.withOpacity(0.4),
          // inactiveThumbColor: Colors.orange,
          // inactiveTrackColor: Colors.black87,
          splashRadius: 50,
          value: value,
          onChanged: (value) => setState(() {
                this.value = value;
              })));
}
