# Myanmar Meter Bill

Flutter application that **estimates** Myanmar electricity charges from **kWh** usage using **incremental block tariffs** (each tier applies only to units in that tier). Meter categories, copy, theme, spacing, and rates are driven by a **bundled JSON configuration** so you can update tariffs or wording without changing Dart code.

The UI has **three tabs**: bill calculator, device power guide, and about / contact (content from JSON).

**Disclaimer:** This tool is **not** affiliated with MOEP, YESC, or any utility. Default rates in `assets/config/default_app_config.json` are for illustration only. Always confirm **current official tariffs**, fees, taxes, and account rules against ministry or supplier notices before relying on amounts.

## Download the app

| Channel | Link / notes |
|--------|----------------|
| **GitHub Releases** | **[Latest releases](https://github.com/zwe-lwin-00/MyanmarMeterBill/releases)** — when a release is published, download the attached **`app-release.apk`** (or the APK attached to that release). If there is no release yet, use **build from source** below. |
| **Repository** | **[github.com/zwe-lwin-00/MyanmarMeterBill](https://github.com/zwe-lwin-00/MyanmarMeterBill)** — clone or browse the source. |

There is **no Google Play listing** in this README by default; add your Play Store URL here if you publish.

Build a release APK locally:

```bash
flutter pub get
flutter build apk
```

Output: `build/app/outputs/flutter-apk/app-release.apk` (install on Android with USB debugging or by copying the file to the phone).

Web build (host on Netlify, GitHub Pages, etc.):

```bash
flutter build web
```

Output under `build/web/`.

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

VS Code / Cursor: use **Run and Debug** and select **Myanmar Meter Bill (web-server)** or **(Chrome)** from `.vscode/launch.json` if present.

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

The JSON includes: `schemaVersion`, `app`, `layout`, `formatting`, `strings`, **`deviceGuide`**, **`aboutDeveloper`**, `meterOptions`, and `tariffSchedules`. Invalid configs fail at load with **`FormatException`** (clear message) instead of failing later in the UI.

### Configuration contract (strict)

Authoritative **required `strings` keys** are defined in **`lib/config/required_config_keys.dart`** (`kRequiredUiStringKeys`). Every key must exist and be **non-empty** after trim.

**`app`:** `materialTitle` and `navigatorTitle` must be non-empty after trim. **`themeSeedColor`** is a `#RRGGBB` or `#AARRGGBB` hex string. **`themeMode`:** `light`, `dark`, or `system` — used as the **first-launch default** until the user picks a theme in the app; the choice is then stored on the device (**`shared_preferences`**) and overrides JSON on later launches.

**Optional `strings` (theme picker):** `theme_picker_title`, `theme_picker_tooltip`, `theme_option_system`, `theme_option_light`, `theme_option_dark` — if missing or empty, English fallbacks are used (`AppConfig.optionalString`).

**`formatting`:** `currencyDisplayPrefix` must be non-empty. **`integerNumberPattern`** must be valid for `intl`’s `NumberFormat`. Templates must include these placeholders and render without leftover `{{` after substitution:

| Field | Required placeholders |
|--------|-------------------------|
| `breakdownLineTemplate` | `{{units}}`, `{{rate}}`, `{{currencyPrefix}}` |
| `totalUnitsTemplate` | `{{units}}` |
| `totalAmountTemplate` | `{{currencyPrefix}}`, `{{amount}}` |

**`layout`:** all numeric fields must be **finite** and **≥ 0**.

**`meterOptions`:** each **`id`** unique, non-empty; **`tariffScheduleId`** non-empty and must match a `tariffSchedules` key. Optional **`maintenanceFeeKyats`** per meter (e.g. residential ပြုပြင်ထိန်းသိမ်းခ) enables an optional checkbox in the calculator.

**`deviceGuide` / `aboutDeveloper`:** validated non-empty titles and minimum content (see `app_config.dart`).

**`tariffSchedules`:** schedule id keys must be non-empty; each tier has **positive** `capacityKwh` and **non-negative** `kyatsPerKwh`.

**`schemaVersion`:** must be the integer **1** (JSON may encode it as `1.0`).

## Project layout

```
lib/
  main.dart                 # Entry: loads config, MainShell (tabs)
  config/                   # AppConfig, loader, scope, required_config_keys.dart
  theme/                    # user_theme_mode_storage (saved light/dark/system)
  models/                   # TariffTier, extra_content (device guide / about)
  ui/                       # main_shell, bill_calculator_tab, device_guide_tab,
                            # about_developer_tab, responsive_layout, theme_sheet
assets/config/              # JSON configuration(s)
test/                       # Widget + config parsing tests
```

## Launcher icons

Source image: `web/icons/AppIcon-clean.png`. After changing it:

```bash
dart run flutter_launcher_icons
```

## Tests

```bash
flutter test
```

## Limitations

- **Estimate only:** no standing charges, VAT, rounding rules, or promotional schemes unless you model them in config and code (optional residential **maintenance** fee is supported via `meterOptions.maintenanceFeeKyats`).
- **Simplified categories:** defaults map to residential-style vs commercial-style schedules; real billing may use more meter classes or regional schedules.
- **Tier coverage:** if configured tiers do not cover all kWh, the app shows a warning and still shows partial math; extend the last tier capacity in JSON for full coverage.
