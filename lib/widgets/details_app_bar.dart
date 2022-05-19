import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/providers/auth_provider.dart';
import 'package:rent_space/providers/wishlist_provider.dart';

class DetailsAppBar extends StatefulWidget {
  final SpaceModel space;

  const DetailsAppBar({
    Key? key,
    required this.space,
  }) : super(key: key);

  @override
  State<DetailsAppBar> createState() => _DetailsAppBarState();
}

class _DetailsAppBarState extends State<DetailsAppBar> {
  _handleNavigateBack(BuildContext context) {
    Navigator.of(context).pop();
  }

  bool isLiked() {
    return Provider.of<AuthProvider>(context, listen: false)
        .user!
        .wishlist!
        .contains(widget.space.id);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 400.0,
              autoPlay: true,
            ),
            items: widget.space.images!.map((i) {
              return Builder(
                builder: (BuildContext context) {
                  return Image.network(
                    widget.space.images!.first,
                    fit: BoxFit.cover,
                    height: double.infinity,
                  );
                },
              );
            }).toList(),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => _handleNavigateBack(context),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await Provider.of<WishlistProvider>(context,
                              listen: false)
                          .addToWishlist(widget.space.id!, isLiked());
                      setState(() {
                        Provider.of<AuthProvider>(context, listen: false)
                            .user!
                            .wishlist!
                            .add(widget.space.id);
                      });
                    },
                    child: Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(5),
                      decoration: const BoxDecoration(
                        color: Colors.grey,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isLiked() ? Icons.favorite : Icons.favorite_border,
                        color: isLiked() ? Colors.red : Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
