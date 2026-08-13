import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import '../data/cards_data.dart';

class FullscreenViewer extends StatefulWidget {
  final List<TacticCard> cards;
  final int initialIndex;

  const FullscreenViewer({
    super.key,
    required this.cards,
    required this.initialIndex,
  });

  @override
  State<FullscreenViewer> createState() => _FullscreenViewerState();
}

class _FullscreenViewerState extends State<FullscreenViewer> {
  late PageController _pageController;
  late int _currentIndex;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _goToPrevious() {
    if (_currentIndex > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _goToNext() {
    if (_currentIndex < widget.cards.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft || event.logicalKey == LogicalKeyboardKey.keyA) {
            _goToPrevious();
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight || event.logicalKey == LogicalKeyboardKey.keyD) {
            _goToNext();
          }
        }
      },
      child: Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                dragDevices: {
                  PointerDeviceKind.touch,
                  PointerDeviceKind.mouse,
                  PointerDeviceKind.trackpad,
                },
              ),
              child: PageView.builder(
                controller: _pageController,
                itemCount: widget.cards.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    minScale: 1.0,
                    maxScale: 5.0,
                    child: Center(
                      child: Image.asset(widget.cards[index].imagePath, fit: BoxFit.contain),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            // Navigation arrows
            if (_currentIndex > 0)
              Positioned(
                left: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white70, size: 40),
                    onPressed: _goToPrevious,
                  ),
                ),
              ),
            if (_currentIndex < widget.cards.length - 1)
              Positioned(
                right: 16,
                top: 0,
                bottom: 0,
                child: Center(
                  child: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 40),
                    onPressed: _goToNext,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
