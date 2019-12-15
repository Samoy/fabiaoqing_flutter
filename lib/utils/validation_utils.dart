const PATTERN_PHONE = r"^1[3456789](\d){9}$";
const PATTERN_PASSWORD = r"^(?![\d]+$)(?![a-zA-Z]+$)(?![^\da-zA-Z]+$).{8,16}$";
const PATTERN_CODE = r"^(\d){6}$";

String validationTextField(
  String name,
  String source,
  String pattern,
) {
  RegExp regExp = RegExp(pattern);
  return regExp.hasMatch(source) ? null : "$name格式不正确";
}
