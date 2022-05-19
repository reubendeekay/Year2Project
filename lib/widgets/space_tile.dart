import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:rent_space/helpers/constants.dart';
import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/screens/details/details.dart';
import 'package:rent_space/screens/landlord/edit_space_screen.dart';
import 'package:rent_space/widgets/circle_icon_button.dart';

class SpacerTile extends StatelessWidget {
  const SpacerTile({Key? key, required this.space, this.isOwner = false})
      : super(key: key);
  final SpaceModel space;
  final bool isOwner;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        Get.to(() => isOwner
            ? EditSpaceScreen(space: space)
            : Details(
                space: space,
              ));
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
                      style: Theme.of(context).textTheme.headline1!.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      space.address!,
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontSize: 12,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'KES ' + space.price!.toStringAsFixed(0),
                      style:
                          const TextStyle(fontSize: 14, color: kPrimaryColor),
                    )
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
    );
  }
}
