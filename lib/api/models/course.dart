class Course {
  String id;
  String start;
  String end;

  Course({
    this.id,
    this.start,
    this.end,
  });
  factory Course.fromJson(Map<String, dynamic> responseData) {
    return Course(
        id: responseData['_id'],
        start: responseData['start'],
        end: responseData['end']);
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['start'] = this.start;
    data['end'] = this.end;
    return data;
  }

  @override
  String toString() {
    return "id: " +
        (id == null ? "NULL" : id) +
        "start:" +
        (start == null ? "NULL" : start) +
        "end:" +
        (end == null ? "NULL" : end);
  }
}
