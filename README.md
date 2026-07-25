# 🌐 IPv4 Network Tools & VLSM Subnetting Suite

[![Flutter Version](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart Version](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Design System](https://img.shields.io/badge/Material_3-7B1FA2?style=for-the-badge&logo=materialdesign&logoColor=white)](https://m3.material.io)
[![Standard](https://img.shields.io/badge/Cisco_CCNA-Standard-1BA0D7?style=for-the-badge&logo=cisco&logoColor=white)](https://www.cisco.com)
[![Database](https://img.shields.io/badge/Hive-Local_Storage-F58220?style=for-the-badge&logo=hive&logoColor=white)](https://docs.hivedb.dev)
[![License](https://img.shields.io/badge/License-MIT-blue.style=for-the-badge)](LICENSE)

[ Arabic Documentation (المستندات باللغة العربية)](docs/README_AR.md)

---

## 🚀 Overview

**IPv4 Network Tools Suite** is a cross-platform Flutter application engineered for network administrators, Cisco CCNA/CCNP candidates, systems engineers, and computer science students. Built with **Clean Architecture**, **BLoC State Management**, and a custom **Material 3 Design System**, it provides an intuitive, high-precision toolkit for IPv4 subnet calculations, Cisco CLI configuration generation, interactive binary bit mapping, and VLSM network planning.

---

## ✨ Features Matrix

| Module | Core Functionality | Technical Highlights |
|---|---|---|
| 🧮 **IPv4 Network Calculator** | Complete address decomposition for any IPv4 & CIDR block. | Calculates Subnet Mask, Wildcard Mask, Network Address, Broadcast Address, Usable Host Range, Total/Usable Capacities, Binary, Hexadecimal, & Reverse DNS (`in-addr.arpa`). |
| 📊 **Full Technical Reports** | Deep-dive network inspection page (`IpDetailsPage`). | Interactive 32-bit bit grid map, visual host capacity progress gauge, advanced identifiers, and 1-click formatted report copy. |
| 🔀 **VLSM Subnetting Engine** | Cisco-standard Variable Length Subnet Masking (`VlsmDetailsPage`). | Computes allocations based on required host counts per department, calculates wasted hosts ratio, efficiency percentages, and exports total plan specs. |
| 💻 **Cisco IOS CLI Generator** | Automated Cisco router/switch command synthesis. | Generates Interface IP configuration, Sub-interface 802.1Q encapsulation, IP Helper addresses, Static Routes, and Standard/Extended Access Control Lists (ACLs). |
| 🧩 **Interactive 32-Bit BitGrid** | Visual binary address matrix (`BitGridWidget`). | Displays Network bits (Primary Accent) vs Host bits (Secondary Accent) with interactive bit state toggles and live decimal conversions. |
| 📖 **CIDR Reference Table** | Full-screen reference lookup (`CidrLookupPage`). | Covers all 33 IPv4 prefixes (`/0` through `/32`) with class filters (Class A, B, C, Subnets), real-time search, and host capacity specs. |
| 🔄 **Base System Converter** | Multi-base IP translation (`IpConverterPage`). | Translates between Decimal, 32-bit dot-separated Binary (`11000000.10101000.00000001.00000001`), and Hexadecimal formats with individual code copy boxes. |
| 🏷️ **IP Classifier & Inspector** | Address scope & classification (`IpClassifierPage`). | Categorizes addresses into Class A–E, RFC 1918 Private ranges, Public Internet space, Loopback, Link-Local, and Multicast scopes. |
| 📏 **Sequential Range Generator** | Consecutive IP address enumerator (`RangeCalculatorPage`). | Generates sequential IP lists between start and end bounds with item indexing and bulk clipboard export. |
| ⭐ **History & Favorites DB** | Offline storage powered by Hive. | Persists past calculations with timestamps, query search, starred favorites tab, and quick report inspection. |
| 🌍 **Full Dual Localization** | Native English & Arabic support. | Dynamic RTL/LTR layout mirroring, high-contrast Slate text themes, and custom typography (`Cairo` & `Inter`). |

---

## 🏗️ Architecture & Project Structure

The project strictly follows **Clean Architecture** principles decoupled into feature-based modules:

```
lib/
├── core/
│   ├── network/             # Pure IPv4 calculation algorithms & Cisco CLI engines
│   ├── theme/               # Material 3 tokens (AppSpacing, AppTextTheme, AppThemeExtension)
│   ├── utils/               # Page route transition animation helpers (AppPageRoutes)
│   └── widgets/             # Shared components (BitGridWidget, CidrLookupPage, IpInputField)
├── features/
│   ├── home/                # Responsive feature grid dashboard & hero banner
│   ├── ip_calculator/       # Calculation BLoC, result cards, and IpDetailsPage
│   ├── cisco_vlsm/          # VLSM engine, allocation cards, and VlsmDetailsPage
│   ├── cisco_cli/           # Cisco IOS command generator interface
│   ├── subnet_calculator/   # Equal subnet subdivider page
│   ├── range_calculator/    # Consecutive IP range enumerator page
│   ├── ip_converter/        # Multi-base system converter page
│   ├── ip_classifier/       # Class & scope classification dashboard
│   └── history/             # Hive local persistence storage & starred favorites
├── l10n/                    # Localization infrastructure (AppLocalizations)
└── main.dart                # Application entry point & Hive initialization
```

---

## ⚙️ Installation & Setup

### Prerequisites
- **Flutter SDK**: `^3.0.0`
- **Dart SDK**: `^3.0.0`
- **Android Studio / VS Code** with Flutter & Dart extensions installed

### Quick Start Guide

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/network_tools.git
   cd network_tools
   ```

2. **Fetch dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify project diagnostics:**
   ```bash
   flutter analyze
   ```

4. **Launch the application:**
   ```bash
   # Run on connected device or emulator
   flutter run

   # Or run specifically on Web / Chrome
   flutter run -d chrome
   ```

---

## 🎨 Design System Specifications

The application uses an extended Material 3 design system built for clarity and tactile feedback:

- **Tokens Centralization**: `AppSpacing` centralizes all padding, margins, border radii, and icon dimensions.
- **High-Contrast Text System**: `AppTextTheme` defines explicit light (`Slate-900` / `Slate-700`) and dark (`Slate-50` / `Slate-300`) colors to eliminate invisible text.
- **Theme Extensions**: `AppThemeExtension` handles feature gradients, status indicators, and custom badges.
- **Responsive Layout**: Zero static pixel offsets; dynamic `Expanded` and `TextOverflow.ellipsis` protections ensure 100% overflow-free rendering across Android phones, tablets, and desktop browsers.

---

## 🤝 Contributing

Contributions are welcome! Please follow these steps:
1. Fork the project repository.
2. Create your feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`).
4. Push to the branch (`git checkout -b feature/AmazingFeature`).
5. Open a Pull Request.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

Developed with ❤️ for Network Engineers, Students, and Cisco Professionals.
