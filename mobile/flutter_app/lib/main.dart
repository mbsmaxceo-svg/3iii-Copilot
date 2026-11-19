import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'l10n/generated/app_localizations.dart';

const _supabaseUrl = String.fromEnvironment('SUPABASE_URL');
const _supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
const _authRedirectUrl = 'io.supabase.iii_copilot://login-callback';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isConfigured = _supabaseUrl.isNotEmpty && _supabaseAnonKey.isNotEmpty;
  if (isConfigured) {
    await Supabase.initialize(url: _supabaseUrl, anonKey: _supabaseAnonKey);
  }
  runApp(CopilotApp(isSupabaseConfigured: isConfigured));
}

class CopilotApp extends StatelessWidget {
  const CopilotApp({required this.isSupabaseConfigured, super.key});

  final bool isSupabaseConfigured;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)), useMaterial3: true),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: isSupabaseConfigured
          ? const _SessionGate()
          : const _AuthScreen(isSupabaseConfigured: false),
    );
  }
}

class _SessionGate extends StatelessWidget {
  const _SessionGate();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = snapshot.data?.session ?? Supabase.instance.client.auth.currentSession;
        return session == null ? const _AuthScreen(isSupabaseConfigured: true) : const _WorkspaceScreen();
      },
    );
  }
}

class _AuthScreen extends StatefulWidget {
  const _AuthScreen({required this.isSupabaseConfigured});

  final bool isSupabaseConfigured;

  @override
  State<_AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<_AuthScreen> {
  bool _isSigningIn = false;
  String? _errorMessage;

  Future<void> _signIn(OAuthProvider provider) async {
    if (!widget.isSupabaseConfigured || _isSigningIn) return;
    setState(() {
      _isSigningIn = true;
      _errorMessage = null;
    });
    try {
      await Supabase.instance.client.auth.signInWithOAuth(provider, redirectTo: _authRedirectUrl);
    } catch (_) {
      if (mounted) setState(() => _errorMessage = AppLocalizations.of(context).signInError);
    } finally {
      if (mounted) setState(() => _isSigningIn = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(Icons.code_rounded, size: 56),
                  const SizedBox(height: 20),
                  Text(l10n.appTitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 12),
                  Text(l10n.signInTitle, textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 8),
                  Text(l10n.signInSubtitle, textAlign: TextAlign.center),
                  const SizedBox(height: 24),
                  if (!widget.isSupabaseConfigured) ...[
                    Text(l10n.configMissing, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                  ],
                  if (_errorMessage != null) ...[
                    Text(_errorMessage!, textAlign: TextAlign.center, style: TextStyle(color: Theme.of(context).colorScheme.error)),
                    const SizedBox(height: 12),
                  ],
                  _providerButton(l10n.continueWithGoogle, OAuthProvider.google),
                  const SizedBox(height: 10),
                  _providerButton(l10n.continueWithGithub, OAuthProvider.github),
                  const SizedBox(height: 10),
                  _providerButton(l10n.continueWithMicrosoft, OAuthProvider.azure),
                  if (_isSigningIn) ...[
                    const SizedBox(height: 16),
                    Text(l10n.authLoading, textAlign: TextAlign.center),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _providerButton(String label, OAuthProvider provider) {
    return OutlinedButton(
      onPressed: widget.isSupabaseConfigured && !_isSigningIn ? () => _signIn(provider) : null,
      child: Text(label, textAlign: TextAlign.center),
    );
  }
}

class _WorkspaceScreen extends StatefulWidget {
  const _WorkspaceScreen();

  @override
  State<_WorkspaceScreen> createState() => _WorkspaceScreenState();
}

class _WorkspaceScreenState extends State<_WorkspaceScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pages = [
      _HomePage(onViewProjects: () => setState(() => _selectedIndex = 1)),
      const _ProjectsPage(),
      const _ProfilePage(),
    ];
    return Scaffold(
      body: SafeArea(child: IndexedStack(index: _selectedIndex, children: pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        destinations: [
          NavigationDestination(icon: const Icon(Icons.home_outlined), selectedIcon: const Icon(Icons.home), label: l10n.navigationHome),
          NavigationDestination(icon: const Icon(Icons.folder_outlined), selectedIcon: const Icon(Icons.folder), label: l10n.navigationProjects),
          NavigationDestination(icon: const Icon(Icons.person_outline), selectedIcon: const Icon(Icons.person), label: l10n.navigationProfile),
        ],
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage({required this.onViewProjects});

  final VoidCallback onViewProjects;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(l10n.welcome, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(l10n.workspaceOverview),
        const SizedBox(height: 28),
        Row(
          children: [
            Expanded(child: Text(l10n.recentProjects, style: Theme.of(context).textTheme.titleLarge)),
            TextButton(onPressed: onViewProjects, child: Text(l10n.viewAll)),
          ],
        ),
        _ProjectCard(title: l10n.projectNameOne, description: l10n.projectDescriptionOne),
        _ProjectCard(title: l10n.projectNameTwo, description: l10n.projectDescriptionTwo),
      ],
    );
  }
}

class _ProjectsPage extends StatefulWidget {
  const _ProjectsPage();

  @override
  State<_ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<_ProjectsPage> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final projects = [
      (l10n.projectNameOne, l10n.projectDescriptionOne),
      (l10n.projectNameTwo, l10n.projectDescriptionTwo),
    ].where((project) => '${project.$1} ${project.$2}'.toLowerCase().contains(_query.toLowerCase())).toList();

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(l10n.projects, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        TextField(
          onChanged: (value) => setState(() => _query = value),
          decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: l10n.searchProjects, border: const OutlineInputBorder()),
        ),
        const SizedBox(height: 16),
        if (projects.isEmpty)
          Padding(padding: const EdgeInsets.all(16), child: Text(l10n.noProjects, textAlign: TextAlign.center))
        else
          for (final project in projects) _ProjectCard(title: project.$1, description: project.$2),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.folder_outlined)),
        title: Text(title, maxLines: 2, overflow: TextOverflow.ellipsis),
        subtitle: Text(description, maxLines: 3, overflow: TextOverflow.ellipsis),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage();

  Future<void> _signOut(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    try {
      await Supabase.instance.client.auth.signOut();
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l10n.signOutError)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(l10n.profile, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        Text(l10n.accountSignedIn),
        const SizedBox(height: 8),
        Text(l10n.settingsComingSoon),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () => _signOut(context),
          icon: const Icon(Icons.logout),
          label: Text(l10n.signOut),
        ),
      ],
    );
  }
}
