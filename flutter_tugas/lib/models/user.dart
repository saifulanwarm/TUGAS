class User {
  final String id; // Ubah ini menjadi String
  final String name;
  final String email;
  final String password;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.password});

  // Pastikan metode toJson() dan fromJson() disesuaikan jika diperlukan
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'].toString(), // Pastikan ID diambil sebagai string
      name: json['name'],
      email: json['email'],
      password: json['password'],
    );
  }
}
