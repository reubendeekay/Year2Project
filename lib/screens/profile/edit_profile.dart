import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/helpers/constants.dart';
import 'package:rent_space/models/user_model.dart';
import 'package:rent_space/providers/auth_provider.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen({Key? key}) : super(key: key);
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // final nameController = TextEditingController();
  // final emailController = TextEditingController();
  // final phoneController = TextEditingController();
  // final idController = TextEditingController();
  // final dateofBirthController = TextEditingController();
  // final postalController = TextEditingController();

  String fullName = '';
  String email = '';
  String phoneNumber = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<AuthProvider>(context, listen: false);
    UserModel user = authData.user!;
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          // backgroundColor: Colors.grey[50],
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                UserPicture(),
              ],
            ),
            SizedBox(height: size.height * 0.05),
//FORM INPUT

            Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: TextFormField(
                      // controller: controller,
                      initialValue: user.name != null
                          ? user.name
                          : 'Enter your full name',
                      onChanged: (val) {
                        setState(() {
                          fullName = val;
                        });
                      },
                      validator: (val) {
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          fullName = val!;
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          labelText: 'Full name',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                  ///////////////////////////////////////////
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: TextFormField(
                      // controller: controller,
                      validator: (val) {
                        return null;
                      },
                      initialValue: user.email != null
                          ? user.email
                          : 'Enter your email address',
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                      onSaved: (val) {
                        setState(() {
                          email = val!;
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          labelText: 'Email address',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                  //////////////////////////////////////////
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    child: TextFormField(
                      initialValue: user.phone != null
                          ? user.phone
                          : 'Enter your phone number',
                      onChanged: (val) {
                        setState(() {
                          phoneNumber = val;
                        });
                      },
                      validator: (val) {
                        return null;
                      },
                      onSaved: (val) {
                        setState(() {
                          phoneNumber = val!;
                        });
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          labelText: 'Phone number',
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(5),
                          )),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: size.height * 0.05),
            RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () async {
                _formKey.currentState!.save();
                // authData.updateProfile(
                //     UserModel(
                //       email: email,

                //       name: fullName,

                //       phone: phoneNumber,

                //     ),
                //     FirebaseAuth.instance.currentUser.uid);

                Navigator.pop(context);
              },
              color: kPrimaryColor,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 60.0, vertical: 15),
                child: Text(
                  'Save Changes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(
              height: 40,
            )
          ]),
        ));
  }
}

class UserPicture extends StatefulWidget {
  @override
  _UserPictureState createState() => _UserPictureState();
}

class _UserPictureState extends State<UserPicture> {
  List<Media> mediaList = [];
  final ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<AuthProvider>(context).user!;
    return Container(
      height: 110,
      width: 110,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    const BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: const Offset(0, 10),
                    )
                  ])),
          Center(
            child: CircleAvatar(
              radius: 50,
              backgroundImage: CachedNetworkImageProvider(user.profile!),
            ),
          ),
          Positioned(
            right: -10,
            bottom: -2,
            child: GestureDetector(
              onTap: () => openImagePicker(context),
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  backgroundColor: kPrimaryColor,
                  radius: 16,
                  child: const Icon(
                    Icons.camera_alt_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void openImagePicker(BuildContext context) {
    // openCamera(onCapture: (image){
    //   setState(()=> mediaList = [image]);
    // });
    showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20), topRight: Radius.circular(20)),
        ),
        context: context,
        builder: (context) {
          return GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop(),
              child: DraggableScrollableSheet(
                initialChildSize: 0.6,
                maxChildSize: 0.95,
                minChildSize: 0.6,
                builder: (ctx, controller) => AnimatedContainer(
                    duration: const Duration(milliseconds: 500),
                    color: Colors.white,
                    child: MediaPicker(
                      scrollController: controller,
                      mediaList: mediaList,
                      onPick: (selectedList) {
                        setState(() => mediaList = selectedList);
                        Navigator.pop(context);
                      },
                      onCancel: () => Navigator.pop(context),
                      mediaCount: MediaCount.single,
                      mediaType: MediaType.image,
                      decoration: PickerDecoration(
                        cancelIcon: const Icon(Icons.close),
                        albumTitleStyle: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                        actionBarPosition: ActionBarPosition.top,
                        blurStrength: 2,
                        completeText: 'Change',
                      ),
                    )),
              ));
        }).then((_) async {
      if (mediaList.isNotEmpty) {
        double mediaSize =
            mediaList.first.file!.readAsBytesSync().lengthInBytes /
                (1024 * 1024);

        if (mediaSize < 1.0001) {
          final image = await FirebaseStorage.instance
              .ref(
                  'userData/profilePics/${FirebaseAuth.instance.currentUser!.uid}')
              .putFile(mediaList.first.file!);

          final url = await image.ref.getDownloadURL();
          await FirebaseFirestore.instance
              .collection('users')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .update({
            'profilePic': url,
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Image should be less than 1 MB')));
        }

        Future.delayed(const Duration(milliseconds: 2000))
            .then((_) => Navigator.pop(context));
      }
    });
  }
}
