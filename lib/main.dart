import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const TrackBusApp());
}

class TrackBusApp extends StatelessWidget {
  const TrackBusApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackBus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1A3A5C)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// ─── SESSION ─────────────────────────────────────────────────────────────────

class UserSession {
  static bool isNewUser = true;
  static List<Map<String, dynamic>> travelHistory = [];

  static void addTrip(Map<String, dynamic> bus, String destination) {
    final exists = travelHistory
        .any((t) => t['busNo'] == bus['busNo'] && t['to'] == destination);
    if (!exists) {
      travelHistory.insert(0, {...bus, 'to': destination, 'lastTravelled': 'Today'});
    }
    isNewUser = false;
  }
}

// ─── DATA ────────────────────────────────────────────────────────────────────

class BusStop {
  final String name;
  final String time;
  final String status; // passed / current / upcoming
  BusStop({required this.name, required this.time, required this.status});
}

class BusData {
  final String busNo;
  final String route;
  final String driverName;
  final String driverPhone;
  final String conductorName;
  final String conductorPhone;
  final int eta;
  final String distance;
  final String crowd;
  final double crowdLevel;
  final Color color;
  final List<BusStop> stops;

  BusData({
    required this.busNo,
    required this.route,
    required this.driverName,
    required this.driverPhone,
    required this.conductorName,
    required this.conductorPhone,
    required this.eta,
    required this.distance,
    required this.crowd,
    required this.crowdLevel,
    required this.color,
    required this.stops,
  });

  Map<String, dynamic> toMap() => {
        'busNo': busNo,
        'route': route,
        'driverName': driverName,
        'conductorName': conductorName,
        'eta': eta,
        'distance': distance,
        'crowd': crowd,
        'crowdLevel': crowdLevel,
        'color': color,
        'stops': stops,
      };
}

