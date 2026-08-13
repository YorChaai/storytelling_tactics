import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import '../data/cards_data.dart';
import 'fullscreen_viewer.dart';

class CardDetailDialog extends StatefulWidget {
  final List<TacticCard> cards;
  final int initialIndex;

  const CardDetailDialog({
    super.key,
    required this.cards,
    this.initialIndex = 0,
  });

  @override
  State<CardDetailDialog> createState() => _CardDetailDialogState();
}

class _CardDetailDialogState extends State<CardDetailDialog> {
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
      child: Dialog(
        backgroundColor: Colors.transparent,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800, maxHeight: 900),
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24),
            child: Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.cards[_currentIndex].name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.cards[_currentIndex].category} ${widget.cards[_currentIndex].isDesertIsland ? "• 🏝️ Desert Island" : ""}',
                          style: const TextStyle(
                            color: Color(0xFF6366F1),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.fullscreen, color: Colors.white70),
                          tooltip: 'Lihat Fullscreen',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => FullscreenViewer(
                                cards: widget.cards,
                                initialIndex: _currentIndex,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ScrollConfiguration(
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
                            final card = widget.cards[index];
                            return ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                card.imagePath,
                                fit: BoxFit.contain,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      ),
                      child: const Text('Tutup', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
                if (_currentIndex > 0)
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios, color: Colors.white54, size: 32),
                        onPressed: _goToPrevious,
                      ),
                    ),
                  ),
                if (_currentIndex < widget.cards.length - 1)
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_forward_ios, color: Colors.white54, size: 32),
                        onPressed: _goToNext,
                      ),
                    ),
                  ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white54),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
