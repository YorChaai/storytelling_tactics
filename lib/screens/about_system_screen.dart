import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class AboutSystemScreen extends StatelessWidget {
  const AboutSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final basePath = settings.cardLanguage.basePath;

    final systemImages = [
      "$basePath/00.SystemStorytellerTactics/coverintroduction.png",
      "$basePath/00.SystemStorytellerTactics/Story Building System.png",
      "$basePath/00.SystemStorytellerTactics/Pickacard...anycard.png",
      "$basePath/00.SystemStorytellerTactics/copyrightlegal.png",
    ];

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: systemImages.length,
      itemBuilder: (context, index) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(51),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: AspectRatio(
                  aspectRatio: 2100 / 1725,
                  child: Image.asset(
                    systemImages[index],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