final List<BusData> allBuses = [
  BusData(
    busNo: 'KA 22 F 1234',
    route: 'Belagavi → Gokak → Athani',
    driverName: 'Raju Patil',
    driverPhone: '9876543210',
    conductorName: 'Suresh Kumar',
    conductorPhone: '9876543211',
    eta: 5,
    distance: '2.1 km',
    crowd: 'Moderate',
    crowdLevel: 0.5,
    color: const Color(0xFF1A3A5C),
    stops: [
      BusStop(name: 'Belagavi CBS',  time: '07:00 AM', status: 'passed'),
      BusStop(name: 'Tilakwadi',     time: '07:12 AM', status: 'passed'),
      BusStop(name: 'Vadgaon',       time: '07:25 AM', status: 'current'),
      BusStop(name: 'Gokak Falls',   time: '07:50 AM', status: 'upcoming'),
      BusStop(name: 'Gokak Town',    time: '08:10 AM', status: 'upcoming'),
      BusStop(name: 'Soudatti',      time: '08:35 AM', status: 'upcoming'),
      BusStop(name: 'Athani',        time: '09:00 AM', status: 'upcoming'),
    ],
  ),
  BusData(
    busNo: 'KA 22 F 5678',
    route: 'Belagavi → Bailhongal → Saundatti',
    driverName: 'Mahesh Desai',
    driverPhone: '9845012345',
    conductorName: 'Vinod Naik',
    conductorPhone: '9845012346',
    eta: 12,
    distance: '4.8 km',
    crowd: 'Light',
    crowdLevel: 0.2,
    color: const Color(0xFF2E7D32),
    stops: [
      BusStop(name: 'Belagavi CBS', time: '08:00 AM', status: 'passed'),
      BusStop(name: 'Angol',        time: '08:15 AM', status: 'passed'),
      BusStop(name: 'Hindalga',     time: '08:30 AM', status: 'current'),
      BusStop(name: 'Bailhongal',   time: '09:00 AM', status: 'upcoming'),
      BusStop(name: 'Saundatti',    time: '09:45 AM', status: 'upcoming'),
    ],
  ),
  BusData(
    busNo: 'KA 22 F 9101',
    route: 'Belagavi → Ramdurg → Badami',
    driverName: 'Basavraj Hungund',
    driverPhone: '9632587410',
    conductorName: 'Prakash Metri',
    conductorPhone: '9632587411',
    eta: 20,
    distance: '8.3 km',
    crowd: 'Crowded',
    crowdLevel: 0.9,
    color: const Color(0xFF6A1B9A),
    stops: [
      BusStop(name: 'Belagavi CBS', time: '09:00 AM', status: 'passed'),
      BusStop(name: 'Munavalli',    time: '09:20 AM', status: 'current'),
      BusStop(name: 'Ramdurg',      time: '10:00 AM', status: 'upcoming'),
      BusStop(name: 'Lokapur',      time: '10:30 AM', status: 'upcoming'),
      BusStop(name: 'Badami',       time: '11:15 AM', status: 'upcoming'),
    ],
  ),
  BusData(
    busNo: 'KA 22 F 7742',
    route: 'Belagavi → Hukkeri → Chikkodi',
    driverName: 'Nagesh Patil',
    driverPhone: '9741236580',
    conductorName: 'Ramesh Goudar',
    conductorPhone: '9741236581',
    eta: 8,
    distance: '3.0 km',
    crowd: 'Crowded',
    crowdLevel: 0.85,
    color: const Color(0xFF00695C),
    stops: [
      BusStop(name: 'Belagavi CBS', time: '06:30 AM', status: 'passed'),
      BusStop(name: 'Hukkeri',      time: '07:10 AM', status: 'current'),
      BusStop(name: 'Nippani',      time: '07:50 AM', status: 'upcoming'),
      BusStop(name: 'Chikkodi',     time: '08:20 AM', status: 'upcoming'),
    ],
  ),
  BusData(
    busNo: 'KA 22 F 3321',
    route: 'Belagavi → Khanapur → Dandeli',
    driverName: 'Santosh Kulkarni',
    driverPhone: '9512347896',
    conductorName: 'Girish Kamble',
    conductorPhone: '9512347897',
    eta: 30,
    distance: '11.2 km',
    crowd: 'Light',
    crowdLevel: 0.15,
    color: const Color(0xFFB71C1C),
    stops: [
      BusStop(name: 'Belagavi CBS', time: '10:00 AM', status: 'passed'),
      BusStop(name: 'Khanapur',     time: '10:45 AM', status: 'current'),
      BusStop(name: 'Castle Rock',  time: '11:30 AM', status: 'upcoming'),
      BusStop(name: 'Dandeli',      time: '12:15 PM', status: 'upcoming'),
    ],
  ),
];

List<BusData> searchBuses(String from, String to) {
  if (from.isEmpty || to.isEmpty) return [];
  return allBuses.where((bus) {
    final names = bus.stops.map((s) => s.name.toLowerCase()).toList();
    final fi = names.indexWhere((n) => n.contains(from.toLowerCase()));
    final ti = names.indexWhere((n) => n.contains(to.toLowerCase()));
    return fi != -1 && ti != -1 && fi < ti;
  }).toList();
}

final List<String> allStops = [
  'Belagavi CBS', 'Tilakwadi', 'Vadgaon', 'Gokak Falls',
  'Gokak Town', 'Soudatti', 'Athani', 'Angol', 'Hindalga',
  'Bailhongal', 'Saundatti', 'Munavalli', 'Ramdurg', 'Lokapur',
  'Badami', 'Hukkeri', 'Nippani', 'Chikkodi', 'Khanapur',
  'Castle Rock', 'Dandeli',
];

// ─── SPLASH ──────────────────────────────────────────────────────────────────

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MainShell()));
    });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D2137),
      body: FadeTransition(
        opacity: _fade,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90, height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4A024),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [BoxShadow(color: const Color(0xFFF4A024).withOpacity(0.4), blurRadius: 24, spreadRadius: 4)],
                ),
                child: const Icon(Icons.directions_bus, color: Colors.white, size: 52),
              ),
              const SizedBox(height: 24),
              const Text('TrackBus', style: TextStyle(color: Colors.white, fontSize: 34, fontWeight: FontWeight.w800, letterSpacing: 1)),
              const SizedBox(height: 6),
              const Text('Belagavi Rural Bus Tracker', style: TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 40),
              const SizedBox(width: 28, height: 28, child: CircularProgressIndicator(color: Color(0xFFF4A024), strokeWidth: 2.5)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── MAIN SHELL ──────────────────────────────────────────────────────────────

class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _index = 0;
  final List<Widget> _screens = const [HomeScreen(), SearchScreen(), SavedRoutesScreen(), ProfileScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFF1A3A5C),
        unselectedItemColor: Colors.grey,
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.bookmark), label: 'Saved Routes'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

