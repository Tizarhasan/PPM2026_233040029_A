import 'dart:io' show File;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF6750A4),
          surface: const Color(0xFFF8F7FF),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
        ),
      ),
      home: const ProfilePage(),
    );
  }
}

// =====================================================================
// MODELS
// =====================================================================

class ProfileData {
  String name;
  String bio;
  String education;
  String location;
  String contact;
  String? imagePath;

  ProfileData({
    required this.name,
    required this.bio,
    required this.education,
    required this.location,
    required this.contact,
    this.imagePath,
  });
}

class ExperienceData {
  String title;
  String description;
  String? imagePath;

  ExperienceData({
    required this.title,
    required this.description,
    this.imagePath,
  });
}

// =====================================================================
// PROFILE PAGE
// =====================================================================

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  ProfileData profile = ProfileData(
    name: 'Tizar',
    bio: 'Belajar Flutter!',
    education: 'Teknik Informatika - Semester 6',
    location: 'Bandung, Jawa Barat',
    contact: 'tizarhasan443@gmail.com',
    imagePath: 'https://avatars.githubusercontent.com/u/145255463?v=4',
  );

  ExperienceData experience = ExperienceData(
    title: 'test',
    description: 'test',
    imagePath: null,
  );

  Widget _buildImage(String? path, {double? width, double? height, BoxFit fit = BoxFit.cover, bool isCircle = false}) {
    ImageProvider imageProvider;
    if (path == null || path.isEmpty) {
      imageProvider = const NetworkImage('https://via.placeholder.com/150');
    } else if (path.startsWith('http') || path.startsWith('blob:')) {
      imageProvider = NetworkImage(path);
    } else {
      imageProvider = kIsWeb ? const NetworkImage('https://via.placeholder.com/150') : FileImage(File(path));
    }

    if (isCircle) {
      return CircleAvatar(
        radius: (width ?? 100) / 2,
        backgroundImage: imageProvider,
      );
    }

    return Image(
      image: imageProvider,
      width: width,
      height: height,
      fit: fit,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya', style: TextStyle(fontWeight: FontWeight.w500)),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
        ],
      ),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  _buildImage(profile.imagePath, width: 90, isCircle: true),
                  const SizedBox(height: 12),
                  Text(
                    profile.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    profile.bio,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            _buildStatRow(),
            const SizedBox(height: 32),
            _buildInfoCard(Icons.school_outlined, 'Pendidikan', profile.education),
            _buildInfoCard(Icons.location_on_outlined, 'Lokasi', profile.location),
            _buildInfoCard(Icons.email_outlined, 'Kontak', profile.contact),
            const SizedBox(height: 12),
            _buildSkillsSection(),
            const SizedBox(height: 12),
            _buildExperienceSection(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditProfilePage(profile: profile)),
          );
          if (result != null && result is ProfileData) {
            setState(() => profile = result);
          }
        },
        label: const Text('Edit Profil'),
        icon: const Icon(Icons.edit_outlined),
        backgroundColor: const Color(0xFFE8E7FF),
        foregroundColor: const Color(0xFF6750A4),
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 60, bottom: 20, left: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF8B78FF), Color(0xFF5451D6)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Text(
              'Menu Utama',
              style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: const Text('Profil'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: const Icon(Icons.grid_view),
            title: const Text('Widget Gallery'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => const GalleryHome()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit_note_outlined),
            title: const Text('Edit Pengalaman'),
            onTap: () async {
              Navigator.pop(context);
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        EditExperiencePage(experience: experience)),
              );
              if (result != null && result is ExperienceData) {
                setState(() => experience = result);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings_outlined),
            title: const Text('Pengaturan'),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem('12', 'Post'),
        _buildStatItem('1280', 'Teman'),
        _buildStatItem('99.2K', 'Like'),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF5451D6)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(content, style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.star_outline, color: Color(0xFF5451D6)),
              SizedBox(width: 12),
              Text('Skills', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ['Flutter', 'Dart', 'Java', 'Python', 'Git'].map((s) => _buildSkillChip(s)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF0EFFF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFDED9FF)),
      ),
      child: Text(label, style: const TextStyle(color: Color(0xFF5451D6), fontSize: 12)),
    );
  }

  Widget _buildExperienceSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.collections_bookmark_outlined, color: Color(0xFF5451D6)),
              SizedBox(width: 12),
              Text('Pengalaman', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Spacer(),
              CircleAvatar(
                radius: 10,
                backgroundColor: Color(0xFFF0EFFF),
                child: Text('1', style: TextStyle(fontSize: 10, color: Color(0xFF5451D6))),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: _buildImage(experience.imagePath, width: 50, height: 50),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(experience.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(experience.description, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                    ],
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

// =====================================================================
// EDIT PROFILE PAGE
// =====================================================================

class EditProfilePage extends StatefulWidget {
  final ProfileData profile;
  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameCtrl;
  late TextEditingController _bioCtrl;
  late TextEditingController _eduCtrl;
  late TextEditingController _locCtrl;
  late TextEditingController _contactCtrl;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.profile.name);
    _bioCtrl = TextEditingController(text: widget.profile.bio);
    _eduCtrl = TextEditingController(text: widget.profile.education);
    _locCtrl = TextEditingController(text: widget.profile.location);
    _contactCtrl = TextEditingController(text: widget.profile.contact);
    _imagePath = widget.profile.imagePath;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _bioCtrl.dispose();
    _eduCtrl.dispose();
    _locCtrl.dispose();
    _contactCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _imagePath = image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      appBar: AppBar(
        title: const Text('Edit Profil', style: TextStyle(fontSize: 18)),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context, _getUpdatedData()),
            icon: const Icon(Icons.check, size: 18),
            label: const Text('Simpan'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const Text('Foto Profil', style: TextStyle(color: Color(0xFF5451D6), fontWeight: FontWeight.w500)),
                  const SizedBox(height: 16),
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey.shade200,
                        backgroundImage: _imageProvider(),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 14,
                          backgroundColor: const Color(0xFF5451D6),
                          child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.collections_outlined, size: 16),
                    label: const Text('Ganti Foto dari Galeri', style: TextStyle(fontSize: 12)),
                  ),
                ],
              ),
            ),
            const Divider(height: 40),
            const Text('Informasi Profil', style: TextStyle(color: Color(0xFF5451D6), fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTextField(_nameCtrl, 'Nama Lengkap *', Icons.person_outline),
            const SizedBox(height: 16),
            _buildTextField(_bioCtrl, 'Bio / Tentang', Icons.info_outline, maxLines: 3),
            const SizedBox(height: 16),
            _buildTextField(_eduCtrl, 'Pendidikan', Icons.school_outlined),
            const SizedBox(height: 16),
            _buildTextField(_locCtrl, 'Lokasi', Icons.location_on_outlined),
            const SizedBox(height: 16),
            _buildTextField(_contactCtrl, 'Kontak', Icons.email_outlined),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, _getUpdatedData()),
                icon: const Icon(Icons.save_outlined),
                label: const Text('Simpan Perubahan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5451D6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  ImageProvider _imageProvider() {
    if (_imagePath == null || _imagePath!.isEmpty) return const NetworkImage('https://via.placeholder.com/150');
    if (_imagePath!.startsWith('http') || _imagePath!.startsWith('blob:')) return NetworkImage(_imagePath!);
    return kIsWeb ? const NetworkImage('https://via.placeholder.com/150') : FileImage(File(_imagePath!));
  }

  ProfileData _getUpdatedData() => ProfileData(
        name: _nameCtrl.text,
        bio: _bioCtrl.text,
        education: _eduCtrl.text,
        location: _locCtrl.text,
        contact: _contactCtrl.text,
        imagePath: _imagePath,
      );

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon, {int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

// =====================================================================
// UPLOAD PENGALAMAN (EDIT EXPERIENCE)
// =====================================================================

class EditExperiencePage extends StatefulWidget {
  final ExperienceData experience;
  const EditExperiencePage({super.key, required this.experience});

  @override
  State<EditExperiencePage> createState() => _EditExperiencePageState();
}

class _EditExperiencePageState extends State<EditExperiencePage> {
  late TextEditingController _titleCtrl;
  late TextEditingController _descCtrl;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _titleCtrl = TextEditingController(text: widget.experience.title);
    _descCtrl = TextEditingController(text: widget.experience.description);
    _imagePath = widget.experience.imagePath;
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) setState(() => _imagePath = image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7FF),
      appBar: AppBar(
        title: const Text('Upload Pengalaman', style: TextStyle(fontSize: 18)),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pop(context, _getUpdatedData()),
            icon: const Icon(Icons.save_outlined, size: 18),
            label: const Text('Simpan'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFF0EFFF),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFDED9FF), style: BorderStyle.solid),
                ),
                child: _imagePath == null
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.add_photo_alternate_outlined, size: 48, color: Color(0xFF5451D6)),
                          SizedBox(height: 12),
                          Text('Ketuk untuk pilih gambar', style: TextStyle(color: Color(0xFF5451D6), fontSize: 14)),
                          Text('dari galeri perangkat kamu', style: TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      )
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _imageWidget(),
                      ),
              ),
            ),
            const SizedBox(height: 32),
            const Text('Informasi Pengalaman', style: TextStyle(color: Color(0xFF5451D6), fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTextField(_titleCtrl, 'Judul *', Icons.title),
            const SizedBox(height: 16),
            _buildTextField(_descCtrl, 'Deskripsi', Icons.description_outlined, maxLines: 4),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.pop(context, _getUpdatedData()),
                icon: const Icon(Icons.save_outlined),
                label: const Text('Simpan Pengalaman'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5451D6),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imageWidget() {
    if (_imagePath == null || _imagePath!.isEmpty) return const Icon(Icons.image);
    if (_imagePath!.startsWith('http') || _imagePath!.startsWith('blob:')) return Image.network(_imagePath!, fit: BoxFit.cover);
    return kIsWeb ? Image.network('https://via.placeholder.com/150', fit: BoxFit.cover) : Image.file(File(_imagePath!), fit: BoxFit.cover);
  }

  ExperienceData _getUpdatedData() => ExperienceData(
        title: _titleCtrl.text,
        description: _descCtrl.text,
        imagePath: _imagePath,
      );

  Widget _buildTextField(TextEditingController ctrl, String label, IconData icon, {int maxLines = 1}) {
    return TextFormField(
      controller: ctrl,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }
}

// =====================================================================
// GALLERY HOME (Simplified)
// =====================================================================

class GalleryHome extends StatelessWidget {
  const GalleryHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Widget Gallery')),
      body: const Center(child: Text('Gallery Content Here')),
    );
  }
}
