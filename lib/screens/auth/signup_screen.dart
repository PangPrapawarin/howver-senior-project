import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:howver/controllers/auth_controller.dart';
import 'package:howver/screens/auth/login_screen.dart';
import 'package:howver/utils/constants.dart';
import 'package:howver/widgets/custom_button.dart';
import 'package:howver/widgets/custom_field.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                 Get.to(() => LoginScreen());
              },
              child: Image.asset(
                'assets/images/arrow_back.png',
              ),
            ),
          ),
        ],
      ),      
      body: GetBuilder(
        init: AuthController(),
        builder: (controller) => Center(
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: SizedBox(
                    width: Get.width * 0.9,
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: CircleAvatar(
                                  radius: 50,
                                  backgroundColor: const Color(0xffD0FFB3),
                                  child: IconButton(
                                    icon: const Icon(Icons.add_a_photo),
                                    color: Colors.black,
                                    iconSize: 40,
                                    onPressed: () {authController.pickImage();},
                                  ),                         
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Column(
                                  children: [
                                    CustomField(
                                      controller: _accountNameController,
                                      labelText: 'accountName',
                                      hintText: '',
                                    ),
                                    SizedBox(height: Get.height * 0.02),
                                    CustomField(
                                      controller: _usernameController,
                                      labelText: 'username',
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
                                    CustomField(
                                      controller: _confirmPasswordController,
                                      labelText: 'confirmPassword',
                                      hintText: '',
                                      obscureText: true,
                                    ),
                                    SizedBox(height: Get.height * 0.02),
                                    CustomField(
                                      controller: _emailController,
                                      labelText: 'email',
                                      hintText: '',
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: Get.height * 0.02),
                          CustomButton(
                            widthPercent: 0.25,
                            onPressed: () => authController.registerUser(_usernameController.text, 
                            _emailController.text, 
                            _passwordController.text, 
                            _confirmPasswordController.text, 
                            _accountNameController.text, 
                            authController.profilePhoto), 
                            btnText: 'SIGNUP',
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
