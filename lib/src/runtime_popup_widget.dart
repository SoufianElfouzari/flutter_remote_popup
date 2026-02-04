import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'runtime_popup_controller.dart';
import 'runtime_popup_models.dart';

class PopupOverlay extends StatefulWidget {
  final PopupController controller;

  const PopupOverlay({
    super.key,
    required this.controller,
  });

  @override
  State<PopupOverlay> createState() => _PopupOverlayState();
}

class _PopupOverlayState extends State<PopupOverlay> {
  bool _dialogShown = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted) {
      return;
    }

    if (widget.controller.shouldShowPopup && !_dialogShown) {
      _dialogShown = true;
      _showDialog(widget.controller.popup);
    }
  }

  Future<void> _showDialog(RuntimePopupModel? popup) async {
    if (popup == null) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: !popup.force,
      builder: (context) {
        return AlertDialog(
          title: popup.title != null ? Text(popup.title!) : null,
          content: popup.message != null ? Text(popup.message!) : null,
          actions: _buildActions(popup),
        );
      },
    );

    widget.controller.clearPopup();
    _dialogShown = false;
  }

  List<Widget> _buildActions(RuntimePopupModel popup) {
    final actions = <Widget>[];

    if (!popup.force) {
      actions.add(
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      );
    }

    if (popup.action == 'reload') {
      actions.add(
        TextButton(
          onPressed: () {
            _handleReload();
          },
          child: const Text('Reload'),
        ),
      );
    }

    return actions;
  }

  void _handleReload() {
    if (kIsWeb) {
      Navigator.of(context).pop();
      return;
    }

    if (Platform.isAndroid || Platform.isIOS) {
      Navigator.of(context).pop();
      return;
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
