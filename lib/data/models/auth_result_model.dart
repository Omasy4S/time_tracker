import '../../domain/entities/auth_result.dart';
import 'user_model.dart';

class AuthResultModel extends AuthResult {
  const AuthResultModel({
    required super.token,
    required super.user,
  });

  factory AuthResultModel.fromJson(Map<String, dynamic> json) {
    return AuthResultModel(
      token: json['token'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': (user as UserModel).toJson(),
    };
  }
}