// ─── HOME SCREEN ─────────────────────────────────────────────────────────────

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late List<BusData> _arriving;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _arriving = List.from(allBuses)..sort((a, b) => a.eta.compareTo(b.eta));
    _timer = Timer.periodic(const Duration(seconds: 6), (_) => setState(() {}));
  }

  @override
  void dispose() { _timer.cancel(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Stack(
        children: [
          Container(height: 260, decoration: const BoxDecoration(gradient: LinearGradient(colors: [Color(0xFF0D2137), Color(0xFF1A3A5C)], begin: Alignment.topCenter, end: Alignment.bottomCenter))),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                    child: Row(
                      children: [
                        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF4A024), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.directions_bus, color: Colors.white, size: 22)),
                        const SizedBox(width: 10),
                        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text('TrackBus', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                          Text('Belagavi', style: TextStyle(color: Colors.white60, fontSize: 12)),
                        ]),
                        const Spacer(),
                        const CircleAvatar(backgroundColor: Colors.white12, child: Icon(Icons.person_outline, color: Colors.white, size: 20)),
                      ],
                    ),
                  ),
                  // Location pill
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
                      child: const Row(children: [
                        Icon(Icons.location_on, color: Color(0xFFF4A024), size: 18),
                        SizedBox(width: 8),
                        Text('📍 My Current Location — Belagavi CBS', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w500)),
                      ]),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Conditional section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: UserSession.isNewUser
                        ? _ArrivingSection(buses: _arriving)
                        : _FrequentSection(),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ArrivingSection extends StatelessWidget {
  final List<BusData> buses;
  const _ArrivingSection({required this.buses});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Icon(Icons.access_time, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          const Text('Buses Arriving Now', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
          const Spacer(),
          Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: const Color(0xFFE3F2FD), borderRadius: BorderRadius.circular(20)),
            child: const Row(children: [Icon(Icons.circle, color: Color(0xFF2196F3), size: 7), SizedBox(width: 4), Text('Live', style: TextStyle(fontSize: 11, color: Color(0xFF1A3A5C), fontWeight: FontWeight.w600))])),
        ]),
        const SizedBox(height: 12),
        ...buses.map((bus) => _HomeBusTile(bus: bus)).toList(),
      ],
    );
  }
}

class _HomeBusTile extends StatelessWidget {
  final BusData bus;
  const _HomeBusTile({required this.bus});

  @override
  Widget build(BuildContext context) {
    final level = bus.crowdLevel;
    Color crowdColor = level < 0.4 ? const Color(0xFF2E7D32) : level < 0.7 ? const Color(0xFFF57C00) : const Color(0xFFC62828);
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BusDetailScreen(bus: bus))),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))]),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(width: 44, height: 44, decoration: BoxDecoration(color: bus.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.directions_bus, color: bus.color, size: 24)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(bus.busNo, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                Text(bus.route, style: TextStyle(fontSize: 11, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                Row(children: [
                  Icon(Icons.people, size: 12, color: crowdColor),
                  const SizedBox(width: 3),
                  Text(bus.crowd, style: TextStyle(fontSize: 11, color: crowdColor, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(3), child: LinearProgressIndicator(value: level, backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation<Color>(crowdColor), minHeight: 5))),
                ]),
              ])),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(color: bus.eta <= 5 ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(20)),
                child: Text(bus.eta <= 1 ? 'Now!' : '${bus.eta} min', style: TextStyle(color: bus.eta <= 5 ? const Color(0xFF2E7D32) : const Color(0xFFE65100), fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FrequentSection extends StatelessWidget {
  const _FrequentSection();
  @override
  Widget build(BuildContext context) {
    final history = UserSession.travelHistory;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(children: [
          Icon(Icons.history, color: Colors.white, size: 16),
          SizedBox(width: 6),
          Text('Frequently Travelled', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: Colors.white)),
        ]),
        const SizedBox(height: 12),
        ...history.map((t) => GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen())),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
            child: ListTile(
              leading: Container(width: 44, height: 44, decoration: BoxDecoration(color: (t['color'] as Color).withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.directions_bus, color: t['color'] as Color, size: 24)),
              title: Text(t['busNo'] as String, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              subtitle: Text('To ${t['to']}', style: const TextStyle(fontSize: 11)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
            ),
          ),
        )).toList(),
      ],
    );
  }
}

