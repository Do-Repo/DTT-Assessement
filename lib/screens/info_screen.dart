import 'package:dtt_assessment/constants/textstyles.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ABOUT", style: TextStyles.header_01),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elli, sea ao elusmoa lemoor Inclalaunt ut lapore eu dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut allaulo ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occsecat Cunlestar non nrolcent sunt In Cuna ali officia deserunt mollit anim id est laborum. Lorem losum color sit amet. consectetur acioiscina elitsed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, auIs nostrue exercitatIon lamco aooris nislUt aliquip ex ea commodo consequat. Duis aute irure color In reorenenaerit In voluolate vellt esse cillum colore ou fidiat nulla nariatur Fycontour sint 0cc30Cst CHnlestat non Drolcont",
                style: TextStyle(fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 15),
              Text("Design and Development", style: TextStyles.header_01),
              const SizedBox(height: 15),
              Row(
                children: [
                  Image.asset("assets/images/banner/dtt_banner.png"),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "by DTT",
                        style: TextStyles.body,
                      ),
                      RichText(
                          text: TextSpan(
                              text: "d-tt.nl",
                              style:
                                  TextStyles.body.copyWith(color: Colors.blue),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () async {
                                  await launchUrl(Uri.parse("https://d-tt.nl"));
                                }))
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
