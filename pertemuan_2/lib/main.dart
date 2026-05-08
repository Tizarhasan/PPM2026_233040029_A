import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

// =====================================================================
// PROFILE PAGE
// =====================================================================

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // APP BAR
      appBar: AppBar(
        title: const Text('Profil Saya'),

        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),

      // DRAWER
      drawer: Drawer(
        child: ListView(
          children: [

            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),

              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),

            const ListTile(
              leading: Icon(Icons.home),
              title: Text('Beranda'),
            ),

            const ListTile(
              leading: Icon(Icons.person),
              title: Text('Profil'),
            ),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Pengaturan'),

              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Pengaturan'),
                    content: const Text(
                      'Halaman pengaturan belum tersedia.',
                    ),

                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },

                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.widgets),
              title: const Text('Widget Gallery'),

              onTap: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const GalleryHome(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // BODY
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,

          children: [

            // FOTO PROFIL
            Center(
              child: Column(
                children: [

                  const CircleAvatar(
                    radius: 50,

                    backgroundImage: NetworkImage(
                      'https://avatars.githubusercontent.com/u/145255463?v=4',
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    'Tizar',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    'Mahasiswa Informatika',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // STATISTIK
            Row(
              children: const [

                Expanded(
                  child: _StatBox(
                    label: 'Post',
                    value: '12',
                  ),
                ),

                Expanded(
                  child: _StatBox(
                    label: 'Teman',
                    value: '1280',
                  ),
                ),

                Expanded(
                  child: _StatBox(
                    label: 'Like',
                    value: '99.2K',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // SECTION CARD
            const _SectionCard(
              icon: Icons.info_outline,
              title: 'Tentang Saya',
              content:
              'Saya suka fotografi, design, dan editing.',
            ),

            const _SectionCard(
              icon: Icons.school,
              title: 'Pendidikan',
              content:
              'Teknik Informatika\nSemester 6',
            ),

            const _SectionCard(
              icon: Icons.favorite,
              title: 'Hobi & Minat',
              content:
              'Fotografi • Editing • Coding • Game',
            ),

            const _SectionCard(
              icon: Icons.email,
              title: 'Kontak',
              content:
              'tizarhasan443@gmail.com\n+62 812-3456-7890',
            ),

            // SKILLS
            Card(
              margin: const EdgeInsets.only(bottom: 12),

              child: Padding(
                padding: const EdgeInsets.all(16),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [

                    const Row(
                      children: [

                        Icon(
                          Icons.star,
                          color: Colors.blue,
                        ),

                        SizedBox(width: 12),

                        Text(
                          'Skills',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 8,
                      runSpacing: 8,

                      children: const [

                        Chip(label: Text('Flutter')),
                        Chip(label: Text('Dart')),
                        Chip(label: Text('Editing')),
                        Chip(label: Text('Photography')),
                        Chip(label: Text('UI Design')),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),

      // FAB
      floatingActionButton: FloatingActionButton(
        onPressed: () {

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                'Edit profil belum tersedia',
              ),
            ),
          );
        },

        child: const Icon(Icons.edit),
      ),

      // BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        type: BottomNavigationBarType.fixed,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Pesan',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Setting',
          ),
        ],

        onTap: (i) {},
      ),
    );
  }
}

// =====================================================================
// HELPER WIDGET
// =====================================================================

class _StatBox extends StatelessWidget {
  final String label;
  final String value;

  const _StatBox({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        Text(
          value,

          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 4),

        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;

  const _SectionCard({
    required this.icon,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),

      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Icon(
              icon,
              color: Colors.blue,
              size: 28,
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    title,

                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    content,

                    style: const TextStyle(
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// GALLERY HOME
// =====================================================================

class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  @override
  Widget build(BuildContext context) {

    final categories = [

      ('Display', Icons.image, Colors.blue),
      ('Input', Icons.edit, Colors.green),
      ('Button', Icons.smart_button, Colors.orange),
      ('Feedback', Icons.notifications, Colors.purple),
      ('Layout', Icons.dashboard, Colors.teal),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Widget Gallery'),
      ),

      body: ListView.separated(
        padding: const EdgeInsets.all(16),

        itemCount: categories.length,

        separatorBuilder: (_, __) {
          return const SizedBox(height: 8);
        },

        itemBuilder: (context, i) {

          final (name, icon, color) = categories[i];

          return Card(
            child: ListTile(

              leading: CircleAvatar(
                backgroundColor: color,
                child: Icon(
                  icon,
                  color: Colors.white,
                ),
              ),

              title: Text(name),

              trailing: const Icon(Icons.chevron_right),

              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CategoryPage(name: name),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// =====================================================================
// CATEGORY PAGE
// =====================================================================

class CategoryPage extends StatelessWidget {
  final String name;

  const CategoryPage({
    super.key,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),

      body: Center(
        child: Text(
          'Konten kategori $name',
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}