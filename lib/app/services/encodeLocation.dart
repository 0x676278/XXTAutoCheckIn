import 'dart:convert';

/// 将地址、经纬度转成 URL 编码的 JSON 字符串
String encodeLocation({
  required String address,
  required double latitude,
  required double longitude,
}) {
  // 构建 JSON 对象
  final Map<String, dynamic> data = {
    "result": "1",
    "mockData": {
      "probability": 0
    },
    "address": address,
    "latitude": latitude,
    "longitude": longitude,
    "altitude": 0
  };

  // 转为 JSON 字符串
  final String jsonString = jsonEncode(data);

  // URL 编码
  final String urlEncoded = Uri.encodeComponent(jsonString);

  return urlEncoded;
}