// ─── SEARCH SCREEN ───────────────────────────────────────────────────────────

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _fromCtrl = TextEditingController();
  final _toCtrl   = TextEditingController();
  String _from = '';
  String _to   = '';
  List<BusData> _results = [];
  bool _searched = false;

  bool _showFromSug = false;
  bool _showToSug   = false;

  List<String> _filter(String q) => allStops.where((s) => s.toLowerCase().contains(q.toLowerCase())).toList();

  void _search() {
    setState(() {
      _results = searchBuses(_from, _to);
      _searched = true;
      _showFromSug = false;
      _showToSug   = false;
    });
    FocusScope.of(context).unfocus();
  }

  @override
  void dispose() { _fromCtrl.dispose(); _toCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Column(
        children: [
          // ── Search card header ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [Color(0xFF0D2137), Color(0xFF1A3A5C)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Row(children: [
                      Container(padding: const EdgeInsets.all(7), decoration: BoxDecoration(color: const Color(0xFFF4A024), borderRadius: BorderRadius.circular(9)), child: const Icon(Icons.directions_bus, color: Colors.white, size: 18)),
                      const SizedBox(width: 10),
                      const Text('Find My Bus', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                    ]),
                    const SizedBox(height: 16),
                    // FROM box
                    Container(
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]),
                      child: Column(
                        children: [
                          // FROM
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 12, 14, 6),
                            child: Row(children: [
                              Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFFF4A024), shape: BoxShape.circle)),
                              const SizedBox(width: 10),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const Text('FROM', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                                TextField(
                                  controller: _fromCtrl,
                                  onChanged: (v) => setState(() { _from = v; _showFromSug = v.isNotEmpty; _showToSug = false; }),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
                                  decoration: const InputDecoration(hintText: 'Your current stop...', hintStyle: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.normal), border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                                ),
                              ])),
                              if (_from.isNotEmpty) GestureDetector(onTap: () => setState(() { _from = ''; _fromCtrl.clear(); _showFromSug = false; }), child: const Icon(Icons.close, size: 16, color: Colors.grey)),
                            ]),
                          ),
                          Padding(padding: const EdgeInsets.symmetric(horizontal: 14), child: Divider(height: 1, color: Colors.grey.shade200)),
                          // TO
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 6, 14, 12),
                            child: Row(children: [
                              Container(width: 10, height: 10, decoration: const BoxDecoration(color: Color(0xFF1A3A5C), shape: BoxShape.circle)),
                              const SizedBox(width: 10),
                              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                                const Text('TO', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                                TextField(
                                  controller: _toCtrl,
                                  onChanged: (v) => setState(() { _to = v; _showToSug = v.isNotEmpty; _showFromSug = false; }),
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E)),
                                  decoration: const InputDecoration(hintText: 'Where do you want to go?', hintStyle: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.normal), border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
                                ),
                              ])),
                              if (_to.isNotEmpty) GestureDetector(onTap: () => setState(() { _to = ''; _toCtrl.clear(); _showToSug = false; }), child: const Icon(Icons.close, size: 16, color: Colors.grey)),
                            ]),
                          ),
                        ],
                      ),
                    ),
                    // Suggestions
                    if (_showFromSug && _filter(_from).isNotEmpty)
                      _SuggestionBox(items: _filter(_from), onTap: (s) => setState(() { _from = s; _fromCtrl.text = s; _showFromSug = false; })),
                    if (_showToSug && _filter(_to).isNotEmpty)
                      _SuggestionBox(items: _filter(_to), onTap: (s) => setState(() { _to = s; _toCtrl.text = s; _showToSug = false; })),
                    const SizedBox(height: 12),
                    // Search button
                    GestureDetector(
                      onTap: _search,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(color: const Color(0xFFF4A024), borderRadius: BorderRadius.circular(12)),
                        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Icon(Icons.search, color: Colors.white, size: 20),
                          SizedBox(width: 8),
                          Text('SEARCH BUSES', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // ── Results ──
          Expanded(
            child: !_searched
                ? _searchHint()
                : _results.isEmpty
                    ? _noResult()
                    : ListView(
                        padding: const EdgeInsets.all(14),
                        children: [
                          Text('${_results.length} bus${_results.length > 1 ? 'es' : ''} found from $_from to $_to',
                              style: const TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 10),
                          ..._results.map((bus) => _ResultTile(bus: bus, destination: _to)).toList(),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  Widget _searchHint() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
    Icon(Icons.directions_bus_outlined, size: 60, color: Colors.grey),
    SizedBox(height: 12),
    Text('Enter your stop and destination', style: TextStyle(fontSize: 14, color: Colors.grey)),
  ]));

  Widget _noResult() => Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
    const Icon(Icons.sentiment_dissatisfied, size: 60, color: Colors.grey),
    const SizedBox(height: 12),
    Text('No direct bus from $_from to $_to', style: const TextStyle(fontSize: 14, color: Colors.grey)),
    const SizedBox(height: 6),
    const Text('Try going via Belagavi CBS', style: TextStyle(fontSize: 12, color: Colors.grey)),
  ]));
}

