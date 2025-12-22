import 'package:ahzir/models/model/user_model.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ahzir/globals/colors.dart';
import 'package:ahzir/widgets/phone_field_widget.dart';

class ProfileDialog extends StatefulWidget {
  final UserModel? user;
  final Function(UserModel) onSave;

  const ProfileDialog({
    Key? key,
    required this.user,
    required this.onSave,
  }) : super(key: key);

  @override
  _ProfileDialogState createState() => _ProfileDialogState();
}

class _ProfileDialogState extends State<ProfileDialog> {
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  AutovalidateMode? messageValidationModeFName =
      AutovalidateMode.onUserInteraction;
  AutovalidateMode? messageValidationModeLName =
      AutovalidateMode.onUserInteraction;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isEmpty = false;
  String? initialCountryCode;
  String? fullNumber;
  String? phoneNb;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.user?.firstName ?? '');
    _lastNameController =
        TextEditingController(text: widget.user?.lastName ?? '');
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: grey1D,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Text(
                  'Complete Your Profile',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.primaryColor,
                  ),
                  textAlign: TextAlign.center,
                ).tr(),
                const SizedBox(height: 24),
                
                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // First Name Field
                      TextFormField(
                        controller: _firstNameController,
                        autovalidateMode: messageValidationModeFName,
                        onChanged: (_) => setState(() {
                          messageValidationModeFName = AutovalidateMode.always;
                        }),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your first name'.tr();
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'First Name'.tr(),
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1.0),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Last Name Field
                      TextFormField(
                        controller: _lastNameController,
                        autovalidateMode: messageValidationModeLName,
                        onChanged: (_) => setState(() {
                          messageValidationModeLName = AutovalidateMode.always;
                        }),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your last name'.tr();
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Last Name'.tr(),
                          labelStyle: const TextStyle(color: Colors.white70),
                          filled: true,
                          fillColor: Colors.transparent,
                          hintStyle: const TextStyle(color: Colors.white70),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 1.0),
                          ),
                          focusedBorder: const UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white, width: 2.0),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                          prefixIcon: Icon(
                            Icons.person_outline,
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Phone Field
                      PhoneFieldWidget(
                        onChanged: (phone) {
                          setState(() {
                            isEmpty = false;
                            initialCountryCode = phone.countryCode;
                            phoneNb = phone.number;
                            fullNumber = initialCountryCode! + phoneNb!;
                          });
                        },
                        onCountryChanged: (country) {
                          setState(() {
                            initialCountryCode = country.dialCode;
                            fullNumber = "+$initialCountryCode$phoneNb";
                          });
                        },
                      ),
                      
                      // Error Message
                      if (isEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                          child: Row(
                            children: [
                              Icon(Icons.error_outline, color: Colors.red[300], size: 16),
                              const SizedBox(width: 4),
                              Text(
                                "Please enter a valid phone number".tr(),
                                style: TextStyle(
                                  color: Colors.red[300],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      const SizedBox(height: 24),
                      
                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _onSubmit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.primaryColor,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 4),
                          ),
                          child: const Text(
                            'Save Profile',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ).tr(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onSubmit() {
    if (_formKey.currentState!.validate() && fullNumber != null && isEmpty == false) {
      // Create a new UserModel with the updated values
      final updatedUser = UserModel(
        id: widget.user?.id ?? 0, // Provide a default ID if null
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        email: widget.user?.email ?? '',
        phone: fullNumber!,
        usergroupstatus: widget.user?.usergroupstatus,
        groupId: widget.user?.groupId,
        totalpoints: widget.user?.totalpoints ?? 0,
        qiCustomerId: widget.user?.qiCustomerId,
      );

      // Debug print to verify the values
      debugPrint("Updated user: ${updatedUser.toString()}");
      
      // Call the onSave callback with the updated user
      widget.onSave(updatedUser);
      
      // Close the dialog
      // if (mounted) {
      //   Navigator.of(context).pop();
      // }
    }
  }
}

// checkFields() {
//   if(_formKey.currentState!.validate() && fullNumber != null && isEmpty == false)
// }

Future<void> showProfileDialog({
  required BuildContext context,
  required UserModel? user,
  required Function(UserModel) onSave,
}) async {
  return showDialog(
    context: context,
    barrierDismissible: false, // Prevent closing by tapping outside
    builder: (BuildContext context) {
      return ProfileDialog(
        user: user,
        onSave: onSave,
      );
    },
  );
}
