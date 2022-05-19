import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:rent_space/screens/search/search_results_screen.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F6),
      body: ListView(
        children: [
          Hero(
            tag: 'textfield',
            transitionOnUserGestures: true,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: TextFormField(
                onFieldSubmitted: (val) {
                  Get.off(() => SearchResultsScreen(searchText: val));
                },
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
          const SizedBox(
            height: 10,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: const Text('Recent Searches',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            alignment: Alignment.centerLeft,
            child: Image.asset(
              'assets/images/accent.png',
              width: 99,
              height: 4,
            ),
          ),
          ...List.generate(
              4,
              (index) => const ListTile(
                  leading: Icon(Icons.search),
                  title: Text('Best apartment in the city'),
                  trailing: Icon(
                    Icons.north_west,
                  )))
        ],
      ),
    );
  }
}
