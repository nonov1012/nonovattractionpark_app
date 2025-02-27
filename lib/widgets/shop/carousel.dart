import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  final List<Map<String, String>> items;

  const Carousel({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        itemCount: items.length,
        controller: PageController(viewportFraction: 0.8),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    items[index]['URL_Image']!,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('${items[index]['Prix']}€'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
