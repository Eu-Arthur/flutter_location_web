import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:location_platform_interface/location_platform_interface.dart';

/// Allows assigning a function to be callable from `window.functionName()`
@JS('window.navigator.geolocation.getCurrentPosition')
external String getCurrentPosition(Object obj);

@JS('window.navigator.geolocation.watchPosition')
external String watchPosition(Object obj);

@JS()
@staticInterop
class JSPromise {}

extension JSPromiseExtension on JSPromise {
  external String state;
}

@JS('window.navigator.permissions.query')
external JSPromise query(PermissionDescriptor obj);

@JS()
@anonymous
class PermissionDescriptor {
  external factory PermissionDescriptor({String name});
}

@JS('alert')
external String alert(String obj);

@JS()
@staticInterop
class JSGeoPosition {}

extension JSGeoPositionExtension on JSGeoPosition {
  external JSGeolocationCoordinates coords;
  external String times;
}

@JS()
@staticInterop
class JSEvent {}

extension JSEventExtension on JSEvent {
  external String state;
}

@JS()
@staticInterop
class JSGeolocationCoordinates {}

extension JSGeolocationCoordinatesExtension on JSGeolocationCoordinates {
  external double latitude;
  external double longitude;
  external double altitude;
  external double accuracy;
  external double altitudeAccuracy;
  external double heading;
  external double speed;
}

Future<PermissionStatus> getPermissionLocation() {
  return promiseToFuture(query(PermissionDescriptor(name: 'geolocation')))
      .then((result) {
    switch (result.state) {
      case 'granted':
        return PermissionStatus.authorizedAlways;
      case 'prompt':
        return PermissionStatus.notDetermined;
      case 'denied':
        return PermissionStatus.denied;
      default:
        throw ArgumentError('Unknown permission ${result.state}.');
    }
  });
}
