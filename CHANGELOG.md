## 0.0.1

* Initial release.
* Added `VibrateButton`: A highly customizable button widget that provides
  horizontal shake feedback when form validation fails.
* Added `WaveDotesLoadingAnimation`: A smooth, staggered wave animation using
  sine-based oscillation for loading states.
* Support for both text-based and custom widget child components in
  `VibrateButton`.
* Seamless integration with Flutter's `Form` and `GlobalKey<FormState>` for
  straightforward validation-triggered shake feedback.
* Cross-platform support for both **Android** and **iOS**.
* Configurable shake animation parameters: duration, intensity, and repeat
  count.
* Null safety enabled — fully compatible with sound null safety.
* Exported all public APIs via the package-level barrel file for clean imports.
* Comprehensive dartdoc documentation on all public classes, constructors, and
  parameters.
* Added a runnable example app demonstrating basic usage with `VibrateButton`
  and form validation.