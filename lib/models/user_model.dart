class UserModel {
  final String id;
  final String email;
  final String displayName;
  final String avatarUrl;
  final String? accessToken;
  final bool isGuest;

  const UserModel({
    required this.id,
    required this.email,
    required this.displayName,
    required this.avatarUrl,
    this.accessToken,
    this.isGuest = false,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'displayName': displayName,
        'avatarUrl': avatarUrl,
        'accessToken': accessToken,
        'isGuest': isGuest,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String? ?? 'Angler',
      avatarUrl: json['avatarUrl'] as String? ??
          'https://i.pravatar.cc/100?img=12',
      accessToken: json['accessToken'] as String?,
      isGuest: json['isGuest'] as bool? ?? false,
    );
  }

  factory UserModel.guest() {
    return const UserModel(
      id: 'guest_angler',
      email: 'guest@castlog.local',
      displayName: 'Guest Angler',
      avatarUrl: 'https://i.pravatar.cc/100?img=12',
      accessToken: null,
      isGuest: true,
    );
  }
}
