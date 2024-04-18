import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:sensors_plus/sensors_plus.dart';

class SensorsModel extends ChangeNotifier {
  final _streamSubscriptions = <StreamSubscription<dynamic>>[];
  MagnetometerEvent? magnetometerEvent;
  AccelerometerEvent? accelerometerEvent;
  UserAccelerometerEvent? userAccelerometerEvent;
  double phonePitch = 0;
  double movementSpeed = 0;
  double azimuth = 0;
  bool phoneIsLayingFlat = true;

  void initSensors(Function onError) {
    phonePitch = 0;
    movementSpeed = 0;
    azimuth = 0;
    _streamSubscriptions.add(magnetometerEventStream().listen(
      (event) {
        magnetometerEvent = event;
        if (accelerometerEvent != null) {
          // obliczenie aktualnego azymutu na podstawie danych z magnetometer i akcelerometra
          var roll = atan2(accelerometerEvent!.y, accelerometerEvent!.z);
          var pitch = atan(-accelerometerEvent!.x /
              (accelerometerEvent!.y * sin(roll) +
                  accelerometerEvent!.z * cos(roll)));

          var yaw = atan2(
              (event.z) * sin(roll) - (event.y) * cos(roll),
              (event.x) * cos(pitch) +
                  (event.y) * sin(pitch) * sin(roll) +
                  (event.z) * sin(pitch) * cos(roll));
          if (yaw < 0) {
            yaw += 2 * pi;
          }
          yaw = yaw + pi / 2;
          var azimuthDegrees = yaw * 180 / pi;
          azimuthDegrees = (azimuthDegrees + 360) % 360;
          azimuthDegrees = 360 - azimuthDegrees;
          var lastAzimuth = azimuth;
          if ((azimuthDegrees - lastAzimuth).abs() > 5) {
            azimuth = azimuthDegrees;

            notifyListeners();
          }
        }
      },
      onError: (error) {
        onError();
      },
      cancelOnError: true,
    ));

    _streamSubscriptions.add(
      userAccelerometerEventStream().listen(
        (event) {
          userAccelerometerEvent = event;
          double accelerometerValue = 0;
          if (phoneIsLayingFlat) {
            accelerometerValue = event.y;
          } else {
            accelerometerValue = event.z;
          }

          if (accelerometerValue.abs() > 0.08) {
            movementSpeed = (accelerometerValue.abs());
            notifyListeners();
          } else if (movementSpeed != 0) {
            movementSpeed = 0;
            notifyListeners();
          }
        },
        onError: (error) {
          onError();
        },
        cancelOnError: true,
      ),
    );

    _streamSubscriptions.add(
      accelerometerEventStream().listen(
        (event) {
          accelerometerEvent = event;

          //sprawdzenie czy telefon jest równolegle do podłoża, wtedy przy akcelometrze bierzemy wartość y lub z
          var g = [event.x, event.y, event.z];
          double normOfg = sqrt(g[0] * g[0] + g[1] * g[1] + g[2] * g[2]);

          g[0] = g[0] / normOfg;
          g[1] = g[1] / normOfg;
          g[2] = g[2] / normOfg;

          double inclination = radianToDeg(acos(g[2]));
          if (inclination < 45 || inclination > 155) {
            phoneIsLayingFlat = true;
          } else {
            phoneIsLayingFlat = false;
          }
        },
        onError: (error) {
          onError();
        },
        cancelOnError: true,
      ),
    );
    _streamSubscriptions.add(
      gyroscopeEventStream(samplingPeriod: Durations.extralong4).listen(
        (event) {
          phonePitch = phonePitch + event.x;
          if (phonePitch.abs() > 2) {
            notifyListeners();
          }
        },
        onError: (error) {
          onError();
        },
        cancelOnError: true,
      ),
    );
  }

  void disposeSensors() {
    for (final subscription in _streamSubscriptions) {
      subscription.cancel();
    }
  }
}
