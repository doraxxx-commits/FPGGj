import 'package:flutter/material.dart';
import '../core/game_engine.dart';
import '../core/fpg_theme.dart';
import 'league_table_screen.dart';
import 'lifestyle_screen.dart';
import 'manager_screen.dart';
import 'match_screen.dart';
import 'news_screen.dart';
import 'player_development_screen.dart';
import 'team_screen.dart';
import 'training_screen.dart';
import 'transfers_screen.dart';
import 'career_decision_center_screen.dart';
import 'career_storylines_screen.dart';
import 'relationship_web_screen.dart';
import 'relationship_actions_screen.dart';
import 'relationship_events_screen.dart';

class CareerHomeScreen extends StatefulWidget {
  final GameEngine engine;
  const CareerHomeScreen({super.key, required this.engine});
  @override State<CareerHomeScreen> createState() => _CareerHomeScreenState();
}

class _CareerHomeScreenState extends State<CareerHomeScreen> {
  GameEngine get engine => widget.engine;
  int tab = 0;

  void open(Widget page) async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => page));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final player = engine.careerPlayer;
    if (player == null || player.contract == null) {
      return const Scaffold(body: Center(child: Text('Brak aktywnej kariery.')));
    }
    final contract = player.contract!;
    final clubMatches = engine.clubs.where((c) => c.id == player.clubId).toList();
    if (clubMatches.isEmpty) {
      return const Scaffold(
        body: Center(child: Text('Nie znaleziono klubu zawodnika.')),
      );
    }
    final club = clubMatches.first;

    final pages = [
      _dashboard(player, contract, club),
      _worldHub(),
      _careerHub(),
      _profile(player, club),
    ];

    return Scaffold(
      backgroundColor: FPGTheme.bg,
      appBar: AppBar(
        title: Row(children: [
          Container(width: 34, height: 34, decoration: BoxDecoration(color: FPGTheme.accent, borderRadius: BorderRadius.circular(10)), child: const Icon(Icons.sports_soccer, color: Colors.black, size: 20)),
          const SizedBox(width: 10),
          const Text('FPG'),
        ]),
        actions: [
          IconButton(icon: const Icon(Icons.save_outlined), onPressed: () async {
            final ok = await engine.saveWorld();
            if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ok ? 'Gra zapisana' : 'Błąd zapisu')));
          }),
        ],
      ),
      body: SafeArea(child: IndexedStack(index: tab, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Start'),
          NavigationDestination(icon: Icon(Icons.public_outlined), selectedIcon: Icon(Icons.public), label: 'Świat'),
          NavigationDestination(icon: Icon(Icons.grid_view_outlined), selectedIcon: Icon(Icons.grid_view), label: 'Kariera'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  Widget _dashboard(dynamic player, dynamic contract, dynamic club) => ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 24), children: [
    _hero(player, club),
    const SizedBox(height: 14),
    _section('NAJBLIŻSZY MECZ'),
    _matchCard(club),
    const SizedBox(height: 18),
    _section('FORMA I STATUS'),
    Row(children: [Expanded(child: _metric('FORMA', '${player.form}', Icons.trending_up)), const SizedBox(width: 10), Expanded(child: _metric('KONDYCJA', '${player.fitness}', Icons.bolt)), const SizedBox(width: 10), Expanded(child: _metric('MORALE', '${player.morale}', Icons.mood))]),
    const SizedBox(height: 18),
    _section('DZISIAJ'),
    _actionTile(Icons.fitness_center, 'Trening', 'Popraw rozwój i walcz o skład', () => open(TrainingScreen(engine: engine))),
    _actionTile(Icons.newspaper_outlined, 'FPG News', 'Co dzieje się w świecie futbolu', () => open(NewsScreen(engine: engine))),
    _actionTile(Icons.hub_outlined, 'Centrum decyzji', 'Transfery, kontrakty, media i sponsorzy', () => open(CareerDecisionCenterScreen(engine: engine))),
  ]);

  Widget _worldHub() => ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 24), children: [
    _title('Świat futbolu', 'Świat działa również bez Ciebie.'),
    _worldCard(Icons.newspaper, 'Wiadomości', 'Transfery, trenerzy, kryzysy i wydarzenia', () => open(NewsScreen(engine: engine))),
    _worldCard(Icons.swap_horiz, 'Transfery', 'Rynek zawodników i ruchy klubów', () => open(TransfersScreen(engine: engine))),
    _worldCard(Icons.leaderboard, 'Tabele', 'Formy lig i walka o awans', () => open(LeagueTableScreen(engine: engine))),
    _worldCard(Icons.groups, 'Klub', 'Kadra, relacje i atmosfera', () => open(TeamScreen(engine: engine))),
    _worldCard(Icons.manage_accounts, 'Trener', 'Zaufanie, decyzje i hierarchia', () => open(ManagerScreen(engine: engine))),
  ]);

  Widget _careerHub() => ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 24), children: [
    _title('Kariera', 'Decyzje, które zmieniają Twoją ścieżkę.'),
    _worldCard(Icons.sports_soccer, 'Mecz', 'Rozegraj kolejkę i wpływaj na wynik', () => open(MatchScreen(engine: engine))),
    _worldCard(Icons.fitness_center, 'Trening', 'Rozwijaj atrybuty i potencjał', () => open(TrainingScreen(engine: engine))),
    _worldCard(Icons.auto_graph, 'Rozwój', 'OVR, potencjał i progres', () => open(PlayerDevelopmentScreen(engine: engine))),
    _worldCard(Icons.favorite, 'Życie', 'Relacje i decyzje poza boiskiem', () => open(LifestyleScreen(engine: engine))),
    _worldCard(Icons.swap_horiz, 'Transfery', 'Zainteresowanie klubów i negocjacje', () => open(TransfersScreen(engine: engine))),
    _worldCard(Icons.hub_outlined, 'Centrum decyzji', 'Wszystkie ważne decyzje kariery w jednym miejscu', () => open(CareerDecisionCenterScreen(engine: engine))),
    _worldCard(Icons.auto_stories_outlined, 'Historie kariery', 'Wielostopniowe wydarzenia i ich zakończenia', () => open(CareerStorylinesScreen(engine: engine))),
    _worldCard(Icons.hub_outlined, 'Sieć relacji', 'Agent, trener, klub, kibice i media', () => open(RelationshipWebScreen(engine: engine))),
    _worldCard(Icons.bolt_outlined, 'Akcje relacji', 'Wykorzystaj zaufanie i odblokowane możliwości', () => open(RelationshipActionsScreen(engine: engine))),
    _worldCard(Icons.forum_outlined, 'Wydarzenia relacji', 'Rozmowy, telefony i sytuacje wymagające decyzji', () => open(RelationshipEventsScreen(engine: engine))),
  ]);

  Widget _profile(dynamic player, dynamic club) => ListView(padding: const EdgeInsets.fromLTRB(16, 8, 16, 24), children: [
    _hero(player, club),
    const SizedBox(height: 16),
    _section('STATYSTYKI KARIERY'),
    Card(child: Padding(padding: const EdgeInsets.all(18), child: Column(children: [
      _row('Występy', '${player.careerAppearances}'),
      _row('Gole', '${player.careerGoals}'),
      _row('Asysty', '${player.careerAssists}'),
      _row('Wartość', '${(player.contract?.marketValue ?? 0).toStringAsFixed(0)} zł'),
    ]))),
    const SizedBox(height: 16),
    _worldCard(Icons.person, 'Pełny profil', 'Atrybuty, kontrakt i historia zawodnika', () {}),
  ]);

  Widget _hero(dynamic player, dynamic club) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF18212B),
            Color(0xFF0E1218),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.fullName,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      club.name,
                      style: const TextStyle(color: FPGTheme.muted),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      '${_position(player.position)} • ${player.age} lat',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: FPGTheme.accent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Text(
                    '${player.overall}',
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _mini('FORMA', '${player.form}')),
              const SizedBox(width: 8),
              Expanded(child: _mini('MORALE', '${player.morale}')),
              const SizedBox(width: 8),
              Expanded(
                child: _mini(
                  'NR',
                  '#${player.contract?.squadNumber ?? '-'}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _matchCard(dynamic club) => Card(
    child: InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => open(MatchScreen(engine: engine)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: FPGTheme.accent.withOpacity(.14),
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.sports_soccer, color: FPGTheme.accent),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('NASTĘPNA KOLEJKA', style: TextStyle(color: FPGTheme.muted, fontSize: 11, fontWeight: FontWeight.w800)),
                  SizedBox(height: 5),
                  Text('Rozegraj mecz', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                  Text('Symulacja + kluczowe akcje', style: TextStyle(color: Colors.white60)),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: FPGTheme.accent),
          ],
        ),
      ),
    ),
  );

  Widget _metric(String label, String value, IconData icon) => Card(child: Padding(padding: const EdgeInsets.all(14), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, size: 18, color: FPGTheme.accent), const SizedBox(height: 10), Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)), Text(label, style: const TextStyle(color: FPGTheme.muted, fontSize: 10, fontWeight: FontWeight.w700))])));
  Widget _mini(String label, String value) => Container(padding: const EdgeInsets.symmetric(vertical: 10), decoration: BoxDecoration(color: Colors.white.withOpacity( .055), borderRadius: BorderRadius.circular(12)), child: Column(children: [Text(value, style: const TextStyle(fontWeight: FontWeight.w900)), Text(label, style: const TextStyle(color: FPGTheme.muted, fontSize: 9))]));
  Widget _section(String t) => Padding(padding: const EdgeInsets.only(bottom: 10), child: Text(t, style: const TextStyle(fontSize: 12, letterSpacing: 1.2, fontWeight: FontWeight.w900, color: Colors.white70)));
  Widget _title(String t, String sub) => Padding(padding: const EdgeInsets.only(bottom: 18), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(t, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(sub, style: const TextStyle(color: FPGTheme.muted))]));
  Widget _worldCard(IconData icon, String title, String sub, VoidCallback onTap) => Card(margin: const EdgeInsets.only(bottom: 10), child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7), leading: Container(width: 44, height: 44, decoration: BoxDecoration(color: FPGTheme.accent.withOpacity( .10), borderRadius: BorderRadius.circular(13)), child: Icon(icon, color: FPGTheme.accent)), title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)), subtitle: Text(sub, style: const TextStyle(color: FPGTheme.muted)), trailing: const Icon(Icons.chevron_right), onTap: onTap));
  Widget _actionTile(IconData icon, String title, String sub, VoidCallback onTap) => _worldCard(icon, title, sub, onTap);
  Widget _row(String a, String b) => Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(a, style: const TextStyle(color: FPGTheme.muted)), Text(b, style: const TextStyle(fontWeight: FontWeight.w800))]));
  String _position(dynamic p) => p.toString().split('.').last.toUpperCase();
}
