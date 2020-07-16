
class Profile {

  final int id;
  final String name;
  final String email;
  final String url;
  String expiry;

  Profile({this.id, this.name, this.email, this.url, this.expiry});

  factory Profile.fromJson(Map<String, dynamic> json) => Profile (
      id: int.parse(json['id']),
      email: json['email'],
      name: json['name'],
      url: json['picture']['data']['url'],
    );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'url': url,
      'expiry': expiry,
    };
  }
  @override
  String toString() {
    return 'Profile{id: $id, name: $name, email: $email, url: $url, expiry: $expiry}';
  }
}
