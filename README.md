# Flutter Basic Games

Flutter ile geliştirilmiş birden fazla özelleştirilebilir basit oyun içeren bir mobil uygulama projesi.

## Özellikler

### Oyunlar

1. **Tic Tac Toe (XOX)**
   - Klasik X ve O oyunu
   - Skor takibi
   - İki oyunculu mod

2. **Memory Game (Hafıza Oyunu)**
   - Kartları eşleştirme oyunu
   - Özelleştirilebilir grid boyutu (2x2 - 6x6)
   - Hamle sayısı takibi

3. **Snake (Yılan Oyunu)**
   - Klasik yılan oyunu
   - Özelleştirilebilir hız ayarları
   - High score takibi

4. **2048**
   - Sayıları birleştirme oyunu
   - Kaydırma kontrolleri
   - Skor sistemi

### Özelleştirme Seçenekleri

- **Tema Renkleri**: 4 farklı renk şeması
  - Blue Ocean (Mavi Okyanus)
  - Forest (Orman)
  - Sunset (Gün Batımı)
  - Dark Mode (Karanlık Mod)

- **Zorluk Seviyeleri**: Easy, Medium, Hard
- **Snake Hız Ayarı**: 100ms - 500ms arası
- **Memory Grid Boyutu**: 2x2'den 6x6'ya kadar

## Proje Yapısı

```
lib/
├── main.dart                 # Ana giriş noktası
├── screens/
│   ├── home_screen.dart      # Ana menü ekranı
│   └── settings_screen.dart  # Ayarlar ekranı
├── games/
│   ├── tic_tac_toe_game.dart # Tic Tac Toe oyunu
│   ├── memory_game.dart      # Hafıza oyunu
│   ├── snake_game.dart       # Yılan oyunu
│   └── game_2048.dart        # 2048 oyunu
├── models/
│   └── game_model.dart       # Oyun veri modeli
├── widgets/
│   └── game_card.dart        # Oyun kartı widget'ı
└── utils/
    └── game_settings.dart    # Oyun ayarları yönetimi
```

## Kurulum

### Gereksinimler

- Flutter SDK (3.0.0 veya üzeri)
- Dart SDK
- Android Studio / VS Code
- Android SDK / Xcode (platform'a göre)

### Adımlar

1. Projeyi klonlayın:
```bash
git clone https://github.com/Ozdemiroguz/flutter_basic_games.git
cd flutter_basic_games
```

2. Bağımlılıkları yükleyin:
```bash
flutter pub get
```

3. Uygulamayı çalıştırın:
```bash
flutter run
```

## Kullanım

### Ana Menü
- Uygulamayı açtığınızda tüm oyunları görebileceğiniz ana menü karşınıza çıkar
- Oynamak istediğiniz oyuna tıklayın

### Ayarlar
- Sağ üst köşedeki ayarlar ikonuna tıklayın
- Renk teması, zorluk seviyesi ve diğer oyun ayarlarını özelleştirin
- "Save Settings" butonuna basarak değişiklikleri kaydedin

### Oyunlar

**Tic Tac Toe:**
- Sırayla X ve O işaretlerini yerleştirin
- 3 tanesini sıralayarak kazanın
- Skorlar otomatik olarak kaydedilir

**Memory Game:**
- Kartları açarak eşlerini bulun
- Tüm eşleri bulmaya çalışın
- Hamle sayınızı minimize edin

**Snake:**
- Ok tuşları ile yılanı yönlendirin
- Yemi yiyerek büyüyün
- Duvarlara veya kendinize çarpmadan devam edin

**2048:**
- Kaydırarak sayıları hareket ettirin
- Aynı sayıları birleştirin
- 2048'e ulaşmaya çalışın

## Katkıda Bulunma

1. Bu repository'yi fork edin
2. Feature branch oluşturun (`git checkout -b feature/YeniOzellik`)
3. Değişikliklerinizi commit edin (`git commit -m 'Yeni özellik eklendi'`)
4. Branch'inizi push edin (`git push origin feature/YeniOzellik`)
5. Pull Request oluşturun

## Lisans

Bu proje açık kaynaklıdır ve özgürce kullanılabilir.

## İletişim

Sorularınız veya önerileriniz için issue açabilirsiniz.

## Ekran Görüntüleri

(Uygulama çalıştırıldıktan sonra ekran görüntüleri eklenebilir)

## Teknik Detaylar

- **State Management**: StatefulWidget
- **Depolama**: SharedPreferences
- **UI Framework**: Material Design 3
- **Minimum SDK**: Flutter 3.0.0

## Gelecek Geliştirmeler

- [ ] Daha fazla oyun eklenmesi
- [ ] Ses efektleri
- [ ] Online multiplayer
- [ ] Liderlik tablosu
- [ ] Başarımlar sistemi