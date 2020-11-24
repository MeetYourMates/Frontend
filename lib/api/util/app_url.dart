class AppUrl {
  static const String liveBaseURL = "https://remote-ur/";
  static const String localBaseURL = "http://10.0.2.2:3000/";

  static const String baseURL = localBaseURL;
  static const String login = baseURL + "/access";
  static const String register = baseURL + "/signUp";
  static const String forgotPassword = baseURL + "/forgotPassword";
}
