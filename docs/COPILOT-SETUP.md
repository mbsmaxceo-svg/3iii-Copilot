# Copilot, MCP, and language setup

## Recommended VS Code extensions

The repository recommends these extensions through `.vscode/extensions.json`:

- GitHub Copilot (`GitHub.copilot`) for AI-assisted coding.
- GitHub Copilot Chat (`GitHub.copilot-chat`) for conversational assistance.
- Dart (`Dart-Code.dart-code`) and Flutter (`Dart-Code.flutter`) for the frontend stack described in `docs/PRD.md`.

Open the repository in VS Code and accept the prompt to install the recommended extensions. These are editor recommendations; they do not install extensions on every contributor's machine automatically.

## MCP servers

MCP is optional and is not configured in this repository. Copilot cloud agent and code review use repository-level MCP server settings configured by a repository administrator on GitHub.com; those settings are separate from VS Code extension recommendations and project-level CLI configuration.

Before enabling an MCP server, choose the service and specific tools needed, review its data access and authentication requirements, and use least-privilege credentials. Do not put personal credentials or secrets in this repository. Personal MCP server setup belongs in the user's Copilot settings. For shared repository access, an administrator should configure the server in repository settings and use an appropriately scoped service account where authentication is required. Copilot cloud agent may call configured tools autonomously, so enable only tools required for the work.

## Thai and English language display

The product requirements identify a mobile-first Flutter application and Thai-language product content. The UI should support Thai (`th`) and English (`en`), with translated labels, buttons, validation messages, empty states, and accessibility text. Let the app's selected locale determine the displayed language, and use the device locale as the initial default when it is supported. Preserve user choice across launches when the application scaffold and settings persistence are implemented.

When the Flutter app is added:

1. Add Flutter's `flutter_localizations` and `intl` dependencies.
2. Enable generated localizations in `pubspec.yaml` and define `l10n.yaml` with ARB resources under `lib/l10n/`.
3. Add parallel English and Thai ARB files (for example, `app_en.arb` and `app_th.arb`) and use generated localization APIs rather than hard-coded UI strings.
4. Configure the app's supported locales and localization delegates, and add an in-app language selector if users need to override the device language.
5. Check Thai font fallback, text scaling, right-sized layouts, and overflow on small Android screens.

This repository currently has no Flutter application scaffold or runtime localization files. The steps above document the intended setup and avoid adding unbuildable application files before the scaffold exists.
