class AppUrl {
  static const String liveBaseURL = "https://remote-url";
  static const String localBaseURL = "http://10.0.2.2:3000";

  static const String baseURL = localBaseURL;
  static const String universities = baseURL + "/university/all";
  static const String subjects = baseURL + "/degree/get/";
  static const String addsubjects = baseURL + "/course/addStudent";
}
