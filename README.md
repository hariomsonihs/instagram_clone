<div align="center">

# 📸 Instagram Home Feed Clone

### A pixel-perfect Flutter recreation of the Instagram Home Feed UI

[![Flutter](https://img.shields.io/badge/Flutter-3.41.0-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.3.0-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Provider](https://img.shields.io/badge/Provider-6.1.2-764ABC?style=for-the-badge)](https://pub.dev/packages/provider)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows-lightgrey?style=for-the-badge)](https://flutter.dev)

<br/>

> Built with clean architecture, Provider state management, and pixel-perfect UI matching the real Instagram app.

> 📱 **This app is designed and optimized for Android & iOS phones only.** Web and desktop builds are available but the UI is not adapted for large screens.

</div>

---

## 📱 Screenshots

> Add your screenshots here after running the app. Recommended: capture on a real Android device.

<div align="center">

| Home Feed | Stories Tray | Post Card | Zoom Viewer |
|:---------:|:------------:|:---------:|:-----------:|
| ![Home Feed](screenshots/home_feed.png) | ![Stories](screenshots/stories.png) | ![Post](screenshots/post_card.png) | ![Zoom](screenshots/zoom.png) |

| Shimmer Loading | Like Toggle | Bottom Nav | Infinite Scroll |
|:--------------:|:-----------:|:----------:|:---------------:|
| ![Shimmer](screenshots/shimmer.png) | ![Like](screenshots/like.png) | ![Nav](screenshots/bottom_nav.png) | ![Scroll](screenshots/infinite_scroll.png) |

> 📁 Place your screenshots inside a `screenshots/` folder in the project root.

</div>

---

## 🎯 Project Overview

This project is a **complete Flutter clone of the Instagram Home Feed**. Every UI element — from the cursive Instagram logo to the gradient story rings, action buttons with counts, and the bottom navigation bar — is built to match the real Instagram app as closely as possible.

The app is built using a **layered clean architecture** separating data models, repositories, state management, screens, and widgets. This makes the codebase easy to test, extend, and maintain.

---

## ✨ Features

<table>
<tr>
<td>

### 🔝 Top App Bar
- `+` icon on the left (new post)
- **Instagram** in cursive `Grand Hotel` Google Font at center
- Heart icon with a **red notification dot** on the right

### 📖 Stories Tray
- **"Your story"** as the first item with a blue `+` badge
- Horizontal scrollable list using `ListView.builder`
- Instagram-style **5-color gradient ring** for active stories
- Grey ring for users without a story

### 🃏 Post Card
- Profile avatar with **gradient story ring**
- Username with optional **verified blue tick** ✅
- Multi-image carousel with **dot indicators**
- Action row: ❤️ Like · 💬 Comment · 🔁 Repost · ✈️ Share · 🔖 Save
- **Live counts** shown next to each action icon
- Caption with bold username prefix
- Relative timestamp (e.g. `5m`, `23m`)

</td>
<td>

### 🔁 Infinite Scroll
- Loads **10 posts per page**
- Triggers next page load **500px before bottom**
- Shows `CircularProgressIndicator` while loading more
- "You're all caught up" message at the end

### ❤️ Like & Save Toggle
- Like → icon turns **red**, count increments
- Unlike → icon turns black, count decrements
- Save → icon becomes **filled bookmark**
- State managed via `Provider` — no unnecessary rebuilds

### 🌀 Shimmer Loading
- Full shimmer skeleton on first launch
- Matches real layout: story circles + post skeletons
- **1.5 second artificial delay** before data loads

### 🔍 Pinch to Zoom
- Tap any post image to open full-screen viewer
- `InteractiveViewer` with **1x–4x zoom**
- Black background overlay
- Close button top-right

### 🗂️ Bottom Navigation Bar
- 5 tabs: **Home · Reels · Send (red dot) · Search · Profile**
- Profile tab shows **real avatar image**
- Active tab icon switches to filled variant

</td>
</tr>
</table>

---

## 🏗️ Project Structure

```
instagram_home_feed_clone/
│
├── lib/
│   ├── main.dart                    ← App entry point, Provider setup
│   │
│   ├── models/
│   │   ├── user_model.dart          ← UserModel (id, username, avatar, hasStory)
│   │   └── post_model.dart          ← PostModel (id, user, images, caption, likes...)
│   │
│   ├── repositories/
│   │   └── post_repository.dart     ← Dummy data generator, simulates API
│   │
│   ├── providers/
│   │   └── post_provider.dart       ← All feed state: load, paginate, like, save
│   │
│   ├── screens/
│   │   └── home_feed_screen.dart    ← Main screen + bottom nav bar
│   │
│   ├── widgets/
│   │   ├── instagram_app_bar.dart   ← Top bar with + / logo / heart
│   │   ├── stories_section.dart     ← Horizontal stories tray
│   │   ├── story_item.dart          ← Single story circle + username
│   │   ├── post_card.dart           ← Full post layout
│   │   ├── post_image_carousel.dart ← PageView carousel + dot indicators
│   │   ├── image_zoom_viewer.dart   ← Full-screen pinch-to-zoom viewer
│   │   └── shimmer_feed.dart        ← Skeleton loading placeholders
│   │
│   └── utils/
│       └── app_constants.dart       ← Colors, padding, sizes
│
├── android/                         ← Android platform files
├── web/                             ← Web platform files
├── windows/                         ← Windows platform files
├── pubspec.yaml                     ← Dependencies
└── README.md
```

---

## 🧰 Technologies & Packages Used

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter` | 3.41.0 | UI framework |
| `provider` | ^6.1.2 | State management |
| `cached_network_image` | ^3.4.1 | Efficient network image loading with cache |
| `shimmer` | ^3.0.0 | Skeleton loading animation |
| `google_fonts` | ^6.2.1 | Instagram cursive logo font (Grand Hotel) |

---

## ⚙️ How Everything Works — Step by Step

### 1. 🚀 App Launch & Initial Load

```
main.dart
  └── MultiProvider
        └── PostProvider(repository: PostRepository())
              └── ..loadInitialPosts()   ← called immediately on creation
```

When the app starts:
1. `PostProvider` is created and `loadInitialPosts()` is called automatically
2. `_isInitialLoading` is set to `true` → UI shows `ShimmerFeed`
3. An **artificial 1.5 second delay** runs (`Future.delayed`) to simulate network latency
4. `PostRepository.fetchPosts(page: 1, pageSize: 10)` is called
5. It generates 10 dummy `PostModel` objects with fake data
6. `_isInitialLoading` becomes `false` → UI switches from shimmer to real feed

---

### 2. 🖼️ Where Do Images Come From?

All images are loaded from **free public internet APIs** — no local assets are used.

| Image Type | Source URL | Example |
|------------|-----------|---------|
| Post images | `picsum.photos` | `https://picsum.photos/seed/post_1_0/1080/1080` |
| Profile avatars | `pravatar.cc` | `https://i.pravatar.cc/150?img=5` |

**How the seed works:**
```dart
// Post image URL — seed ensures same image loads consistently
'https://picsum.photos/seed/post_${postNumber}_${imageIndex}/1080/1080'

// Avatar — img param picks a specific face (1–70)
'https://i.pravatar.cc/150?img=${(postNumber % 70) + 1}'
```

The `seed` parameter in picsum.photos ensures the **same image always loads for the same post** — so scrolling up and down doesn't show different images.

---

### 3. 📦 How Images Are Cached

`cached_network_image` handles all image loading:

```
First load:
  Network request → Image downloaded → Stored in device cache

Second load (same URL):
  Cache hit → Image loaded instantly from disk (no network request)
```

Every image has:
- **Placeholder** → `CircularProgressIndicator` while loading
- **Error widget** → Grey container with broken image icon if URL fails
- **Cache** → Automatic disk cache managed by the package

---

### 4. 🌀 How Shimmer Loading Works

```dart
// ShimmerFeed widget
Shimmer.fromColors(
  baseColor: Color(0xFFF1F1F1),   // light grey
  highlightColor: Color(0xFFF8F8F8), // near white
  child: ListView(...)  // skeleton layout matching real UI
)
```

The shimmer package animates a **highlight sweep** from left to right over grey placeholder shapes. The shapes exactly mirror the real layout:
- Row of circles → story avatars
- Circle + rectangle → post header
- Large square → post image
- Two rectangles → like count + caption

After 1.5 seconds the real data replaces the shimmer.

---

### 5. 📜 How Infinite Scroll Works

```dart
// ScrollController listener in HomeFeedScreen
void _onScroll() {
  final position = _scrollController.position;
  if (position.pixels >= position.maxScrollExtent - 500) {
    context.read<PostProvider>().loadMorePosts();
  }
}
```

**Flow:**
1. User scrolls down
2. When scroll position is within **500px of the bottom**, `loadMorePosts()` fires
3. `_isLoadingMore` becomes `true` → spinner appears at bottom
4. `PostRepository.fetchPosts(page: nextPage)` fetches 10 more posts
5. New posts are **appended** to the existing list
6. After page 6, repository returns empty list → `_hasMore = false` → "You're all caught up"

The guard `if (_isInitialLoading || _isLoadingMore || !_hasMore) return;` prevents duplicate calls.

---

### 6. ❤️ How Like & Save Toggle Works

```dart
// In PostProvider
void toggleLike(String postId) {
  final index = _posts.indexWhere((p) => p.id == postId);
  final post = _posts[index];
  final willLike = !post.isLiked;

  _posts[index] = post.copyWith(
    isLiked: willLike,
    likeCount: willLike ? post.likeCount + 1 : post.likeCount - 1,
  );
  notifyListeners();
}
```

**Why `copyWith`?**
`PostModel` is **immutable** — you can't change a field directly. `copyWith` creates a new object with only the changed fields, keeping everything else the same. This is a Flutter best practice for state management.

**Why `Selector` instead of `Consumer`?**
```dart
Selector<PostProvider, PostModel?>(
  selector: (_, provider) => provider.getPostById(postId),
  builder: (context, post, _) { ... }
)
```
`Selector` only rebuilds the **specific PostCard** whose post changed. If you liked post #5, only post #5 rebuilds — not all 50 posts in the feed. This keeps scrolling smooth.

---

### 7. 🎠 How the Image Carousel Works

```dart
PageView.builder(
  controller: _pageController,
  itemCount: imageUrls.length,
  onPageChanged: (index) => setState(() => _currentPage = index),
  itemBuilder: (context, index) => CachedNetworkImage(...)
)
```

- Each post can have **1, 2, or 3 images** (determined by `postNumber % 3 + 1`)
- `PageView` allows horizontal swipe between images
- Dot indicators use `AnimatedContainer` — active dot is **Instagram blue** (`#3797EF`), inactive dots are semi-transparent white
- Single-image posts show **no dots**

---

### 8. 🔍 How Pinch-to-Zoom Works

```dart
// Tap on image → navigate to full screen
Navigator.of(context).push(
  MaterialPageRoute(builder: (_) => ImageZoomViewer(imageUrl: imageUrl))
);

// Inside ImageZoomViewer
InteractiveViewer(
  minScale: 1.0,
  maxScale: 4.0,
  clipBehavior: Clip.none,
  child: CachedNetworkImage(...)
)
```

- Tapping a post image opens `ImageZoomViewer` as a new route
- `InteractiveViewer` handles all pinch/zoom/pan gestures natively
- `maxScale: 4.0` allows up to 4× zoom
- `clipBehavior: Clip.none` lets the zoomed image overflow the bounds naturally
- Close button pops the route back to the feed

---

### 9. 🎨 How the Instagram Gradient Story Ring Works

```dart
Container(
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    gradient: LinearGradient(
      colors: [
        Color(0xFFFEDA75),  // yellow
        Color(0xFFF58529),  // orange
        Color(0xFFDD2A7B),  // pink
        Color(0xFF8134AF),  // purple
        Color(0xFF515BD4),  // blue
      ],
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
    ),
  ),
  child: Container(
    // White gap between gradient ring and avatar
    decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
    padding: EdgeInsets.all(2),
    child: ClipOval(child: CachedNetworkImage(...))
  )
)
```

Three nested containers create the effect:
1. **Outer** → gradient circle (the colourful ring)
2. **Middle** → white circle with 2px padding (the gap)
3. **Inner** → the actual avatar image

---

### 10. 🔄 Pull-to-Refresh

```dart
RefreshIndicator(
  onRefresh: provider.loadInitialPosts,
  child: ListView.builder(
    physics: AlwaysScrollableScrollPhysics(), // allows pull even when list is short
    ...
  )
)
```

Pulling down the feed calls `loadInitialPosts()` which resets the page counter, clears existing posts, and reloads from page 1 with the shimmer delay.

---

### 11. 🏛️ Architecture Explanation

```
┌─────────────────────────────────────────────────────┐
│                      UI Layer                        │
│   Screens + Widgets (read state, dispatch actions)   │
└──────────────────────┬──────────────────────────────┘
                       │ Consumer / Selector
┌──────────────────────▼──────────────────────────────┐
│                  State Layer                         │
│         PostProvider (ChangeNotifier)                │
│   owns: posts list, loading flags, pagination        │
└──────────────────────┬──────────────────────────────┘
                       │ calls
┌──────────────────────▼──────────────────────────────┐
│                  Data Layer                          │
│         PostRepository (pure Dart class)             │
│   generates dummy PostModel list, simulates API      │
└─────────────────────────────────────────────────────┘
```

- **Models** are immutable plain Dart classes with `copyWith`
- **Repository** has no Flutter dependency — easily swappable with a real API
- **Provider** owns all mutable state — widgets never mutate data directly
- **Widgets** are stateless where possible; stateful only when local UI state is needed (carousel page, scroll controller)

---

## 🚀 How to Run

### Prerequisites
- Flutter SDK installed
- Android device connected via USB with USB Debugging enabled, OR an emulator running

### Steps

```bash
# 1. Clone or open the project
cd "Instagram Clone"

# 2. Install dependencies
flutter pub get

# 3. Run on connected Android device
flutter run

# 4. Or run on Windows desktop
flutter run -d windows

# 5. Or run in Chrome
flutter run -d chrome
```

### Build APK

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

---

## 📦 Dependencies Explained

```yaml
provider: ^6.1.2
# State management. PostProvider extends ChangeNotifier.
# Widgets use Consumer<T> or Selector<T,R> to listen to changes.

cached_network_image: ^3.4.1
# Loads images from URLs with automatic disk caching.
# Shows placeholder while loading, error widget on failure.

shimmer: ^3.0.0
# Animates a shimmer sweep over placeholder widgets.
# Used during the 1.5s initial load delay.

google_fonts: ^6.2.1
# Loads Google Fonts at runtime.
# Used for 'Grand Hotel' — the cursive Instagram logo font.
```

---

## 🗺️ Data Flow Diagram

```
App Start
    │
    ▼
PostProvider.loadInitialPosts()
    │
    ├── isInitialLoading = true  ──────► ShimmerFeed shown
    │
    ├── Future.delayed(1.5s)
    │
    ├── PostRepository.fetchPosts(page:1)
    │       └── generates 10 PostModel objects
    │           ├── images from picsum.photos
    │           └── avatars from pravatar.cc
    │
    ├── posts = fetchedPosts
    └── isInitialLoading = false ──────► Real feed shown

User scrolls near bottom
    │
    ▼
PostProvider.loadMorePosts()
    │
    ├── isLoadingMore = true  ─────────► Spinner at bottom
    ├── PostRepository.fetchPosts(page: n+1)
    ├── posts = [...existing, ...new]
    └── isLoadingMore = false ─────────► New posts appended

User taps ❤️
    │
    ▼
PostProvider.toggleLike(postId)
    │
    ├── Find post by id
    ├── post.copyWith(isLiked: true, likeCount: +1)
    └── notifyListeners() ────────────► Only that PostCard rebuilds
```

---

## 🎨 Design Tokens

| Token | Value | Usage |
|-------|-------|-------|
| Instagram Red | `#ED4956` | Like icon, notification dot |
| Instagram Blue | `#0095F6` | Verified badge, Your story + button |
| Carousel Blue | `#3797EF` | Active dot indicator |
| Border Color | `#E8E8E8` | Dividers, nav bar top border |
| Light Text | `#6E6E6E` | Timestamps, footer text |
| Gradient Yellow | `#FEDA75` | Story ring start |
| Gradient Pink | `#DD2A7B` | Story ring mid |
| Gradient Purple | `#8134AF` | Story ring mid |
| Gradient Blue | `#515BD4` | Story ring end |
---

## 📝 Notes

> ⚠️ **Platform Notice**
> This app is **optimized for Android/iOS phones only**.
> The UI layout, spacing, font sizes, and bottom navigation are designed specifically for mobile screens.
> Running on Windows desktop or Chrome browser may not look correct — use a real Android device or emulator for the best experience.

- All images are loaded from the internet — **no local assets** are used
- `picsum.photos` uses a seed so the same post always shows the same image
- `pravatar.cc` provides consistent avatar faces by index number
- Pagination stops after **page 6** (60 posts total) by design
- The app works on **Android, iOS, Web, and Windows** with the same codebase
- `local.properties` in the android folder contains the Flutter SDK path — do not delete it

---

<div align="center">

Made with ❤️ using Flutter

[![Flutter](https://img.shields.io/badge/Made%20with-Flutter-02569B?style=for-the-badge&logo=flutter)](https://flutter.dev)

</div>

---

## 👨‍💻 Developer

<div align="center">

<img src="https://github.com/hariomsonihs/instagram_clone/blob/main/screenshots/profile_photo.jpg" width="90" style="border-radius:50%" />

### Hariom Soni

*Flutter Developer · Full Stack Enthusiast*

<br/>

[![Email](https://img.shields.io/badge/Email-hariomsoni0818%40gmail.com-D14836?style=for-the-badge&logo=gmail&logoColor=white)](mailto:hariomsoni0818@gmail.com)
[![LinkedIn](https://img.shields.io/badge/LinkedIn-hariomsonihs-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://linkedin.com/in/hariomsonihs)
[![Instagram](https://img.shields.io/badge/Instagram-hariomsonihs-E4405F?style=for-the-badge&logo=instagram&logoColor=white)](https://www.instagram.com/hariomsonihs)
[![Phone](https://img.shields.io/badge/Phone-7667110195-25D366?style=for-the-badge&logo=whatsapp&logoColor=white)](tel:+917667110195)

<br/>

> *"Building pixel-perfect apps, one widget at a time."*

</div>
