import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker_icon/marker_icon.dart';
import 'package:rent_space/helpers/constants.dart';

class SpaceLocation extends StatefulWidget {
  final LatLng? location;
  final String? imageUrl;
  const SpaceLocation({Key? key, this.location, this.imageUrl})
      : super(key: key);
  @override
  _SpaceLocationState createState() => _SpaceLocationState();
}

class _SpaceLocationState extends State<SpaceLocation> {
  final GlobalKey globalKey = GlobalKey();
  GoogleMapController? mapController;
  Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) async {
    _markers.add(Marker(
      markerId: const MarkerId('1'),
      icon: await MarkerIcon.downloadResizePictureCircle(
          widget.imageUrl ??
              'https://www.kenyans.co.ke/files/styles/article_style/public/images/media/Mechanic.jpg?itok=-c2o5ygc',
          borderSize: 10,
          size: 130,
          addBorder: true,
          borderColor: kPrimaryColor),
      position: LatLng(widget.location!.latitude, widget.location!.longitude),
    ));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: 10,
        ),
        AspectRatio(
          aspectRatio: 16 / 9,
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.grey,
                  width: 1,
                )),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Stack(
                children: [
                  GoogleMap(
                    myLocationEnabled: true,
                    onMapCreated: _onMapCreated,
                    markers: _markers,
                    initialCameraPosition: CameraPosition(
                        target: LatLng(widget.location!.latitude,
                            widget.location!.longitude),
                        zoom: 13),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
