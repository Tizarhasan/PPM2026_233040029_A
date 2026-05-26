import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class Catatan {
  final String judul;
  final String isi;
  final String kategori;
  final DateTime dibuatPada;

  Catatan({
    required this.judul,
    required this.isi,
    required this.kategori,
    required this.dibuatPada,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catatan Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => const HomePage());
          case '/tambah':
            return MaterialPageRoute(
              builder: (_) => const TambahCatatanPage(),
            );
          case '/edit':
            final catatan = settings.arguments as Catatan;
            return MaterialPageRoute(
              builder: (_) => TambahCatatanPage(catatan: catatan),
            );
          case '/detail':
            final args = settings.arguments as Map<String, dynamic>;
            return MaterialPageRoute(
              builder: (_) => DetailCatatanPage(
                catatan: args['catatan'],
                onUpdate: args['onUpdate'],
              ),
            );
        }
        return null;
      },
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Catatan> _catatan = [
    Catatan(
      judul: 'Belajar Flutter',
      isi: 'Mempelajari Stateful Widget, Form, dan Navigation.',
      kategori: 'Kuliah',
      dibuatPada: DateTime.now(),
    ),
  ];

  Future<void> _bukaTambahCatatan() async {
    final hasil = await Navigator.pushNamed(context, '/tambah');

    if (hasil is Catatan) {
      setState(() => _catatan.add(hasil));

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Catatan "${hasil.judul}" ditambahkan')),
      );
    }
  }

  void _updateCatatan(int index, Catatan catatanBaru) {
    setState(() {
      _catatan[index] = catatanBaru;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Catatan diperbarui')),
    );
  }

  void _hapusCatatan(int index) {
    final judul = _catatan[index].judul;
    setState(() => _catatan.removeAt(index));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Catatan "$judul" dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Catatan Mahasiswa')),
      body: _catatan.isEmpty
          ? const _EmptyState()
          : ListView.builder(
        itemCount: _catatan.length,
        itemBuilder: (context, i) {
          final c = _catatan[i];
          return ListTile(
            title: Text(c.judul),
            subtitle:
            Text('${c.kategori} • ${_formatTanggal(c.dibuatPada)}'),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: () => _hapusCatatan(i),
            ),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/detail',
                arguments: {
                  'catatan': c,
                  'onUpdate': (Catatan baru) => _updateCatatan(i, baru),
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _bukaTambahCatatan,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_alt_outlined, size: 80, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'Belum ada catatan.\nKetuk tombol + untuk menambah.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }
}

String _formatTanggal(DateTime dt) {
  return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}";
}

class TambahCatatanPage extends StatefulWidget {
  final Catatan? catatan; // Jika null = tambah, jika ada = edit
  const TambahCatatanPage({super.key, this.catatan});

  @override
  State<TambahCatatanPage> createState() => _TambahCatatanPageState();
}

class _TambahCatatanPageState extends State<TambahCatatanPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _judulCtrl;
  late TextEditingController _isiCtrl;
  late String _kategori;

  final _kategoriOpsi = const ['Kuliah', 'Tugas', 'Pribadi', 'Lainnya'];

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data lama jika sedang mode Edit
    _judulCtrl = TextEditingController(text: widget.catatan?.judul ?? '');
    _isiCtrl = TextEditingController(text: widget.catatan?.isi ?? '');
    _kategori = widget.catatan?.kategori ?? 'Kuliah';
  }

  @override
  void dispose() {
    _judulCtrl.dispose();
    _isiCtrl.dispose();
    super.dispose();
  }

  void _simpan() {
    if (!_formKey.currentState!.validate()) return;

    final catatanBaru = Catatan(
      judul: _judulCtrl.text.trim(),
      isi: _isiCtrl.text.trim(),
      kategori: _kategori,
      // Jika edit, gunakan tanggal lama. Jika baru, gunakan tanggal sekarang.
      dibuatPada: widget.catatan?.dibuatPada ?? DateTime.now(),
    );

    Navigator.pop(context, catatanBaru);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.catatan != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Catatan' : 'Tambah Catatan')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _judulCtrl,
              decoration: const InputDecoration(
                labelText: 'Judul',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Judul wajib diisi';
                if (v.trim().length < 3) return 'Minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _kategori,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: _kategoriOpsi
                  .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                  .toList(),
              onChanged: (v) => setState(() => _kategori = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _isiCtrl,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Isi',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
              validator: (v) =>
              (v == null || v.trim().isEmpty) ? 'Isi wajib diisi' : null,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _simpan,
              icon: Icon(isEdit ? Icons.edit : Icons.save),
              label: Text(isEdit ? 'Simpan Perubahan' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailCatatanPage extends StatefulWidget {
  final Catatan catatan;
  final Function(Catatan) onUpdate;

  const DetailCatatanPage({
    super.key,
    required this.catatan,
    required this.onUpdate,
  });

  @override
  State<DetailCatatanPage> createState() => _DetailCatatanPageState();
}

class _DetailCatatanPageState extends State<DetailCatatanPage> {
  late Catatan _currentCatatan;

  @override
  void initState() {
    super.initState();
    _currentCatatan = widget.catatan;
  }

  Future<void> _bukaEdit() async {
    final hasil = await Navigator.pushNamed(
      context,
      '/edit',
      arguments: _currentCatatan,
    );

    if (hasil is Catatan) {
      setState(() {
        _currentCatatan = hasil;
      });
      widget.onUpdate(hasil); // Kirim ke HomePage
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Catatan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: _bukaEdit,
            tooltip: 'Edit Catatan',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_currentCatatan.judul,
                style:
                const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Row(
              children: [
                Chip(label: Text(_currentCatatan.kategori)),
                const SizedBox(width: 12),
                Text(
                  _formatTanggal(_currentCatatan.dibuatPada),
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
            const Divider(height: 32),
            const Text('Isi Catatan:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(_currentCatatan.isi,
                style: const TextStyle(fontSize: 16, height: 1.5)),
          ],
        ),
      ),
    );
  }
}