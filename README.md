# 🎵 Suarana

Suarana adalah aplikasi music streaming yang dibangun menggunakan Flutter. Proyek ini dikembangkan sebagai tugas Ujian Akhir Semester (UAS) mata kuliah **Mobile Computing** sekaligus sebagai portofolio pembelajaran pengembangan aplikasi mobile modern.

Aplikasi mengintegrasikan **Audius API** sebagai sumber data musik publik dan **Supabase** sebagai layanan autentikasi, dengan arsitektur yang rapi dan scalable.

---

## ✨ Fitur Aplikasi

| Fitur | Keterangan |
|---|---|
| 🔐 Login & Register | Autentikasi via Supabase Auth |
| 🏠 Home | Trending tracks, album populer, genre populer dari Audius API |
| 🎵 Music Player | Streaming audio langsung dari Audius, kontrol play/pause/next/previous |
| 💿 Album Detail | List lagu per album, tap untuk putar |
| 🎸 Genre Detail | Trending lagu per genre |
| 🎛️ Mini Player | Floating player global, selalu tampil saat musik diputar |
| 👤 Profil | Info akun (read-only), ganti foto profil, logout |
| 📷 Kamera | Ambil/pilih foto profil dari kamera atau galeri |
| 💾 Local Storage | Foto profil disimpan secara lokal via SharedPreferences |
| 🌑 Dark Theme | Tema gelap konsisten di seluruh halaman |
| 🔍 Search | Upcoming Features |
| 🎶 Playlist | Upcoming Features |

---

## 🛠️ Tech Stack

| Kategori | Teknologi |
|---|---|
| Framework | Flutter |
| State Management | Riverpod (`FutureProvider`, `AsyncNotifier`, `NotifierProvider`) |
| Navigasi | GoRouter (dengan auth guard redirect) |
| REST API | Audius Public API |
| Backend & Auth | Supabase (Auth + PostgreSQL) |
| Audio Playback | just\_audio |
| Local Storage | SharedPreferences |
| Fitur Perangkat | Camera (image\_picker) |
| Font | Inter (Google Fonts) |
| UI | Material 3, Dark Theme |

---

## 🏗️ Software Architecture

Proyek menggunakan arsitektur **feature-first** dengan pemisahan tanggung jawab yang jelas, mengikuti pola **MVC / MVVM**:

```
View       →  lib/features/*/pages/       (UI only, tidak ada logic)
Controller →  lib/features/*/providers/   (AsyncNotifier / Notifier sebagai controller)
Model      →  lib/core/models/            (Data class + fromJson)
Service    →  lib/features/*/services/    (API call / Supabase call murni)
```

### Struktur Folder

```text
lib/
├── app/
│   ├── router/
│   │   ├── app_router.dart         ← GoRouter + auth guard
│   │   └── route_names.dart
│   └── shell/
│       └── app_shell.dart          ← Global shell (bottom nav + mini player)
│
├── core/
│   ├── models/
│   │   ├── track_model.dart
│   │   ├── album_model.dart
│   │   └── genre_model.dart
│   ├── theme/
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart
│   │   ├── app_spacing.dart
│   │   ├── app_text_styles.dart
│   │   └── app_gradients.dart
│   └── widgets/
│       ├── common/
│       ├── buttons/
│       ├── inputs/
│       ├── navigation/
│       └── music/
│           └── mini_player.dart
│
├── features/
│   ├── auth/
│   │   ├── services/auth_service.dart
│   │   ├── providers/auth_provider.dart
│   │   └── pages/
│   │       ├── login_page.dart
│   │       └── register_page.dart
│   │
│   ├── home/
│   │   ├── services/audius_home_service.dart
│   │   ├── providers/home_providers.dart
│   │   ├── pages/home_page.dart
│   │   ├── sections/
│   │   └── widgets/
│   │
│   ├── album/
│   │   ├── services/album_service.dart
│   │   ├── providers/album_providers.dart
│   │   └── pages/album_detail_page.dart
│   │
│   ├── genre/
│   │   ├── services/genre_service.dart
│   │   ├── providers/genre_providers.dart
│   │   └── pages/genre_detail_page.dart
│   │
│   ├── player/
│   │   ├── providers/player_provider.dart
│   │   └── pages/player_page.dart
│   │
│   ├── profile/
│   │   ├── services/profile_picture_service.dart
│   │   ├── providers/profile_providers.dart
│   │   └── pages/profile_page.dart
│   │
│   ├── search/
│   │   └── pages/search_page.dart
│   │
│   └── playlist/
│       └── pages/playlist_page.dart
│
└── main.dart
```

