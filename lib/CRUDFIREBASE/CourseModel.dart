// ignore_for_file: file_names, non_constant_identifier_names

class Course {
    DateTime ?datimeStart;
    DateTime ?datetimeEnd;
    String ?nameofCourse;
    String ?description;
    String ? ID;
    String ?image;
    String ?price;
    Course({this.datimeStart, this.datetimeEnd, this.nameofCourse, this.description, this.ID, this.image, this.price});
    factory Course.fromJson(Map<String, dynamic> json) => Course(
        datimeStart: json["datimeStart"],
        datetimeEnd: json["datetimeEnd"],
        nameofCourse: json["nameofCourse"],
        description: json["description"],
        ID: json["ID"],
        image: json["image"],
        price: json["price"],
    );

}