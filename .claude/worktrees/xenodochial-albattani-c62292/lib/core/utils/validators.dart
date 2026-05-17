class Validators {
  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
  static bool isValidEmail(String email) => _emailRegex.hasMatch(email.trim());
}
