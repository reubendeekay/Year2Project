import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/helpers/constants.dart';
import 'package:rent_space/providers/auth_provider.dart';

class ChangePassword extends StatefulWidget {
  static const routeName = '/change-password';
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  String? _password;
  String? initialPassword;
  String? confirmPassword;
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    final size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: size.height - MediaQuery.of(context).padding.top,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 15),
                    child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: const Icon(Icons.arrow_back_ios))),
                Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Text(
                    'Change Password',
                    style: GoogleFonts.openSans(
                        fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Divider(
                  thickness: 0.3,
                  height: 2,
                ),
                Container(
                  height: 45,
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200]),
                  child: TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter your current password';
                        }
                        if (val.length < 6) {
                          return 'Password should have atleast 6 characters';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          labelText: 'Current Password',
                          helperStyle: const TextStyle(color: kPrimaryColor),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: kPrimaryColor, width: 1)),
                          border: InputBorder.none),
                      onChanged: (text) => {
                            setState(() {
                              initialPassword = text;
                            })
                          }),
                ),
                Container(
                  height: 45,
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200]),
                  child: TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please enter your new password';
                        }
                        if (val.length < 6) {
                          return 'Password should have atleast 6 characters';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          labelText: 'New Password',
                          helperStyle: TextStyle(color: kPrimaryColor),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1)),
                          border: InputBorder.none),
                      onChanged: (text) => {
                            setState(() {
                              _password = text;
                            })
                          }),
                ),
                Container(
                  height: 45,
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey[200]),
                  child: TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (val.length < 6) {
                          return 'Password should have atleast 6 characters';
                        }

                        return null;
                      },
                      decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 15),
                          labelText: 'Confirm New Password',
                          helperStyle: TextStyle(color: kPrimaryColor),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  BorderSide(color: kPrimaryColor, width: 1)),
                          border: InputBorder.none),
                      onChanged: (text) => {
                            setState(() {
                              confirmPassword = text;
                            })
                          }),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 50,
                  ),
                  height: 45,
                  width: double.infinity,
                  child: RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    color: kPrimaryColor,
                    onPressed: () async {
                      if (user!.password == initialPassword) {
                        setState(() {
                          isLoading = true;
                        });

                        await FirebaseAuth.instance.currentUser!
                            .updatePassword(_password!);
                        FirebaseFirestore.instance
                            .collection('users')
                            .doc(user.userId)
                            .update({'password': _password});
                        setState(() {
                          isLoading = false;
                        });
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'Password Changed Successfully. Please login again'),
                        ));
                        Navigator.pop(context);
                      } else if (confirmPassword != _password) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text(
                              'Confirmed password does not match with new password'),
                        ));
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text('Please enter the correct current password'),
                        ));
                      }
                    },
                    child: const Text(
                      'Change Password',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 40,
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
