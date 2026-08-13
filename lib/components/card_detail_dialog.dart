import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
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
  late ValueNotifier<int> _currentIndexNotifier;
  final FocusNode _focusNode = FocusNode();

  bool _isZoomed = false;
  final Map<int, PhotoViewController> _photoViewControllers = {};
  final Map<int, PhotoViewScaleStateController> _scaleStateControllers = {};
  final Map<int, double> _baseScales = {};

  @override
  void initState() {
    super.initState();
    _currentIndexNotifier = ValueNotifier(widget.initialIndex);
    _pageController = PageController(initialPage: widget.initialIndex);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _currentIndexNotifier.dispose();
    _focusNode.dispose();
    for (final ctrl in _photoViewControllers.values) {
      ctrl.dispose();
    }
    for (final ctrl in _scaleStateControllers.values) {
      ctrl.dispose();
    }
    super.dispose();
  }

  PhotoViewController _getController(int index) {
    if (!_photoViewControllers.containsKey(index)) {
      final ctrl = PhotoViewController();
      ctrl.outputStateStream.listen((state) {
        if (!mounted) return;
        final stateCtrl = _scaleStateControllers[index];
        if (stateCtrl != null && stateCtrl.scaleState == PhotoViewScaleState.initial) {
          if (state.scale != null) {
            _baseScales[index] = state.scale!;
          }
        }
      });
      _photoViewControllers[index] = ctrl;
    }
    return _photoViewControllers[index]!;
  }

  PhotoViewScaleStateController _getScaleStateController(int index) {
    if (!_scaleStateControllers.containsKey(index)) {
      final ctrl = PhotoViewScaleStateController();
      ctrl.outputScaleStateStream.listen((state) {
        if (!mounted) return;
        final bool isCurrentlyZoomed = state != PhotoViewScaleState.initial;
        _isZoomed = isCurrentlyZoomed;
      });
      _scaleStateControllers[index] = ctrl;
    }
    return _scaleStateControllers[index]!;
  }

  void _goToPrevious() {
    if (_currentIndexNotifier.value > 0) {
      _pageController.animateToPage(_currentIndexNotifier.value - 1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  void _goToNext() {
    if (_currentIndexNotifier.value < widget.cards.length - 1) {
      _pageController.animateToPage(_currentIndexNotifier.value + 1, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    }
  }

  PhotoViewScaleState _customScaleStateCycle(PhotoViewScaleState actual) {
    if (actual == PhotoViewScaleState.initial) {
      return PhotoViewScaleState.covering;
    }
    return PhotoViewScaleState.initial;
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardListener(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (KeyEvent event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowLeft || event.logicalKey == LogicalKeyboardKey.keyA) {
            if (!_isZoomed) _goToPrevious();
          } else if (event.logicalKey == LogicalKeyboardKey.arrowRight || event.logicalKey == LogicalKeyboardKey.keyD) {
            if (!_isZoomed) _goToNext();
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
                    ValueListenableBuilder<int>(
                      valueListenable: _currentIndexNotifier,
                      builder: (context, currentIndex, child) {
                        return Column(
                          children: [
                            Text(
                              widget.cards[currentIndex].name,
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
                                  '${widget.cards[currentIndex].category} ${widget.cards[currentIndex].isDesertIsland ? "• 🏝️ Desert Island" : ""}',
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
                                        initialIndex: currentIndex,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: Listener(
                        onPointerUp: (event) {
                          if (!_pageController.hasClients) return;
                          final double page = _pageController.page!;
                          final double diff = page - _currentIndexNotifier.value;
                          
                          if (diff.abs() > 0.05 && diff.abs() < 0.5) {
                            if (diff > 0) {
                              _goToNext();
                            } else {
                              _goToPrevious();
                            }
                          }
                        },
                        onPointerSignal: (event) {
                          if (event is PointerScrollEvent) {
                            final int currentIndex = _currentIndexNotifier.value;
                            final ctrl = _getController(currentIndex);
                            if (ctrl.value.scale == null) return;
                            
                            final double curScale = ctrl.value.scale!;
                            
                            if (!_isZoomed && !_baseScales.containsKey(currentIndex)) {
                              _baseScales[currentIndex] = curScale;
                            }
                            final double baseScale = _baseScales[currentIndex] ?? curScale;
                            final double maxScale = baseScale * 8.0;
                            
                            final double delta = -event.scrollDelta.dy;
                            final double change = (1.0 + (delta / 120.0) * 0.1).clamp(0.8, 1.2);
                            
                            final double newScale = (curScale * change).clamp(baseScale, maxScale);
                            
                            if (newScale <= baseScale * 1.01) {
                              ctrl.scale = baseScale;
                              _getScaleStateController(currentIndex).scaleState = PhotoViewScaleState.initial;
                            } else {
                              ctrl.scale = newScale;
                              _getScaleStateController(currentIndex).scaleState = PhotoViewScaleState.zoomedIn;
                            }
                          }
                        },
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context).copyWith(
                            dragDevices: {
                              PointerDeviceKind.touch,
                              PointerDeviceKind.mouse,
                              PointerDeviceKind.trackpad,
                            },
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: PhotoViewGallery.builder(
                              scrollPhysics: const ClampingScrollPhysics(),
                              pageController: _pageController,
                              itemCount: widget.cards.length,
                              onPageChanged: (index) {
                                _currentIndexNotifier.value = index;
                                _isZoomed = false;
                                
                                for (var key in _photoViewControllers.keys) {
                                  if (key != index) {
                                    _photoViewControllers[key]!.scale = null;
                                    _photoViewControllers[key]!.position = Offset.zero;
                                  }
                                }
                                for (var key in _scaleStateControllers.keys) {
                                  if (key != index) {
                                    _scaleStateControllers[key]!.scaleState = PhotoViewScaleState.initial;
                                  }
                                }
                              },
                              builder: (context, index) {
                                final card = widget.cards[index];
                                return PhotoViewGalleryPageOptions(
                                  imageProvider: AssetImage(card.imagePath),
                                  filterQuality: FilterQuality.high,
                                  initialScale: PhotoViewComputedScale.contained,
                                  minScale: PhotoViewComputedScale.contained,
                                  maxScale: PhotoViewComputedScale.covered * 4,
                                  controller: _getController(index),
                                  scaleStateController: _getScaleStateController(index),
                                  scaleStateCycle: _customScaleStateCycle,
                                );
                              },
                            ),
                          ),
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
