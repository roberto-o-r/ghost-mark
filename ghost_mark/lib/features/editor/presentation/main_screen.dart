import 'package:flutter/material.dart';
import 'package:ghost_mark/features/editor/presentation/editor_screen.dart';
import 'package:ghost_mark/features/preview/presentation/preview_screen.dart';
import 'package:ghost_mark/features/feedback/feedback.dart';
import 'package:ghost_mark/shared/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key, this.feedback});
  final FeedbackController? feedback;
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  FeedbackController? feedback;
  @override
  void initState() {
    super.initState();
    initializeFeedback();
  }

  Future<void> initializeFeedback() async {
    try {
      final value = widget.feedback ??
          FeedbackController(await SharedPreferences.getInstance());
      if (!mounted) {
        if (widget.feedback == null) value.dispose();
        return;
      }
      feedback = value;
      value.addListener(refresh);
      await value.initialize();
      refresh();
    } catch (_) {/* Optional feedback never blocks writing. */}
  }

  void refresh() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    feedback?.removeListener(refresh);
    if (widget.feedback == null) feedback?.dispose();
    super.dispose();
  }

  Future<void> openLink(Uri uri, {bool dismissInvitation = true}) async {
    try {
      final value = feedback;
      if (value == null) {
        if (!await FeedbackController.launch(uri)) {
          throw StateError('Launch failed');
        }
      } else {
        await value.open(uri, dismissInvitation: dismissInvitation);
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Could not open link. Please try again.')));
      }
    }
  }

  Future<void> dismiss() async {
    try {
      await feedback?.dismiss();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Could not save dismissal. Please try again.')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final rating = ratingUri(Theme.of(context).platform);
    return Scaffold(
      appBar: CustomAppBar(
        onOpen: currentIndex == 0
            ? () => EditorScreen.openFileAction?.call(context)
            : null,
        onSave: currentIndex == 0
            ? () => EditorScreen.saveFileAction?.call(context)
            : null,
        onClear: currentIndex == 0
            ? () => EditorScreen.clearFileAction?.call(context)
            : null,
        onFeedback: () => openLink(feedbackUri()),
        onPrivacy: () => openLink(privacyUri(), dismissInvitation: false),
        onRate: rating == null ? null : () => openLink(rating),
      ),
      body: Column(children: [
        Expanded(
            child: currentIndex == 0
                ? EditorScreen(
                    provideOpen: (fn) => EditorScreen.openFileAction = fn,
                    provideSave: (fn) => EditorScreen.saveFileAction = fn,
                    provideClear: (fn) => EditorScreen.clearFileAction = fn)
                : const PreviewScreen()),
        if (feedback?.showPrompt == true &&
            MediaQuery.viewInsetsOf(context).bottom == 0)
          ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.sizeOf(context).height * 0.32),
            child: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Card(
                  child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(children: [
                            const Expanded(child: Text('Help shape GhostMark')),
                            IconButton(
                                tooltip: 'Dismiss feedback invitation',
                                onPressed: dismiss,
                                icon: const Icon(Icons.close)),
                          ]),
                          const Text(
                              'What works well, or could work better? Feedback is optional. Your document stays private.'),
                          Wrap(spacing: 8, children: [
                            TextButton(
                                onPressed: () => openLink(feedbackUri()),
                                child: const Text('Share feedback')),
                            if (rating != null)
                              TextButton(
                                  onPressed: () => openLink(rating),
                                  child: const Text('Rate GhostMark')),
                          ]),
                        ],
                      ))),
            )),
          ),
      ]),
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => setState(() => currentIndex = index),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.wysiwyg), label: 'Edit'),
            BottomNavigationBarItem(icon: Icon(Icons.preview), label: 'View')
          ]),
    );
  }
}
