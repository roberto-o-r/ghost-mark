import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:ghost_mark/features/preview/data/preview_links.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:url_launcher/url_launcher.dart';

typedef ExternalLinkLauncher = Future<bool> Function(Uri uri);

Future<bool> launchExternalWebLink(Uri uri) =>
    launchUrl(uri, mode: LaunchMode.externalApplication);

/// A Markdown preview with selectable text, safe web links, and internal
/// heading navigation.
class NavigableMarkdown extends StatefulWidget {
  final String data;
  final ExternalLinkLauncher launchExternalLink;
  final ScrollController? controller;

  const NavigableMarkdown({
    super.key,
    required this.data,
    this.launchExternalLink = launchExternalWebLink,
    this.controller,
  });

  @override
  State<NavigableMarkdown> createState() => _NavigableMarkdownState();
}

class _NavigableMarkdownState extends State<NavigableMarkdown> {
  late ScrollController _controller;
  late bool _ownsController;
  late Map<String, GlobalKey> _anchors;
  late Map<int, GlobalKey> _anchorKeysByBlock;

  @override
  void initState() {
    super.initState();
    _setController(widget.controller);
    _resetAnchors();
  }

  @override
  void didUpdateWidget(NavigableMarkdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (_ownsController) _controller.dispose();
      _setController(widget.controller);
    }
    if (widget.data != oldWidget.data) _resetAnchors();
  }

  void _setController(ScrollController? controller) {
    _ownsController = controller == null;
    _controller = controller ?? ScrollController();
  }

  void _resetAnchors() {
    _anchors = <String, GlobalKey>{};
    _anchorKeysByBlock = <int, GlobalKey>{};

    final document = md.Document(extensionSet: md.ExtensionSet.gitHubWeb);
    final nodes =
        document.parseLines(const LineSplitter().convert(widget.data));
    final ids = UniqueHeadingIds();

    for (var index = 0; index < nodes.length; index++) {
      final node = nodes[index];
      if (node is! md.Element || !_headingTags.contains(node.tag)) continue;

      final generatedId = node.generatedId;
      if (generatedId == null || generatedId.isEmpty) continue;

      final id = ids.next(generatedId);
      final key = GlobalKey(debugLabel: 'heading-$id');
      _anchors[id] = key;
      _anchorKeysByBlock[index] = key;
    }
  }

  @override
  void dispose() {
    if (_ownsController) _controller.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _handleLink(String? href) async {
    final anchorId = internalAnchorId(href);
    if (anchorId != null) {
      final anchorContext = _anchors[anchorId]?.currentContext;
      if (anchorContext == null) {
        _showMessage('Heading not found.');
        return;
      }
      await Scrollable.ensureVisible(
        anchorContext,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
      return;
    }

    final uri = externalWebUri(href);
    if (uri == null) {
      _showMessage('Only web links are supported.');
      return;
    }

    final launched = await widget.launchExternalLink(uri);
    if (!launched) _showMessage('Could not open link.');
  }

  @override
  Widget build(BuildContext context) {
    return SelectionArea(
      child: SingleChildScrollView(
        controller: _controller,
        padding: const EdgeInsets.all(16),
        child: _AnchoredMarkdownBody(
          data: widget.data,
          anchorKeysByBlock: _anchorKeysByBlock,
          onTapLink: (text, href, title) => unawaited(_handleLink(href)),
        ),
      ),
    );
  }
}

const _headingTags = {'h1', 'h2', 'h3', 'h4', 'h5', 'h6'};

class _AnchoredMarkdownBody extends MarkdownWidget {
  final Map<int, GlobalKey> anchorKeysByBlock;

  _AnchoredMarkdownBody({
    required super.data,
    required this.anchorKeysByBlock,
    required super.onTapLink,
  }) : super(extensionSet: md.ExtensionSet.gitHubWeb);

  @override
  Widget build(BuildContext context, List<Widget>? children) {
    final blocks = children ?? const <Widget>[];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < blocks.length; index++)
          KeyedSubtree(
            key: anchorKeysByBlock[index],
            child: blocks[index],
          ),
      ],
    );
  }
}
