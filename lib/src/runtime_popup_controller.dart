import 'package:flutter/foundation.dart';

import 'runtime_popup_api_clients.dart';
import 'runtime_popup_models.dart';

class PopupController extends ChangeNotifier {
  final PopupApiClient apiClient;

  RuntimePopupModel? _popup;
  bool _isLoading = false;

  PopupController({
    required this.apiClient,
  });

  RuntimePopupModel? get popup => _popup;

  bool get isLoading => _isLoading;

  bool get shouldShowPopup {
    return _popup?.show == true;
  }

  Future<void> loadPopup({
    required String appId,
    required String appVersion,
    String? platform,
  }) async {
    if (_isLoading) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    final result = await apiClient.fetchPopup(
      appId: appId,
      appVersion: appVersion,
      platform: platform,
    );

    _popup = result;

    _isLoading = false;
    notifyListeners();
  }

  void clearPopup() {
    _popup = null;
    notifyListeners();
  }
}
