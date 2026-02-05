import 'package:flutter/material.dart';
import 'package:user_domain/user_domain.dart';

class AuthEmailField extends StatelessWidget {
  const AuthEmailField({
    required this.controller,
    required this.labelText,
    required this.hintText,
    required this.invalidErrorText,
    this.focusNode,
    this.onFieldSubmitted,
    super.key,
  });

  final TextEditingController controller;
  final String labelText;
  final String hintText;
  final String invalidErrorText;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: const Icon(Icons.email_outlined),
      ),
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      autofillHints: const [AutofillHints.email],
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (v) => Validators.email(v, invalidMessage: invalidErrorText),
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}