class _SuggestionBox extends StatelessWidget {
  final List<String> items;
  final void Function(String) onTap;
  const _SuggestionBox({required this.items, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 4),
      constraints: const BoxConstraints(maxHeight: 140),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8)]),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: items.map((s) => ListTile(
          dense: true,
          leading: const Icon(Icons.location_on_outlined, color: Color(0xFF1A3A5C), size: 16),
          title: Text(s, style: const TextStyle(fontSize: 13)),
          onTap: () => onTap(s),
        )).toList(),
      ),
    );
  }
}

class _ResultTile extends StatelessWidget {
  final BusData bus;
  final String destination;
  const _ResultTile({required this.bus, required this.destination});

  @override
  Widget build(BuildContext context) {
    final level = bus.crowdLevel;
    Color crowdColor = level < 0.4 ? const Color(0xFF2E7D32) : level < 0.7 ? const Color(0xFFF57C00) : const Color(0xFFC62828);
    return GestureDetector(
      onTap: () {
        UserSession.addTrip(bus.toMap(), destination);
        Navigator.push(context, MaterialPageRoute(builder: (_) => BusDetailScreen(bus: bus)));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))]),
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Container(width: 48, height: 48, decoration: BoxDecoration(color: bus.color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.directions_bus, color: bus.color, size: 26)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(bus.busNo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                Text(bus.route, style: TextStyle(fontSize: 12, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
              ])),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: bus.eta <= 5 ? const Color(0xFFE8F5E9) : const Color(0xFFFFF3E0), borderRadius: BorderRadius.circular(20)),
                child: Text(bus.eta <= 1 ? 'Now!' : '${bus.eta} min', style: TextStyle(color: bus.eta <= 5 ? const Color(0xFF2E7D32) : const Color(0xFFE65100), fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
            child: Row(children: [
              Icon(Icons.people, size: 13, color: crowdColor),
              const SizedBox(width: 4),
              Text('${bus.crowd}  •  ${(level * 100).toInt()}% full', style: TextStyle(fontSize: 12, color: crowdColor, fontWeight: FontWeight.w600)),
              const SizedBox(width: 8),
              Expanded(child: ClipRRect(borderRadius: BorderRadius.circular(4), child: LinearProgressIndicator(value: level, backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation<Color>(crowdColor), minHeight: 6))),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
            child: ElevatedButton.icon(
              onPressed: () {
                UserSession.addTrip(bus.toMap(), destination);
                Navigator.push(context, MaterialPageRoute(builder: (_) => BusDetailScreen(bus: bus)));
              },
              icon: const Icon(Icons.location_searching, size: 16),
              label: const Text('View Bus Details'),
              style: ElevatedButton.styleFrom(backgroundColor: bus.color, foregroundColor: Colors.white, minimumSize: const Size(double.infinity, 40), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), elevation: 0, textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ),
        ]),
      ),
    );
  }
}

