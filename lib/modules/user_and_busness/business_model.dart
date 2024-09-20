enum accountTypes {
  admin,
  user,
  business,
}

class BusinessModel {
  final String businessId;
  String businessName;
  final String businessLogo;
  final String adminEmail;
  final String businessAddress;
  final String contactNumber;
  final String businessType;
  final List<dynamic> posLocations;
  final String businessDescription;
  final Map<String, dynamic> accounts;

  BusinessModel({
    required this.businessId,
    required this.businessName,
    required this.businessLogo,
    required this.adminEmail,
    required this.businessAddress,
    required this.posLocations,
    required this.contactNumber,
    required this.businessType,
    required this.businessDescription,
    required this.accounts,
  });

  factory BusinessModel.fromMap(Map<String, dynamic> map) {
    return BusinessModel(
      businessId: map['business_id'],
      businessName: map['business_name'],
      businessLogo: map['business_logo'],
      adminEmail: map['email'],
      businessAddress: map['location'],
      contactNumber: map['contact_number'],
      businessType: map['business_type'],
      businessDescription: map['description'],
      posLocations: map['pos_locations'],
      accounts: map['accounts'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "business_id": this.businessId,
      "business_name": this.businessName,
      "business_logo": this.businessLogo,
      "email": this.adminEmail,
      "location": this.businessAddress,
      "contact_number": this.contactNumber,
      "business_type": this.businessType,
      "description": this.businessDescription,
      "pos_locations": this.posLocations,
      "accounts": this.accounts,
    };
  }

  List<dynamic> toList() {
    return [
      businessName,
      businessLogo,
      adminEmail,
      businessAddress,
      contactNumber,
      businessType,
      businessDescription,
      accounts.toString()
    ];
  }
}
