
class User {
  int id;
  String name;
  String email;
  String birthDate;
  String emailVerifiedAt;
  String image;

  User({
    this.id,
    this.name,
    this.email,
    this.birthDate,
    this.image,
    this.emailVerifiedAt,
  });

  factory User.fromJson(Map<String, dynamic> data) {
    return User(
        //This will be used to convert JSON objects that
        //are coming from querying the database and converting
        //it into a User object
        id:data['id'],
        name: data['name'],
        email: data['email'],
        emailVerifiedAt: data['email_verified_at'],
        image: data['image'].toString(),
      );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'image': image,
    'email_verified_at':emailVerifiedAt
  };

  Map<String, dynamic> toUpdateJson() => {
    'name': name,
    'email': email,
  };
}
