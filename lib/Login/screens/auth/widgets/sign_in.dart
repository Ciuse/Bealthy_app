import 'package:Bealthy_app/Login/screens/auth/widgets/provider_button.dart';
import 'package:Bealthy_app/Login/screens/auth/widgets/sign_in_up_bar.dart';
import 'package:flutter/material.dart';
import 'package:lit_firebase_auth/lit_firebase_auth.dart';

import 'decoration_functions.dart';
import 'title.dart';

class SignIn extends StatelessWidget {
  const SignIn({
    Key key,
    @required this.onRegisterClicked,
  }) : super(key: key);

  final VoidCallback onRegisterClicked;

  @override
  Widget build(BuildContext context) {
    final isSubmitting = context.isSubmitting();
    return SignInForm(
      child: Padding(
        padding: const EdgeInsets.all(22.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: LoginTitle(
                  title: 'Welcome\nBack',
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: EmailTextFormField(
                  decoration: signInInputDecoration(hintText: 'Email'),
                  style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: PasswordTextFormField(
                  decoration: signInInputDecoration(hintText: 'Password'),
                  style:  TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              SignInBar(
                label: 'Sign in',
                isLoading: isSubmitting,
                onPressed: () {
                  context.signInWithEmailAndPassword();
                },
              ),
              const SizedBox(
                height: 5.0,
              ),
              const Text(
                "or sign in with",
                style: TextStyle(
                  color: Colors.black54, fontSize: 16
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ProviderButton(
                    context: context,
                    signInType: "google",
                  ),
                  ProviderButton(
                    context: context,
                    signInType: "apple",
                  ),
                  ProviderButton(
                    context: context,
                    signInType: "twitter",
                  ),
                ],
              ),
              const SizedBox(
                height: 24.0,
              ),
              InkWell(
                  splashColor: Colors.white,
                  onTap: () {
                    onRegisterClicked?.call();
                  },
                  child: RichText(
                    text: const TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                      children: <TextSpan>[
                        TextSpan(
                          text: 'SIGN UP',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
