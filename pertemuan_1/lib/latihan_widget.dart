import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    ),
  );
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F2F5),

      body: Center(
        child: Container(
          width: 200,
          height: 200,

          padding: const EdgeInsets.all(20),

          decoration: BoxDecoration(
            color: Colors.blue,

            borderRadius: BorderRadius.circular(20),

            boxShadow: [
              BoxShadow(
                color: Colors.blue.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),

          child: const Center(
            child: Text(
              'Box',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),

        decoration: const BoxDecoration(
          color: Color(0xFFF5F2F5),

          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            ),
          ],
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [

            // HOME
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.home,
                  color: Colors.red,
                  size: 32,
                ),

                SizedBox(height: 4),

                Text('Home'),
              ],
            ),

            // ORDERS
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.receipt_long,
                  color: Colors.green,
                  size: 32,
                ),

                SizedBox(height: 4),

                Text('Orders'),
              ],
            ),

            // SAVED
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.favorite,
                  color: Colors.purple,
                  size: 32,
                ),

                SizedBox(height: 4),

                Text('Saved'),
              ],
            ),

            // PROFILE
            Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.person,
                  color: Colors.grey,
                  size: 32,
                ),

                SizedBox(height: 4),

                Text('Profile'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}