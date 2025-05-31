import 'package:flutter/material.dart';

class CustomSnackbars {
  static void showSuccessSnack({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _showSnackBar(
      context: context,
      title: title,
      message: message,
      backgroundColor: Colors.greenAccent,
      textColor: Colors.black,
    );
  }

  static void showErrorSnack({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _showSnackBar(
      context: context,
      title: title,
      message: message,
      backgroundColor: Colors.redAccent,
      textColor: Colors.white,
    );
  }

  static void showInfoSnack({
    required BuildContext context,
    required String title,
    required String message,
  }) {
    _showSnackBar(
      context: context,
      title: title,
      message: message,
      backgroundColor: Colors.white,
      textColor: Colors.black,
    );
  }

  static void _showSnackBar({
    required BuildContext context,
    required String title,
    required String message,
    required Color backgroundColor,
    required Color textColor,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: 50, // Position from top of the screen
        left: 10,
        right: 10,
        child: Material(
          color: Colors.transparent,
          child: FadeTransition(
            opacity: _getAnimation(context) ?? const AlwaysStoppedAnimation(1.0),
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, -1),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _getAnimation(context) ?? const AlwaysStoppedAnimation(1.0),
                curve: Curves.easeOut,
              )),
              child: ShakeTransition(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.green, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      const BoxShadow(
                        color: Colors.black26,
                        blurRadius: 12,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: textColor,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: textColor,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              message,
                              style: TextStyle(color: textColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);

    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  static Animation<double>? _getAnimation(BuildContext context) {
    final route = ModalRoute.of(context);
    if (route == null || route.animation == null) {
      return null;
    }
    return route.animation;
  }
}

class ShakeTransition extends StatefulWidget {
  final Widget child;

  const ShakeTransition({super.key, required this.child});

  @override
  _ShakeTransitionState createState() => _ShakeTransitionState();
}

class _ShakeTransitionState extends State<ShakeTransition> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )..repeat(reverse: true);

    _shakeAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0.01, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    ));
  }

  @override
  Widget build(BuildContext context) { 
    return SlideTransition(
      position: _shakeAnimation,
      child: widget.child,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
