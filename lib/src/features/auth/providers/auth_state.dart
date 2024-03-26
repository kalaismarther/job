class AuthState {
  final bool isLoginLoading;

  const AuthState({this.isLoginLoading = false,
  });

  AuthState copySWith({bool? isLoginLoading}) =>
      AuthState(isLoginLoading: isLoginLoading ?? this.isLoginLoading);
}
