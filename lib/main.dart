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
        fontFamily: 'Roboto',
      ),
      home: const SplashScreen(),
    );
  }
}

// ─── GLOBAL USER SESSION ─────────────────────────────────────────────────────
// In real app this comes from Firebase / shared_preferences
class UserSession {
  static bool isNewUser = true; // flip to false to test returning user view
  static List<Map<String, dynamic>> travelHistory = [];

  static void addTrip(Map<String, dynamic> bus, String destination) {
    // avoid duplicates
    final exists = travelHistory
        .any((t) => t['busNo'] == bus['busNo'] && t['to'] == destination);
    if (!exists) {
      travelHistory.insert(0, {
        ...bus,
        'to': destination,
        'lastTravelled': 'Today',
      });
    }
    isNewUser = false;
  }
}

// ─── DATA ────────────────────────────────────────────────────────────────────

final List<Map<String, dynamic>> allBuses = [
  {
    'busNo': 'KA 22 F 1234',
    'route': 'Belagavi → Gokak → Athani',
    'eta': 4,
    'distance': '2.1 km',
    'crowd': 'Moderate',
    'crowdLevel': 0.5,
    'color': Color(0xFF1A3A5C),
    'stops': [
      'Belagavi CBS', 'Tilakwadi', 'Vadgaon',
      'Gokak Falls', 'Gokak Town', 'Soudatti', 'Athani'
    ],
  },
  {
    'busNo': 'KA 22 F 5678',
    'route': 'Belagavi → Bailhongal → Saundatti',
    'eta': 11,
    'distance': '4.8 km',
    'crowd': 'Light',
    'crowdLevel': 0.2,
    'color': Color(0xFF2E7D32),
    'stops': [
      'Belagavi CBS', 'Angol', 'Hindalga', 'Bailhongal', 'Saundatti'
    ],
  },
  {
    'busNo': 'KA 22 F 9101',
    'route': 'Belagavi → Ramdurg → Badami',
    'eta': 18,
    'distance': '8.3 km',
    'crowd': 'Crowded',
    'crowdLevel': 0.9,
    'color': Color(0xFF6A1B9A),
    'stops': [
      'Belagavi CBS', 'Munavalli', 'Ramdurg', 'Lokapur', 'Badami'
    ],
  },
  {
    'busNo': 'KA 22 F 3321',
    'route': 'Belagavi → Khanapur → Dandeli',
    'eta': 28,
    'distance': '11.2 km',
    'crowd': 'Light',
    'crowdLevel': 0.15,
    'color': Color(0xFFB71C1C),
    'stops': [
      'Belagavi CBS', 'Khanapur', 'Castle Rock', 'Dandeli'
    ],
  },
  {
    'busNo': 'KA 22 F 7742',
    'route': 'Belagavi → Hukkeri → Chikkodi',
    'eta': 7,
    'distance': '3.0 km',
    'crowd': 'Crowded',
    'crowdLevel': 0.85,
    'color': Color(0xFF00695C),
    'stops': [
      'Belagavi CBS', 'Hukkeri', 'Nippani', 'Chikkodi'
    ],
  },
];

final List<String> destinations = [
  'Athani', 'Bailhongal', 'Badami', 'Chikkodi',
  'Dandeli', 'Gokak', 'Hukkeri', 'Khanapur',
  'Lokapur', 'Nippani', 'Ramdurg', 'Saundatti',
  'Soudatti', 'Tilakwadi', 'Vadgaon',
];

