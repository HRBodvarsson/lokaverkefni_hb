import 'package:url_launcher/url_launcher.dart';

class EmailSender {
  static Future<void> sendEmail(Map<String, dynamic> profileData, List<String> characteristicOptions) async {
    final List<bool> characteristics = List<bool>.from(profileData['characteristics']);
    String characteristicsString = characteristics
        .asMap()
        .entries
        .where((entry) => entry.value)
        .map((entry) => characteristicOptions[entry.key])
        .join(', ');

    String emailBody = '''
Pet's Name: ${profileData['petName']}
Owner's Name: ${profileData['ownerName']}
Type of Dog: ${profileData['selectedDogType']}
Characteristics: $characteristicsString
''';

    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'hrbodvarsson@gmail.com',
      queryParameters: {
        'subject': 'New Profile Created',
        'body': emailBody,
      },
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      throw 'Could not launch $emailLaunchUri';
    }
  }
}
