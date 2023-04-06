import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/controllers/auth_controller.dart';
import 'package:howver/screens/auth/signup_screen.dart';
import 'package:howver/utils/constants.dart';
import 'package:howver/widgets/custom_button.dart';
import 'package:howver/widgets/custom_field.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder(
        init: AuthController(),
        builder: (controller) => Center(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: Get.width * 0.65,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/images/logo.png',
                            height: 100,
                          ),
                          SizedBox(height: Get.height * 0.02),
                          const Text(
                            'HOWVER',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: Get.height * 0.04),
                          CustomField(
                            controller: _emailController,
                            labelText: 'email',
                            hintText: '',
                          ),
                          SizedBox(height: Get.height * 0.02),
                          CustomField(
                            controller: _passwordController,
                            labelText: 'password',
                            hintText: '',
                            obscureText: true,
                          ),
                          SizedBox(height: Get.height * 0.02),
                          CustomButton(
                            onPressed: () => authController.loginUser( 
                              _emailController.text, _passwordController.text),
                            widthPercent: 0.3,
                            btnText: 'LOGIN',
                          ),
                          SizedBox(height: Get.height * 0.02),
                          InkWell(
                            onTap: () {
                              Get.to(() => SignUpScreen());
                            },
                            child: Text(
                              'Don\'t have an account?\nSIGN-UP HERE',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black.withOpacity(0.4),
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(height: Get.height * 0.02),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
