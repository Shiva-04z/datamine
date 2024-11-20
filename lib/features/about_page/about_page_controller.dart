import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AboutPageController extends GetxController {
  void launchEmail({String subject = 'Support Inquiry', String body = 'Hello Shivalik,'}) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'shivaliksharma2@gmail.com',
      query: 'subject=${Uri.encodeComponent(subject)}&body=${Uri.encodeComponent(body)}',
    );

    try {
      if (kIsWeb) {
        // For web, use the `launchUrl` function with a string
        await launchUrl(emailUri, mode: LaunchMode.externalApplication);
      } else {
        // For mobile (Android/iOS), use the `launchUrl` with a Uri
        if (await canLaunchUrl(emailUri)) {
          await launchUrl(emailUri);
        } else {
          Get.snackbar('Error', 'Could not launch email client. Please try again later.');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
    }
  }
}
