import 'package:equatable/equatable.dart';
import 'user.dart';

class AuthResult extends Equatable {
  final String token;
  final User user;

  const AuthResult({
    required this.token,
    required this.user,
  });

  @override
  List<Object> get props => [token, user];
}
