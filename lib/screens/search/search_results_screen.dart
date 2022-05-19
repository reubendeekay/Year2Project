import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/route_manager.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/helpers/loading_effect.dart';
import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/providers/post_provider.dart';
import 'package:rent_space/screens/search/search_screen.dart';
import 'package:rent_space/widgets/space_tile.dart';

class SearchResultsScreen extends StatelessWidget {
  SearchResultsScreen({Key? key, required this.searchText}) : super(key: key);
  final String searchText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6F6),
      body: SafeArea(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GestureDetector(
            onTap: () {
              Get.to(() => const SearchScreen());
            },
            child: Hero(
              tag: 'textfield',
              transitionOnUserGestures: true,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  enabled: false,
                  initialValue: searchText,
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
          Expanded(
            child: FutureBuilder<List<SpaceModel>>(
              future: Provider.of<PostProvider>(context, listen: false)
                  .searchSpaces(searchText),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return LoadingEffect.getSearchLoadingScreen(context);
                }

                return ListView(
                    shrinkWrap: true,
                    children: snapshot.data!
                        .map((e) => Container(
                            margin: const EdgeInsets.all(10),
                            child: SpacerTile(space: e)))
                        .toList());
              },
            ),
          )
        ]),
      ),
    );
  }
}
