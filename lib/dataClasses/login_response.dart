class LoginResponse{

  final String loginId;
  final String loginTime;

  LoginResponse({required this.loginId, required this.loginTime});

  factory LoginResponse.fromJson(Map<String, dynamic> json){
    return LoginResponse(
        loginId: json["loginId"],
      loginTime: json["dateTime"],
    );
  }
}