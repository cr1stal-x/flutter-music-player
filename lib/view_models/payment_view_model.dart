import 'package:flutter/material.dart';
import 'sign_up_view_model.dart';
class PaymentViewModel extends ChangeNotifier {
  PaymentViewModel({required this.userPassword});
  String userPassword;
  String cardNumber = '';
  String password = '';
  String? errorMessage;
  bool isSuccess = false;

  void updateCardNumber(String value) {
    cardNumber = value;
    notifyListeners();
  }

  void updatePassword(String value) {
    password = value;
    notifyListeners();
  }

  void processPayment() {
    final expectedPassword = userPassword.substring(userPassword.length - 4);
    if (password == expectedPassword) {
      isSuccess = true;
      errorMessage = null;
    } else {
      isSuccess = false;
      errorMessage = 'Wrong password!';
    }
    notifyListeners();
  }
}
