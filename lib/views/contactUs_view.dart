import 'package:flutter/material.dart';
import 'package:flutter_social_button/flutter_social_button.dart';

class AboutUs extends StatelessWidget {
  const AboutUs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 40),
              child: Text('C O N T A C T     U S', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 17, vertical: 30),
              padding: EdgeInsets.only(top: 30, bottom: 30),
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Theme.of(context).colorScheme.primary),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Text(
                    'Follow For Updates!',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.secondary),
                  ),
                  SizedBox(height: 20),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlutterSocialButton(
                        onTap: () {
                        },
                        title: 'LinkedIn',
                        mini: false,
                        buttonType: ButtonType.linkedin,
                      ),
                      SizedBox(width: 30),
                      FlutterSocialButton(
                        onTap: () {},
                        title: 'Instagram',
                        mini: false,
                        buttonType: ButtonType.instagram,
                      ),
                      SizedBox(width: 30),
                      FlutterSocialButton(
                        onTap: () {},
                        mini: false,
                        title: 'GitHub',
                        buttonType: ButtonType.github,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}