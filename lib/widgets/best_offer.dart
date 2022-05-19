import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:rent_space/helpers/constants.dart';

import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/screens/details/details.dart';
import 'package:rent_space/screens/home/view_all_screen.dart';
import 'package:rent_space/widgets/circle_icon_button.dart';

class BestOffer extends StatelessWidget {
  BestOffer({Key? key, required this.spaces}) : super(key: key);
  final List<SpaceModel> spaces;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Best Offer',
                style: Theme.of(context).textTheme.headline1!.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              InkWell(
                onTap: () {
                  Get.to(() => const ViewAllScreen());
                },
                child: Text(
                  'See All',
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 14,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ...spaces
              .map(
                (space) => GestureDetector(
                  onTap: () {
                    Get.to(() => Details(space: space));
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Stack(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: size.width * 0.25,
                              height: 80,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: NetworkImage(space.images!.first),
                                  fit: BoxFit.cover,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            const SizedBox(width: 15),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  space.spaceName!,
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
                                  space.address!,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1!
                                      .copyWith(
                                        fontSize: 12,
                                      ),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'KES ' + space.price.toString(),
                                  style: const TextStyle(
                                      color: kPrimaryColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const Positioned(
                            right: 0,
                            child: CircleIconButton(
                              iconUrl: 'assets/icons/heart.svg',
                              color: Colors.grey,
                            ))
                      ],
                    ),
                  ),
                ),
              )
              .toList(),
        ],
      ),
    );
  }
}