List<Map<String, dynamic>> busesForDestination(String dest) {
  return allBuses.where((b) {
    final stops = b['stops'] as List<String>;
    return stops.any((s) => s.toLowerCase().contains(dest.toLowerCase()));
  }).toList();
}

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
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

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
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4A024),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFFF4A024).withOpacity(0.4),
                        blurRadius: 24,
                        spreadRadius: 4)
                  ],
                ),
                child: const Icon(Icons.directions_bus,
                    color: Colors.white, size: 52),
              ),
              const SizedBox(height: 24),
              const Text('TrackBus',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 34,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1)),
              const SizedBox(height: 6),
              const Text('Belagavi Rural Bus Tracker',
                  style: TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 40),
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                    color: Color(0xFFF4A024), strokeWidth: 2.5),
              ),
            ],
          ),
        ),
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
  String _destination = '';
  final TextEditingController _destCtrl = TextEditingController();
  bool _showSuggestions = false;
  late List<Map<String, dynamic>> _arrivingBuses;
  late Timer _etaTimer;

  @override
  void initState() {
    super.initState();
    _arrivingBuses = allBuses
        .map((b) => Map<String, dynamic>.from(b))
        .toList()
      ..sort((a, b) => (a['eta'] as int).compareTo(b['eta'] as int));
    _etaTimer = Timer.periodic(const Duration(seconds: 6), (_) {
      setState(() {
        for (final b in _arrivingBuses) {
          if ((b['eta'] as int) > 1) b['eta'] = (b['eta'] as int) - 1;
        }
      });
    });
  }

  @override
  void dispose() {
    _etaTimer.cancel();
    _destCtrl.dispose();
    super.dispose();
  }

  List<String> get _filtered => destinations
      .where((d) => d.toLowerCase().contains(_destination.toLowerCase()))
      .toList();

  void _selectDest(String dest) {
    setState(() {
      _destination = dest;
      _destCtrl.text = dest;
      _showSuggestions = false;
    });
    FocusScope.of(context).unfocus();
  }

  void _onGo() {
    if (_destination.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => BusListScreen(destination: _destination)),
    ).then((_) => setState(() {})); // refresh on return so history updates
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            height: 280,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0D2137), Color(0xFF1A3A5C)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 260),
            color: const Color(0xFFF0F2F5),
          ),

          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header ──
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4A024),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.directions_bus,
                              color: Colors.white, size: 22),
                        ),
                        const SizedBox(width: 10),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('TrackBus',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800)),
                            Text('Belagavi',
                                style: TextStyle(
                                    color: Colors.white60, fontSize: 12)),
                          ],
                        ),
                        const Spacer(),
                        CircleAvatar(
                          backgroundColor: Colors.white12,
                          child: const Icon(Icons.person_outline,
                              color: Colors.white, size: 20),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Search card ──
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.18),
                              blurRadius: 20,
                              offset: const Offset(0, 8)),
                        ],
                      ),
                      child: Column(
                        children: [
                          // FROM — auto location
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FF),
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20)),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFF4A024),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('FROM',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5)),
                                      SizedBox(height: 2),
                                      Text('📍 My Current Location',
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600,
                                              color: Color(0xFF1A1A2E))),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8F5E9),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Text('Live',
                                      style: TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF2E7D32),
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            ),
                          ),

                          // Dots divider
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              children: [
                                const SizedBox(width: 4),
                                Column(
                                  children: List.generate(
                                      3,
                                      (i) => Container(
                                            width: 2,
                                            height: 5,
                                            margin: const EdgeInsets.symmetric(
                                                vertical: 1),
                                            color: Colors.grey.shade300,
                                          )),
                                ),
                              ],
                            ),
                          ),

                          // TO — type destination
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16, 6, 16, 14),
                            child: Row(
                              children: [
                                Container(
                                  width: 10,
                                  height: 10,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF1A3A5C),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text('TO',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.w600,
                                              letterSpacing: 0.5)),
                                      const SizedBox(height: 2),
                                      TextField(
                                        controller: _destCtrl,
                                        onChanged: (v) => setState(() {
                                          _destination = v;
                                          _showSuggestions = v.isNotEmpty;
                                        }),
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF1A1A2E)),
                                        decoration: const InputDecoration(
                                          hintText:
                                              'Where do you want to go?',
                                          hintStyle: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey,
                                              fontWeight: FontWeight.normal),
                                          border: InputBorder.none,
                                          isDense: true,
                                          contentPadding: EdgeInsets.zero,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (_destination.isNotEmpty)
                                  GestureDetector(
                                    onTap: () => setState(() {
                                      _destination = '';
                                      _destCtrl.clear();
                                      _showSuggestions = false;
                                    }),
                                    child: const Icon(Icons.close,
                                        color: Colors.grey, size: 18),
                                  ),
                              ],
                            ),
                          ),

                          // GO button
                          GestureDetector(
                            onTap: _onGo,
                            child: Container(
                              width: double.infinity,
                              margin:
                                  const EdgeInsets.fromLTRB(12, 0, 12, 12),
                              padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(colors: [
                                  Color(0xFF1A3A5C),
                                  Color(0xFF2D6A9F)
                                ]),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.search,
                                      color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text('FIND MY BUS',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 1)),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Suggestions dropdown ──
                  if (_showSuggestions && _filtered.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Container(
                        constraints: const BoxConstraints(maxHeight: 180),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(16)),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 10)
                          ],
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          children: _filtered
                              .map((d) => ListTile(
                                    dense: true,
                                    leading: const Icon(
                                        Icons.location_on_outlined,
                                        color: Color(0xFF1A3A5C),
                                        size: 18),
                                    title: Text(d,
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500)),
                                    onTap: () => _selectDest(d),
                                  ))
                              .toList(),
                        ),
                      ),
                    ),

                  const SizedBox(height: 20),

                  // ── Popular destinations chips ──
                  if (!_showSuggestions)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Popular destinations',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              'Gokak',
                              'Badami',
                              'Saundatti',
                              'Dandeli',
                              'Chikkodi',
                              'Athani'
                            ]
                                .map((d) => GestureDetector(
                                      onTap: () => _selectDest(d),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 14, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: Colors.white
                                              .withOpacity(0.12),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: Colors.white
                                                  .withOpacity(0.2)),
                                        ),
                                        child: Text(d,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight:
                                                    FontWeight.w500)),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  // ── CONDITIONAL SECTION ──
                  // New user → Buses Arriving Now
                  // Returning user → Frequently Travelled Routes
                  UserSession.isNewUser
                      ? _ArrivingNowSection(buses: _arrivingBuses)
                      : _FrequentRoutesSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── NEW USER: BUSES ARRIVING NOW ────────────────────────────────────────────

