class Task {
  String id;
  String name;
  String description;
  String hashtag;
  String deadline;
  /* List<String> assignees; */
  bool completed;

  Task({this.id, this.name, this.description, this.deadline, this.hashtag, this.completed /* , this.assignees */});

  factory Task.fromJson(Map<String, dynamic> responseData) {
    return Task(
      id: responseData['_id'],
      name: responseData['name'],
      description: responseData['description'],
      hashtag: responseData['hashtag'],
      deadline: responseData['deadline'],
      completed: responseData['completed'],
      /* assignees: responseData['assignees'] */
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['hashtag'] = this.hashtag;
    data['deadline'] = this.deadline;
    data['completed'] = this.completed;
    /* data['assignees'] = this.assignees; */
    return data;
  }
}
