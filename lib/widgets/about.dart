import 'package:flutter/material.dart';
import 'package:rent_space/models/space_model.dart';

class About extends StatelessWidget {
  const About({Key? key, required this.space}) : super(key: key);
  final SpaceModel space;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About',
            style: Theme.of(context).textTheme.headline1!.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 10),
          Text(
            space.description!,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                  fontSize: 14,
                ),
          )
        ],
      ),
    );
  }
}
