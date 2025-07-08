import 'dart:async';
import 'package:flutter/material.dart';

class OffersCarousel extends StatefulWidget {
  const OffersCarousel({super.key});

  @override
  State<OffersCarousel> createState() => _OffersCarouselState();
}

class _OffersCarouselState extends State<OffersCarousel> {
  final PageController _pageController = PageController(
    viewportFraction: 0.85,
    initialPage: 1000, // start from a high number for infinite forward scroll
  );

  double _currentPage = 1000.0;
  Timer? _autoScrollTimer;
  bool _isUserInteracting = false;

  final List<Map<String, dynamic>> offers = [
    {
      'tag': '50% OFF',
      'title': 'Monsoon Feast',
      'subtitle': 'Flat 50% off on top restaurants',
      'colors': {
        'gradient': [Color(0xFFE0F7FA), Color(0xFFB2EBF2)],
        'accent': Color(0xFF00ACC1),
      }
    },
    {
      'tag': 'Free Delivery',
      'title': 'No Delivery Fees',
      'subtitle': 'On orders above ₹199',
      'colors': {
        'gradient': [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
        'accent': Color(0xFF43A047),
      }
    },
    {
      'tag': '30% Cashback',
      'title': 'Super Saver',
      'subtitle': 'Get cashback on prepaid orders',
      'colors': {
        'gradient': [Color(0xFFFFF3E0), Color(0xFFFFE0B2)],
        'accent': Color(0xFFFB8C00),
      }
    },
  ];

  @override
  void initState() {
    super.initState();

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? _currentPage;
      });
    });

    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!_pageController.hasClients || _isUserInteracting) return;

      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int actualIndex = _currentPage.floor() % offers.length;

    return GestureDetector(
      onPanDown: (_) => _isUserInteracting = true,
      onPanCancel: () => _isUserInteracting = false,
      onPanEnd: (_) => _isUserInteracting = false,
      child: Column(
        children: [
          SizedBox(
            height: 160,
            child: PageView.builder(
              controller: _pageController,
              itemBuilder: (context, index) {
                final actualItem = offers[index % offers.length];
                final colors = actualItem['colors'];

                final double scale = (_currentPage - index).abs() < 1.0
                    ? 1 - (_currentPage - index).abs() * 0.1
                    : 0.9;

                return Transform.scale(
                  scale: scale,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutQuint,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: OffersCard(
                      tag: actualItem['tag'],
                      title: actualItem['title'],
                      subtitle: actualItem['subtitle'],
                      onPressed: () {},
                      gradientColors: List<Color>.from(colors['gradient']),
                      accentColor: colors['accent'],
                    ),
                  ),
                );
              },
            ),
          ),

          // const SizedBox(height: 10),
         
        ],
      ),
    );
  }
}

class OffersCard extends StatelessWidget {
  final String tag;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;
  final List<Color> gradientColors;
  final Color accentColor;

  const OffersCard({
    super.key,
    required this.tag,
    required this.title,
    required this.subtitle,
    required this.onPressed,
    required this.gradientColors,
    required this.accentColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: -40,
            right: -40,
            child: Container(
              width: 140,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: accentColor.withOpacity(0.2),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
                  decoration: BoxDecoration(
                    color: accentColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    tag,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 28,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: accentColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                    onPressed: onPressed,
                    child: const Text(
                      "Order Now",
                      style: TextStyle(fontSize: 12, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
