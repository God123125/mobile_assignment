class ApiEndpoints {
  static const String baseUrl = 'https://khmer-culture-cyan.vercel.app/api';

  // User
  static String register() =>'$baseUrl/mobile-users/register';
  static String verify() =>'$baseUrl/mobile-users/verify';
  static String login() =>'$baseUrl/mobile-users/login';
  static String resendCode() =>'$baseUrl/mobile-users/resend-code';

  //get
  static String get getPersonalInfo => '$baseUrl/mobile-users';
}
