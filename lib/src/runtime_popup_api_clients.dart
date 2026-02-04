import 'dart:convert';

import 'package:http/http.dart' as http;

import 'runtime_popup_models.dart';


class PopupApiClient {
  final String endpoint;
  final Duration timeout;

  PopupApiClient({
    required this.endpoint,
    this.timeout = const Duration(seconds: 5),
  });

  Future<RuntimePopupModel?> fetchPopup({
    required String appId,
    required String appVersion,
    String? platform,
  }) async {
    try {
      final uri = Uri.parse(endpoint).replace(
        queryParameters: {
          'app_id': appId,
          'version': appVersion,
          'platform': ?platform,
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(timeout);

      if (response.statusCode != 200) {
        return null;
      }

      final Map<String, dynamic> data =
          json.decode(response.body) as Map<String, dynamic>;

      return RuntimePopupModel.fromJson(data);
    } catch (_) {
      return null;
    }
  }
}