class _ArrivingNowSection extends StatelessWidget {
  final List<Map<String, dynamic>> buses;
  const _ArrivingNowSection({required this.buses});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.access_time,
                  color: Color(0xFF1A3A5C), size: 16),
              const SizedBox(width: 6),
              const Text('Buses Arriving Now',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E))),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.circle, color: Color(0xFF2196F3), size: 7),
                    SizedBox(width: 4),
                    Text('Live',
                        style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF1A3A5C),
                            fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Buses near Belagavi Bus Stand right now',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 12),
          ...buses.map((bus) => _ArrivingBusTile(bus: bus)).toList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _ArrivingBusTile extends StatelessWidget {
  final Map<String, dynamic> bus;
  const _ArrivingBusTile({required this.bus});

  @override
  Widget build(BuildContext context) {
    final color = bus['color'] as Color;
    final eta = bus['eta'] as int;
    final level = bus['crowdLevel'] as double;

    Color crowdColor = level < 0.4
        ? const Color(0xFF2E7D32)
        : level < 0.7
            ? const Color(0xFFF57C00)
            : const Color(0xFFC62828);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(Icons.directions_bus, color: color, size: 24),
        ),
        title: Text(bus['busNo'] as String,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1A1A2E))),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(bus['route'] as String,
                style:
                    TextStyle(fontSize: 11, color: Colors.grey.shade600),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            const SizedBox(height: 5),
            Row(
              children: [
                Icon(Icons.people, size: 12, color: crowdColor),
                const SizedBox(width: 3),
                Text(bus['crowd'] as String,
                    style: TextStyle(
                        fontSize: 11,
                        color: crowdColor,
                        fontWeight: FontWeight.w600)),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: level,
                      backgroundColor: Colors.grey.shade200,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(crowdColor),
                      minHeight: 5,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
              decoration: BoxDecoration(
                color: eta <= 5
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                eta <= 1 ? 'Now!' : '$eta min',
                style: TextStyle(
                    color: eta <= 5
                        ? const Color(0xFF2E7D32)
                        : const Color(0xFFE65100),
                    fontSize: 12,
                    fontWeight: FontWeight.w700),
              ),
            ),
            const SizedBox(height: 4),
            Text(bus['distance'] as String,
                style: TextStyle(
                    fontSize: 10, color: Colors.grey.shade500)),
          ],
        ),
      ),
    );
  }
}

// ─── RETURNING USER: FREQUENTLY TRAVELLED ROUTES ─────────────────────────────

class _FrequentRoutesSection extends StatelessWidget {
  const _FrequentRoutesSection();

