class CustomerModel {
  final String email;
  final String phoneNumber;
  final String name;

  CustomerModel(
      {required this.name, required this.phoneNumber, required this.email});

  /// Converts instance of Customer to json
  Map<String, dynamic> toJson() {
    return {"email": email, "phonenumber": phoneNumber, "name": name};
  }
}
