# vibrate_button

<p align="center">
  <img src="https://img.shields.io/pub/v/github/your-github/button?style=flat-square&label=pub.dev+version" alt="Pub Version">
  <img src="https://img.shields.io/badge/platform-Android%20%7C%20iOS-blue?style=flat-square" alt="Platform">
  <img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="License">
  <img src="https://img.shields.io/badge/Flutter-3.x-blue?style=flat-square&logo=flutter" alt="Flutter">
  <img src="https://img.shields.io/badge/Dart-null%20safety-blue?style=flat-square&logo=dart" alt="Null Safety">
</p>

<p align="center">
A premium, interactive Flutter Vibrate button package featuring validation-triggered shake animations and a smooth wave-based loading indicator. Built for developers who need polished, responsive UI feedback without the boilerplate.
</p>

---

## Demo

 ![App Demo](https://github.com/vsaravananc/buttons/video/validate_button.gif)

---

## Table of Contents

- [Features](#features)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Usage](#usage)
  - [VibrateButton with Form Validation](#vibratebutton-with-form-validation)
  - [Standalone WaveDotesLoadingAnimation](#standalone-wavedotesloadinganimation)
  - [Custom Child Widget](#custom-child-widget)
- [API Reference](#api-reference)
  - [VibrateButton](#vibratebutton-properties)
- [Customization Guide](#customization-guide)
  - [Shake Behavior](#shake-behavior)
  - [Loading State](#loading-state)
  - [Theming](#theming)
- [Platform Support](#platform-support)
- [Requirements](#requirements)
- [Contributing](#contributing)
- [License](#license)

---

## Features

| Feature | Description |
|---|---|
| **Shake on Validation Failure** | `VibrateButton` automatically triggers a horizontal shake animation whenever `FormState.validate()` fails — zero manual wiring required. |
| **Wave Loading Indicator** | `WaveDotesLoadingAnimation` renders three dots oscillating in a staggered sine-wave pattern, providing a clean visual cue during async operations. |
| **Form Integration** | Designed to work natively with Flutter's `Form` widget and `GlobalKey<FormState>`. Simply pass your form key — the button handles the rest. |
| **Flexible Content** | Accepts either a plain `text` string or an arbitrary `child` widget (icons, images, rich text), giving you full creative control over the button label. |
| **Highly Configurable** | Tune every aspect of the shake animation — duration, pixel intensity, and oscillation count — and style the button with custom colors, border radius, and dimensions. |
| **Async-Ready Loading States** | Toggle the loading state with a simple boolean. The button content is seamlessly replaced by the wave animation while your async task completes. |
| **Cross-Platform** | Runs identically on Android and iOS with no platform-specific configuration needed. |
| **Null Safety** | Fully compatible with Dart sound null safety. |

---

## Installation

Add `vibrate_button` to your project's `pubspec.yaml` dependencies:

```yaml
dependencies:
  flutter:
    sdk: flutter
  vibrate_button: ^0.0.1          # Use the latest published version
```

Run the following command to fetch the dependency:

```bash
flutter pub get
```

---

## Quick Start

```dart
import 'package:vibrate_button/vibrate_button.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(hintText: 'Enter your email'),
              validator: (value) =>
                  (value == null || value.trim().isEmpty) ? 'Email is required' : null,
            ),
            const SizedBox(height: 24),
            VibrateButton(
              formState: _formKey,
              loading: _isLoading,
              text: 'Submit',
              color: Colors.deepPurple,
              onTap: () async {
                setState(() => _isLoading = true);

                // Simulate an async network call
                await Future.delayed(const Duration(seconds: 2));

                setState(() => _isLoading = false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Usage

### VibrateButton with Form Validation

The core use case: a button that shakes when the attached form fails validation, and only calls `onTap` when all fields pass.

```dart
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool _isLoading = false;

@override
Widget build(BuildContext context) {
  return Form(
    key: _formKey,
    child: Column(
      children: [
        // --- Form fields with validators ---
        TextFormField(
          decoration: const InputDecoration(label: Text('Name')),
          validator: (value) =>
              (value == null || value.trim().isEmpty) ? 'Name is required' : null,
        ),
        TextFormField(
          decoration: const InputDecoration(label: Text('Email')),
          validator: (value) =>
              (value == null || !value.contains('@')) ? 'Enter a valid email' : null,
        ),
        const SizedBox(height: 20),

        // --- VibrateButton ---
        VibrateButton(
          formState: _formKey,
          loading: _isLoading,
          text: 'Create Account',
          color: Colors.indigo,
          radius: 12,
          onTap: () async {
            setState(() => _isLoading = true);
            await _submitForm(); // Your async logic here
            setState(() => _isLoading = false);
          },
        ),
      ],
    ),
  );
}
```

**How it works under the hood:**

1. On tap, `VibrateButton` calls `_formKey.currentState!.validate()`.
2. If validation **fails**, the shake animation plays and `onTap` is **not** invoked.
3. If validation **passes**, `onTap` fires immediately.
4. While `loading` is `true`, the button displays `WaveDotesLoadingAnimation` in place of its label and remains non-interactive.

---

### Standalone WaveDotesLoadingAnimation

You can use the wave animation independently of `VibrateButton` — for example, inside a custom dialog or overlay:

```dart
const Center(
  child: WaveDotesLoadingAnimation(),
);
```

The animation is stateless from the consumer's perspective — simply mount it when you want the indicator visible and remove it when done.

---

### Custom Child Widget

When a plain text label isn't enough, pass any widget as the button's content:

```dart
VibrateButton(
  formState: _formKey,
  loading: _isLoading,
  color: Colors.teal,
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Icon(Icons.login, color: Colors.white),
      SizedBox(width: 8),
      Text(
        'Sign In',
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  ),
  onTap: () {
    // Handle sign-in
  },
);
```

> **Note:** `text` and `child` are mutually exclusive. Providing both will throw an assertion error at runtime.

---

## API Reference

### VibrateButton Properties

| Property | Type | Default | Description |
|---|---|---|---|
| `formState` | `GlobalKey<FormState>` | — | **Required.** The key of the `Form` widget this button validates against. |
| `onTap` | `VoidCallback` | — | **Required.** Callback invoked only when form validation passes. |
| `loading` | `bool` | — | **Required.** When `true`, the button displays the wave loading animation and ignores taps. |
| `text` | `String?` | `null` | Label text rendered inside the button. Mutually exclusive with `child`. |
| `child` | `Widget?` | `null` | Arbitrary widget rendered inside the button. Mutually exclusive with `text`. |
| `color` | `Color?` | `null` | Background color of the button. Falls back to the theme's primary color if `null`. |
| `radius` | `double` | `8.0` | Border radius of the button in logical pixels. |
| `duration` | `Duration` | `450 ms` | Total duration of one full shake animation cycle. |
| `movePixels` | `double` | `12.0` | Maximum horizontal displacement (in logical pixels) during the shake. |
| `shakeCount` | `double` | `4.0` | Number of full oscillations within one shake cycle. Higher values produce a tighter, faster shake. |

---

## Customization Guide

### Shake Behavior

The shake animation is fully configurable. Here is a quick reference for common feels:

| Feel | `duration` | `movePixels` | `shakeCount` |
|---|---|---|---|
| Subtle nudge | `300 ms` | `6.0` | `2.0` |
| Default | `450 ms` | `12.0` | `4.0` |
| Aggressive alert | `600 ms` | `18.0` | `6.0` |

```dart
VibrateButton(
  // ... required params
  duration: const Duration(milliseconds: 600),
  movePixels: 18.0,
  shakeCount: 6.0,
  text: 'Submit',
  onTap: () {},
);
```

### Loading State

Control the loading state externally using a `bool` variable, typically paired with `setState`:

```dart
bool _loading = false;

void _handleTap() async {
  setState(() => _loading = true);

  try {
    await apiCall();
  } finally {
    setState(() => _loading = false);
  }
}
```

While `loading` is `true`:
- The button label is replaced by `WaveDotesLoadingAnimation`.
- Tap events are suppressed — the button is effectively disabled.

### Theming

`VibrateButton` respects your app's theme by default. When `color` is not explicitly set, the button falls back to `Theme.of(context).colorScheme.primary`. For full control, pass a specific color:

```dart
VibrateButton(
  color: const Color(0xFF6C5CE7), // Custom purple
  // ...
);
```

---

## Platform Support

| Platform | Supported |
|---|---|
| Android | ✅ |
| iOS | ✅ |
| Web | ⬜ Untested |
| macOS | ⬜ Untested |
| Windows | ⬜ Untested |
| Linux | ⬜ Untested |

---

## Requirements

| Dependency | Minimum Version |
|---|---|
| Flutter SDK | `>=3.0.0` |
| Dart SDK | `>=2.17.0` |

---

## Contributing

Contributions are welcome and appreciated. Here is how to get started:

1. **Fork** the [repository](https://github.com/vsaravananc/buttons) and clone your fork locally:
   ```bash
   git clone https://github.com/your-username/buttons.git
   cd vibrate_button
   ```
2. Create a **feature branch** from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. Make your changes and ensure all tests pass:
   ```bash
   flutter test
   ```
4. Run the analyzer to confirm zero warnings:
   ```bash
   dart analyze
   ```
5. Push your branch and **open a Pull Request** [here](https://github.com/vsaravananc/buttons/pulls) against `main` with a clear description of your changes.

Please follow Dart and Flutter coding conventions and include tests for any new functionality.

> **Found a bug?** File an issue [here](https://github.com/vsaravananc/buttons/issues/new).


## License

This package is distributed under the **MIT License**.

See the [LICENSE](https://github.com/vsaravananc/buttons/blob/Main/LICENSE) file for the full text.