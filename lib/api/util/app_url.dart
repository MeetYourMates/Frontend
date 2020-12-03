class AppUrl {
  static const String liveBaseURL = "https://remote-url";
  static const String localBaseURL = "http://10.0.2.2:3000";

  static const String baseURL = localBaseURL;
  static const String login = baseURL + "/auth/signIn";
  static const String register = baseURL + "/auth/signUp";
  static const String forgotPassword = baseURL + "/forgotPassword";
  static const String validate = baseURL + "/auth/validate/";
}
