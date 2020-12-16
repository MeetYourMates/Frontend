class AppUrl {
  static const String liveBaseURL = "https://remote-url";
  static const String localBaseURL = "http://10.0.2.2:3000";
  static const String localhostBaseURL = "http://localhost:3000";
  static const String baseURL = localBaseURL;

  //Login and register screens
  static const String login = baseURL + "/auth/signIn";
  static const String register = baseURL + "/auth/signUp";
  static const String forgotPassword = baseURL + "/forgotPassword";
  static const String validate = baseURL + "/auth/validate/";

  //Universities
  static const String universities = baseURL + "/university/all";

  //Degrees
  static const String subjects = baseURL + "/degree/get/";

  //Students
  static const String addsubjects = baseURL + "/course/addStudent";
  static const String getCourseStudents = baseURL + "/course/getStudents";
}
