import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

const iosStoreId = String.fromEnvironment(
  'IOS_APP_STORE_ID',
  defaultValue: '',
);
Uri privacyUri() => Uri.https('eunoialab.io', '/privacy/ghostmark');

Uri feedbackUri() => Uri.https(
      'docs.google.com',
      '/forms/d/e/1FAIpQLScB-jMiFv_NgujQtqPCO-6V4h1DnO69DR7l6K47RzpVjSvCYA/viewform',
      {'usp': 'pp_url', 'entry.2007142099': 'GhostMark'},
    );

Uri? ratingUri(TargetPlatform platform, {String appStoreId = iosStoreId}) {
  if (platform == TargetPlatform.iOS) {
    if (!RegExp(r'^\d+$').hasMatch(appStoreId)) return null;
    return Uri.https('apps.apple.com', '/app/id$appStoreId', {
      'action': 'write-review',
    });
  }
  if (platform == TargetPlatform.android || kIsWeb) {
    return Uri.https('play.google.com', '/store/apps/details', {
      'id': 'com.eunoia.ghost_mark',
    });
  }
  return null;
}

class FeedbackController extends ChangeNotifier {
  FeedbackController(
    this.preferences, {
    DateTime Function()? clock,
    Future<bool> Function(Uri)? open,
  })  : _clock = clock ?? DateTime.now,
        _open = open ?? launch;

  static const firstUseKey = 'ghostmark.feedback-first-use.v1';
  static const dismissedKey = 'ghostmark.feedback-dismissed.v1';
  final SharedPreferences preferences;
  final DateTime Function() _clock;
  final Future<bool> Function(Uri) _open;
  DateTime? _firstUse;
  bool _disposed = false;
  bool _dismissed = false;

  static Future<bool> launch(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);

  Future<void> initialize() async {
    try {
      _dismissed = preferences.getBool(dismissedKey) == true;
      _firstUse = DateTime.tryParse(preferences.getString(firstUseKey) ?? '');
      if (_firstUse == null) {
        final now = _clock();
        final day = DateTime(now.year, now.month, now.day);
        if (!await preferences.setString(firstUseKey, day.toIso8601String())) {
          return;
        }
        _firstUse = day;
      }
      if (!_disposed) notifyListeners();
    } catch (_) {
      // Optional invitation storage must never interrupt reading or menu access.
      _firstUse = null;
    }
  }

  bool get showPrompt {
    final first = _firstUse;
    if (first == null || _dismissed) {
      return false;
    }
    final eligible = DateTime(first.year, first.month, first.day + 14);
    return !_clock().isBefore(eligible);
  }

  Future<void> dismiss() async {
    _dismissed = true;
    if (!_disposed) notifyListeners();
    if (!await preferences.setBool(dismissedKey, true)) {
      throw StateError('Could not save feedback preference');
    }
    if (!_disposed) notifyListeners();
  }

  Future<void> open(Uri uri, {bool dismissInvitation = true}) async {
    if (!await _open(uri)) throw StateError('Could not open destination');
    if (dismissInvitation) await dismiss();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
