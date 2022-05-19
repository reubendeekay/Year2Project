import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:marker_icon/marker_icon.dart';
import 'package:provider/provider.dart';
import 'package:rent_space/helpers/constants.dart';
import 'package:rent_space/models/space_model.dart';
import 'package:rent_space/providers/location_provider.dart';
import 'package:rent_space/providers/post_provider.dart';
import 'package:rent_space/screens/details/details.dart';

class MapsScreen extends StatefulWidget {
  const MapsScreen({Key? key}) : super(key: key);

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  GoogleMapController? mapController;

  Set<Marker> _markers = <Marker>{};
  void _onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    mapController!.setMapStyle(value);

    final size = MediaQuery.of(context).size;

    final spaces =
        await Provider.of<PostProvider>(context, listen: false).getSpaces();

    //for loop to map markers in different locations
    for (SpaceModel space in spaces) {
      _markers.add(
        Marker(
          markerId: MarkerId(space.id!),
          onTap: () {
            Get.to(() => Details(space: space));
          },
          //circle to show the mechanic profile in map
          icon: await MarkerIcon.downloadResizePictureCircle(
              space.images!.first,
              size: (size.height * .13).toInt(),
              borderSize: 10,
              addBorder: true,
              borderColor: kPrimaryColor),
          position: LatLng(space.location!.latitude, space.location!.longitude),
        ),
      );
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LocationProvider>(context, listen: false).getCurrentLocation();
    var _locationData = Provider.of<LocationProvider>(
      context,
    ).locationData;

    return SafeArea(
      child: Stack(
        children: [
          GoogleMap(
            markers: _markers,
            onMapCreated: _onMapCreated,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: true,
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
                target:
                    LatLng(_locationData!.latitude!, _locationData.longitude!),
                zoom: 15),
          ),
          Positioned(
            top: 15,
            right: 15,
            left: 15,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: TextFormField(
                  textAlignVertical: TextAlignVertical.center,
                  onFieldSubmitted: (val) async {
                    final spaces =
                        await Provider.of<PostProvider>(context, listen: false)
                            .searchSpaces(val);

                    mapController!.animateCamera(
                      CameraUpdate.newCameraPosition(
                        CameraPosition(
                          target: LatLng(spaces.first.location!.latitude,
                              spaces.first.location!.longitude),
                          zoom: 18,
                        ),
                      ),
                    );
                  },
                  decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 15),
                      border: InputBorder.none,
                      fillColor: Colors.white,
                      filled: true,
                      prefixIcon: Icon(
                        Icons.location_on_outlined,
                        size: 16,
                        color: kPrimaryColor,
                      ),
                      suffixIcon: Icon(
                        Icons.search,
                      ),
                      hintText: 'Search location',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ))),
            ),
          )
        ],
      ),
    );
  }
}
