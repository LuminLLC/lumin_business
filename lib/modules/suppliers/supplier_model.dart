class SupplierModel {
  String id;
  String name;
  String contactNumber;
  String email;
  String address;

  // Constructor
  SupplierModel({
    required this.id,
    required this.name,
    required this.contactNumber,
    required this.email,
    required this.address,
  });

  // Method to convert SupplierModel object into a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'contactNumber': contactNumber,
      'email': email,
      'address': address,
    };
  }

  // Static method to create a SupplierModel object from a map
  static SupplierModel fromMap(Map<String, dynamic> map) {
    return SupplierModel(
      id: map['id'],
      name: map['name'],
      contactNumber: map['contactNumber'],
      email: map['email'],
      address: map['address'],
    );
  }
}