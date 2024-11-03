class UserData{
  final String userId;
  final String userName;
  final String userPhoneNumber;

  UserData({required this.userName, required this.userPhoneNumber, required this.userId});

  factory UserData.fromJson(Map<String, dynamic> json){
    return UserData(
        userId: json["userId"],
        userName: json["userName"],
        userPhoneNumber: json["phoneNumber"],
    );
  }
}