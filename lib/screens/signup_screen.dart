import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/auth_method.dart';
import 'package:instagram/responsivelayout/mobile_screen.dart';
import 'package:instagram/responsivelayout/responsive_screen.dart';
import 'package:instagram/responsivelayout/web_screen.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widget/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreen();
}

class _SignupScreen extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  Uint8List? _image;

  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _bioController.dispose();
    _usernameController.dispose();
  }

  void selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);

    setState(() {
      _image = im;
    });
  }

  // signup user method
  void signupUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().signupUser(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      bio: _bioController.text,
      file: _image!,
    );
    // print(res);

    setState(() {
      _isLoading = false;
    });

    if (res != 'success') {
      showSnackBar(res, context);
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
              webScreenLayout: WebScreen(), mobileScreenLayout: MobileScreen()),
        ),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(child: Container(), flex: 2),
              // svg image
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(height: 64),
              // circular widget for profile image
              Stack(
                children: [
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : CircleAvatar(
                          radius: 64,
                          backgroundImage: NetworkImage(
                              "https://www.clipartkey.com/mpngs/m/152-1520367_user-profile-default-image-png-clipart-png-download.png"),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                        onPressed: selectImage,
                        icon: Icon(
                          Icons.add_a_photo,
                        )),
                  )
                ],
              ),
              SizedBox(height: 12),
              // username field
              TextFieldInput(
                hintText: "Enter UserName",
                textEditingController: _usernameController,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              // email field
              TextFieldInput(
                hintText: "Enter Email",
                textEditingController: _emailController,
                textInputType: TextInputType.emailAddress,
              ),
              SizedBox(height: 24),
              // password field
              TextFieldInput(
                hintText: "Enter Password",
                textEditingController: _passwordController,
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(height: 24),
              TextFieldInput(
                hintText: "Enter Your bio",
                textEditingController: _bioController,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              // login button
              InkWell(
                onTap: signupUser,
                child: Container(
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        )
                      : const Text('Sign Up'),
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(child: Container(), flex: 2),

              // transitioning to signin screen
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Text('Dont have an account?'),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      child: const Text(
                        'Login',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
