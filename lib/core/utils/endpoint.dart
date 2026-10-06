class Endpoint {
  static const String sendOtp = 'api/auth/send-otp';
  static const String verifyOtp = 'api/auth/verify-otp';
  static const String login = 'api/login';
  static const String register = 'api/register';
  static const String account = 'api/account';
  static const String establishments = 'api/establishments';

  static String establishment(int id) => '$establishments/$id';
  static const String requestPhoneOtp = 'api/v1/auth/request-phone-otp';
  static const String verifyPhone = 'api/v1/auth/verify-phone';
  static const String refreshToken = 'api/v1/auth/refresh-token';
  static const String getProfile = 'api/v1/users/profile/me';
  static const String updateProfile = 'api/v1/users/profile/me';
  static const String profileImage = 'api/v1/users/profile/me/photo';
  static const String requestEmailOtp = 'api/v1/auth/request-email-otp';
  static const String verifyEmail = 'api/v1/auth/verify-email';
  static const String addresses = 'api/v1/users/addresses';
}
