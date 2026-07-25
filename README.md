# 🌐 Network Tools Suite (IPv4 Engine & Subnetting Toolkit)

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white" alt="Flutter Badge" />
  <img src="https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white" alt="Dart Badge" />
  <img src="https://img.shields.io/badge/Material_Design_3-7B1FA2?style=for-the-badge&logo=materialdesign&logoColor=white" alt="Material 3 Badge" />
  <img src="https://img.shields.io/badge/Cisco_CCNA-1BA0D7?style=for-the-badge&logo=cisco&logoColor=white" alt="Cisco Badge" />
  <img src="https://img.shields.io/badge/Hive_DB-F58220?style=for-the-badge&logo=hive&logoColor=white" alt="Hive Badge" />
</p>

---

## 📌 Arabic Summary | نبذة عن التطبيق باللغة العربية

تطبيق **Network Tools Suite** هو جناح أدوات هندسة شبكات IPv4 متكامل، مصمم بأعلى معايير **Material Design 3** وهيكلية كود نظيفة (**Clean Architecture** + **BLoC**). يوفر التطبيق حلاً شاملاً لمهندسي شبكات **Cisco CCNA/CCNP** والطلاب والمطورين لتقسيم الشبكات، توليد أوامر الأجهزة، وتحليل العناوين بدقة متناهية.

---

## ✨ Key Features | الميزات الرئيسية

| Feature | Description | الوصف بالعربية |
|---|---|---|
| 🧮 **IPv4 Network Calculator** | Complete calculation of Netmask, Broadcast, Wildcard, Usable IP Range, 32-bit Binary, Hexadecimal, and Reverse DNS (in-addr.arpa). | حاسبة IPv4 كاملة تشمل أقنعة الشبكة، المدى المتاح، العنوان العكسي والتمثيل الثنائي. |
| 📊 **Full Technical Reports** | Dedicated full-screen technical analysis report for any IPv4 address with interactive bit map and capacity gauge. | تقرير فني شامل للشبكة مع خريطة البتات الـ 32 التفاعلية ومؤشر سعة الأجهزة. |
| 🔀 **VLSM Subnetting Engine** | Cisco-standard Variable Length Subnet Masking (VLSM) calculator by host requirements with efficiency percentage. | محرك تقسيم الشبكات المتغير (VLSM) وفق معايير Cisco مع قياس نسبة الكفاءة والعناوين المهدورة. |
| 💻 **Cisco IOS CLI Generator** | Automatic generation of Cisco Router/Switch interface configs, Sub-interfaces, IP Helper, Static Routing, and ACLs. | مولد أوامر راوترات ومفاتيح Cisco تلقائياً للإعدادات، الواجهات الفرعية، والموجهات الثابتة. |
| 🧩 **Interactive 32-Bit BitGrid** | Visual 32-bit map showing Network bits (Blue) vs Host bits (Green) with interactive bit state inspection. | خريطة البتات الـ 32 التفاعلية الملونة لتحديد بتات الشبكة مقابل بتات الأجهزة بنقرة واحدة. |
| 📖 **Full-Screen CIDR Reference Table** | Interactive lookup table for all 33 IPv4 prefixes (`/0` to `/32`) with class filters (A, B, C) and search. | جدول CIDR المرجعي الشامل لجميع السوابق 33 مع فلترة سريعة ومحرك بحث مدمج. |
| 🔄 **IP Base Systems Converter** | Instant conversion between Decimal, 32-bit Binary (dot-separated), and Hexadecimal notations. | محول الأنظمة الرقمية (العشري، الثنائي المنقط، والست عشري) مع أزرار نسخ فورية. |
| 🏷️ **IP Classifier & Scope Inspector** | Classifies IPv4 addresses into Class A-E, RFC 1918 Private, Public Internet, Loopback, or Multicast. | مصنف فئات العناوين وبيئة التشغيل (خاص، عام، استرجاعي، بث متعدد). |
| 📏 **Consecutive Range Generator** | Generates sequential IPv4 ranges with host counts and one-click item copying. | مولد مدى عناوين IP المتسلسلة مع رقم تسلسلي وتصدير فوري. |
| ⭐ **History & Favorites Manager** | Hive local storage for past calculation history and starred favorite entries. | سجل النشاطات والمفضلة المعتمد على قاعدة بيانات Hive المحلية السريعة. |
| 🌍 **Full Dual Language (AR/EN)** | Seamless localization between Arabic (RTL) and English (LTR) with custom fonts (Cairo). | دعم كامل ومزدوج للغتين العربية والإنجليزية مع ضبط اتجاهات النصوص والرسم. |

---

## 🛠️ Technology Stack & Architecture | التقنيات وهيكلية المشروع

- **Framework:** Flutter 3.x (Dart 3.x)
- **State Management:** `flutter_bloc` / BLoC Pattern
- **Design System:** Custom Material 3 Token System (`AppSpacing`, `AppTextTheme`, `AppThemeExtension`)
- **Local Persistence:** Hive DB (`hive`, `hive_flutter`)
- **Typography:** Google Fonts (Cairo & Inter)
- **Architecture Pattern:** Clean Architecture (Core, Domain, Data, Presentation)

```
lib/
├── core/
│   ├── network/             # Pure IPv4 & Cisco Engine Logic
│   ├── theme/               # Material 3 Tokens, Colors & Spacing
│   ├── utils/               # Page Transition Animation Helpers
│   └── widgets/             # Shared UI Components (BitGrid, CidrPage, Inputs)
├── features/
│   ├── home/                # Feature Grid Dashboard & Hero Banner
│   ├── ip_calculator/       # IPv4 Analysis & Dedicated Full Report Page
│   ├── cisco_vlsm/          # VLSM Allocation Engine & Detailed Report Page
│   ├── cisco_cli/           # Cisco IOS Configuration Generator
│   ├── subnet_calculator/   # Equal Subnet Division Page
│   ├── range_calculator/    # Consecutive IP Generator
│   ├── ip_converter/        # Decimal/Binary/Hex Converter
│   ├── ip_classifier/       # Scope & Class Inspector
│   └── history/             # Hive History & Starred Favorites Storage
├── l10n/                    # Localization (EN & AR AppLocalizations)
└── main.dart                # App Entry Point & Hive Initialization
```

---

## 🚀 Getting Started | كيفية التشغيل

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`>= 3.0.0`)
- Android Studio / VS Code with Dart & Flutter extensions

### Installation Steps

1. **Clone the repository:**
   ```bash
   git clone https://github.com/your-username/network_tools.git
   cd network_tools
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the application:**
   ```bash
   flutter run
   ```

---

## 🎨 UI/UX Design System Highlights | أبرز المعايير التصميمية

1. **High Contrast Typography:** Explicit Slate-900 / Slate-50 text themes to ensure zero invisible text across Light & Dark modes.
2. **Tactile Feedback:** Subtle micro-interactions, `AnimatedScale` card hover responses, and `HapticFeedback.lightImpact()` on tap.
3. **Zero Layout Overflow:** All flexible containers utilize `Expanded`, `Flexible`, and `TextOverflow.ellipsis` for 100% responsive layouts across all Android & Web screens.

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.

Developed with ❤️ for Network Engineers and Developers.
