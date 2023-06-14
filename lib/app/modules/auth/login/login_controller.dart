import 'package:todo_list/app/services/user/user_service.dart';

import '../../../core/notifier/default_change_notifier.dart';
import '../../../exception/auth_exception.dart';

class LoginController extends DefaultChangeNotifier {
  final UserService _userService;
  String? infoMessage;

  LoginController({required UserService userService}) : _userService = userService;

  bool get hasInfo => infoMessage != null;
  String get message => infoMessage ?? '';

  Future<void> login(String email, String password) async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
      notifyListeners();

      final user = await _userService.login(email, password);

      if (user != null) {
        success();
      } else {
        setError('Usuário ou senha inválidos');
      }
    } on AuthException catch (e) {
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> googleLogin() async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
      notifyListeners();

      final user = await _userService.googleLogin();

      if (user != null) {
        success();
      } else {
        setError('Erro ao realizar login com google');
      }
    } on AuthException catch (e) {
      _userService.googleLogout();
      setError(e.message);
    } finally {
      hideLoading();
      notifyListeners();
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      showLoadingAndResetState();
      infoMessage = null;
      notifyListeners();
      await _userService.forgotPassword(email);
      infoMessage = "Reset de senha enviado para seu e-mail";
    } on AuthException catch (e) {
      setError(e.message);
    } catch (_) {
      setError('Erro ao resetar a senha');
    } finally {
      hideLoading();
      notifyListeners();
    }
  }
}
