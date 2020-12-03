class AppUrl {
  static const String liveBaseURL = "http://147.83.7.157:3000";
  static const String localBaseURL = "http://10.0.2.2:3000";

  static const String baseURL = liveBaseURL;
  static const String login = baseURL + "/auth/signIn";
  static const String register = baseURL + "/auth/signUp";
  static const String forgotPassword = baseURL + "/forgotPassword";
}
