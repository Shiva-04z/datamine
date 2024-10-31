import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPageController extends GetxController{

  void launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'shivaliksharma2@gmail.com',
      query: 'subject=Support Inquiry&body=Hello Shivalik,', // You can pre-fill the subject and body if needed
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

}