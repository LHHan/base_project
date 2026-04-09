# Base Project — Architecture Guide

Flutter base project using GetX. Clone this repo to bootstrap a new project with production-ready architecture, token-refresh auth, dark/light theme, i18n, and clean module structure.

---

## Tech Stack

| Layer | Package |
|---|---|
| State / DI / Routing | [get](https://pub.dev/packages/get) v4.7.2 |
| HTTP client | [dio](https://pub.dev/packages/dio) |
| Local storage | [get_storage](https://pub.dev/packages/get_storage) |
| Responsive sizing | [flutter_screenutil](https://pub.dev/packages/flutter_screenutil) (design: 428×926) |
| Logging | [logger](https://pub.dev/packages/logger) — all levels in debug, warning+ in release |
| Splash screen | [flutter_native_splash](https://pub.dev/packages/flutter_native_splash) |

---

## Folder Structure

```
lib/
├── app/
│   ├── core/
│   │   ├── languages/          # i18n strings
│   │   │   ├── en_us.dart
│   │   │   ├── vi_vn.dart
│   │   │   └── ja_jp.dart
│   │   └── utils/
│   │       ├── app_asset.dart       # Asset path constants (images, fonts)
│   │       ├── app_colors.dart      # Seed colors for ColorScheme
│   │       ├── app_config.dart      # Multi-env config + base URL (dev/prod)
│   │       ├── app_const.dart       # App-wide constants (nav bar height, etc.)
│   │       ├── app_enum.dart        # Enumerations (EnvType, LocaleCode, …)
│   │       ├── app_extension.dart   # Dart/Flutter extensions (TextTheme, List, …)
│   │       ├── app_helper.dart      # parseJsonWithIsolate, showErrorMessage
│   │       ├── app_log.dart         # Global `logger` instance
│   │       ├── app_style.dart       # TextStyle factory (AppStyles)
│   │       └── app_theme.dart       # ThemeData light + dark
│   ├── data/
│   │   ├── models/             # Data models — fromJson / toJson
│   │   └── providers/          # HTTP providers (ApiService injected via constructor)
│   ├── modules/                # One folder per feature/screen
│   │   └── <module>/
│   │       ├── bindings/       # DI wiring
│   │       ├── controllers/    # Business logic (GetxController)
│   │       └── views/          # UI (GetView<Controller>)
│   ├── routes/
│   │   ├── app_pages.dart      # GetPage list + route imports
│   │   └── app_routes.dart     # Route name constants (Routes.FOO / _Paths.FOO)
│   ├── services/
│   │   ├── api_service.dart           # Dio + auto token refresh (401 → refresh → retry)
│   │   ├── app_binding.dart           # Root binding (ApiService, AuthService)
│   │   ├── auth_service.dart          # Auth state + handleLogout()
│   │   ├── localization_service.dart  # GetX translations setup
│   │   ├── rest_api_safety.dart       # Mixin: apiCallSafety lifecycle
│   │   └── token_storage_service.dart # Token persistence (GetStorage)
│   └── widgets/                # Shared, reusable widgets
│       ├── p_appbar_transparency.dart  # Transparent status bar wrapper
│       ├── p_material.dart             # Root Material wrapper
│       ├── w_bottom_nav_bar_dynamic.dart # Animated bottom nav (nav ↔ logout)
│       ├── w_frosted_app_bar.dart      # iOS-style frosted glass nav bar
│       └── …
└── main.dart   # Global error handlers, GetStorage.init, flavor detection
```

---

## Architecture Patterns

### 1 — Model

Plain Dart class. Always use safe casting in `fromJson`.

```dart
class FooModel {
  final int id;
  final String name;

  const FooModel({required this.id, required this.name});

  factory FooModel.fromJson(Map<String, dynamic> json) => FooModel(
        id: json['id'] as int? ?? 0,
        name: json['name'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {'id': id, 'name': name};
}
```

### 2 — Provider

Owns all HTTP logic. Receives `ApiService` via **constructor injection** — never calls `Get.find()` internally.

```dart
class FooProvider {
  FooProvider(this._api);
  final ApiService _api;

  Future<List<FooModel>> getItems() async {
    final response = await _api.get('/foo');
    if (response.statusCode == 200) {
      return AppHelper().parseJsonWithIsolate(
        jsonEncode(response.data['items']),
        FooModel.fromJson,
      );
    }
    return [];
  }
}
```

### 3 — Controller

Receives providers via **constructor injection**. Use `RestApiSafety.apiCallSafety` for all API calls.

```dart
class FooController extends GetxController with RestApiSafety {
  FooController({required FooProvider fooProvider})
      : _fooProvider = fooProvider;

  final FooProvider _fooProvider;

  var items = <FooModel>[].obs;
  var isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    fetchItems();
  }

  Future<void> fetchItems() async {
    await apiCallSafety(
      () => _fooProvider.getItems(),
      onStart: () async => isLoading.value = true,
      onCompleted: (ok, res) async {
        if (ok && res != null) items.assignAll(res);
        isLoading.value = false;
      },
    );
  }
}
```

### 4 — Binding

Wires providers and controllers with `Get.lazyPut`. Always inject `ApiService` into providers via `Get.find<ApiService>()`.

```dart
class FooBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FooProvider>(() => FooProvider(Get.find<ApiService>()));
    Get.lazyPut<FooController>(() => FooController(fooProvider: Get.find()));
  }
}
```

### 5 — View

Extends `GetView<Controller>`. Use `Obx()` only where reactive state is consumed.

```dart
class FooView extends GetView<FooController> {
  const FooView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.builder(
          itemCount: controller.items.length,
          itemBuilder: (_, i) => Text(controller.items[i].name),
        );
      }),
    );
  }
}
```

### 6 — Route Registration

**`app_routes.dart`** — add route name constants:
```dart
static const FOO = _Paths.FOO;
// ...
static const FOO = '/foo';
```

**`app_pages.dart`** — add imports + `GetPage`:
```dart
GetPage(
  name: _Paths.FOO,
  page: () => const FooView(),
  binding: FooBinding(),
),
```

**Navigate:**
```dart
Get.toNamed(Routes.FOO);                        // push
Get.toNamed(Routes.FOO, arguments: someObject); // push with args
Get.offAllNamed(Routes.HOME);                   // replace entire stack
// Receive argument in controller:
final data = Get.arguments as FooModel;
```

---

## Adding a New Module — Checklist

```
□ lib/app/data/models/<name>_model.dart          ← data model
□ lib/app/data/providers/<name>_provider.dart    ← HTTP provider
□ lib/app/modules/<name>/bindings/<name>_binding.dart
□ lib/app/modules/<name>/controllers/<name>_controller.dart
□ lib/app/modules/<name>/views/<name>_view.dart
□ lib/app/routes/app_routes.dart                 ← add route constant
□ lib/app/routes/app_pages.dart                  ← add GetPage + imports
□ lib/app/core/languages/en_us.dart              ← add i18n keys
□ lib/app/core/languages/vi_vn.dart
□ lib/app/core/languages/ja_jp.dart
```

---

## Naming Conventions

| Type | File prefix | Class prefix | Example file | Example class |
|---|---|---|---|---|
| Full-screen page | `p_` | `P` | `p_home.dart` | `PHome` |
| Reusable widget | `w_` | `W` | `w_button.dart` | `WButton` |
| Model | — | — | `user_model.dart` | `UserModel` |
| Provider | — | — | `user_provider.dart` | `UserProvider` |
| Controller | — | — | `user_controller.dart` | `UserController` |
| Binding | — | — | `user_binding.dart` | `UserBinding` |

---

## i18n Keys — Naming Convention

```dart
'screenName<Screen>'   // page titles      → 'screenNameSettings': 'Settings'
'label<Thing>'         // labels/subtitles → 'labelLanguages': 'Languages'
'btn<Action>'          // buttons          → 'btnLogout': 'Logout'
'msg<Thing>'           // body messages    → 'msgEmptyList': 'No items found'
```

Always use `.tr` in the view — **never hardcode** display strings:
```dart
Text('screenNameFeed'.tr, style: Get.textTheme.tsPageName)
```

---

## Environment / Flavors

```bash
# Run dev
flutter run --flavor dev

# Run prod  
flutter run --flavor prod

# Override base URL at runtime (any flavor)
flutter run --flavor dev --dart-define=API_BASE_URL=https://my-api.com
# Per-flavor overrides
flutter run --flavor dev  --dart-define=API_BASE_URL_DEV=https://dev.api.com
flutter run --flavor prod --dart-define=API_BASE_URL_PROD=https://api.com
```

Base URL resolves from `AppConfig.I.env.apiBaseUrl` — set in `main.dart` → `_loadEnvironment()`.

---

## ApiService — Token Refresh Flow

```
Request → 401 Unauthorized
    └─ _handleRefreshToken()
          ├─ already refreshing? → wait for ongoing future
          └─ first caller → POST /auth/refresh
                ├─ success → save new tokens → retry original request
                └─ failure → clear tokens → redirect to login
```

**To configure:** replace the refresh endpoint in `api_service.dart`:
```dart
// Line ~130 — update URL and response parsing to match your auth API
final response = await _dio.post('/auth/refresh', data: {...});
```

---

## Theme

Toggle programmatically:
```dart
Get.changeThemeMode(ThemeMode.dark);   // switch to dark
Get.changeThemeMode(ThemeMode.light);  // switch to light
```

Persist the preference with `GetStorage` so it survives restarts (see `SettingController.onChangeAppTheme`).

Customize colors in `app_colors.dart` — both `seedColorLight` and `seedColorDark` feed into `ColorScheme.fromSeed`.

---

## Key Utilities

| Utility | Where | What it does |
|---|---|---|
| `AppHelper().parseJsonWithIsolate(json, fromJson)` | `app_helper.dart` | Parses a JSON list in a background isolate — use for large API responses |
| `AppHelper.showErrorMessage(msg)` | `app_helper.dart` | Shows a standard error snackbar |
| `apiCallSafety(...)` | `rest_api_safety.dart` | Wraps any API call with start / completed / error / finally hooks |
| `logger.i/d/w/e(...)` | `app_log.dart` | Structured logging; silent in release builds |
| `WFrostedAppBar` | `widgets/` | iOS-style frosted glass nav bar with scroll-triggered title fade |
| `PAppbarTransparency` | `widgets/` | Wraps a `Scaffold` so the status bar is transparent |

---

## Example Modules (included)

| Module | Purpose |
|---|---|
| `feed` | Text post feed — `FeedModel`, `FeedProvider` → `https://dummyjson.com/posts` |
| `chat` | Contact list + individual chat — mock conversations, typing indicator |
| `notifications` | Notification list — mock data, mark-as-read |
| `profile` | User profile — `UserModel`, `UserProvider` → `https://dummyjson.com/users` |
| `setting` | Settings page — theme toggle (persisted), language, frosted appbar |
| `isolate` | Demo — parallel JSON parsing with `parseJsonWithIsolate` |
| `onboarding` | 3-page onboarding flow with PageView |

Replace `dummyjson.com` endpoints with your own APIs when building a real project.
