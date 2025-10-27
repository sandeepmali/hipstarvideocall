class LoginState {
  final String email;
  final String password;
  final String error;
  final bool isSubmitting;
  final bool isSuccess;

  LoginState({
    required this.email,
    required this.password,
    required this.error,
    required this.isSubmitting,
    required this.isSuccess,
  });

  factory LoginState.initial() => LoginState(
    email: '',
    password: '',
    error: '',
    isSubmitting: false,
    isSuccess: false,
  );

  LoginState copyWith({
    String? email,
    String? password,
    String? error,
    bool? isSubmitting,
    bool? isSuccess,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      error: error ?? this.error,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}