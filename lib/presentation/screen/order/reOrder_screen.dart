import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recorder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const RecorderScreen(),
    );
  }
}

class RecorderScreen extends StatelessWidget {
  const RecorderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RECORDER'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search by restaurant or dish',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 12.0),
                ),
              ),
            ),
            
            const Divider(height: 1),
            
            // Favourites section
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Favourites', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Price 149 - 300'),
                  Text('Price > 300'),
                ],
              ),
            ),
            
            const Divider(height: 1),
            
            // Restaurant header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tasty Buds • 20-25 mins', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 4),
                      Text('📌 ₹50 off above ₹199'),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            
            // Menu items
            _buildMenuItem(
              title: 'Chicken Dum Biryani',
              price: '₹269',
              available: true,
            ),
            
            _buildMenuItem(
              title: 'Rich cream',
              price: 'Uh-oh! The outlet is not accepting orders at...',
              available: false,
              prefix: '❶',
            ),
            
            _buildMenuItem(
              title: 'Hakka Noodles [Egg]',
              price: '₹180',
              available: false,
              prefix: '🎵',
            ),
            
            _buildMenuItem(
              title: 'Fried Wings',
              price: 'Uh-oh! The outlet is not accepting orders at...',
              available: false,
              prefix: '❶',
            ),
            
            _buildMenuItem(
              title: 'Chicken Tandoori Pizza',
              price: '₹319',
              available: false,
              prefix: '🎵',
            ),
            
            // View full menu button
            Center(
              child: TextButton(
                onPressed: () {},
                child: const Text('Tasty Buds\nView Full Menu', 
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            
            const Divider(height: 1),
            
            // Checkout bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1 item | ₹269'),
                      SizedBox(height: 4),
                      Text('Checkout', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: const Text('Checkout', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildMenuItem({
    required String title,
    required String price,
    required bool available,
    String? prefix,
  }) {
    return Column(
      children: [
        const Divider(height: 1),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (prefix != null) 
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(prefix),
                ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(price, style: TextStyle(
                      color: available ? Colors.black : Colors.grey,
                    )),
                    if (!available) 
                      const Padding(
                        padding: EdgeInsets.only(top: 4.0),
                        child: Text('Not available at the moment', 
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}