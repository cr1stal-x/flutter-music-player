import 'package:flutter/material.dart';
import 'package:musix/views/drawer.dart';
import 'package:musix/views/server_view.dart';

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = ['Classic', 'Pop', 'Top new', 'Top 100'];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Shop', style: TextStyle(color: Colors.black)),
            Icon(Icons.settings, color: Colors.black),
          ],
        ),
      ),
      drawer: MyDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: GridView.builder(
          itemCount: categories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:2,
            childAspectRatio: 1,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (_, index) {
            return Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Column(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: (){Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SongsListView(),
                          ),
                        );},
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.asset(
                            'assets/images/songs.png',
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        categories[index],
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
              ),
            );
          },
        ),
      ),
    );
  }
}
