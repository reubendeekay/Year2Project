import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/helpers/loading_effect.dart';
import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/providers/post_provider.dart';
import 'package:rent_space/widgets/space_tile.dart';

class ViewAllScreen extends StatelessWidget {
  const ViewAllScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('All Spaces')),
      body: FutureBuilder<List<SpaceModel>>(
        future: Provider.of<PostProvider>(context, listen: false).getSpaces(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return LoadingEffect.getSearchLoadingScreen(context);
          }

          return ListView(
              children: snapshot.data!
                  .map((e) => Container(
                      margin: const EdgeInsets.all(10),
                      child: SpacerTile(space: e)))
                  .toList());
        },
      ),
    );
  }
}
