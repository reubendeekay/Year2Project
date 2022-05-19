import 'package:flutter/material.dart';

import 'package:rent_space/models/space_model.dart';

class ContentIntro extends StatelessWidget {
  final SpaceModel space;

  const ContentIntro({
    Key? key,
    required this.space,
  }) : super(key: key);

  String rentTime() {
    if (space.rentTime == 1) {
      return 'Per Month';
    } else if (space.rentTime == 7) {
      return 'Per Week';
    } else if (space.rentTime == 30) {
      return 'Per Month';
    } else {
      return 'Per Year';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            space.spaceName!,
            style: Theme.of(context).textTheme.headline1!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            space.address!,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 14,
                ),
          ),
          const SizedBox(height: 15),
          Text(
            '500 sqft',
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 14,
                ),
          ),
          const SizedBox(height: 5),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'KES ' + space.price!.toStringAsFixed(0),
                  style: Theme.of(context).textTheme.headline1!.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                TextSpan(
                  text: ' ' + rentTime(),
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
