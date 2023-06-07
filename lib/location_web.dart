import 'dart:ui' show Color;
import 'package:js/js.dart';
import 'package:location_platform_interface/location_platform_interface.dart';
import 'package:location_web/JSLocation.dart';


/// The Web implementation of [LocationPlatform].
class LocationWeb extends LocationPlatform {
  /// The Web implementation of [LocationPlatform].
  LocationWeb();

  LocationAccuracy? _accuracy;

  /// Registers this class as the default instance of [LocationPlatform]
  static void registerWith([Object? registrar]) {
    LocationPlatform.instance = LocationWeb();
  }

  @override
  Future<LocationData?> getLocation({LocationSettings? settings}) async {
    final List<LocationData> reference = [];
    getCurrentPosition(
      allowInterop((JSGeoPosition result) {
        reference.add(LocationData(
            latitude: result.coords.latitude.toDouble(),
            longitude: result.coords.longitude.toDouble(),
            bearing: result.coords.heading.toDouble(),
            altitude: result.coords.altitude.toDouble(),
            speed: result.coords.speed.toDouble(),
            accuracy: result.coords.accuracy.toDouble(),
            verticalAccuracy: result.coords.altitudeAccuracy.toDouble(),
            time: double.parse(result.times)));
      }),
    );
    return Future.doWhile(() => reference.isEmpty).then((value) {
      return reference.first;
    });
  }

  @override
  Stream<LocationData?> onLocationChanged({bool inBackground = false}) {
    final List<LocationData?> reference = [];
    final List<bool> blocked = [];
    getCurrentPosition(
      allowInterop((JSGeoPosition result) {
        reference.add(LocationData(
            latitude: result.coords.latitude.toDouble(),
            longitude: result.coords.longitude.toDouble(),
            bearing: result.coords.heading.toDouble(),
            altitude: result.coords.altitude.toDouble(),
            speed: result.coords.speed.toDouble(),
            accuracy: result.coords.accuracy.toDouble(),
            verticalAccuracy: result.coords.altitudeAccuracy.toDouble(),
            time: double.parse(result.times)));
        blocked.add(false);
      }),
    );
    return Stream.fromFuture(
      Future.doWhile(() => blocked.isEmpty).then((value) {
        return reference.first;
      }),
    );
  }

  @override
  Future<PermissionStatus?> getPermissionStatus() async {
    return getPermissionLocation();
  }

  @override
  Future<bool?> isGPSEnabled() async {
    return true;
  }

  @override
  Future<bool?> isNetworkEnabled() async {
    return true;
  }

  @override
  Future<PermissionStatus?> requestPermission() async {
    try {
      await getLocation(settings: LocationSettings());
      return PermissionStatus.authorizedAlways;
    } catch (e) {
      return PermissionStatus.denied;
    }
  }

  @override
  Future<bool?> setLocationSettings(LocationSettings settings) async {
    _accuracy = settings.accuracy;
    return true;
  }

  @override
  Future<bool> updateBackgroundNotification({
    String? channelName,
    String? title,
    String? iconName,
    String? subtitle,
    String? description,
    Color? color,
    bool? onTapBringToFront,
  }) async {
    return true;
  }
}