  @override
  Widget build(BuildContext context) {
    final history = UserSession.travelHistory;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history, color: Color(0xFF1A3A5C), size: 16),
              const SizedBox(width: 6),
              const Text('Frequently Travelled',
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1A1A2E))),
              const Spacer(),
              Text('${history.length} route${history.length != 1 ? 's' : ''}',
                  style: const TextStyle(
                      fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 4),
          const Text('Your previously travelled bus routes',
              style: TextStyle(fontSize: 12, color: Colors.grey)),
          const SizedBox(height: 12),
          ...history
              .map((trip) => _FrequentRouteTile(trip: trip))
              .toList(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _FrequentRouteTile extends StatelessWidget {
  final Map<String, dynamic> trip;
  const _FrequentRouteTile({required this.trip});

  @override
  Widget build(BuildContext context) {
    final color = trip['color'] as Color;
    final level = trip['crowdLevel'] as double;

    Color crowdColor = level < 0.4
        ? const Color(0xFF2E7D32)
        : level < 0.7
            ? const Color(0xFFF57C00)
            : const Color(0xFFC62828);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                BusListScreen(destination: trip['to'] as String),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withOpacity(0.15)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.directions_bus, color: color, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(trip['busNo'] as String,
                            style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E))),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text('To ${trip['to']}',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: color,
                                  fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(trip['route'] as String,
                        style: TextStyle(
                            fontSize: 11, color: Colors.grey.shade600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 6),
                    // Crowd bar
                    Row(
                      children: [
                        Icon(Icons.people, size: 12, color: crowdColor),
                        const SizedBox(width: 3),
                        Text(trip['crowd'] as String,
                            style: TextStyle(
                                fontSize: 11,
                                color: crowdColor,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(3),
                            child: LinearProgressIndicator(
                              value: level,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  crowdColor),
                              minHeight: 5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(Icons.arrow_forward, color: color, size: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(trip['lastTravelled'] as String,
                      style: TextStyle(
                          fontSize: 10, color: Colors.grey.shade400)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── BUS LIST SCREEN ─────────────────────────────────────────────────────────

class BusListScreen extends StatefulWidget {
  final String destination;
  const BusListScreen({super.key, required this.destination});

  @override
  State<BusListScreen> createState() => _BusListScreenState();
}

class _BusListScreenState extends State<BusListScreen> {
  late List<Map<String, dynamic>> _buses;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _buses = busesForDestination(widget.destination)
        .map((b) => Map<String, dynamic>.from(b))
        .toList();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        for (final b in _buses) {
          if ((b['eta'] as int) > 1) b['eta'] = (b['eta'] as int) - 1;
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.48,
            child: Stack(
              children: [
                _FakeMapBackground(),
                ..._buses
                    .asMap()
                    .entries
                    .map((e) => _AnimatedBusDot(bus: e.value)),
                const Positioned(
                    top: 160, left: 170, child: _UserDot()),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    child: Row(
                      children: [
                        _mapBtn(
                            Icons.arrow_back,
                            () => Navigator.pop(context)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.08),
                                    blurRadius: 8)
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.my_location,
                                    color: Color(0xFFF4A024), size: 16),
                                const SizedBox(width: 6),
                                const Text('My Location',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w500)),
                                const Text('  →  ',
                                    style: TextStyle(color: Colors.grey)),
                                const Icon(Icons.location_on,
                                    color: Color(0xFF1A3A5C), size: 16),
                                const SizedBox(width: 4),
                                Text(widget.destination,
                                    style: const TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF1A3A5C))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.42,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 20)
                ],
              ),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2)),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                    child: Row(
                      children: [
                        Text('${_buses.length} buses near you',
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E))),
                        const Spacer(),
                        _liveBadge(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      itemCount: _buses.length,
                      itemBuilder: (_, i) => _BusListTile(
                        bus: _buses[i],
                        onTap: () {
                          // Save to travel history
                          UserSession.addTrip(
                              _buses[i], widget.destination);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  LiveBusScreen(bus: _buses[i]),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1), blurRadius: 8)
          ],
        ),
        child: Icon(icon, color: const Color(0xFF1A3A5C), size: 20),
      ),
    );
  }

  Widget _liveBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        children: [
          Icon(Icons.circle, color: Color(0xFF2196F3), size: 8),
          SizedBox(width: 4),
          Text('Live',
              style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF1A3A5C),
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── BUS LIST TILE ───────────────────────────────────────────────────────────

class _BusListTile extends StatelessWidget {
  final Map<String, dynamic> bus;
  final VoidCallback onTap;
  const _BusListTile({required this.bus, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = bus['color'] as Color;
    final eta = bus['eta'] as int;
    final level = bus['crowdLevel'] as double;
    Color crowdColor = level < 0.4
        ? const Color(0xFF2E7D32)
        : level < 0.7
            ? const Color(0xFFF57C00)
            : const Color(0xFFC62828);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3))
          ],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child:
                        Icon(Icons.directions_bus, color: color, size: 26),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(bus['busNo'] as String,
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF1A1A2E))),
                        const SizedBox(height: 3),
                        Text(bus['route'] as String,
                            style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: eta <= 5
                              ? const Color(0xFFE8F5E9)
                              : const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          eta <= 1 ? 'Arriving!' : '$eta min',
                          style: TextStyle(
                              color: eta <= 5
                                  ? const Color(0xFF2E7D32)
                                  : const Color(0xFFE65100),
                              fontSize: 13,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(bus['distance'] as String,
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey.shade500)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 8),
              child: Row(
                children: [
                  Icon(Icons.people, size: 13, color: crowdColor),
                  const SizedBox(width: 4),
                  Text('${bus['crowd']}  •  ${(level * 100).toInt()}% full',
                      style: TextStyle(
                          fontSize: 12,
                          color: crowdColor,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: level,
                        backgroundColor: Colors.grey.shade200,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(crowdColor),
                        minHeight: 6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
              child: ElevatedButton.icon(
                onPressed: onTap,
                icon: const Icon(Icons.location_searching, size: 16),
                label: const Text('Track This Bus on Map'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 40),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                  textStyle: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── FAKE MAP BACKGROUND ─────────────────────────────────────────────────────

class _FakeMapBackground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE8EFF6),
      child: CustomPaint(
          painter: _MapPainter(), child: Container()),
    );
  }
}

class _MapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 12
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final minor = Paint()
      ..color = Colors.white.withOpacity(0.6)
      ..strokeWidth = 6
      ..style = PaintingStyle.stroke;
    canvas.drawLine(Offset(0, size.height * 0.3),
        Offset(size.width, size.height * 0.3), road);
    canvas.drawLine(Offset(0, size.height * 0.6),
        Offset(size.width, size.height * 0.6), road);
    canvas.drawLine(Offset(size.width * 0.35, 0),
        Offset(size.width * 0.35, size.height), road);
    canvas.drawLine(Offset(size.width * 0.7, 0),
        Offset(size.width * 0.7, size.height), road);
    canvas.drawLine(Offset(0, size.height * 0.15),
        Offset(size.width, size.height * 0.15), minor);
    canvas.drawLine(Offset(size.width * 0.55, 0),
        Offset(size.width * 0.55, size.height), minor);
  }

  @override
  bool shouldRepaint(_) => false;
}

// ─── ANIMATED BUS DOT ────────────────────────────────────────────────────────

class _AnimatedBusDot extends StatefulWidget {
  final Map<String, dynamic> bus;
  const _AnimatedBusDot({required this.bus});
  @override
  State<_AnimatedBusDot> createState() => _AnimatedBusDotState();
}

class _AnimatedBusDotState extends State<_AnimatedBusDot> {
  final _rng = Random();
  double _top = 0, _left = 0;
  late Timer _mover;

  @override
  void initState() {
    super.initState();
    _top  = 80 + _rng.nextDouble() * 140;
    _left = 40 + _rng.nextDouble() * 280;
    _mover = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        _left =
            (_left + 3 + _rng.nextDouble() * 4).clamp(20.0, 340.0);
      });
    });
  }

  @override
  void dispose() {
    _mover.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.bus['color'] as Color;
    return AnimatedPositioned(
      duration: const Duration(seconds: 3),
      curve: Curves.linear,
      top: _top,
      left: _left,
      child: Column(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                    color: color.withOpacity(0.4), blurRadius: 6)
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.directions_bus,
                    color: Colors.white, size: 14),
                const SizedBox(width: 3),
                Text(
                  (widget.bus['busNo'] as String).split(' ').last,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          CustomPaint(
            size: const Size(10, 6),
            painter: _TrianglePainter(color: color),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  _TrianglePainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final p = Path()
      ..moveTo(size.width / 2, size.height)
      ..lineTo(0, 0)
      ..lineTo(size.width, 0)
      ..close();
    canvas.drawPath(p, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_) => false;
}

class _UserDot extends StatelessWidget {
  const _UserDot();
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF4A024).withOpacity(0.2),
            shape: BoxShape.circle,
          ),
        ),
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: const Color(0xFFF4A024),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFFF4A024).withOpacity(0.5),
                  blurRadius: 8)
            ],
          ),
        ),
      ],
    );
  }
}

