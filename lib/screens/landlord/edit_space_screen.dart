import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:media_picker_widget/media_picker_widget.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/helpers/constants.dart';
import 'package:rent_space/helpers/my_dropdown.dart';
import 'package:rent_space/helpers/my_loader.dart';
import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/providers/post_provider.dart';
import 'package:rent_space/screens/landlord/widgets/add_on_map.dart';

class EditSpaceScreen extends StatefulWidget {
  const EditSpaceScreen({Key? key, required this.space}) : super(key: key);
  final SpaceModel space;

  @override
  _EditSpaceScreenState createState() => _EditSpaceScreenState();
}

class _EditSpaceScreenState extends State<EditSpaceScreen> {
  LatLng? propertyLocation;
  File? coverImage;
  List<File> imageFiles = [];
  List<Media> mediaList = [];
  bool isLoading = false;
  final formKey = GlobalKey<FormState>();

  String? ownerId;
  String? type;
  String? name;
  String? description;
  String? address;
  String? price;
  String? beds;
  String? baths;
  String? area;
  String? floors;
  String? category;
  String? rentTime;
  String? rentRate;

  List<String> options = [
    'House',
    'Office',
    'Conference Room',
    'Fun',
    'Utility',
    'Shelf',
  ];

  List<String> rates = [
    'Daily',
    'Weekly',
    'Monthly',
    'Yearly',
  ];

