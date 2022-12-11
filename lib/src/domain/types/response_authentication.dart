class AuthenticationResponse {
  final bool isSignUp;
  final String? phoneNumber;
  final String? email;

  AuthenticationResponse({
    required this.isSignUp,
    this.phoneNumber,
    this.email,
  });
}
