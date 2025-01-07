import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:html_unescape/html_unescape.dart';

class HtmlContentRenderer extends StatelessWidget {
  final String htmlContent;
  final double? width;
  final double? maxHeight;
  final TextStyle? defaultTextStyle;
  final Color? linkColor;
  final bool handleLinks;

  final HtmlUnescape _unescape = HtmlUnescape();
  
  HtmlContentRenderer({
    super.key,
    required this.htmlContent,
    this.width,
    this.maxHeight,
    this.defaultTextStyle,
    this.linkColor,
    this.handleLinks = true,
  });

  String _cleanHtml(String html) {
    // First unescape any HTML entities
    String cleaned = _unescape.convert(html);
    
    // Remove any raw <p> and </p> tags that might be visible
    cleaned = cleaned.replaceAll('<p>', '\n').replaceAll('</p>', '\n');
    
    // Wrap content in a div with proper styling
    return '''
      <div style="white-space: pre-wrap;">
        $cleaned
      </div>
    ''';
  }

  @override
  Widget build(BuildContext context) {
    final cleanedContent = _cleanHtml(htmlContent);

    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: width ?? constraints.maxWidth,
          height: maxHeight,
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: HtmlWidget(
              cleanedContent,
              textStyle: defaultTextStyle,
              customStylesBuilder: (element) {
                final styles = <String, String>{};
                
                if (element.localName == 'a' && linkColor != null) {
                  styles['color'] = linkColor!.toHex();
                }
                
                return styles;
              },
              onTapUrl: handleLinks ? _handleLinkTap : null,
              onErrorBuilder: (context, element, error) => Text(
                _unescape.convert(htmlContent.replaceAll(RegExp(r'<[^>]*>'), '')),
                style: defaultTextStyle,
              ),
            ),
          ),
        );
      },
    );
  }

  Future<bool> _handleLinkTap(String url) async {
    try {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
        return true;
      }
    } catch (e) {
      debugPrint('Error launching URL: $e');
    }
    return false;
  }
}

// Helper extension for Color
extension ColorExtension on Color {
  String toHex() => '#${value.toRadixString(16).padLeft(8, '0')}';
}

// Helper function for easier usage
Widget renderHtml({
  required String html,
  double? width,
  double? maxHeight,
  TextStyle? textStyle,
  Color? linkColor,
  bool handleLinks = true,
}) {
  return HtmlContentRenderer(
    htmlContent: html,
    width: width,
    maxHeight: maxHeight,
    defaultTextStyle: textStyle,
    linkColor: linkColor,
    handleLinks: handleLinks,
  );
}