// ─── BUS DETAIL SCREEN ───────────────────────────────────────────────────────

class BusDetailScreen extends StatefulWidget {
  final BusData bus;
  const BusDetailScreen({super.key, required this.bus});
  @override
  State<BusDetailScreen> createState() => _BusDetailScreenState();
}

class _BusDetailScreenState extends State<BusDetailScreen> {
  late int _eta;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _eta = widget.bus.eta;
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() { if (_eta > 0) _eta--; });
    });
  }

  @override
  void dispose() { _timer.cancel(); super.dispose(); }

  Color get _crowdColor => widget.bus.crowdLevel < 0.4 ? const Color(0xFF2E7D32) : widget.bus.crowdLevel < 0.7 ? const Color(0xFFF57C00) : const Color(0xFFC62828);

  IconData get _crowdIcon => widget.bus.crowdLevel < 0.4 ? Icons.sentiment_very_satisfied : widget.bus.crowdLevel < 0.7 ? Icons.sentiment_neutral : Icons.sentiment_very_dissatisfied;

  @override
  Widget build(BuildContext context) {
    final bus   = widget.bus;
    final color = bus.color;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Hero header ──
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [color, color.withOpacity(0.8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              ),
              child: SafeArea(
                bottom: false,
                child: Column(
                  children: [
                    // Back + title
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Row(children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle), child: const Icon(Icons.arrow_back, color: Colors.white, size: 20)),
                        ),
                        const SizedBox(width: 12),
                        const Text('Bus Details', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                        const Spacer(),
                        Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                          child: const Row(children: [Icon(Icons.circle, color: Colors.greenAccent, size: 8), SizedBox(width: 4), Text('Live', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600))])),
                      ]),
                    ),
                    // TrackBus logo + bus number
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                      child: Row(children: [
                        Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(14)), child: const Icon(Icons.directions_bus, color: Colors.white, size: 32)),
                        const SizedBox(width: 14),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          const Text('TrackBus', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500, letterSpacing: 1)),
                          Text(bus.busNo, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w800)),
                          Text(bus.route, style: const TextStyle(color: Colors.white70, fontSize: 12)),
                        ]),
                      ]),
                    ),
                  ],
                ),
              ),
            ),

            // ── Driver & Conductor ──
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                    child: Text('Staff Details', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.grey.shade700, letterSpacing: 0.3)),
                  ),
                  Divider(height: 1, color: Colors.grey.shade100),
                  _StaffRow(icon: Icons.drive_eta, label: 'Driver', name: bus.driverName, phone: bus.driverPhone, color: color),
                  Divider(height: 1, color: Colors.grey.shade100, indent: 56),
                  _StaffRow(icon: Icons.confirmation_number, label: 'Conductor', name: bus.conductorName, phone: bus.conductorPhone, color: color),
                ],
              ),
            ),

            // ── 3 info boxes ──
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(children: [
                // ETA
                Expanded(child: _InfoBox(
                  color: color,
                  icon: Icons.access_time_filled,
                  label: 'Arrival Time',
                  value: _eta <= 0 ? 'Here!' : '$_eta min',
                  sub: _eta <= 0 ? 'Bus arrived' : 'away from you',
                )),
                const SizedBox(width: 10),
                // Distance
                Expanded(child: _InfoBox(
                  color: const Color(0xFF1565C0),
                  icon: Icons.straighten,
                  label: 'Distance',
                  value: bus.distance,
                  sub: 'from your stop',
                )),
                const SizedBox(width: 10),
                // Crowd
                Expanded(child: _InfoBox(
                  color: _crowdColor,
                  icon: _crowdIcon,
                  label: 'Crowd',
                  value: bus.crowd,
                  sub: '${(bus.crowdLevel * 100).toInt()}% full',
                  progress: bus.crowdLevel,
                )),
              ]),
            ),

            // ── Route Timeline ──
            Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
                    child: Row(children: [
                      Icon(Icons.route, color: color, size: 18),
                      const SizedBox(width: 6),
                      Text('Route & Live Position', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.grey.shade700)),
                    ]),
                  ),
                  Divider(height: 1, color: Colors.grey.shade100),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Column(
                      children: bus.stops.asMap().entries.map((entry) {
                        final i    = entry.key;
                        final stop = entry.value;
                        final isLast = i == bus.stops.length - 1;
                        return _StopTimelineTile(stop: stop, color: color, isLast: isLast);
                      }).toList(),
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

class _StaffRow extends StatelessWidget {
  final IconData icon;
  final String label, name, phone;
  final Color color;
  const _StaffRow({required this.icon, required this.label, required this.name, required this.phone, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(children: [
        Container(width: 40, height: 40, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 20)),
        const SizedBox(width: 12),
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w600, letterSpacing: 0.3)),
          Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
        ]),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: const Color(0xFFE8F5E9), borderRadius: BorderRadius.circular(20)),
          child: Row(children: [const Icon(Icons.phone, size: 12, color: Color(0xFF2E7D32)), const SizedBox(width: 4), Text(phone, style: const TextStyle(fontSize: 11, color: Color(0xFF2E7D32), fontWeight: FontWeight.w600))]),
        ),
      ]),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label, value, sub;
  final double? progress;
  const _InfoBox({required this.color, required this.icon, required this.label, required this.value, required this.sub, this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(width: 36, height: 36, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 20)),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500)),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: color)),
        Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        if (progress != null) ...[
          const SizedBox(height: 6),
          ClipRRect(borderRadius: BorderRadius.circular(3), child: LinearProgressIndicator(value: progress, backgroundColor: Colors.grey.shade200, valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 4)),
        ],
      ]),
    );
  }
}

