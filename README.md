# NSZ to NSP Converter - Android App

A Flutter-based Android application that converts NSZ files to NSP format locally on your device, designed specifically for Nintendo Switch emulation enthusiasts using Android gaming handhelds.

## 📥 Download APK

<div align="center">

[![Download APK](https://img.shields.io/badge/Download-APK%20v1.0.4-brightgreen?style=for-the-badge&logo=android)](https://github.com/gabrielvaz/nsz-to-nsp-android/releases/download/v1.0.4/nsz-to-nsp-converter-v1.0.4.apk)

**Latest Version: v1.0.4** • **Size: ~44 MB** • **Android 8.0+**

[📋 View All Releases](https://github.com/gabrielvaz/nsz-to-nsp-android/releases) • [🐛 Report Issues](https://github.com/gabrielvaz/nsz-to-nsp-android/issues)

</div>

---

## Features

- **Local Conversion**: All processing happens on your device - no internet connection required
- **Progress Tracking**: Real-time conversion progress with estimated time remaining and transfer speed
- **File Size Support**: Handles large NSZ files (tested with 6+ GB files)
- **Material Design**: Modern, intuitive interface following Material Design 3 guidelines
- **Error Handling**: Comprehensive error reporting with recovery options
- **Orientation Support**: Works in both portrait and landscape modes

## Target Devices

This app is particularly beneficial for users of Android-based gaming handhelds, including:

- **Retroid Pocket** series (Retroid Pocket 2, 3, 4)
- **Ayn Odin** series
- **Anbernic RG series** (Android models)
- **Steam Deck** (via Android dual-boot)
- Any Android device running emulators like **Yuzu**, **Ryujinx**, or **Skyline**

## Download

### Latest Release

Download the latest APK from the [Releases](https://github.com/gabrielvaz/nsz-to-nsp-android/releases) page.

**Current Version**: v1.0.4
- **File**: `nsz-to-nsp-converter-v1.0.4.apk`
- **Size**: ~44 MB
- **Minimum Android**: 8.0 (API 26)

### Installation Instructions

1. Download the APK file to your Android device
2. Enable "Install from unknown sources" in your device settings
3. Open the downloaded APK file and follow the installation prompts
4. Grant storage permissions when prompted

## How to Use

1. **Launch the App**: Open NSZ to NSP Converter
2. **Legal Notice**: Read and accept the legal notice (shown only once)
3. **Select NSZ File**: 
   - Tap "Select NSZ File" 
   - Choose your .nsz file from storage
   - The app will validate and display file information
4. **Convert**: 
   - Tap "Continue to Conversion"
   - Press "Start Conversion" to begin
   - Monitor real-time progress with time estimates
5. **Complete**: View conversion results and locate your .nsp file

## Features in Detail

### Progress Tracking
- Real-time progress bar with percentage completion
- Estimated time remaining based on processing speed
- File transfer speed indicator (MB/s)
- Detailed status messages throughout conversion

### File Management
- Automatic output directory creation
- Uses app-specific storage (no additional permissions needed)
- Original file preservation (original NSZ file is not modified)
- File size validation and error checking

### Error Handling
- Comprehensive error messages with technical details
- Retry functionality for failed conversions
- Stack trace information for debugging
- Recovery options with clear user guidance

## Technical Specifications

- **Platform**: Flutter 3.32.7
- **Target**: Android 8.0+ (API level 26+)
- **Architecture**: ARM64, ARM32 support
- **Storage**: Uses app-specific external storage
- **Permissions**: Storage access for file selection

## Development

### Prerequisites

- Flutter SDK 3.32.7 or higher
- Android SDK with API 26+
- Android Studio or VS Code with Flutter extensions

### Building from Source

```bash
# Clone the repository
git clone https://github.com/gabrielvaz/nsz-to-nsp-android.git
cd nsz-to-nsp-android

# Install dependencies
flutter pub get

# Build APK
flutter build apk --release
```

### Project Structure

```
lib/
├── main.dart                 # App entry point
├── screens/
│   ├── splash_screen.dart    # Initial loading screen
│   ├── onboarding_screen.dart # Legal notice (first run)
│   ├── file_selection_screen.dart # NSZ file picker
│   ├── conversion_screen.dart # Conversion progress
│   └── result_screen.dart    # Conversion results
├── services/
│   ├── nsz_converter.dart    # Core conversion logic
│   └── permission_manager.dart # Storage permissions
└── [other files]
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

### Development Guidelines

- Follow Flutter/Dart best practices
- Maintain Material Design consistency
- Add comprehensive error handling
- Include progress tracking for long operations
- Test on various Android devices and versions

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Disclaimer

This tool is for personal use only. Users are responsible for ensuring they own the games they are converting and comply with all applicable laws and Nintendo's terms of service. The developers are not responsible for any misuse of this application.

## Support

- **Issues**: [GitHub Issues](https://github.com/gabrielvaz/nsz-to-nsp-android/issues)
- **Discussions**: [GitHub Discussions](https://github.com/gabrielvaz/nsz-to-nsp-android/discussions)

## Changelog

### v1.0.4 (Latest)
- Enhanced progress tracking with time estimation
- Added file loading progress bar
- Improved conversion speed indicators
- Better error handling and recovery
- UI/UX improvements

### v1.0.3
- Fixed storage permission issues
- Improved file validation
- Added comprehensive logging
- Enhanced error reporting

### v1.0.2
- Fixed file picker compatibility
- English localization
- UI improvements

### v1.0.1
- Initial public release
- Basic NSZ to NSP conversion
- Material Design interface
- Progress tracking

---

**Made for the Android gaming handheld community** 🎮

Support emulation enthusiasts using devices like Retroid Pocket, Ayn Odin, and other Android gaming handhelds!
