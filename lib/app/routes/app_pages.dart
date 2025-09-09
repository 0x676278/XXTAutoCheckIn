import 'package:get/get.dart';

import '../modules/accountManager/bindings/account_manager_binding.dart';
import '../modules/accountManager/views/account_manager_view.dart';
import '../modules/check_in/bindings/check_in_binding.dart';
import '../modules/check_in/views/check_in_view.dart';
import '../modules/class/bindings/class_binding.dart';
import '../modules/class/views/class_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/qrSign/bindings/qr_sign_binding.dart';
import '../modules/qrSign/views/qr_sign_view.dart';
import '../modules/scan/bindings/scan_binding.dart';
import '../modules/scan/views/scan_view.dart';
import '../modules/signProxy/bindings/sign_proxy_binding.dart';
import '../modules/signProxy/views/sign_proxy_view.dart';
import '../modules/tabs/bindings/tabs_binding.dart';
import '../modules/tabs/views/tabs_view.dart';
import '../modules/user/bindings/user_binding.dart';
import '../modules/user/views/user_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.TABS;

  static final routes = [
    GetPage(
      name: _Paths.TABS,
      page: () => const TabsView(),
      binding: TabsBinding(),
    ),
    GetPage(
      name: _Paths.USER,
      page: () => const UserView(),
      binding: UserBinding(),
    ),
    GetPage(
      name: _Paths.CLASS,
      page: () => const ClassView(),
      binding: ClassBinding(),
    ),
    GetPage(
      name: _Paths.CHECK_IN,
      page: () => const CheckInView(),
      binding: CheckInBinding(),
    ),
    GetPage(
      name: _Paths.SCAN,
      page: () => ScanView(),
      binding: ScanBinding(),
    ),
    GetPage(
      name: _Paths.QR_SIGN,
      page: () => const QrSignView(),
      binding: QrSignBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: _Paths.SIGN_PROXY,
      page: () => const SignProxyView(),
      binding: SignProxyBinding(),
    ),
    GetPage(
      name: _Paths.ACCOUNT_MANAGER,
      page: () => const AccountManagerView(),
      binding: AccountManagerBinding(),
    ),
  ];
}
