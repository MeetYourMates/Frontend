class AppUrl {
  static const String liveBaseURL = "http://147.83.7.157:3000";
  static const String localBaseURL = "http://10.0.2.2:3000";
  static const String localhostBaseURL = "http://localhost:3000";
  static const String baseURL = localhostBaseURL;

  static const String login = baseURL + "/auth/signIn";
  static const String register = baseURL + "/auth/signUp";
  static const String registerWithGoogle = baseURL + "/auth/signUpGoogle";
  static const String forgotPassword = baseURL + "/auth/forgotPassword/";
  static const String changePassword = baseURL + "/auth/changePassword";
  static const String validate = baseURL + "/auth/validate/";

  //Universities
  static const String universities = baseURL + "/university/all";

  //Degrees
  static const String subjects = baseURL + "/degree/get/";

  //Students
  static const String addsubjects = baseURL + "/course/addStudent";
  static const String getCourseStudents = baseURL + "/course/getStudents";
  static const String editProfile = baseURL + "/student/updateStudent";
  static const String editProfilePhoto = baseURL + "/student/StudentPhoto";
}
