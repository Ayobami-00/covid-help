import 'package:url_launcher/url_launcher.dart';

class CallsAndMessagesService {
  void call(String number) => launch("tel:$number");
  void sendSms(String number) => launch("sms:$number?body=Hi%20I%20am%20reminding%20you%20to%20wash%20your%20hands%20and%20update%20it%20on%20the%20covid%20help%20app%20to%20show%20everyone%20that%20you%20are%20helping%20reduce%20the%20spread%20of%20the%20virus");
  void sendInviteSms(String number) => launch("sms:$number?body=Hi%20join%20me%20on%20covid%20help%20app%20to%20get%20frequent%20reminders%20to%20wash%20your%20hands%20against%20corona%20virus%20and%20live%20updates%20from%20around%20the%20world%20Download%20from%20www.freetek.com.ng%2FindexCorona.html");
 
}


