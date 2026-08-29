import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 105,
                    backgroundColor: const Color(0xffaada30),
                    child: CircleAvatar(
                      radius: 100,
                      backgroundImage: AssetImage('assets/profile.jpg'),
                    ),
                  ),
                ),
                //name
                Text(
                  'Yuba Acharya',
                  style: GoogleFonts.praise(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                //position
                Text(
                  'Flutter Developer',
                  style: GoogleFonts.poppins(
                    color: Color(0xff26235C),
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 10),
                //description
                Text(
                  "A Flutter developer builds sleek mobile apps for both iOS and Android using Google's  Flutter framework.",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(),
                ),
                SizedBox(height: 10),
                //email
                Container(
                  // height: 20,
                  // width: 200,
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Color(0xff26235C),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    'yuba@gmail.com',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final Uri _url = Uri.parse('https://flutter.dev');
                        await launchUrl(_url);
                      },
                      child: Image.asset('assets/Instagram.png'),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final Uri _url = Uri.parse('https://flutter.dev');
                        try {
                          await launchUrl(_url);
                        } catch (e) {
                          print(e);
                        }
                      },
                      child: Image.asset('assets/LinkedIn.png'),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("Internet");
                      },
                      child: Image.asset('assets/Internet.png'),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("TwitterX");
                      },
                      child: Image.asset('assets/TwitterX.png'),
                    ),
                    GestureDetector(
                      onTap: () {
                        print("GitHub");
                      },
                      child: Image.asset('assets/GitHub.png'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
