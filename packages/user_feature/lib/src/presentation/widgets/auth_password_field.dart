import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:user_domain/user_domain.dart';

class AuthPasswordField extends HookWidget {
  const AuthPasswordField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.tooShortErrorText,
    this.focusNode,
    this.onFieldSubmitted,
    this.textInputAction,
    this.isNewPassword = false,
    super.key,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String tooShortErrorText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final TextInputAction? textInputAction;
  final bool isNewPassword;

  @override
  Widget build(BuildContext context) {
    final passwordVisible = useState(false);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            passwordVisible.value
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
          ),
          onPressed: () => passwordVisible.value = !passwordVisible.value,
        ),
      ),
      obscureText: !passwordVisible.value,
      textInputAction: textInputAction ?? TextInputAction.next,
      autofillHints: [isNewPassword ? AutofillHints.newPassword : AutofillHints.password],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (v) => Validators.password(v, tooShortMessage: tooShortErrorText),
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