// ─── LIVE BUS SCREEN ─────────────────────────────────────────────────────────

class LiveBusScreen extends StatefulWidget {
  final Map<String, dynamic> bus;
  const LiveBusScreen({super.key, required this.bus});
  @override
  State<LiveBusScreen> createState() => _LiveBusScreenState();
}

class _LiveBusScreenState extends State<LiveBusScreen> {
  double _busLeft = 60, _busTop = 160;
  int _eta = 0;
  late Timer _mover;
  final _rng = Random();

  @override
  void initState() {
    super.initState();
    _eta = widget.bus['eta'] as int;
    _mover = Timer.periodic(const Duration(seconds: 2), (_) {
      setState(() {
        _busLeft =
            (_busLeft + 5 + _rng.nextDouble() * 6).clamp(20.0, 300.0);
        _busTop = (_busTop + (_rng.nextDouble() - 0.5) * 6)
            .clamp(80.0, 260.0);
        if (_eta > 0) _eta--;
      });
    });
  }

  @override
  void dispose() {
    _mover.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.bus['color'] as Color;
    final level = widget.bus['crowdLevel'] as double;
    Color crowdColor = level < 0.4
        ? const Color(0xFF2E7D32)
        : level < 0.7
            ? const Color(0xFFF57C00)
            : const Color(0xFFC62828);

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              children: [
                _FakeMapBackground(),
                AnimatedPositioned(
                  duration: const Duration(seconds: 2),
                  curve: Curves.easeInOut,
                  top: _busTop,
                  left: _busLeft,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: color.withOpacity(0.5),
                                blurRadius: 12,
                                spreadRadius: 2)
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.directions_bus,
                                color: Colors.white, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              (widget.bus['busNo'] as String)
                                  .split(' ')
                                  .last,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      ),
                      CustomPaint(
                        size: const Size(12, 7),
                        painter: _TrianglePainter(color: color),
                      ),
                    ],
                  ),
                ),
                const Positioned(
                    top: 180, left: 180, child: _UserDot()),
              ],
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 8)
                        ],
                      ),
                      child: const Icon(Icons.arrow_back,
                          color: Color(0xFF1A3A5C), size: 20),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8)
                        ],
                      ),
                      child: Text(
                        'Tracking ${widget.bus['busNo']}',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1A1A2E)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 20)
                ],
              ),
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2)),
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: color.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(Icons.directions_bus,
                            color: color, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.bus['busNo'] as String,
                                style: const TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF1A1A2E))),
                            Text(widget.bus['route'] as String,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: _eta <= 3
                              ? const Color(0xFFE8F5E9)
                              : const Color(0xFFFFF3E0),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          children: [
                            Text(
                              _eta <= 0 ? '🎉' : '$_eta',
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: _eta <= 3
                                      ? const Color(0xFF2E7D32)
                                      : const Color(0xFFE65100)),
                            ),
                            Text(
                              _eta <= 0 ? 'Here!' : 'min',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(Icons.people, size: 15, color: Colors.grey),
                      const SizedBox(width: 6),
                      Text('Crowd level',
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600)),
                      const Spacer(),
                      Text(widget.bus['crowd'] as String,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: crowdColor)),
                      const SizedBox(width: 6),
                      Text('${(level * 100).toInt()}% full',
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      value: level,
                      backgroundColor: Colors.grey.shade200,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(crowdColor),
                      minHeight: 8,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _InfoPill(
                          icon: Icons.near_me,
                          label: widget.bus['distance'] as String,
                          color: color),
                      const SizedBox(width: 10),
                      const _InfoPill(
                          icon: Icons.circle,
                          label: 'Live Tracking',
                          color: Color(0xFF2E7D32)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _InfoPill(
      {required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(label,
              style: TextStyle(
                  fontSize: 12,
                  color: color,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
