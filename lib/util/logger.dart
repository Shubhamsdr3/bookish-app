import 'dart:async';

import 'package:flutter/foundation.dart';

/// Runs [body] so every [print] in that zone uses one callback.
///
/// Release builds drop the line. [debugPrint] calls [print], so this
/// callback must use [parent.print] or the zone calls itself.
R runZoneGuard<R>(R Function() body) {
  return runZoned(
    body,
    zoneSpecification: ZoneSpecification(
      print: (self, parent, zone, line) {
        if (kReleaseMode) {
          return;
        }
        parent.print(zone, line);
      },
    ),
  );
}