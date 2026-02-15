import 'package:get/get_rx/src/rx_types/rx_types.dart';

class Account {
  String username;
  String password;
  String nickname;
  RxBool isSelected = false.obs;
  RxString status = 'success'.obs; // 'success', 'fail', ''
  RxString message = ''.obs; // 错误信息

  Account({required this.username, required this.password, required this.nickname});

  // 转 Map（用于存储到 GetStorage）
  Map<String, dynamic> toJson() {
    return {
      "username": username,
      "password": password,
      "nickname": nickname,

    };
  }

  // 从 Map 转换
  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      username: json["username"],
      password: json["password"],
      nickname: json["nickname"],
    );
  }
}
