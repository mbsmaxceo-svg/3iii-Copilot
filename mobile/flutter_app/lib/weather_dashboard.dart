import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:3iii_copilot/l10n/app_localizations.dart';
import 'weather_service.dart';

class WeatherDashboard extends StatefulWidget {
  const WeatherDashboard({super.key});
  @override
  State<WeatherDashboard> createState() => _WeatherDashboardState();
}

class _WeatherDashboardState extends State<WeatherDashboard> {
  final _service = WeatherService();
  final _search = TextEditingController();
  City _city = const City(name: 'Bangkok', latitude: 13.7563, longitude: 100.5018, country: 'Thailand');
  WeatherSnapshot? _weather;
  bool _loading = true;
  bool _searching = false;
  bool _fahrenheit = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final result = await _service.fetchWeather(_city, fahrenheit: _fahrenheit);
      if (mounted) setState(() { _weather = result; _loading = false; });
    } catch (_) {
      if (mounted) setState(() { _error = 'weather'; _loading = false; });
    }
  }

  Future<void> _findCity() async {
    final query = _search.text.trim();
    final l10n = AppLocalizations.of(context)!;
    if (query.isEmpty) {
      _snack(l10n.emptySearch);
      return;
    }
    setState(() => _searching = true);
    try {
      final cities = await _service.searchCities(query);
      if (!mounted) return;
      if (cities.isEmpty) {
        _snack(l10n.noCity);
      } else {
        setState(() { _city = cities.first; _weather = null; });
        await _load();
      }
    } catch (_) {
      if (mounted) _snack(l10n.errorTitle);
    } finally {
      if (mounted) setState(() => _searching = false);
    }
  }

  void _snack(String message) => ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating));

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final weather = _weather;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [Color(0xFF10263B), Color(0xFF07111F), Color(0xFF0B1725)]),
        ),
        child: SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                    sliver: SliverList.list(children: [
                      _header(l10n),
                      const SizedBox(height: 26),
                      _searchBox(l10n),
                      const SizedBox(height: 22),
                      if (_loading || _searching) _loadingCard(l10n)
                      else if (_error != null) _errorCard(l10n)
                      else if (weather != null) ...[
                        _hero(l10n, weather),
                        const SizedBox(height: 16),
                        _conditions(l10n, weather),
                        const SizedBox(height: 24),
                        _forecast(l10n, weather),
                        const SizedBox(height: 18),
                        _sunCard(l10n, weather),
                        const SizedBox(height: 18),
                        Text(l10n.updatedNow, textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white.withValues(alpha: .48), fontSize: 12)),
                      ],
                    ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _header(AppLocalizations l10n) => Row(children: [
    Container(width: 42, height: 42, decoration: BoxDecoration(
      color: const Color(0xFF69D8D0).withValues(alpha: .13), borderRadius: BorderRadius.circular(14)),
      child: const Icon(Icons.wb_cloudy_rounded, color: Color(0xFF69D8D0))),
    const SizedBox(width: 12),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(l10n.appTitle, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
      Text('3iii  •  WEATHER', style: TextStyle(color: Colors.white.withValues(alpha: .48), fontSize: 10, letterSpacing: 1.8)),
    ])),
    Semantics(label: l10n.unitLabel, child: SegmentedButton<bool>(
      segments: [
        ButtonSegment(value: false, label: Text(l10n.celsius)),
        ButtonSegment(value: true, label: Text(l10n.fahrenheit)),
      ],
      selected: {_fahrenheit},
      showSelectedIcon: false,
      style: ButtonStyle(textStyle: const WidgetStatePropertyAll(TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
        visualDensity: VisualDensity.compact, padding: const WidgetStatePropertyAll(EdgeInsets.symmetric(horizontal: 10))),
      onSelectionChanged: (value) {
        setState(() => _fahrenheit = value.first);
        _load();
      },
    )),
  ]);

  Widget _searchBox(AppLocalizations l10n) => TextField(
    controller: _search,
    textInputAction: TextInputAction.search,
    onSubmitted: (_) => _findCity(),
    decoration: InputDecoration(
      hintText: l10n.searchHint,
      prefixIcon: const Icon(Icons.search_rounded),
      suffixIcon: IconButton(tooltip: l10n.searchLabel, onPressed: _searching ? null : _findCity,
        icon: const Icon(Icons.arrow_forward_rounded)),
      filled: true,
      fillColor: Colors.white.withValues(alpha: .055),
      contentPadding: const EdgeInsets.symmetric(vertical: 17),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: Colors.white.withValues(alpha: .08))),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: BorderSide(color: Colors.white.withValues(alpha: .08))),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(18), borderSide: const BorderSide(color: Color(0xFF69D8D0), width: 1.4)),
    ),
  );

  Widget _hero(AppLocalizations l10n, WeatherSnapshot weather) {
    final code = (weather.current['weather_code'] as num).toInt();
    final temp = (weather.current['temperature_2m'] as num).round();
    final date = DateFormat('EEEE, d MMMM', Localizations.localeOf(context).toLanguageTag()).format(DateTime.now());
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: Colors.white.withValues(alpha: .10)),
        gradient: const LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight,
          colors: [Color(0xFF1C4056), Color(0xFF183246), Color(0xFF152A3B)]),
        boxShadow: [BoxShadow(color: const Color(0xFF69D8D0).withValues(alpha: .07), blurRadius: 35, spreadRadius: 1)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          const Icon(Icons.location_on_rounded, size: 17, color: Color(0xFF69D8D0)),
          const SizedBox(width: 5),
          Expanded(child: Text(_city.label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16), overflow: TextOverflow.ellipsis)),
          Text(date, style: TextStyle(color: Colors.white.withValues(alpha: .56), fontSize: 12)),
        ]),
        const SizedBox(height: 23),
        Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('$temp${weather.unit}', style: const TextStyle(fontSize: 76, height: .98, fontWeight: FontWeight.w300, letterSpacing: -4)),
            const SizedBox(height: 8),
            Text(_weatherDescription(l10n, code), style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w500)),
            const SizedBox(height: 5),
            Text('${l10n.feelsLike} ${(weather.current['apparent_temperature'] as num).round()}${weather.unit}',
              style: TextStyle(color: Colors.white.withValues(alpha: .58), fontSize: 13)),
          ])),
          _weatherIcon(code, size: 100),
        ]),
        const SizedBox(height: 23),
        Divider(color: Colors.white.withValues(alpha: .12), height: 1),
        const SizedBox(height: 16),
        Row(children: [
          Icon((weather.current['is_day'] as num).toInt() == 1 ? Icons.wb_sunny_outlined : Icons.nightlight_outlined,
            size: 16, color: const Color(0xFFF4D28C)),
          const SizedBox(width: 8),
          Text(l10n.currentWeather, style: TextStyle(color: Colors.white.withValues(alpha: .72), fontSize: 13)),
          const Spacer(),
          Text('${l10n.today}  •  ${weather.timezone.replaceAll('_', ' ')}',
            style: TextStyle(color: Colors.white.withValues(alpha: .5), fontSize: 11), overflow: TextOverflow.ellipsis),
        ]),
      ]),
    );
  }

  Widget _conditions(AppLocalizations l10n, WeatherSnapshot weather) {
    final values = [
      (Icons.water_drop_outlined, l10n.humidity, '${weather.current['relative_humidity_2m']}%'),
      (Icons.air_rounded, l10n.wind, '${(weather.current['wind_speed_10m'] as num).round()} km/h'),
      (Icons.grain_rounded, l10n.precipitation, '${(weather.daily['precipitation_probability_max'] as List).first}%'),
    ];
    return Row(children: values.map((item) => Expanded(child: Container(
      margin: EdgeInsets.only(right: item == values.last ? 0 : 10),
      padding: const EdgeInsets.all(15),
      decoration: _panelDecoration(),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Icon(item.$1, size: 19, color: const Color(0xFF69D8D0)),
        const SizedBox(height: 15),
        Text(item.$3, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700), overflow: TextOverflow.ellipsis),
        const SizedBox(height: 3),
        Text(item.$2, style: TextStyle(color: Colors.white.withValues(alpha: .54), fontSize: 11), overflow: TextOverflow.ellipsis),
      ]),
    ))).toList());
  }

  Widget _forecast(AppLocalizations l10n, WeatherSnapshot weather) {
    final daily = weather.daily;
    final dates = daily['time'] as List<dynamic>;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _sectionTitle(l10n.nextDays),
      const SizedBox(height: 12),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: _panelDecoration(),
        child: Column(children: List.generate(dates.length, (index) {
          final date = DateTime.parse(dates[index] as String);
          final code = (daily['weather_code'] as List)[index] as num;
          final high = ((daily['temperature_2m_max'] as List)[index] as num).round();
          final low = ((daily['temperature_2m_min'] as List)[index] as num).round();
          final rain = (daily['precipitation_probability_max'] as List)[index] as num;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(children: [
              SizedBox(width: 76, child: Text(index == 0 ? l10n.today : DateFormat('EEE', Localizations.localeOf(context).toLanguageTag()).format(date),
                style: TextStyle(color: Colors.white.withValues(alpha: .82), fontWeight: FontWeight.w600))),
              _weatherIcon(code.toInt(), size: 27),
              const SizedBox(width: 10),
              Expanded(child: Text(_weatherDescription(l10n, code.toInt()), style: TextStyle(color: Colors.white.withValues(alpha: .6), fontSize: 12), overflow: TextOverflow.ellipsis)),
              if (rain > 0) ...[const Icon(Icons.water_drop, size: 12, color: Color(0xFF76CDE0)), const SizedBox(width: 4), Text('$rain%', style: TextStyle(color: Colors.white.withValues(alpha: .54), fontSize: 11)), const SizedBox(width: 10)],
              Text('$high°', style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(width: 9),
              SizedBox(width: 32, child: Text('$low°', textAlign: TextAlign.end, style: TextStyle(color: Colors.white.withValues(alpha: .48)))),
            ]),
          );
        })),
      ),
    ]);
  }

  Widget _sunCard(AppLocalizations l10n, WeatherSnapshot weather) {
    final daily = weather.daily;
    String clock(String value) => DateFormat('h:mm a').format(DateTime.parse(value));
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
      decoration: _panelDecoration(),
      child: Row(children: [
        Expanded(child: _sunItem(Icons.wb_twilight_rounded, l10n.sunrise, clock((daily['sunrise'] as List).first as String))),
        Container(width: 1, height: 38, color: Colors.white.withValues(alpha: .12)),
        Expanded(child: _sunItem(Icons.nights_stay_rounded, l10n.sunset, clock((daily['sunset'] as List).first as String))),
      ]),
    );
  }

  Widget _sunItem(IconData icon, String label, String time) => Row(mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(icon, color: const Color(0xFFF4D28C), size: 22),
    const SizedBox(width: 10),
    Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: TextStyle(color: Colors.white.withValues(alpha: .52), fontSize: 11)),
      const SizedBox(height: 3),
      Text(time, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700)),
    ]),
  ]);

  Widget _sectionTitle(String title) => Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700));

  BoxDecoration _panelDecoration() => BoxDecoration(
    color: Colors.white.withValues(alpha: .045),
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color: Colors.white.withValues(alpha: .08)),
  );

  Widget _weatherIcon(int code, {required double size}) {
    final icon = switch (code) {
      0 => Icons.wb_sunny_rounded,
      1 || 2 => Icons.partly_cloudy_day_rounded,
      3 => Icons.cloud_rounded,
      45 || 48 => Icons.foggy,
      51 || 53 || 55 || 56 || 57 => Icons.grain_rounded,
      61 || 63 || 65 || 66 || 67 => Icons.water_drop_rounded,
      71 || 73 || 75 || 77 => Icons.ac_unit_rounded,
      80 || 81 || 82 => Icons rainy,
      85 || 86 => Icons.cloudy_snowing,
      95 || 96 || 99 => Icons.thunderstorm_rounded,
      _ => Icons.cloud_queue_rounded,
    };
    final color = code == 0 ? const Color(0xFFFFD27A) : const Color(0xFF9CD9E8);
    return Icon(icon, size: size, color: color);
  }

  String _weatherDescription(AppLocalizations l10n, int code) => switch (code) {
    0 => l10n.clear,
    1 => l10n.mainlyClear,
    2 => l10n.partlyCloudy,
    3 => l10n.overcast,
    45 || 48 => l10n.fog,
    51 || 53 || 55 || 56 || 57 => l10n.drizzle,
    61 || 63 || 65 || 66 || 67 => l10n.rain,
    71 || 73 || 75 || 77 => l10n.snow,
    80 || 81 || 82 || 85 || 86 => l10n.showers,
    95 || 96 || 99 => l10n.thunderstorm,
    _ => l10n.unknownWeather,
  };

  Widget _loadingCard(AppLocalizations l10n) => Container(
    padding: const EdgeInsets.all(40), decoration: _panelDecoration(),
    child: Column(children: [const CircularProgressIndicator(color: Color(0xFF69D8D0)), const SizedBox(height: 18), Text(l10n.loading)]),
  );

  Widget _errorCard(AppLocalizations l10n) => Container(
    padding: const EdgeInsets.all(24), decoration: _panelDecoration(),
    child: Column(children: [
      const Icon(Icons.cloud_off_rounded, size: 42, color: Color(0xFF9CD9E8)),
      const SizedBox(height: 12), Text(l10n.errorTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
      const SizedBox(height: 14), FilledButton.icon(onPressed: _load, icon: const Icon(Icons.refresh), label: Text(l10n.retry)),
    ]),
  );
}
