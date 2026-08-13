import 'package:flutter/material.dart';

class AboutSystemScreen extends StatelessWidget {
  const AboutSystemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final systemImages = [
      "asset/card/00.SystemStorytellerTactics/coverintroduction.png",
      "asset/card/00.SystemStorytellerTactics/Story Building System.png",
      "asset/card/00.SystemStorytellerTactics/Pickacard...anycard.png",
      "asset/card/00.SystemStorytellerTactics/copyrightlegal.png",
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
