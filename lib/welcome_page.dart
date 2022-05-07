import 'package:flutter/material.dart';
import 'package:qr_code/delayed_animation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qr_code/main.dart';

import './qr_code.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDECF2),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(
            vertical: 60,
            horizontal: 30,
          ),
          child: Column(
            children: [
              DelayedAnimation(
                delay: 1500,
                child: Container(
                  height: 170,
                  child: Image.asset('images/3dwave.png'),
                ),
              ),
              DelayedAnimation(
                delay: 2500,
                child: Container(
                  height: 400,
                  child: Image.asset('images/sterilizer.png'),
                ),
              ),
              DelayedAnimation(
                delay: 3500,
                child: Container(
                  height: 400,
                  margin: const EdgeInsets.only(
                    top: 30,
                    bottom: 20,
                  ),
                  child: Text(
                    "c'est primordial, pour qu'on vivons dans un milieu clarifier",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.grey,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
              DelayedAnimation(
                delay: 4500,
                child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: d_red,
                        shape: StadiumBorder(),
                        padding: EdgeInsets.all(13)),
                    child: Text('Scan'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QRViewExample(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
