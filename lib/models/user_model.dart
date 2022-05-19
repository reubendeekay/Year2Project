class UserModel {
  String? userId;
  final String? name;
  final String? email;
  final String? password;
  final String? profile;
  List<dynamic>? rentedPlaces = [];
  List<dynamic>? wishlist = [];
  final String? phone;
  final bool? isLandlord;
  final bool? isAdmin;
  final double? balance;

  UserModel({
    this.userId,
    this.name,
    this.email,
    this.password,
    this.profile,
    this.phone,
    this.isLandlord,
    this.isAdmin,
    this.rentedPlaces,
    this.wishlist,
    this.balance,
  });

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'name': name,
        'email': email,
        'password': password,
        'profile': profile,
        'phone': phone,
        'isLandlord': isLandlord,
        'isAdmin': isAdmin,
        'rentedPlaces': rentedPlaces,
        'wishlist': wishlist,
        'balance': 0,
      };

  factory UserModel.fromJson(dynamic json) {
    return UserModel(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      profile: json['profile'],
      phone: json['phone'],
      isLandlord: json['isLandlord'],
      isAdmin: json['isAdmin'],
      rentedPlaces: json['rentedPlaces'],
      wishlist: json['wishlist'],
      balance: double.parse(json['balance'].toString()),
    );
  }
}
