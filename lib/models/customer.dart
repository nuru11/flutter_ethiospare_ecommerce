class CustomerModel {
  CustomerModel(
      {required this.email, required this.userName, required this.last_name, required this.password});
  String email;
  String userName;
  String last_name;
  String password;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> map = {};
    map.addAll({
      'email': email,
      'userName': userName,
      'last_name': last_name,
      'password': password,
    });
    return map;
  }
}
