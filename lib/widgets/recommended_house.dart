import 'package:flutter/material.dart';
import 'package:rent_space/helpers/constants.dart';

import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/screens/details/details.dart';
import 'package:rent_space/widgets/circle_icon_button.dart';

class RecommendedHouse extends StatelessWidget {
  RecommendedHouse({Key? key, required this.spaces}) : super(key: key);
  final List<SpaceModel> spaces;

  _handleNavigateToDetails(BuildContext context, SpaceModel space) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Details(space: space),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: SizedBox(
        height: 340,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) => GestureDetector(
            onTap: () => _handleNavigateToDetails(context, spaces[index]),
            child: Container(
              height: 300,
              width: 230,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                          spaces[index].images!.first,
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: 15,
                    top: 15,
                    child: CircleIconButton(
                      iconUrl: 'assets/icons/mark.svg',
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.white54,
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                spaces[index].spaceName!,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1!
                                    .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                spaces[index].address!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      fontSize: 12,
                                    ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(
                                'KES ' + spaces[index].price!.toString(),
                                style: const TextStyle(
                                    color: kPrimaryColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          separatorBuilder: (_, index) => const SizedBox(width: 20),
          itemCount: spaces.length,
        ),
      ),
    );
  }
}
