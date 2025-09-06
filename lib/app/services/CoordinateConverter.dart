import 'dart:math';

class CoordinateConverter {
  static const double pi = 3.1415926535897932384626;
  static const double xPi = pi * 3000.0 / 180.0;

  /// WGS84 → GCJ-02
  static Map<String, double> wgs84ToGcj02(double lat, double lon) {
    if (_outOfChina(lat, lon)) {
      return {'lat': lat, 'lon': lon};
    }
    double dLat = _transformLat(lon - 105.0, lat - 35.0);
    double dLon = _transformLon(lon - 105.0, lat - 35.0);
    double radLat = lat / 180.0 * pi;
    double magic = sin(radLat);
    magic = 1 - 0.00669342162296594323 * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((6378245.0 * (1 - 0.00669342162296594323)) / (magic * sqrtMagic) * pi);
    dLon = (dLon * 180.0) / (6378245.0 / sqrtMagic * cos(radLat) * pi);
    double mgLat = lat + dLat;
    double mgLon = lon + dLon;
    return {'lat': mgLat, 'lon': mgLon};
  }

  /// GCJ-02 → BD-09
  static Map<String, double> gcj02ToBd09(double lat, double lon) {
    double z = sqrt(lon * lon + lat * lat) + 0.00002 * sin(lat * xPi);
    double theta = atan2(lat, lon) + 0.000003 * cos(lon * xPi);
    double bdLon = z * cos(theta) + 0.0065;
    double bdLat = z * sin(theta) + 0.006;
    return {'lat': bdLat, 'lon': bdLon};
  }

  /// WGS84 → BD-09
  static Map<String, double> wgs84ToBd09(double lat, double lon) {
    var gcj = wgs84ToGcj02(lat, lon);
    return gcj02ToBd09(gcj['lat']!, gcj['lon']!);
  }

  static bool _outOfChina(double lat, double lon) {
    if (lon < 72.004 || lon > 137.8347) return true;
    if (lat < 0.8293 || lat > 55.8271) return true;
    return false;
  }

  static double _transformLat(double x, double y) {
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(x.abs());
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * pi) + 40.0 * sin(y / 3.0 * pi)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * pi) + 320 * sin(y * pi / 30.0)) * 2.0 / 3.0;
    return ret;
  }

  static double _transformLon(double x, double y) {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(x.abs());
    ret += (20.0 * sin(6.0 * x * pi) + 20.0 * sin(2.0 * x * pi)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * pi) + 40.0 * sin(x / 3.0 * pi)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * pi) + 300.0 * sin(x / 30.0 * pi)) * 2.0 / 3.0;
    return ret;
  }
}
