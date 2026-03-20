class ApiEndpoints {
  static const String baseUrl = 'https://khmer-culture-cyan.vercel.app/api';

  //Order
  static String addOrder() =>'$baseUrl/orders/checkout';
  static String get getOrder => '$baseUrl/orders';
  static String confirmOrder(String orderId) => '$baseUrl/orders/end-order/$orderId';

  // User
  static String register() =>'$baseUrl/mobile-users/register';
  static String verify() =>'$baseUrl/mobile-users/verify';
  static String login() =>'$baseUrl/mobile-users/login';
  static String resendCode() =>'$baseUrl/mobile-users/resend-code';
  static String requestToEmail() =>'$baseUrl/mobile-users/request-to-email';
  static String updateInfo() =>'$baseUrl/mobile-users/update-account';
  static String updateProfile() =>'$baseUrl/mobile-users/update-profile';

  //get
  static String get getPersonalInfo => '$baseUrl/mobile-users/personal-info';
  static String get getCagories => '$baseUrl/mobile/categories';
  static String get getStoreCategories => '$baseUrl/store-categories';
  static String get getProducts => '$baseUrl/mobile/products';
  static String get getStores => '$baseUrl/stores';
  static String get getAdvertisings => '$baseUrl/advertisings';
  static String get getFeedback => '$baseUrl/feedbacks';

  //update
  static String updatePassword() => '$baseUrl/mobile-users/update-account';
  static String updatePasswordByOldPass() => '$baseUrl/mobile-users/update-account';
  static String updatePasswordWithoutLoginModel() => '$baseUrl/mobile-users/verify-code';
}
