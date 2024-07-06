class UserAccount {
  final String id;
  final String emailId;
  final String name;
  final String designation;
  final String profilePicUrl;
  final int invoiceCount;

  UserAccount({
    required this.id,
    required this.emailId,
    required this.name,
    required this.designation,
    required this.profilePicUrl,
    required this.invoiceCount,
  });

  factory UserAccount.fromJson(Map<String, dynamic> json) {
    return UserAccount(
      id: json['id'],
      emailId: json['emailId'],
      name: json['name'],
      designation: json['designation'],
      profilePicUrl: json['profilePicUrl'],
      invoiceCount: json['invoiceCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emailId': emailId,
      'name': name,
      'designation': designation,
      'profilePicUrl': profilePicUrl,
      'invoiceCount': invoiceCount,
    };
  }
}
