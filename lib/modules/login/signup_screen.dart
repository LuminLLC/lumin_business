import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lumin_business/common/lumin_utll.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/inventory/app_styles.dart';
import 'package:lumin_business/modules/login/app_colors.dart';
import 'package:lumin_business/modules/login/app_icons.dart';
import 'package:lumin_business/modules/login/create_business.dart';
import 'package:lumin_business/modules/login/lumin_auth_provider.dart';
import 'package:lumin_business/modules/login/responsive_widget.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final SizeAndSpacing sp = SizeAndSpacing();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool obscureText = true;
  String? _emailError;
  String? _passwordError;
  String? _nameError;
  String? _confirmPasswordError;
  String? signInError;
  bool formSubmitted = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  bool _validateForm() {
    _nameError = LuminUtll.validateName(_nameController.text);
    _emailError = LuminUtll.validateEmail(_emailController.text);
    _passwordError = LuminUtll.validatePassword(_passwordController.text);
    _confirmPasswordError = LuminUtll.validateConfirmPassword(
        _passwordController.text, _confirmPasswordController.text);

    return _nameError == null &&
        _emailError == null &&
        _passwordError == null &&
        _confirmPasswordError == null;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backColor,
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ResponsiveWidget.isSmallScreen(context)
                ? const SizedBox()
                : Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(left: sp.getWidth(30, width)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset(
                          "assets/login_image.webp",
                          height: height * 0.8,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                  ),
            Expanded(
              child: Container(
                height: height,
                margin: EdgeInsets.symmetric(
                    horizontal: ResponsiveWidget.isSmallScreen(context)
                        ? height * 0.032
                        : height * 0.12),
                color: AppColors.backColor,
                child: SingleChildScrollView(
                  primary: false,
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Form(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: height * 0.15),
                        Text(
                          "Let's Get you started ✨",
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w800,
                            color: AppColors.blueDarkColor,
                            fontSize: 25.0,
                          ),
                        ),
                        SizedBox(height: height * 0.01),
                        Text(
                          'Enter your details to create an account',
                          style: ralewayStyle.copyWith(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textColor,
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Name',
                            style: ralewayStyle.copyWith(
                              fontSize: 12.0,
                              color: AppColors.blueDarkColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Container(
                          height: 50.0,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: AppColors.whiteColor,
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              if (_nameError != null) {
                                setState(() {
                                  _nameError = null;
                                });
                              }
                            },
                            controller: _nameController,
                            style: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor,
                              fontSize: 12.0,
                            ),
                            decoration: InputDecoration(
                              errorText: _nameError,
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.person,
                                size: sp.getFontSize(25, width),
                              ),
                              contentPadding: const EdgeInsets.only(top: 16.0),
                              hintText: 'Enter you name',
                              hintStyle: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.blueDarkColor.withOpacity(0.5),
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.014),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Email',
                            style: ralewayStyle.copyWith(
                              fontSize: 12.0,
                              color: AppColors.blueDarkColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Container(
                          height: 50.0,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: AppColors.whiteColor,
                          ),
                          child: TextFormField(
                            onChanged: (value) {
                              if (_emailError != null) {
                                setState(() {
                                  _emailError = null;
                                });
                              }
                            },
                            controller: _emailController,
                            style: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor,
                              fontSize: 12.0,
                            ),
                            decoration: InputDecoration(
                              errorText: _emailError,
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.email,
                                size: sp.getFontSize(25, width),
                              ),
                              contentPadding: const EdgeInsets.only(top: 16.0),
                              hintText: 'Enter Email',
                              hintStyle: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.blueDarkColor.withOpacity(0.5),
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.014),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Password',
                            style: ralewayStyle.copyWith(
                              fontSize: 12.0,
                              color: AppColors.blueDarkColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Container(
                          height: 50.0,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: AppColors.whiteColor,
                          ),
                          child: TextFormField(
                            controller: _passwordController,
                            onChanged: (value) {
                              if (_passwordError != null) {
                                setState(() {
                                  _passwordError = null;
                                });
                              }
                            },
                            style: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor,
                              fontSize: 12.0,
                            ),
                            obscureText: obscureText,
                            decoration: InputDecoration(
                              errorText: _passwordError,
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                icon: Image.asset(AppIcons.eyeIcon),
                              ),
                              prefixIcon: Icon(
                                Icons.password,
                                size: sp.getFontSize(25, width),
                              ),
                              contentPadding: const EdgeInsets.only(top: 16.0),
                              hintText: 'Enter Password',
                              hintStyle: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.blueDarkColor.withOpacity(0.5),
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.014),
                        Padding(
                          padding: const EdgeInsets.only(left: 16.0),
                          child: Text(
                            'Confirm Password',
                            style: ralewayStyle.copyWith(
                              fontSize: 12.0,
                              color: AppColors.blueDarkColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 6.0),
                        Container(
                          height: 50.0,
                          width: width,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: AppColors.whiteColor,
                          ),
                          child: TextFormField(
                            controller: _confirmPasswordController,
                            onChanged: (value) {
                              if (_confirmPasswordError != null) {
                                setState(() {
                                  _confirmPasswordError = null;
                                });
                              }
                            },
                            style: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w400,
                              color: AppColors.blueDarkColor,
                              fontSize: 12.0,
                            ),
                            obscureText: obscureText,
                            decoration: InputDecoration(
                              errorText: _confirmPasswordError,
                              border: InputBorder.none,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                icon: Image.asset(AppIcons.eyeIcon),
                              ),
                              prefixIcon: Icon(
                                Icons.password,
                                size: sp.getFontSize(25, width),
                              ),
                              contentPadding: const EdgeInsets.only(top: 16.0),
                              hintText: 'Re-enter Password',
                              hintStyle: ralewayStyle.copyWith(
                                fontWeight: FontWeight.w400,
                                color: AppColors.blueDarkColor.withOpacity(0.5),
                                fontSize: 12.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        Material(
                          color: Colors.transparent,
                          child: Consumer<LuminAuthProvider>(
                            builder: (context, luminAuth, _) => InkWell(
                              onTap: () async {
                                if (_validateForm()) {
                                  setState(() {
                                    formSubmitted = true;
                                  });
                                  await luminAuth
                                      .createUserWithEmail(
                                          _nameController.text,
                                          _emailController.text,
                                          _passwordController.text)
                                      .then((response) {
                                    setState(() {
                                      formSubmitted = false;
                                    });
                                    bool isError =
                                        response.runtimeType == String;
                                    if (isError) {
                                      setState(() {
                                        signInError = response;
                                      });
                                    } else {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              CreateBusinessScreen(
                                            userID: response.user!.uid,
                                          ),
                                        ),
                                      );
                                    }
                                  });
                                }
                              },
                              borderRadius: BorderRadius.circular(16.0),
                              child: Ink(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 70.0, vertical: 18.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16.0),
                                  color: AppColors.mainBlueColor,
                                ),
                                child: Center(
                                  child: formSubmitted
                                      ? SizedBox(
                                          height:
                                              sp.getHeight(30, height, width),
                                          width:
                                              sp.getHeight(30, height, width),
                                          child: CircularProgressIndicator())
                                      : Text(
                                          'Create Account',
                                          style: ralewayStyle.copyWith(
                                            fontWeight: FontWeight.w700,
                                            color: AppColors.whiteColor,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: sp.getHeight(25, height, width),
                        ),
                        Center(
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                    text: 'Already have an account?',
                                    style: ralewayStyle.copyWith(
                                      color: AppColors.blueDarkColor,
                                      fontWeight: FontWeight.normal,
                                    )),
                                TextSpan(
                                  text: ' Sign In',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () => Navigator.pushNamed(
                                        context, "/sign-in"),
                                  style: ralewayStyle.copyWith(
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.blueDarkColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: sp.getHeight(50, height, width),
                        ),
                        signInError == null
                            ? SizedBox()
                            : Center(
                                child: Text(
                                  signInError!,
                                  style: TextStyle(color: Colors.red),
                                ),
                              )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
