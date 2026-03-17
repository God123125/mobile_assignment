import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MenuShimmer extends StatelessWidget {
  const MenuShimmer({super.key});

  Widget box({double height = 20, double width = double.infinity}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget circle() {
    return Container(
      width: 45,
      height: 45,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            const SizedBox(height: 70),

            /// search box
            box(height: 50),

            const SizedBox(height: 15),

            /// category title
            box(height: 16, width: 120),

            const SizedBox(height: 10),

            /// categories list
            SizedBox(
              height: 60,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (_, __) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: Row(
                      children: [
                        circle(),
                        const SizedBox(width: 8),
                        box(height: 10, width: 50),
                      ],
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 15),

            /// store title
            box(height: 16, width: 150),
            /// store list
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (_, _) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// store image
                          box(height: 180),

                          const SizedBox(height: 8),

                          /// title
                          box(height: 14, width: 200),

                          const SizedBox(height: 6),

                          /// subtitle
                          box(height: 12, width: 150),

                          const SizedBox(height: 6),

                          Row(
                            children: [
                              box(height: 12, width: 60),
                              const SizedBox(width: 20),
                              box(height: 12, width: 60),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}