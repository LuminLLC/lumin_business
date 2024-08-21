import 'package:flutter/material.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/inventory/app_styles.dart';
import 'package:lumin_business/modules/login/app_colors.dart';
import 'package:lumin_business/modules/login/app_icons.dart';
import 'package:lumin_business/modules/login/lumin_auth_provider.dart';
import 'package:provider/provider.dart';

class CreateBusinessScreen extends StatefulWidget {
  const CreateBusinessScreen({Key? key}) : super(key: key);

  @override
  State<CreateBusinessScreen> createState() => _CreateBusinessScreenState();
}

class _CreateBusinessScreenState extends State<CreateBusinessScreen> {
  final SizeAndSpacing sp = SizeAndSpacing();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool obscureText = true;
  String? _emailError;
  String? _passwordError;
  String? _confirmPasswordError;
  String? signInError;
  bool formSubmitted = false;
  final List<String> businessTypes = [
    'Retail',
    'Wholesale',
    'Service',
    'Manufacturing',
    'Other'
  ];
  String? selectedBusinessType;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool _validateEmail() {
    if (_emailController.text.isEmpty) {
      setState(() {
        _emailError = 'Please enter your email';
      });
      return false;
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    if (!emailRegex.hasMatch(_emailController.text)) {
      setState(() {
        _emailError = 'Please enter a valid email';
      });
      return false;
    }
    return true;
  }

  // Password validation
  bool _validatePassword() {
    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordError = 'Please enter your password';
      });
      return false;
    }
    if (_passwordController.text.length < 6) {
      setState(() {
        _passwordError = 'Password must be at least 6 characters long';
      });
      return false;
    }
    return true;
  }

  bool _validateConfirmPassword() {
    if (_confirmPasswordController.text.isEmpty) {
      setState(() {
        _confirmPasswordError = 'Please confirm your password';
      });
      return false;
    }
    if (_confirmPasswordController.text != _passwordController.text) {
      setState(() {
        _confirmPasswordError = 'Passwords do not match';
      });
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppColors.backColor,
      body: Container(
        width: width,
        height: height,
        margin: EdgeInsets.symmetric(horizontal: height * 0.5),
        color: AppColors.backColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.125),
                Text(
                  "Tell us about your business 📦",
                  style: ralewayStyle.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.blueDarkColor,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: height * 0.05),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'Business Name',
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
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Image.asset(AppIcons.emailIcon),
                      ),
                      contentPadding: const EdgeInsets.only(top: 16.0),
                      hintText: 'Enter Business Name',
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
                    'Business Type',
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
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    value: selectedBusinessType,
                    onChanged: (newValue) {
                      setState(() {
                        selectedBusinessType = newValue;
                      });
                    },
                    items: businessTypes
                        .map<DropdownMenuItem<String>>((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(
                          type,
                          style: ralewayStyle.copyWith(
                            fontWeight: FontWeight.w400,
                            color: AppColors.blueDarkColor,
                            fontSize: 12.0,
                          ),
                        ),
                      );
                    }).toList(),
                    hint: Text(
                      'Select Business Type',
                      style: ralewayStyle.copyWith(
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
                    'Business Emal',
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
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Image.asset(AppIcons.lockIcon),
                      ),
                      contentPadding: const EdgeInsets.only(top: 16.0),
                      hintText: 'Enter Business Email',
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
                    'Phone Number',
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
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Image.asset(AppIcons.lockIcon),
                      ),
                      contentPadding: const EdgeInsets.only(top: 16.0),
                      hintText: 'Enter Phone Number',
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
                    'Business Address',
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
                      prefixIcon: IconButton(
                        onPressed: () {},
                        icon: Image.asset(AppIcons.lockIcon),
                      ),
                      contentPadding: const EdgeInsets.only(top: 16.0),
                      hintText: 'Enter Business Address',
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
                        Navigator.pushNamed(context, "/uploadData");
                        // bool isEmailValid = _validateEmail();
                        // bool isPasswordValid = _validatePassword();
                        // bool isConfirmPasswordValid =
                        //     _validateConfirmPassword();
                        // if (isPasswordValid &&
                        //     isEmailValid &&
                        //     isConfirmPasswordValid) {
                        //   setState(() {
                        //     formSubmitted = true;
                        //   });
                        //   await luminAuth
                        //       .createUserWithEmail(_emailController.text,
                        //           _passwordController.text)
                        //       .then((response) {
                        //     setState(() {
                        //       formSubmitted = false;
                        //     });
                        //     bool isError = response.runtimeType == String;
                        //     if (isError) {
                        //       setState(() {
                        //         signInError = response;
                        //       });
                        //     } else {
                        //       print(response.user!.uid);
                        //       // Navigator.pushReplacementNamed(
                        //       //     context, "/platform");
                        //     }
                        //   });
                        // }
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
                                  height: sp.getHeight(30, height, width),
                                  width: sp.getHeight(30, height, width),
                                  child: CircularProgressIndicator())
                              : Text(
                                  'Save Business Information',
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
                  child: InkWell(
                    onTap: () {},
                    child: Text("I'll do this later",
                        style: ralewayStyle.copyWith(
                          color: AppColors.blueDarkColor,
                          fontWeight: FontWeight.normal,
                        )),
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
    );
  }
}
