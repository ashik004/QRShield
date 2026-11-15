# QR Shield 🛡️

> **Create, Scan & Stay Safe**  
> Generate stylish QR codes, scan instantly, and check links for safety. Built with 100% native **SwiftUI** for iOS.

[![iOS](https://img.shields.io/badge/iOS-17.0%2B-blue.svg)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange.svg)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/UI-SwiftUI-purple.svg)](https://developer.apple.com/xcode/swiftui/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📱 Overview

**QR Shield** is an iOS application designed to blend aesthetic QR code creation with cybersecurity link inspection. With QR Shield, users can generate branded, customized QR codes with gradients, logos, and custom frames, while scanning QR codes with active threat heuristics to protect against phishing, scam redirects, and malicious URLs.

---

## ✨ Features & Functionality

### 1. 🏠 Home Screen
- **App Header**: Shield brand identity with quick Pro upgrade access.
- **Hero Banner**: "Create, Scan & Stay Safe" with 3D isometric QR graphic and glowing safety shield.
- **Primary CTAs**:
  - `Generate QR Code`: One-tap navigation to the QR creator.
  - `Scan QR Code`: Opens the live camera scanner.
- **Quick Access Grid (2x2)**:
  - 🎨 **Templates**: Explore pre-styled designer QR codes.
  - 📁 **My Codes**: Access your collection of saved QR codes.
  - 🕒 **Scan History**: Review past scans and safety audits.
  - ⭐ **Favorites**: Quick filter for starred QR codes.
- **Custom Floating Navigation Bar**: Clean 5-tab interface with elevated purple center scan button.

### 2. 🎨 Templates Library
- Filter chips: `[ All | Social | Wi-Fi | Business | Event ]`
- 8 pre-designed visual templates matching brand themes:
  - **Instagram**: Sunset gradient (orange/pink/magenta) with central camera logo.
  - **YouTube**: Vibrant red gradient with play button badge.
  - **Wi-Fi**: Cyan to royal blue gradient with Wi-Fi signal glyph.
  - **WhatsApp**: Emerald green gradient with chat bubble phone icon.
  - **Black Friday %**: High-contrast black card with golden `%` tag.
  - **SALE Event**: Bold red retail card with `SALE` banner.
  - **Valentine Hearts**: Romantic rose-pink gradient with floating hearts.
  - **Ocean Waves**: Deep blue cyber wave pattern with diamond dots.

### 3. ⚡ QR Code Generator (8 Payload Types)
- Segmented toggle: `[ Content | Template ]`
- Multi-format input generators with validation:
  1. **Website / Link**: URLs with protocol auto-completion (`https://`).
  2. **Wi-Fi**: SSID, password, security protocol (WPA/WPA2, WEP, Open), hidden network flag.
  3. **Contact (vCard)**: Full contact cards (Name, Phone, Email, Company, Job Title, URL).
  4. **Phone Number**: Direct dial links (`tel:`).
  5. **Text**: Multi-line plain text encoding.
  6. **Email**: Recipient address, subject line, and prefilled body (`mailto:`).
  7. **Location**: Latitude/longitude coordinates and named pins (`geo:`).
  8. **Social Media**: Platform selector (Instagram, YouTube, WhatsApp, X/Twitter, TikTok, LinkedIn) and username handle.

### 4. 🎛️ QR Code Customizer
- **Live Preview Card**: Real-time rendering of generated QR codes with smooth animations.
- **Style Tabs**:
  - **Style**: Classic Square, Rounded Dots, Micro-Dots, and Diamond shapes.
  - **Color**: Vibrant multi-stop gradients (Instagram Sunset, Royal Purple, Ocean Blue, Emerald Green, YouTube Red, Sunset Orange, Midnight Dark) and single colors.
  - **Logo**: Social logos, Wi-Fi glyph, Link icon, Heart, Star, or custom image upload from Photos.
  - **Frame**: None, "SCAN ME" bottom banner, Card Badge, Neon Glow, and Tech Brackets.
- **Actions**: Save to "My Codes" database, export directly to Apple Photos (`UIImageWriteToSavedPhotosAlbum`), and system share sheet.

### 5. 🗄️ My Codes & Favorites
- Search bar: Filter your saved codes by title or payload in real-time.
- Filter chips: Categorize by All, Social, Wi-Fi, or Business.
- Quick star favorite toggle with persistent state.
- Three dots `...` action menu: Fullscreen presentation, edit in customizer, copy payload, save photo, or delete.

### 6. 📷 Camera Scanner
- Real-time `AVCaptureSession` scanner targeting QR codes.
- Glowing viewfinder brackets with animated sweeping laser line.
- Flashlight / torch toggle with state feedback.
- Photo Library Picker to scan saved screenshots or images.
- Simulator Testing Mode: Built-in menu to test Safe, Suspicious, or Dangerous link scenarios.
- Scan Tips sheet.

### 7. 🛡️ Link Safety Scanner (Checking Link Safety...)
- Cosmic dark backdrop with concentric animated radar rings and pulsing shield.
- Rotating radar sweep beam.
- 4-step threat assessment checklist:
  - `[✓] Reading QR code...`
  - `[✓] Extracting link...`
  - `[✓] Analyzing for threats...`
  - `[✓] Checking against safety database...`

### 8. 🚦 Scan Results (Safe, Suspicious, Dangerous)
- **Safe Link (Emerald Green)**:
  - Green shield checkmark.
  - Site type (e.g. Social Media), SSL status (`Yes`), Reputation (`Good`).
  - "Open Link" (Safari / SFSafariViewController) and "Copy Link" buttons.
- **Suspicious Link (Amber / Orange)**:
  - Warning triangle icon.
  - Issues Found (e.g. Unverified website), Risk Level (`Medium`), Recommendation (`Avoid if not trusted`).
  - Caution prompt alert before opening.
- **Dangerous Link (Crimson Red)**:
  - Hazard skull icon.
  - Threat Type (e.g. `Phishing`), Risk Level (`High`), Recommendation (`Do not open`).
  - Opening disabled to safeguard device security; Copy Link available.

### 9. ⚙️ Settings & Pro Paywall
- **QR Shield Pro**: Unlock premium templates, high-res vector exports, and advanced threat detection.
- Restore purchases with alert feedback.
- Multi-language switcher (English, Spanish, French, German, Japanese).
- In-App Store Review prompt (`SKStoreReviewController`).
- Share app action sheet.
- Integrated Privacy Policy & Terms of Use modal sheets.

---

## 🛠️ Tech Stack & Requirements

- **Language**: Swift 5.9+ / Swift 6.4
- **Framework**: SwiftUI, UIKit, CoreImage, AVFoundation, PhotosUI, StoreKit, SafariServices
- **Target OS**: iOS 17.0+
- **Architecture**: Modular MVVM with reactive Services and persistent Storage.

---

## 🚀 Getting Started

1. Clone the repository:
   ```bash
   git clone https://github.com/ashik004/QRShield.git
   cd QRShield
   ```

2. Open the Xcode project:
   ```bash
   open QRShield.xcodeproj
   ```

3. Select your desired simulator (e.g., iPhone 17 Pro, iPhone 16 Pro) or connected device and press **Cmd + R** to run.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
