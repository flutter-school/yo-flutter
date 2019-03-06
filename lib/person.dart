class Person {
  static const REF = "people";

  Person(this.uid, this.name, this.photoUrl);

  String uid;
  String name;
  String photoUrl;

  factory Person.fromJson(Map<String, dynamic> data) {
    return Person(data['uid'], data['name'], data['photoUrl']);
  }

  Map<String, String> toJson() {
    return {
      'uid': uid,
      'name': name,
      'photoUrl': photoUrl,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Person &&
          runtimeType == other.runtimeType &&
          uid == other.uid &&
          name == other.name &&
          photoUrl == other.photoUrl;

  @override
  int get hashCode => uid.hashCode ^ name.hashCode ^ photoUrl.hashCode;
}
