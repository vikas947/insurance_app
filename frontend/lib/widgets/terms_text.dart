import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../core/app_theme.dart';

import 'link_text.dart';

class TermsText extends StatelessWidget {
  const TermsText({super.key});

  @override
  Widget build(BuildContext context) {
    const double termsFontSize = 11.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Center(
        child: Text.rich(
          TextSpan(
            text: "By signing up, you agree to the ",
            style: const TextStyle(
              fontSize: termsFontSize,
              color: AppColors.grey,
              height: 1.4,
            ),
            children: [
              WidgetSpan(
                child: LinkText(
                  text: "Terms of Service",
                  fontSize: termsFontSize,
                  onTap: () {
                    _launchURL("https://www.indusindinsurance.com/insurance/about-us/disclaimer.aspx");
                  },
                  isUnderlined: true,
                ),
                alignment: PlaceholderAlignment.middle,
              ),
              const TextSpan(text: " and "),
              WidgetSpan(
                child: LinkText(
                  text: "Data Processing Agreement",
                  fontSize: termsFontSize,
                  onTap: () {
                    _launchURL("https://www.indusindinsurance.com/about-us/terms-and-conditions");
                  },
                  isUnderlined: true,
                ),
                alignment: PlaceholderAlignment.middle,
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint("Could not launch $urlString");
    }
  }
}
