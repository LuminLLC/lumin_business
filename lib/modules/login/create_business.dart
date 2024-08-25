import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lumin_business/common/app_text_theme.dart';
import 'package:lumin_business/common/lumin_utll.dart';
import 'package:lumin_business/common/size_and_spacing.dart';
import 'package:lumin_business/modules/accounting/accounting_provider.dart';
import 'package:lumin_business/modules/customers/customer_provider.dart';
import 'package:lumin_business/modules/general_platform/app_state.dart';
import 'package:lumin_business/modules/inventory/app_styles.dart';
import 'package:lumin_business/modules/inventory/inventory_provider.dart.dart';
import 'package:lumin_business/modules/login/app_colors.dart';
import 'package:lumin_business/modules/suppliers/supplier_provider.dart';
import 'package:provider/provider.dart';

class CreateBusinessScreen extends StatefulWidget {
  final String userID;
  const CreateBusinessScreen({Key? key, required this.userID})
      : super(key: key);

  @override
  State<CreateBusinessScreen> createState() => _CreateBusinessScreenState();
}

class _CreateBusinessScreenState extends State<CreateBusinessScreen> {
  final SizeAndSpacing sp = SizeAndSpacing();
  late TextEditingController businessName;
  String? selectedBusinessType;
  String? selectedRef;
  late TextEditingController phoneNumber;
  late TextEditingController address;
  late TextEditingController hearAboutUs;
  String? _businessNameError;
  String? _selectedBusinessTypeError;
  String? _phoneNumberError;
  String? _addressError;
  String? signInError;
  bool formSubmitted = false;

  final List<String> businessTypes = [
    'Retail',
    'Wholesale',
    'Service',
    'Manufacturing',
    'Other'
  ];

  final List<String> ref = [
    "Social Media (Facebook, Instagram, Li,nkedIn, etc.)",
    "Google Search",
    "Friend or Colleague",
    "Online Advertisement",
    "Email Campaign",
    "Blog or Article",
    "Referral",
    "Attended a Webinar/Event",
    "YouTube",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    businessName = TextEditingController();
    phoneNumber = TextEditingController();
    address = TextEditingController();
    hearAboutUs = TextEditingController();
  }

  @override
  void dispose() {
    businessName.dispose();
    phoneNumber.dispose();
    address.dispose();
    selectedBusinessType = null;
    hearAboutUs.dispose();
    super.dispose();
  }

  bool _validateBusinessName() {
    if (businessName.text.isEmpty) {
      setState(() {
        _businessNameError = 'Please enter your business name';
      });
      return false;
    }
    return true;
  }

  // Password validation
  bool _validateBusinessType() {
    if (selectedBusinessType == null) {
      setState(() {
        _selectedBusinessTypeError = 'Please select a business type';
      });
      return false;
    }
    return true;
  }

  bool validatePhoneNumber() {
    String phoneNumberText = phoneNumber.text;

    // Updated regex to handle the format with dashes
    final RegExp phoneRegex = RegExp(r'^\d{3}-\d{3}-\d{4}$');

    print(phoneNumberText);
    if (phoneRegex.hasMatch(phoneNumberText)) {
      return true;
    } else {
      setState(() {
        _phoneNumberError = "Enter a valid number";
      });
      return false;
    }
  }

