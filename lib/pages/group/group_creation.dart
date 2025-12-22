import 'dart:convert';
import 'dart:io';

import 'package:ahzir/index.dart';
import 'package:ahzir/pages/bottom_nav_pages.dart';
import 'package:ahzir/pages/favorites/favorite_teams.dart';
import 'package:ahzir/screens/next_screens.dart';
import 'package:ahzir/view-model/auth_view_model.dart';
import 'package:ahzir/widgets/app_bar_widget.dart';
import 'package:ahzir/widgets/app_snackbar.dart';
import 'package:ahzir/widgets/shared/button/app_button.dart';
import 'package:ahzir/widgets/text_inputs/TextWithInput.dart';
import 'package:ahzir/widgets/text_inputs/text_input_widget.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GroupCreation extends StatefulWidget {
  final bool isRegistering;

  const GroupCreation({
    required this.isRegistering,
    super.key
  });

  @override
  State<GroupCreation> createState() => _GroupCreationState();
}

class _GroupCreationState extends State<GroupCreation> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  AutovalidateMode? messageValidationModeName =
      AutovalidateMode.onUserInteraction;
  final nameController = TextEditingController();
  File? _imageFile;
  AuthViewModel? authProvider;
  // FlutterSecureStorage storage = FlutterSecureStorage();
  late SharedPreferences prefs;


  Future<void> _pickImage() async {
    try {
      // Request permission
      PermissionStatus status = await Permission.photos.request();

      if (status.isGranted) {
        final ImagePicker picker = ImagePicker();
        final XFile? pickedFile = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 500,
          maxHeight: 500,
          imageQuality: 80,
        );

        if (pickedFile != null) {
          setState(() {
            _imageFile = File(pickedFile.path);
          });
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Permission denied to access gallery').tr()),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('$e')),
        );
      }
      // debugPrint('Error picking image: $e');
    }
  }

  createGroup() async {
    prefs = await SharedPreferences.getInstance();
    if (formKey.currentState!.validate()) {
      FormData formData = FormData.fromMap({
        'name': nameController.text,
        if (_imageFile != null)
          'logo': await MultipartFile.fromFile(
            _imageFile!.path,
            filename: _imageFile!.path.split('/').last, // Correct filename
          ),
      });
      // debugPrint("data: ${formData}");
      Response response = await authProvider?.createGroup(context: context, data: formData);
      if(response.statusCode != null &&
          (response.statusCode! >= 200 && response.statusCode! <= 399)) {
        //save user info
        await prefs.setString(
            "userInfo", jsonEncode(response.data['user']));
        appSnackBar(context: context, msg: 'Your group has been created and waiting for review');
        if(widget.isRegistering) {
          nextScreenCloseOthers(context, FavoriteTeams(
              navigateTo: BottomNavPages(index: 4),
              isRegistering: true));
        }else{
          Navigator.pop(context, response.data);
        }
      }else{
        appSnackBar(context: context, msg: response.data['message'], isError: true);
      }
    }
  }

  @override
  void initState() {
    authProvider = Provider.of<AuthViewModel>(context, listen: false);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'Create Group',
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWithInput(
                  text: 'Group name',
                  crossAxisAlignment: CrossAxisAlignment.start,
                  widget: TextInputWidget(
                      autoValidateMode: messageValidationModeName,
                      controller: nameController,
                      hintText: "Enter group name".tr(),
                      maxLines: 1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'field is empty'.tr();
                        }
                        return null;
                      })),
              const SizedBox(height: 20),
              Text("Group Photo",
                      style: TextStyle(
                          color: secondaryColor,
                          fontSize: fontSize16,
                          fontStyle: FontStyle.normal))
                  .tr(),
              const SizedBox(height: 10),
              InkWell(
                onTap: _pickImage,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add_photo_alternate,
                                size: 40, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'Add group photo',
                              style: TextStyle(color: Colors.grey, fontSize: fontSize12),
                            ).tr(),
                          ],
                        ),
                ),
              ),
              const SizedBox(height: 80),
              AppButton(onPressed: () => createGroup(), text: 'Create')
            ],
          ),
        ),
      ),
    );
  }
}
