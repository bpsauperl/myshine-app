import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

/// Opens [url] in the in-app browser view (Safari View Controller / Custom
/// Tabs), falling back to the default browser.
Future<void> openInBrowserView(BuildContext context, String url) async {
  final uri = Uri.tryParse(url);
  final messenger = ScaffoldMessenger.of(context);
  if (uri == null) {
    messenger.showSnackBar(
      const SnackBar(content: Text('This link doesn\'t work.')),
    );
    return;
  }
  var opened = false;
  try {
    opened = await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
  } catch (_) {
    opened = false;
  }
  if (!opened) {
    try {
      opened = await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      opened = false;
    }
  }
  if (!opened) {
    messenger.showSnackBar(
      const SnackBar(content: Text('We couldn\'t open the link.')),
    );
  }
}

/// Opens a `tel:` or `mailto:` link.
Future<void> openContact(BuildContext context, Uri uri) async {
  final messenger = ScaffoldMessenger.of(context);
  var opened = false;
  try {
    opened = await launchUrl(uri);
  } catch (_) {
    opened = false;
  }
  if (!opened) {
    messenger.showSnackBar(
      SnackBar(content: Text('We couldn\'t open ${uri.path}.')),
    );
  }
}