class _StopTimelineTile extends StatelessWidget {
  final BusStop stop;
  final Color color;
  final bool isLast;
  const _StopTimelineTile({required this.stop, required this.color, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final isPassed  = stop.status == 'passed';
    final isCurrent = stop.status == 'current';

    Color dotColor = isCurrent ? color : isPassed ? Colors.grey.shade400 : Colors.grey.shade300;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Timeline
        SizedBox(
          width: 28,
          child: Column(children: [
            Container(
              width: isCurrent ? 18 : 12,
              height: isCurrent ? 18 : 12,
              decoration: BoxDecoration(
                color: dotColor,
                shape: BoxShape.circle,
                border: isCurrent ? Border.all(color: color.withOpacity(0.3), width: 3) : null,
                boxShadow: isCurrent ? [BoxShadow(color: color.withOpacity(0.4), blurRadius: 6)] : null,
              ),
            ),
            if (!isLast) Container(width: 2, height: 44, color: isPassed ? Colors.grey.shade300 : Colors.grey.shade200),
          ]),
        ),
        const SizedBox(width: 12),
        // Stop info
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(stop.name, style: TextStyle(fontSize: 14, fontWeight: isCurrent ? FontWeight.w700 : FontWeight.w500, color: isPassed ? Colors.grey : const Color(0xFF1A1A2E)))),
                    Text(stop.time, style: TextStyle(fontSize: 12, color: isPassed ? Colors.grey : const Color(0xFF1A3A5C), fontWeight: isCurrent ? FontWeight.w700 : FontWeight.normal)),
                  ],
                ),
                if (isCurrent) ...[
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Icon(Icons.directions_bus, size: 12, color: color),
                      const SizedBox(width: 4),
                      Text('Bus is here now', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600)),
                    ]),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }

}

// ─── SAVED ROUTES SCREEN ────────────────────────────────────────────────────

