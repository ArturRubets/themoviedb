import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../library/widgets/inherited/provider.dart';
import '../../theme/app_button_style.dart';
import 'auth_model.dart';

class AuthWidget extends StatefulWidget {
  const AuthWidget({Key? key}) : super(key: key);

  @override
  State<AuthWidget> createState() => _AuthWidgetState();
}

class _AuthWidgetState extends State<AuthWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login to your account'),
      ),
      body: ListView(
        children: [
          const _HeaderWidget(),
        ],
      ),
    );
  }
}

class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const textStyle = TextStyle(
      fontSize: 16,
      color: Colors.black,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const SizedBox(height: 25),
          FormWidget(),
          const SizedBox(height: 25),
          Text.rich(
            TextSpan(
              text:
                  'In order to use the editing and rating capabilities of TMDB, as well as get personal recommendations you will need to login to your account. If you do not have an account, registering for an account is free and simple.',
              children: [
                TextSpan(
                  style: const TextStyle(color: AppButtonStyle.blueColor),
                  text: ' Click here ',
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                const TextSpan(text: 'to get started.'),
              ],
            ),
            style: textStyle,
          ),
          const SizedBox(height: 25),
          Text.rich(
            TextSpan(
              text:
                  'If you signed up but didn\'t get your verification email, ',
              children: [
                TextSpan(
                  text: 'click here ',
                  style: const TextStyle(color: AppButtonStyle.blueColor),
                  recognizer: TapGestureRecognizer()..onTap = () {},
                ),
                const TextSpan(text: 'to have it resent.'),
              ],
            ),
            style: textStyle,
          ),
        ],
      ),
    );
  }
}

class FormWidget extends StatelessWidget {
  FormWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.of<AuthModel>(context);

    const textStyle = TextStyle(
      fontSize: 16,
      color: Color(0xFF212529),
    );

    const textDecoration = InputDecoration(
      border: OutlineInputBorder(),
      isCollapsed: true,
      contentPadding: EdgeInsets.all(10),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: AppButtonStyle.blueColor),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _ErrorMessageWidget(),
        const Text('Username', style: textStyle),
        const SizedBox(height: 5),
        TextField(
          decoration: textDecoration,
          controller: model?.loginTextController,
        ),
        const SizedBox(height: 20),
        const Text('Password', style: textStyle),
        const SizedBox(height: 5),
        TextField(
          decoration: textDecoration,
          obscureText: true,
          controller: model?.passwordTextController,
        ),
        const SizedBox(height: 25),
        Row(
          children: [
            const _AuthButtonWidget(),
            const SizedBox(width: 30),
            TextButton(
              onPressed: () {},
              style: AppButtonStyle.staticlink,
              child: const Text('Reset password'),
            ),
          ],
        )
      ],
    );
  }
}

class _AuthButtonWidget extends StatelessWidget {
  const _AuthButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.of<AuthModel>(context);

    final onPressed =
        model?.canStartAuth == true ? () => model?.auth(context) : null;

    final content = onPressed != null
        ? const Text('Login')
        : const SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(),
          );

    return SizedBox(
      width: 80,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(AppButtonStyle.blueColor),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          textStyle: MaterialStateProperty.all(
            const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          padding: MaterialStateProperty.all(
            const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 8,
            ),
          ),
        ),
        child: content,
      ),
    );
  }
}

class _ErrorMessageWidget extends StatelessWidget {
  const _ErrorMessageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = NotifierProvider.of<AuthModel>(context);
    final errorMessage = model?.errorMessage;
    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text(
          errorMessage,
          style: const TextStyle(
            color: Colors.red,
            fontSize: 17,
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
