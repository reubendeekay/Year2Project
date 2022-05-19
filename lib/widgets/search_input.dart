import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:rent_space/screens/search/search_screen.dart';

class SearchInput extends StatelessWidget {
  const SearchInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => const SearchScreen());
      },
      child: Hero(
        tag: 'textfield',
        transitionOnUserGestures: true,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Card(
            elevation: 0,
            color: Colors.transparent,
            child: TextField(
              enabled: false,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Search here...',
                prefixIcon: Container(
                  padding: const EdgeInsets.all(15),
                  child: SvgPicture.asset('assets/icons/search.svg'),
                ),
                contentPadding: const EdgeInsets.all(2),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
