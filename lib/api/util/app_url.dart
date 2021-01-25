class AppUrl {
  static const String liveBaseURL = "http://147.83.7.157:3000";
  static const String localBaseURL = "http://10.0.2.2:3000";
  static const String localhostBaseURL = "http://localhost:3000";
  static const String baseURL = localBaseURL;

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
  static const String getStudentsAndCourses =
      baseURL + "/student/getStudentsAndCourses";
  static const String getProfessorCoursesAndStudents =
      baseURL + "/professor/getStudentsAndCourses";
  static const String editProfileStudent = baseURL + "/student/updateStudent";
  static const String editProfileProfessor = baseURL + "/professor/update";
  static const String editProfilePhoto = baseURL + "/student/StudentPhoto";
  static const String getProjects = baseURL + "/student/getStudentProjects/";
  //Professors
  static const String addsubjectsProfessor = baseURL + "/course/addProfessor";
  //Meetings
  static const String getMeeting = baseURL + "/meeting/get/";
  static const String addMeeting = baseURL + "/meeting/addMeeting";

  //Projects
  static const String getCourseProjects =
      baseURL + "/professor/getCourseProjects";
  static const String addProject = baseURL + "/project/add";
}
