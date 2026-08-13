import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
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

  bool _isZoomed = false;
  final Map<int, PhotoViewController> _photoViewControllers = {};
  final Map<int, PhotoViewScaleStateController> _scaleStateControllers = {};
  final Map<int, double> _baseScales = {};

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
        if (_isZoomed != isCurrentlyZoomed) {
          setState(() {
            _isZoomed = isCurrentlyZoomed;
          });
        }
      });
      _scaleStateControllers[index] = ctrl;
    }
    return _scaleStateControllers[index]!;
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
      child: Dialog.fullscreen(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            Listener(
              onPointerSignal: (event) {
                if (event is PointerScrollEvent) {
                  final ctrl = _getController(_currentIndex);
                  if (ctrl.value.scale == null) return;
                  
                  final double curScale = ctrl.value.scale!;
                  
                  if (!_isZoomed && !_baseScales.containsKey(_currentIndex)) {
                    _baseScales[_currentIndex] = curScale;
                  }
                  final double baseScale = _baseScales[_currentIndex] ?? curScale;
                  final double maxScale = baseScale * 8.0;
                  
                  final double delta = -event.scrollDelta.dy;
                  final double change = (1.0 + (delta / 120.0) * 0.1).clamp(0.8, 1.2);
                  
                  final double newScale = (curScale * change).clamp(baseScale, maxScale);
                  
                  if (newScale <= baseScale * 1.01) {
                    ctrl.scale = baseScale;
                    _getScaleStateController(_currentIndex).scaleState = PhotoViewScaleState.initial;
                  } else {
                    ctrl.scale = newScale;
                    _getScaleStateController(_currentIndex).scaleState = PhotoViewScaleState.zoomedIn;
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
                child: PhotoViewGallery.builder(
                  scrollPhysics: const ClampingScrollPhysics(),
                  pageController: _pageController,
                  itemCount: widget.cards.length,
                  onPageChanged: (index) {
                    final oldIndex = _currentIndex;
                    setState(() {
                      _currentIndex = index;
                      _isZoomed = false;
                    });
                    if (_photoViewControllers.containsKey(oldIndex)) {
                      _photoViewControllers[oldIndex]!.scale = null;
                      _photoViewControllers[oldIndex]!.position = Offset.zero;
                    }
                    if (_scaleStateControllers.containsKey(oldIndex)) {
                      _scaleStateControllers[oldIndex]!.scaleState = PhotoViewScaleState.initial;
                    }
                  },
                  builder: (context, index) {
                    return PhotoViewGalleryPageOptions(
                      imageProvider: AssetImage(widget.cards[index].imagePath),
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
            Positioned(
              top: 16,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 32),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
