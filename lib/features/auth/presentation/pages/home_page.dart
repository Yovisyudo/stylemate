import 'package:flutter/material.dart';

class StyleMateHome extends StatelessWidget {
  const StyleMateHome({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isTablet = constraints.maxWidth >= 600;

        return isTablet ? _buildTabletLayout() : _buildMobileLayout();
      },
    );
  }

  // ============================================================
  //                    📱 MOBILE LAYOUT
  // ============================================================
  Widget _buildMobileLayout() {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      body: SafeArea(
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
              _eventCard(
                "Kencan Malam",
                "Pakaian Romantis",
                "24-12-2025",
                "30°",
              ),
              _eventCard("Rapat Ormawa", "Pakaian Formal", "21-12-2025", "30°"),
            ],
          ),
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey,
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Beranda"),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: "Lemari",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_awesome),
            label: "AI Recommend",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: "Event"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }

  // ============================================================
  //                    🖥️ TABLET LAYOUT
  // ============================================================
  Widget _buildTabletLayout() {
    return Scaffold(
      backgroundColor: const Color(0xffF4F4F4),
      body: Row(
        children: [
          // ============= SIDEBAR =============
          Container(
            width: 90,
            color: const Color(0xffA7CCEA),
            child: Column(
              children: [
                const SizedBox(height: 40),
                _sidebarIcon(Icons.home),
                _sidebarIcon(Icons.inventory_2),
                _sidebarIcon(Icons.auto_awesome),
                _sidebarIcon(Icons.event),
                _sidebarIcon(Icons.person),
              ],
            ),
          ),

          // ============= MAIN CONTENT =============
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Container(
                  width: 900, // 🔥 BIAR RAPI DAN TIDAK TERLALU KELEBARAN
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ============= HEADER BIRU TIPIS =============
                      Container(
                        height: 90,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.centerLeft,
                        decoration: const BoxDecoration(
                          color: Color(0xffA7CCEA),
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        child: const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "StyleMate",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Rekomendasi Outfit",
                              style: TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 26),

                      // ============= INTRO TEXT =============
                      const Text(
                        "Hai, Yuda!",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text("Apa outfit hari ini?"),
                      const SizedBox(height: 16),

                      _headerCard(),

                      const SizedBox(height: 26),
                      const Text(
                        "Acara Mendatang",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 12),

                      _eventCard(
                        "Kondangan",
                        "Pakaian Batik",
                        "21-12-2025",
                        "30°",
                      ),
                      _eventCard(
                        "Rapat Ormawa",
                        "Pakaian Formal",
                        "21-12-2025",
                        "30°",
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
}
