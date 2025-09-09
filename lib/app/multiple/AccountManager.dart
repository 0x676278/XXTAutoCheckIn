import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../moudel/Account.dart';

class AccountManager extends GetxController {
  final storage = GetStorage();
  final accounts = <Account>[].obs; // 所有账号列表

  final String storageKey = "account_list";

  @override
  void onInit() {
    super.onInit();
    loadAccounts();
  }

  /// 保存账号
  void addAccount(Account account) {
    accounts.add(account);
    saveAccounts();
  }

  /// 删除账号
  void removeAccount(Account account) {
    accounts.remove(account);
    saveAccounts();
  }

  /// 清空账号
  void clearAccounts() {
    accounts.clear();
    saveAccounts();
  }

  /// 保存到本地
  void saveAccounts() {
    List<Map<String, dynamic>> jsonList = accounts.map((a) => a.toJson()).toList();
    storage.write(storageKey, jsonList);
  }

  /// 读取本地账号
  void loadAccounts() {
    List? jsonList = storage.read(storageKey);
    if (jsonList != null) {
      accounts.assignAll(jsonList.map((e) => Account.fromJson(Map<String, dynamic>.from(e))).toList());
    }
  }
}
