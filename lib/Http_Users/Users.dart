// ignore_for_file: file_names

class Person {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;
  Person(this.id, this.email, this.firstName, this.lastName, this.avatar);
  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      json['id'],
      json['email'],
      json['first_name'],
      json['last_name'],
      json['avatar'],
    );
  }
}

class Page {
  int page;
  int per_page;
  int total;
  int total_page;
  List<Person> data;
  Page(this.page, this.per_page, this.total, this.total_page, this.data);
}
