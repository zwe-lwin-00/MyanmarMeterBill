# Myanmar Meter Bill

Flutter application that **estimates** Myanmar electricity charges from **kWh** usage using **incremental block tariffs** (each tier applies only to units in that tier). Meter categories, copy, theme, spacing, and rates are driven by a **bundled JSON configuration** so you can update tariffs or wording without changing Dart code.

**Disclaimer:** This tool is **not** affiliated with MOEP, YESC, or any utility. Default rates in `assets/config/default_app_config.json` are for illustration only. Always confirm **current official tariffs**, fees, taxes, and account rules against ministry or supplier notices before relying on amounts.

## Requirements

- [Flutter](https://docs.flutter.dev/get-started/install) (Dart SDK **≥ 3.3.0** as specified in `pubspec.yaml`)
- For mobile builds: platform toolchains reported healthy by `flutter doctor`

## Quick start

```bash
cd MyanmarMeterBill
flutter pub get
```

If platform folders are missing (first clone of a minimal tree):

```bash
flutter create . --platforms=android,ios,web
```

Run the app:

```bash
flutter run
```

Choose a device when prompted, or pass a device id (examples):

```bash
flutter run -d chrome
flutter run -d web-server   # open the printed URL manually if Chrome launch fails
flutter devices
flutter run -d <device_id>
```

VS Code / Cursor: use **Run and Debug** and select **Myanmar Meter Bill (web-server)** or **(Chrome)** from `.vscode/launch.json`.

## Configuration

| Topic | Location |
|--------|-----------|
| Default bundled config | `assets/config/default_app_config.json` |
| Asset bundle | `pubspec.yaml` declares `assets/config/` (add new JSON files under this folder) |
| Load path override | Compile-time define `APP_CONFIG_ASSET` (see below) |
| Parsing and validation | `lib/config/app_config.dart` |
| Runtime load | `lib/config/app_config_loader.dart` |

**Switch config file** (path must be under `assets/config/` and included at build time):

```bash
flutter run --dart-define=APP_CONFIG_ASSET=assets/config/your_file.json
```

The JSON includes: `schemaVersion`, `app` (titles, theme seed color, Material 3 flag), `layout`, `formatting` (currency prefix, number pattern, line templates with `{{placeholders}}`), `strings` (UI keys), `meterOptions` (id, labels, `tariffScheduleId`), and `tariffSchedules` (named lists of `{ "capacityKwh", "kyatsPerKwh" }` tiers). Each meter option’s `tariffScheduleId` must exist in `tariffSchedules`.

## Project layout

```
lib/
  main.dart                 # Entry: loads config, error shell if asset fails
  config/                   # AppConfig model, loader, InheritedWidget scope
  calculator/               # Tiered bill math
  models/                   # e.g. TariffTier
  ui/                       # Bill calculator screen
assets/config/              # JSON configuration(s)
test/                       # Widget + config parsing tests
```

## Tests

```bash
flutter test
```

## Limitations

- **Estimate only:** no standing charges, VAT, rounding rules, or promotional schemes unless you model them in config and code.
- **Simplified categories:** defaults map to residential-style vs commercial-style schedules; real billing may use more meter classes or regional schedules.
- **Web:** if `flutter run -d chrome` fails to start the browser on your machine, use **`-d web-server`** and open the URL shown in the terminal.
