import 'package:flutter/material.dart';
import 'package:stylemate/features/event/presentation/pages/event_page.dart';
import 'package:stylemate/features/wardrobe/presentation/pages/wardrobe_page.dart';
// Pastikan import file WardrobePage Anda di sini

class StyleMateHome extends StatefulWidget {
  const StyleMateHome({super.key});

  @override
  State<StyleMateHome> createState() => _StyleMateHomeState();
}

class _StyleMateHomeState extends State<StyleMateHome> {
  int _currentIndex = 0;

  // Fungsi untuk berpindah halaman
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // List halaman yang akan ditampilkan berdasarkan index menu
    final List<Widget> _pages = [
      _HomeContent(), // Widget isi beranda yang dipisah
      const WardrobePage(),
      const EventPage(), // Halaman Lemari Anda
      const Center(child: Text("AI Recommendation Page")),
      const Center(child: Text("Event Page")),
      const Center(child: Text("Profile Page")),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTablet = constraints.maxWidth >= 600;
        return Scaffold(
          body:
              isTablet
                  ? _buildTabletLayout(_pages[_currentIndex])
                  : _pages[_currentIndex], // Menampilkan halaman aktif
          bottomNavigationBar: isTablet ? null : _buildBottomNav(),
        );
      },
    );
  }

  // ============================================================
  //                    📱 MOBILE COMPONENTS
  // ============================================================
  Widget _buildBottomNav() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      currentIndex: _currentIndex,
      onTap: _onItemTapped, // Menangani klik menu
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
        BottomNavigationBarItem(icon: Icon(Icons.inventory_2), label: "Lemari"),
        BottomNavigationBarItem(
          icon: Icon(Icons.auto_awesome),
          label: "AI Recommend",
        ),
        BottomNavigationBarItem(icon: Icon(Icons.event), label: "Event"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }

  // ============================================================
  //                    🖥️ TABLET LAYOUT
  // ============================================================
  Widget _buildTabletLayout(Widget currentPage) {
    return Row(
      children: [
        Container(
          width: 90,
          color: const Color(0xffA7CCEA),
          child: Column(
            children: [
              const SizedBox(height: 40),
              _sidebarIcon(Icons.home, 0),
              _sidebarIcon(Icons.inventory_2, 1),
              _sidebarIcon(Icons.auto_awesome, 2),
              _sidebarIcon(Icons.event, 3),
              _sidebarIcon(Icons.person, 4),
            ],
          ),
        ),
        Expanded(
          child: currentPage, // Menampilkan halaman yang dipilih di tablet
        ),
      ],
    );
  }

  Widget _sidebarIcon(IconData icon, int index) {
    return GestureDetector(
      onTap: () => _onItemTapped(index), // Klik icon sidebar
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 22),
        child: Icon(
          icon,
          size: 30,
          color: _currentIndex == index ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "StyleMate",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _headerCard(),
            const SizedBox(height: 20),
            const Text(
              "Acara Mendatang",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _eventCard("Kondangan", "Pakaian Batik", "21-12-2025", "30°"),
            _eventCard("Kencan Malam", "Pakaian Romantis", "24-12-2025", "30°"),
            _eventCard("Rapat Ormawa", "Pakaian Formal", "21-12-2025", "30°"),
          ],
        ),
      ),
    );
  }

  // Copy paste semua Helper Widget Anda (_headerCard, _eventCard, _infoBox) di sini...
  Widget _headerCard() {
    /* ... kode Anda ... */
    return Container();
  }

  Widget _eventCard(String t, String c, String d, String te) {
    /* ... kode Anda ... */
    return Container();
  }

  Widget _infoBox(String t, String v) {
    /* ... kode Anda ... */
    return Column();
  }
}

// ============================================================
//                COMPONENTS MOBILE + TABLET
// ============================================================
Widget _sidebarIcon(IconData icon) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 22),
    child: Icon(icon, size: 30, color: Colors.black87),
  );
}

Widget _headerCard() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xffAEC9FF),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _infoBox("Total Items", "12"),
        _infoBox("Acara Mendatang", "4"),
      ],
    ),
  );
}

Widget _infoBox(String title, String value) {
  return Column(
    children: [
      Text(
        title,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 6),
      Text(
        value,
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    ],
  );
}

Widget _eventCard(String title, String category, String date, String temp) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xffD8E3FA),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Text(date),
                const SizedBox(width: 6),
                const Icon(Icons.cloud, size: 18),
                Text(temp),
              ],
            ),
          ],
        ),

        const SizedBox(height: 4),
        Text(category),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xffAEC9FF),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {},
            child: const Text("Get AI Rekomendasi"),
          ),
        ),
      ],
    ),
  );
}
