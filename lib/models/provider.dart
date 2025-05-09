class ProviderModel {
  final int id;
  final String name;
  final String lastName;
  final String email;
  final String state;

  ProviderModel({
    this.id = 0,
    required this.name,
    required this.lastName,
    required this.email,
    required this.state,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) {
    return ProviderModel(
      id: json['provider_id'] ?? 0,
      name: json['provider_name'],
      lastName: json['provider_last_name'],
      email: json['provider_mail'],
      state: json['provider_state'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider_id': id,
      'provider_name': name,
      'provider_last_name': lastName,
      'provider_mail': email,
      'provider_state': state,
    };
  }
}
