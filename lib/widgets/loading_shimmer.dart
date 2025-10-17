import 'package:flutter/material.dart';
import 'package:news_app/utils/app.colors.dart';

class LoadingShimmer extends StatefulWidget {
  const LoadingShimmer({super.key});

  @override
  _LoadingShimmerState createState() => _LoadingShimmerState();
}

class _LoadingShimmerState extends State<LoadingShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: false);

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget shimmerBox({
    required double height,
    required double width,
    BorderRadius? radius,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            borderRadius: radius ?? BorderRadius.circular(8),
            gradient: LinearGradient(
              begin: Alignment(-1.0 + _animation.value, 0),
              end: Alignment(1.0 + _animation.value, 0),
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
              stops: const [0.1, 0.3, 0.4],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      physics: const BouncingScrollPhysics(),
      itemCount: 5,
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image shimmer
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: shimmerBox(height: 180, width: double.infinity),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    shimmerBox(height: 12, width: 100, radius: BorderRadius.circular(6)),
                    const SizedBox(height: 12),
                    shimmerBox(height: 16, width: double.infinity),
                    const SizedBox(height: 8),
                    shimmerBox(
                        height: 16,
                        width: MediaQuery.of(context).size.width * 0.7),
                    const SizedBox(height: 12),
                    shimmerBox(height: 14, width: double.infinity),
                    const SizedBox(height: 6),
                    shimmerBox(
                        height: 14,
                        width: MediaQuery.of(context).size.width * 0.5),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
