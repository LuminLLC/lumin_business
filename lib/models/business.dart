enum accountTypes {
  admin,
  user,
  business,

}

class Business {
  final String businessId;
  String businessName;
  final String businessLogo;
  final String adminEmail;
  final String businessAddress;
  final String contactNumber;
  final String  businessType;
  final String businessDescription;
  final  Map<String, dynamic> accounts;


  Business({
    required this.businessId,
    required this.businessName,
    required this.businessLogo,
    required this.adminEmail,
    required this.businessAddress,
    required this.contactNumber,
    required this.businessType,
    required this.businessDescription,
    required this.accounts,
  });
}