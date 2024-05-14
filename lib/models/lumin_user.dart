class LuminUser {
  final String id;
  String email;
  String name;
  String businessId;
  String? access;

  LuminUser({
    required this.id,
    required this.email,
    required this.name,
     this.access,
    required this.businessId,
  });
}