  int getRate() {
    if (rentRate == 'Daily') {
      return 1;
    } else if (rentRate == 'Weekly') {
      return 7;
    } else if (rentRate == 'Monthly') {
      return 30;
    } else if (rentRate == 'Yearly') {
      return 365;
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Add a Listing"),
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 10, left: 15, right: 15),
          children: <Widget>[
            const Text("Space Information",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0,
                    color: Colors.black)),
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(top: 16),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          name = val;
                        });
                      },
                      initialValue: widget.space.spaceName,
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please enter a name";
                        }
                        return null;
                      },
                      style: const TextStyle(
                          letterSpacing: 0, fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                        labelText: "Space Name",
                        labelStyle: TextStyle(
                            fontSize: 14,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Color(0xfff0f0f0),
                        prefixIcon: Icon(
                          Icons.person,
                          size: 22,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          description = val;
                        });
                      },
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please enter the space description";
                        }
                        return null;
                      },
                      initialValue: widget.space.description,
                      style: const TextStyle(
                          letterSpacing: 0, fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                        labelText: "Description",
                        labelStyle: TextStyle(
                            fontSize: 14,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Color(0xfff0f0f0),
                        prefixIcon: Icon(
                          Icons.more_vert,
                          size: 22,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.all(0),
                      ),
                    ),
                  ),
                  MyDropDown(
                    selectedOption: (val) {
                      setState(() {
                        category = val;
                      });
                    },
                    hintText: "Space Category",
                    options: options,
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 12),
                    child: TextFormField(
                      onChanged: (val) {
                        setState(() {
                          price = val;
                        });
                      },
                      initialValue: widget.space.price!.toStringAsFixed(0),
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Please enter the price";
                        }
                        return null;
                      },
                      style: const TextStyle(
                          letterSpacing: 0, fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                        labelText: "Price",
                        labelStyle: TextStyle(
                            fontSize: 14,
                            letterSpacing: 0,
                            fontWeight: FontWeight.w500),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(4),
                            ),
                            borderSide: BorderSide.none),
                        filled: true,
                        fillColor: Color(0xfff0f0f0),
                        prefixIcon: Icon(
                          Icons.sell_outlined,
                          size: 22,
                        ),
                        isDense: true,
                        contentPadding: EdgeInsets.all(0),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 24),
              child: const Text("More",
                  style:
                      TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0)),
            ),

            MyDropDown(
              selectedOption: (val) {
                setState(() {
                  rentRate = val;
                });
              },
              hintText: "Rent rate",
              options: rates,
            ),
            Container(
              margin: const EdgeInsets.only(top: 0),
              child: TextFormField(
                onChanged: (val) {
                  setState(() {
                    address = val;
                  });
                },
                validator: (val) {
                  if (val!.isEmpty) {
                    return "Please enter the space address";
                  }
                  return null;
                },
                initialValue: widget.space.address,
                style: const TextStyle(
                    letterSpacing: 0, fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                  labelText: "Space Address",
                  labelStyle: TextStyle(
                      fontSize: 14,
                      letterSpacing: 0,
                      fontWeight: FontWeight.w500),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                      borderSide: BorderSide.none),
                  filled: true,
                  fillColor: Color(0xfff0f0f0),
                  prefixIcon: Icon(Icons.location_on_outlined),
                  isDense: true,
                  contentPadding: EdgeInsets.all(0),
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            InkWell(
              onTap: () {
                Get.to(() => AddOnMap(
                      onChanged: (val) {
                        setState(() {
                          propertyLocation = val;
                        });
                      },
                    ));
              },
              child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                          backgroundColor: kPrimaryColor.withOpacity(0.2),
                          child: const Icon(
                            Icons.location_on_outlined,
                            color: kPrimaryColor,
                          )),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text('Location on Map'),
                      const Spacer(),
                      Icon(
                        Icons.check_circle,
                        color: propertyLocation == null
                            ? Colors.grey[400]
                            : kPrimaryColor,
                      )
                    ],
                  )),
            ),
            Container(
              margin: const EdgeInsets.only(top: 24, bottom: 0),
              child: const Text("Photos",
                  style:
                      TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0)),
            ),
            // InkWell(
            //   onTap: () {
            //     openImagePicker(context, true);
            //   },
            //   child: Container(
            //       margin: const EdgeInsets.only(top: 12),
            //       child: Row(
            //         children: [
            //           CircleAvatar(
            //               backgroundColor: Colors.grey[400],
            //               child: const Icon(Icons.camera_alt_outlined)),
            //           const SizedBox(
            //             width: 10,
            //           ),
            //           const Text('Cover Image'),
            //           const Spacer(),
            //           Icon(
            //             Icons.check_circle,
            //             color: coverImage == null
            //                 ? Colors.grey[400]
            //                 : Colors.green,
            //           )
            //         ],
            //       )),
            // ),
            const SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      openImagePicker(context, false);
                    },
                    child: Container(
                        padding: const EdgeInsets.all(20),
                        color: kPrimaryColor.withOpacity(0.2),
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          color: kPrimaryColor,
                        )),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  ...List.generate(
                      imageFiles.length,
                      (index) => Stack(
                            clipBehavior: Clip.none,
                            children: [
                              SizedBox(
                                height: 80,
                                width: 80,
                                child: Image.file(
                                  imageFiles[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                  top: -5,
                                  right: -5,
                                  child: GestureDetector(
                                    onTap: () {
                                      imageFiles.remove(imageFiles[index]);
                                      setState(() {});
                                    },
                                    child: const Icon(Icons.cancel,
                                        color: Colors.pinkAccent),
                                  ))
                            ],
                          ))
                ],
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 24),
              child: RaisedButton.icon(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
                label: const Text(
                  "Delete Space",
                  style: TextStyle(color: Colors.white),
                ),
                color: Colors.red,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Delete Space"),
                        content: const Text(
                            "Are you sure you want to delete this space?"),
                        actions: [
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text("Cancel"),
                          ),
                          FlatButton(
                            onPressed: () async {
                              await Provider.of<PostProvider>(context,
                                      listen: false)
                                  .deleteSpace(widget.space.id!);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: const Text("Delete"),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 10),
              child: Center(
                child: Container(
                  height: 45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey[400]!,
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      final space = SpaceModel(
                        spaceName: name ?? widget.space.spaceName,
                        id: widget.space.id,
                        images: widget.space.images,
                        description: description ?? widget.space.description,
                        price: price != null
                            ? double.parse(price!)
                            : widget.space.price,
                        address: address ?? widget.space.address,
                        location: propertyLocation != null
                            ? GeoPoint(propertyLocation!.latitude,
                                propertyLocation!.longitude)
                            : widget.space.location,
                        imageFiles: imageFiles,
                        ownerId: FirebaseAuth.instance.currentUser!.uid,
                        category: category ?? widget.space.category,
                        size: area ?? widget.space.size,
                        features: {
                          'beds': beds,
                          'baths': baths,
                          'floors': floors,
                          'area': area,
                        },
                        rentTime: rentRate != null
                            ? getRate()
                            : widget.space.rentTime,
                      );

                      await Provider.of<PostProvider>(context, listen: false)
                          .editSpace(space);

                      setState(() {
                        isLoading = false;
                      });
                      Navigator.of(context).pop();
                    },
                    child: isLoading
                        ? const MyLoader()
                        : const Text("Save Changes",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                    style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          kPrimaryColor,
                        ),
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 16))),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ));
  }

  Future<void> openImagePicker(
    BuildContext context,
    bool isCover,
  ) async {
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

                        if (isCover) {
                          coverImage = mediaList.first.file;
                          mediaList.clear();
                        }

                        if (!isCover) {
                          for (var element in mediaList) {
                            imageFiles.add(element.file!);
                          }
                          mediaList.clear();
                        }

                        mediaList.clear();

                        Navigator.pop(context);
                      },
                      onCancel: () => Navigator.pop(context),
                      mediaCount:
                          isCover ? MediaCount.single : MediaCount.multiple,
                      mediaType: MediaType.image,
                      decoration: PickerDecoration(
                        cancelIcon: const Icon(Icons.close),
                        albumTitleStyle: TextStyle(
                            color: Theme.of(context).iconTheme.color,
                            fontWeight: FontWeight.bold),
                        actionBarPosition: ActionBarPosition.top,
                        blurStrength: 2,
                        completeButtonStyle: const ButtonStyle(),
                        completeTextStyle:
                            TextStyle(color: Theme.of(context).iconTheme.color),
                        completeText: 'Select',
                      ),
                    )),
              ));
        });
  }
}
