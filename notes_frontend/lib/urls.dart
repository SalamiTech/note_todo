 class ApiUrls {
  static const String baseUrl = 'http://10.0.2.2:8000/';
  static const String getNotes = "${baseUrl}notes/";
  static const String createNote = "${baseUrl}notes/create/";
  static String updateNote(String pk) => "${baseUrl}notes/$pk/update/";
  static String deleteNote(String pk) => "${baseUrl}notes/$pk/delete/";
}
