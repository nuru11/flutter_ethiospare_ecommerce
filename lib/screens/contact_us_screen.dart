import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contact Us"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            launchButton(
              title: 'Phone Call',
              icon: Icons.phone,
              onPressed: () async {
                Uri uri = Uri.parse('tel:+251913918821');
                if (!await launcher.launchUrl(uri)) {
                  debugPrint(
                      "Could not launch the uri"); // because the simulator doesn't have the phone app
                }
              },
            ),
            launchButton(
              title: 'Visit Website / URL',
              icon: Icons.language,
              onPressed: () {
                launcher.launchUrl(
                  Uri.parse('https://ethiosparemarket.com/'),
                  mode: launcher.LaunchMode.externalApplication,
                );
              },
            ),
            launchButton(
              title: 'SMS / Message',
              icon: Icons.message,
              onPressed: () => launcher.launchUrl(
                Uri.parse(
                  'sms:+251913918821${Platform.isAndroid ? '?' : '&'}body=Message from Flutter app',
                ),
              ),
            ),
            launchButton(
              title: 'Telegram',
              icon: FontAwesomeIcons.telegram,
              onPressed: () => launcher.launchUrl(
                Uri.parse('https://t.me/ethio_online_spare'),
              ),
            ),
            launchButton(
              title: 'WhatsApp',
              icon: FontAwesomeIcons.whatsapp,
              onPressed: () => launcher.launchUrl(
                Uri.parse('https://wa.me/+251913918821'),
              ),
            ),
            launchButton(
              title: 'Email Message',
              icon: Icons.email,
              onPressed: () async {
                Uri uri = Uri.parse(
                  'mailto:nuruibrahim11111@gmail.com?subject=Flutter Url Launcher&body=Hi, Flutter developer',
                );
                if (!await launcher.launchUrl(uri)) {
                  debugPrint(
                      "Could not launch the uri"); // because the simulator doesn't have the email app
                }
              },
            ),
            const SizedBox(height: 20),
            Text(
              'Follow Us On',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.tiktok),
                  onPressed: () => launcher.launchUrl(
                    Uri.parse('https://www.tiktok.com/@yourusername'),
                  ),
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.facebook),
                  onPressed: () => launcher.launchUrl(
                    Uri.parse('https://www.facebook.com/yourpage'),
                  ),
                ),
                IconButton(
                  icon: FaIcon(FontAwesomeIcons.instagram),
                  onPressed: () => launcher.launchUrl(
                    Uri.parse('https://www.instagram.com/yourusername'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget launchButton({
    required String title,
    required IconData icon,
    required Function() onPressed,
  }) {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.green),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}