class SavedRoutesScreen extends StatelessWidget {
  const SavedRoutesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final history = UserSession.travelHistory;
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A3A5C),
        title: const Text('Saved Routes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: history.isEmpty
          ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
              Icon(Icons.bookmark_outline, size: 60, color: Colors.grey),
              SizedBox(height: 16),
              Text('No saved routes yet', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.grey)),
              SizedBox(height: 8),
              Text('Travel on a bus to save routes here', style: TextStyle(fontSize: 13, color: Colors.grey)),
            ]))
          : ListView(
              padding: const EdgeInsets.all(14),
              children: [
                const Text('YOUR TRAVELLED ROUTES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 0.5)),
                const SizedBox(height: 10),
                ...history.map((t) {
                  final color = t['color'] as Color;
                  return GestureDetector(
                    onTap: () {
                      final bus = allBuses.firstWhere((b) => b.busNo == t['busNo'], orElse: () => allBuses.first);
                      Navigator.push(context, MaterialPageRoute(builder: (_) => BusDetailScreen(bus: bus)));
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8)]),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(children: [
                          Container(width: 46, height: 46, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.directions_bus, color: color, size: 24)),
                          const SizedBox(width: 12),
                          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(t['busNo'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFF1A1A2E))),
                            Text(t['route'] as String, style: TextStyle(fontSize: 12, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 4),
                            Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                              child: Text('To ${t['to']}', style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600))),
                          ])),
                          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                            const SizedBox(height: 6),
                            Text(t['lastTravelled'] as String, style: TextStyle(fontSize: 10, color: Colors.grey.shade400)),
                          ]),
                        ]),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
    );
  }
}

// ─── PROFILE SCREEN ──────────────────────────────────────────────────────────

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Column(
        children: [
          // ── Blue top half with user details ──
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D2137), Color(0xFF1A3A5C)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                child: Column(
                  children: [
                    // Top bar
                    Row(children: [
                      Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFF4A024), borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.directions_bus, color: Colors.white, size: 22)),
                      const SizedBox(width: 10),
                      const Text('TrackBus', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                    ]),
                    const SizedBox(height: 24),
                    // User photo
                    Stack(
                      children: [
                        Container(
                          width: 90, height: 90,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.15),
                            border: Border.all(color: Colors.white.withOpacity(0.5), width: 3),
                          ),
                          child: const Icon(Icons.person, color: Colors.white, size: 52),
                        ),
                        Positioned(
                          bottom: 2, right: 2,
                          child: Container(
                            width: 26, height: 26,
                            decoration: const BoxDecoration(color: Color(0xFFF4A024), shape: BoxShape.circle),
                            child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // User name & info
                    const Text('Rahul Patil', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 4),
                    const Text('rahulpatil@gmail.com', style: TextStyle(color: Colors.white60, fontSize: 13)),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                      child: const Text('📍 Belagavi, Karnataka', style: TextStyle(color: Colors.white, fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── White bottom with options ──
          Expanded(
            child: Container(
              color: Colors.white,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text('ACCOUNT OPTIONS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 0.5)),
                  const SizedBox(height: 14),
                  _ProfileOption(icon: Icons.edit, label: 'Edit Profile', sub: 'Update your name, phone, photo', color: const Color(0xFF1A3A5C),
                    onTap: () => _showSnack(context, 'Edit Profile coming soon!')),
                  _ProfileOption(icon: Icons.school, label: 'Student Registration', sub: 'Register for student bus pass', color: const Color(0xFF2E7D32),
                    onTap: () => _showSnack(context, 'Student Registration coming soon!')),
                  _ProfileOption(icon: Icons.bookmark, label: 'Edit Saved Routes', sub: 'Manage your saved bus routes', color: const Color(0xFF6A1B9A),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SavedRoutesScreen()))),
                  _ProfileOption(icon: Icons.notifications_outlined, label: 'Notifications', sub: 'Manage bus arrival alerts', color: const Color(0xFFF57C00),
                    onTap: () => _showSnack(context, 'Notifications coming soon!')),
                  const SizedBox(height: 8),
                  const Text('MORE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.grey, letterSpacing: 0.5)),
                  const SizedBox(height: 14),
                  _ProfileOption(icon: Icons.help_outline, label: 'Help & Support', sub: 'FAQs and contact us', color: Colors.grey,
                    onTap: () => _showSnack(context, 'Help coming soon!')),
                  _ProfileOption(icon: Icons.logout, label: 'Logout', sub: 'Sign out of your account', color: const Color(0xFFC62828),
                    onTap: () => _showSnack(context, 'Logged out!')),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: const Color(0xFF1A3A5C)));
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label, sub;
  final Color color;
  final VoidCallback onTap;

  const _ProfileOption({required this.icon, required this.label, required this.sub, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Row(children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 22)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A1A2E))),
            Text(sub, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ])),
          Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
        ]),
      ),
    );
  }
}
