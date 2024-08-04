import 'package:flutter/material.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/inventory/app_styles.dart';
import 'package:lumin_business/modules/login/app_colors.dart';
import 'package:lumin_business/modules/login/lumin_auth_provider.dart';
import 'package:provider/provider.dart';

class UploadData extends StatefulWidget {
  const UploadData({Key? key}) : super(key: key);

  @override
  State<UploadData> createState() => _UploadDataState();
}

class _UploadDataState extends State<UploadData> {
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
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.125),
              Text(
                "Upload Data 📁",
                style: ralewayStyle.copyWith(
                  fontWeight: FontWeight.w800,
                  color: AppColors.blueDarkColor,
                  fontSize: 25.0,
                ),
              ),
              Expanded(
                child: GridView(
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  children: [
                    UploadButton(
                      label: 'Upload Inventory File',
                      folder: 'inventory',
                      onUpload: (s) {},
                    ),
                    UploadButton(
                      label: 'Upload Accounts File',
                      folder: 'accounts',
                      onUpload: (s) {},
                    ),
                    UploadButton(
                      label: 'Upload Customers File',
                      folder: 'customers',
                      onUpload: (s) {},
                    ),
                    UploadButton(
                      label: 'Upload Suppliers File',
                      folder: 'suppliers',
                      onUpload: (s) {},
                    ),
                  ],
                ),
              ),
              SizedBox(height: height * 0.05),
              Material(
                color: Colors.transparent,
                child: Consumer<LuminAuthProvider>(
                  builder: (context, luminAuth, _) => InkWell(
                    onTap: () async {},
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
                                'Continue',
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
            ]),
      ),
    );
  }
}

class UploadButton extends StatelessWidget {
  final String label;
  final String folder;
  final Function(String) onUpload;

  const UploadButton({
    Key? key,
    required this.label,
    required this.folder,
    required this.onUpload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextButton.icon(
        icon: Icon(Icons.upload),
        onPressed: () => onUpload(folder),
        label: Text(label),
      ),
    );
  }
}