---

## 🔌 Integrasi REST API

Aplikasi menggunakan **Audius Public API** (tidak memerlukan API key) untuk mengambil data musik secara real-time.

| Endpoint | Kegunaan |
|---|---|
| `GET /tracks/trending` | Trending tracks di halaman Home |
| `GET /playlists/trending` | Album populer di halaman Home |
| `GET /tracks/trending?genre=` | Trending tracks per genre |
| `GET /playlists/{id}/tracks` | List lagu dalam album |
| `GET /tracks/{id}/stream` | Streaming audio langsung |

Setiap service mengimplementasikan **timeout 10 detik** dan **error handling** yang membedakan antara koneksi tidak ada (`SocketException`) dan kesalahan server.

---

## 💾 Local Storage

Aplikasi menggunakan **SharedPreferences** untuk menyimpan path foto profil pengguna secara lokal di perangkat. Foto profil yang dipilih dari kamera atau galeri disimpan dan dibaca kembali saat aplikasi dibuka.

Supabase Auth secara otomatis mengelola **session token** pengguna secara persisten, sehingga pengguna tetap login setelah menutup aplikasi.

---

## 📷 Fitur Perangkat: Kamera

Pengguna dapat mengganti foto profil melalui:
- **Kamera** — mengambil foto langsung menggunakan kamera perangkat
- **Galeri** — memilih foto dari penyimpanan lokal

Implementasi menggunakan package `image_picker`. Foto disimpan secara lokal menggunakan `SharedPreferences` (menyimpan path file).

---

## 🗄️ Database (Supabase)

Tabel yang digunakan di Supabase PostgreSQL:

| Tabel | Fungsi |
|---|---|
| `profiles` | Data profil user (username, avatar), auto-created saat register |
| `playlists` | Playlist milik user |
| `playlist_tracks` | Lagu dalam playlist |
| `favorites` | Track yang di-like user |
| `play_history` | Riwayat lagu yang diputar |

Semua tabel dilindungi **Row Level Security (RLS)** — setiap user hanya dapat mengakses data miliknya sendiri.

---

## 🚀 Cara Menjalankan Proyek

### Prasyarat

- Flutter SDK >= 3.x
- Dart >= 3.x
- Android Studio / VS Code
- Akun Supabase

### Clone Repository

```bash
git clone https://github.com/praditia12/suarana-mobile.git
cd suarana-mobile
```

### Install Dependencies

```bash
flutter pub get
```

### Konfigurasi Supabase

Buka `lib/main.dart` dan isi dengan credentials Supabase kamu:

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

### Jalankan Aplikasi

```bash
flutter run
```

---

## 📦 Build APK

```bash
flutter build apk --release
```

---

## 🎨 Desain

👉 [Buka Figma Design](https://www.figma.com/design/t2Qtw2U0RA30JUxsf9s7fp/Suarana---Music-App?m=auto&t=1Hv8QBfWxfXv72RU-1)

👉 Screenshot Aplikasi


---

## 🎯 Learning Goals

Proyek ini dibuat untuk mempelajari:

- Flutter fundamentals & widget tree
- Feature-based project structure
- Riverpod state management
- REST API integration & error handling
- Audio streaming dengan just\_audio
- Autentikasi dengan Supabase
- Database design & Row Level Security
- Local storage dengan SharedPreferences
- Fitur kamera dengan image\_picker
- GoRouter navigasi & auth guard

---

## 📄 Lisensi

This project is created for learning and educational purposes.