  bool _validateAddress() {
    if (address.text.isEmpty) {
      setState(() {
        _addressError = 'Please enter your address';
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
        margin: EdgeInsets.symmetric(horizontal: height * 0.3),
        color: AppColors.backColor,
        child: SingleChildScrollView(
          primary: false,
          padding: const EdgeInsets.only(bottom: 40.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.05),
                Text(
                  "Tell us about your business 📦",
                  style: ralewayStyle.copyWith(
                    fontWeight: FontWeight.w800,
                    color: AppColors.blueDarkColor,
                    fontSize: 25.0,
                  ),
                ),
                SizedBox(height: height * 0.03),
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
                      if (_businessNameError != null) {
                        setState(() {
                          _businessNameError = null;
                        });
                      }
                    },
                    controller: businessName,
                    style: ralewayStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppColors.blueDarkColor,
                      fontSize: 12.0,
                    ),
                    decoration: InputDecoration(
                      errorText: _businessNameError,
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.business),
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
                    dropdownColor: Colors.grey,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    value: selectedBusinessType,
                    onChanged: (newValue) {
                      if (_selectedBusinessTypeError != null) {
                        setState(() {
                          _selectedBusinessTypeError = null;
                        });
                      }
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
                    controller: phoneNumber,
                    inputFormatters: [PhoneNumberInputFormatter()],
                    onChanged: (value) {
                      if (_phoneNumberError != null) {
                        setState(() {
                          _phoneNumberError = null;
                        });
                      }
                    },
                    style: ralewayStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppColors.blueDarkColor,
                      fontSize: 12.0,
                    ),
                    decoration: InputDecoration(
                      errorText: _phoneNumberError,
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.phone),
                      contentPadding: const EdgeInsets.only(top: 16.0),
                      hintText: 'Enter Business Phone Number',
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
                    'Address',
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
                    controller: address,
                    onChanged: (value) {
                      if (_addressError != null) {
                        setState(() {
                          _addressError = null;
                        });
                      }
                    },
                    style: ralewayStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppColors.blueDarkColor,
                      fontSize: 12.0,
                    ),
                    decoration: InputDecoration(
                      errorText: _addressError,
                      border: InputBorder.none,
                      prefixIcon: Icon(Icons.location_pin),
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
                SizedBox(height: height * 0.014),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Text(
                    'How did you hear about Lumin Business?',
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
                    dropdownColor: Colors.grey,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    value: selectedRef,
                    onChanged: (newValue) {
                      setState(() {
                        selectedRef = newValue;
                      });
                    },
                    items: ref.map<DropdownMenuItem<String>>((String type) {
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
                      'Select a ref type',
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
                    'Would you like to import your existing business data? (Optional)',
                    style: ralewayStyle.copyWith(
                      fontSize: 12.0,
                      color: AppColors.blueDarkColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 6.0),
                Consumer4<AccountingProvider, InventoryProvider,
                        CustomerProvider, SupplierProvider>(
                    builder: (context, accountingProvider, inventoryProvider,
                        customerProvider, supplierProvidder, _) {
                  return Container(
                    padding: EdgeInsets.all(sp.getHeight(50, height, width)),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        border:
                            Border.all(color: Colors.black.withOpacity(0.3))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        uploadTrigger(
                            onTap: () {
                              accountingProvider.uploadTransactionsFromCSV();
                            },
                            isUploaded:
                                accountingProvider.allTransactions.isNotEmpty,
                            headers: accountingProvider.transactionHeaders,
                            icon: FontAwesomeIcons.calculator,
                            label: "Uplaod Accounts",
                            height: height,
                            width: width),
                        uploadTrigger(
                            onTap: () {
                              inventoryProvider.uploadProductsFromCSV();
                            },
                            isUploaded:
                                inventoryProvider.allProdcuts.isNotEmpty,
                            headers: inventoryProvider.productHeaders,
                            icon: FontAwesomeIcons.store,
                            label: "Uplaod Inventory",
                            height: height,
                            width: width),
                        uploadTrigger(
                            onTap: () {
                              customerProvider.uploadCustomersFromCSV();
                            },
                            isUploaded:
                                customerProvider.allCustomers.isNotEmpty,
                            headers: customerProvider.customerHeaders,
                            icon: FontAwesomeIcons.person,
                            label: "Uplaod Customers",
                            height: height,
                            width: width),
                        uploadTrigger(
                            onTap: () {
                              supplierProvidder.uploadSuppliersFromCSV();
                            },
                            isUploaded:
                                supplierProvidder.allSuppliers.isNotEmpty,
                            headers: supplierProvidder.supplierHeaders,
                            icon: FontAwesomeIcons.peopleCarryBox,
                            label: "Uplaod Suppliers",
                            height: height,
                            width: width),
                      ],
                    ),
                  );
                }),
                SizedBox(height: height * 0.05),
                Material(
                  color: Colors.transparent,
                  child: Consumer<AppState>(
                    builder: (context, appState, _) => InkWell(
                      onTap: () async {
                        print("called");
                        // Navigator.pushNamed(context, "/uploadData");
                        bool isBusinessNameValid = _validateBusinessName();
                        bool isBusinessTypeValid = _validateBusinessType();
                        bool isAddressValid = _validateAddress();
                        bool isPhoneNumberValid = validatePhoneNumber();
                        if (isBusinessTypeValid &&
                            isBusinessNameValid &&
                            isAddressValid &&
                            isPhoneNumberValid) {
                          print("here");
                          setState(() {
                            formSubmitted = true;
                          });
                          await appState
                              .setBusiness(
                                  user: widget.userID,
                                  businessName: businessName.text,
                                  contact: phoneNumber.text,
                                  businessType: selectedBusinessType!,
                                  address: address.text,
                                  ref: hearAboutUs.text)
                              .then((response) {
                            setState(() {
                              formSubmitted = false;
                            });
                            bool isError = response.runtimeType == String;
                            if (isError) {
                              setState(() {
                                signInError = response;
                              });
                            } else {
                              Navigator.pushReplacementNamed(
                                  context, "/platform");
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
                  height: sp.getHeight(10, height, width),
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

  Widget uploadTrigger(
      {required VoidCallback onTap,
      required List<String> headers,
      required IconData icon,
      required String label,
      required double height,
      required bool isUploaded,
      required double width}) {
    return InkWell(
      onTap: () async {
        await showDialog(
            context: context,
            builder: (builder) {
              return AlertDialog(
                title: SizedBox(
                  width: width * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "CSV Guidelines",
                        style: AppTextTheme().textTheme(width).displayMedium,
                      ),
                      Text(
                        "Ensure that your CSV has the following headers",
                        style: AppTextTheme().textTheme(width).bodyMedium,
                      )
                    ],
                  ),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (String s in headers)
                        ListTile(
                          leading: Text("${headers.indexOf(s) + 1}"),
                          title: Text(s),
                        )
                    ],
                  ),
                ),
                actions: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      onTap();
                    },
                    label: Icon(Icons.east),
                    icon: Text("Continue"),
                  )
                ],
              );
            });
      },
      //onTap,
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.black.withOpacity(isUploaded ? 1 : 0.3),
          ),
          SizedBox(
            height: sp.getHeight(10, height, width),
          ),
          Text(
            label,
            style: AppTextTheme()
                .textTheme(width)
                .bodySmall!
                .copyWith(color: Colors.black),
          )
        ],
      ),
    );
  }
}
