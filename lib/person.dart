class Person {
  static const REF = "people";

  String uid;
  String name;
  String photoUrl;

  Person(this.uid, this.name, this.photoUrl);

  Person.fromJson(Map<String, dynamic> data)
      : uid = data['uid'],
        name = data['name'],
        photoUrl = data['photoUrl'];

  Map<String, String> toJson() {
    return {
      'uid': uid,
      'name': name,
      'photoUrl': photoUrl,
    };
  }
}
