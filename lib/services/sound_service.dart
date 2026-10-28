import 'dart:js' as js;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class SoundService extends ChangeNotifier {
  static final SoundService _instance = SoundService._internal();
  factory SoundService() => _instance;
  SoundService._internal();

  bool _isMuted = false;
  bool get isMuted => _isMuted;

  void toggleMute() {
    _isMuted = !_isMuted;
    if (kIsWeb) {
      try {
        js.context.callMethod('setPortfolioMuted', [_isMuted]);
      } catch (_) {}
    }
    notifyListeners();
  }

  void playClick() {
    if (_isMuted) return;
    HapticFeedback.selectionClick();
    _triggerSound('click');
  }

  void playPop() {
    if (_isMuted) return;
    HapticFeedback.lightImpact();
    _triggerSound('pop');
  }

  void playChime() {
    if (_isMuted) return;
    HapticFeedback.mediumImpact();
    _triggerSound('chime');
  }

  void playKey() {
    if (_isMuted) return;
    HapticFeedback.selectionClick();
    _triggerSound('key');
  }

  void playSuccess() {
    if (_isMuted) return;
    HapticFeedback.mediumImpact();
    _triggerSound('success');
  }

  void _triggerSound(String type) {
    if (kIsWeb) {
      try {
        js.context.callMethod('playPortfolioSound', [type]);
      } catch (_) {}
    }
  }
}
