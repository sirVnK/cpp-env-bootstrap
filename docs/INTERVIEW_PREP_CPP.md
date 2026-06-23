# C++ mülakat ezber sırası

Bu belge bir “cevabı ezberle” listesi değil, kavramları doğru sırada geri çağırma iskeletidir. Her başlıkta önce tanımı söyleyin, sonra küçük örneği açıklayın, en son maliyet/güvenlik tercihinden bahsedin.

## 1. `main`

**Kısa açıklama:** İşletim sisteminin C++ programına girdiği standart başlangıç noktasıdır. `int` döndürür; `0` başarıyı ifade eder.

```cpp
#include <iostream>

int main() {
    std::cout << "Merhaba\n";
    return 0;
}
```

**Mülakatta nasıl anlatılır?** “Program `main` ile başlar. Akışı küçük fonksiyonlara dağıtırım; `main` orchestration yapar ve anlamlı bir exit code döndürür.”

## 2. Variable

**Kısa açıklama:** Bir türü, adı, değeri ve yaşam süresi olan nesnedir. Değişmemesi gereken veriyi `const` yaparız.

```cpp
const int threshold = 70;
double temperature = 24.5;
temperature = 25.0;
```

**Mülakatta nasıl anlatılır?** “Tür, bellekteki temsil ve izin verilen işlemleri belirler. Değeri değiştirmeyeceksem niyeti ve derleyici kontrolünü güçlendirmek için `const` kullanırım.”

## 3. `if/else`

**Kısa açıklama:** Boolean koşula göre farklı kod yollarından birini seçer. Özel ve tehlikeli durumları genellikle önce kontrol etmek okunabilirliği artırır.

```cpp
if (temperature >= 70) {
    alarm();
} else if (temperature >= 50) {
    warn();
} else {
    monitor();
}
```

**Mülakatta nasıl anlatılır?** “Koşulları birbirini dışlayacak sırada yazarım. Sınır değerlerini özellikle test ederim: 49, 50, 69 ve 70 gibi.”

## 4. Loop

**Kısa açıklama:** Bir işi koşula veya koleksiyondaki elemanlara göre tekrarlar. Range-based `for`, indeks gerekmiyorsa sade ve güvenlidir.

```cpp
const std::vector<int> values{2, 4, 8};
for (const int value : values) {
    std::cout << value << '\n';
}
```

**Mülakatta nasıl anlatılır?** “İndekse ihtiyacım yoksa range-based `for` seçerim. Sonsuz döngü, off-by-one ve koleksiyonu iterasyon sırasında değiştirme risklerini kontrol ederim.”

## 5. Function

**Kısa açıklama:** Parametre alabilen, tek bir sorumluluğu isimlendiren ve sonuç döndürebilen kod birimidir.

```cpp
int add(const int left, const int right) {
    return left + right;
}
```

**Mülakatta nasıl anlatılır?** “Küçük ve saf fonksiyonlar test edilmeyi kolaylaştırır. Küçük temel türleri değerle, kopyası pahalı ve değişmeyecek nesneleri `const&` ile geçiririm.”

## 6. Array

**Kısa açıklama:** Aynı türde sabit sayıda elemanı ardışık tutar. C++ kodunda boyut bilgisi taşıdığı için ham dizi yerine çoğunlukla `std::array` tercih edilir.

```cpp
std::array<int, 3> samples{10, 20, 30};
samples.at(1) = 25;
```

**Mülakatta nasıl anlatılır?** “`std::array` stack üzerinde sabit boyutlu saklama ve iterator desteği verir. Dinamik boyut gerekiyorsa `std::vector` kullanırım. `at` sınır kontrolü yapar, `operator[]` yapmaz.”

## 7. Pointer

**Kısa açıklama:** Başka bir nesnenin adresini tutar; null olabilir ve `*` ile işaret edilen değere erişilir. Sahiplik ile yalnızca gözlemleme ayrılmalıdır.

```cpp
int value = 7;
int* pointer = &value;
if (pointer != nullptr) {
    *pointer = 9;
}
```

**Mülakatta nasıl anlatılır?** “Ham pointer'ı çoğunlukla sahiplik taşımayan, null olabilen erişim için kullanırım. Sahiplik için RAII ve `std::unique_ptr`; paylaşımlı sahiplik gerçekten gerekiyorsa `std::shared_ptr` seçerim.”

## 8. Reference

**Kısa açıklama:** Var olan nesneye alias olur; bağlandıktan sonra başka nesneye yöneltilemez ve normal kullanımda null değildir.

```cpp
void increment(int& value) {
    ++value;
}
```

**Mülakatta nasıl anlatılır?** “Zorunlu bir nesneyle çalışıyorsam referans niyeti daha iyi anlatır. Değiştirmeyeceksem `const T&`, değiştireceksem `T&` kullanırım; opsiyonellik gerekiyorsa pointer düşünülebilir.”

## 9. Struct

**Kısa açıklama:** İlişkili alanları tek bir kullanıcı tanımlı türde toplar. `struct` üyeleri varsayılan olarak `public`tir.

```cpp
struct Reading {
    double temperature;
    double smoke;
};
```

**Mülakatta nasıl anlatılır?** “Basit veri taşıyan ve invarianta ihtiyaç duymayan tiplerde `struct` kullanırım. Davranış ve korunan invariant arttıkça kapsüllemeyi class ile belirginleştiririm.”

## 10. Enum

**Kısa açıklama:** Bir değerin alabileceği isimli, sınırlı seçenekleri modeller. `enum class` isim çakışmasını ve istemsiz integer dönüşümünü önler.

```cpp
enum class State { Normal, Warning, Alarm };
State current = State::Normal;
```

**Mülakatta nasıl anlatılır?** “Boolean sayısı büyüyüp geçersiz kombinasyonlar oluşturuyorsa durumları `enum class` ile tek tipe indirgerim. `switch` kullanırken bütün değerleri ele alırım.”

## 11. Class

**Kısa açıklama:** Veri ile o verinin geçerli kalmasını sağlayan davranışı bir araya getirir. `private` üyeler kapsülleme sınırını oluşturur.

```cpp
class Counter {
  public:
    void increment() { ++value_; }
    [[nodiscard]] int value() const { return value_; }

  private:
    int value_{0};
};
```

**Mülakatta nasıl anlatılır?** “Class'ın görevi yalnızca alanları saklamak değil, invariantı korumaktır. Küçük bir public API, `const` üye fonksiyonlar ve açık sahiplik tercih ederim.”

## 12. Constructor

**Kısa açıklama:** Nesne oluşturulurken üyeleri başlatır ve nesneyi geçerli ilk duruma getirir. Üyeler constructor gövdesinden önce initializer list ile kurulmalıdır.

```cpp
class Sensor {
  public:
    Sensor(double temperature, double smoke)
        : temperature_(temperature), smoke_(smoke) {}

  private:
    double temperature_;
    double smoke_;
};
```

**Mülakatta nasıl anlatılır?** “Initializer list gereksiz önce oluştur-sonra ata adımını önler ve `const`/reference üyelerde zorunludur. Geçersiz nesne oluşmasına izin vermemeye çalışırım.”

## 13. State machine

**Kısa açıklama:** Sistemin sınırlı durumlarını ve olaylara göre izin verilen geçişleri açıkça modeller. Sonraki durum yalnızca geçerli durum ve girdiden türetilebilir.

```cpp
enum class State { Idle, Running };
enum class Event { Start, Stop };

State transition(State state, Event event) {
    if (state == State::Idle && event == Event::Start) {
        return State::Running;
    }
    if (state == State::Running && event == Event::Stop) {
        return State::Idle;
    }
    return state;
}
```

**Mülakatta nasıl anlatılır?** “Dağınık flag'ler yerine durum ve geçiş tablosu kullanırım. Geçersiz olayı yok sayma, hata verme veya güvenli duruma geçme politikası gereksinimle belirlenir ve sınır geçişleri test edilir.”

## 14. Embedded fire alarm simulation

**Kısa açıklama:** Sensör okumasını karar mantığından ayırır. Controller, sıcaklık ve duman eşiklerini değerlendirip en yüksek riskli durumu seçer ve durum değişimini loglar.

```cpp
enum class SystemState { NORMAL, WARNING, ALARM };

SystemState evaluate(double temperature, double smoke) {
    if (temperature >= 70.0 || smoke >= 80.0) {
        return SystemState::ALARM;
    }
    if (temperature >= 50.0 || smoke >= 40.0) {
        return SystemState::WARNING;
    }
    return SystemState::NORMAL;
}
```

**Mülakatta nasıl anlatılır?** “`Sensor` ölçümü temsil ediyor, `AlarmController` politika ve state machine'i yönetiyor. Önce ALARM eşiklerini kontrol ederek tehlikeli duruma öncelik veriyorum. Gerçek gömülü sistemde örnekleme aralığı, sensör hatası, hysteresis/debounce, watchdog, kalıcı log ve fail-safe çıkışları ayrıca tasarlarım.”

## Son tekrar: 60 saniyelik bağlantı

“Program `main` ile başlar. Değişkenler ve koşullar veriyi işler; döngüler tekrar, fonksiyonlar sorumluluk ayrımı sağlar. Array veriyi toplar; pointer ve reference erişim/sahiplik niyetini taşır. Struct ve enum problem alanını modeller. Class ve constructor geçerli nesne durumunu korur. State machine geçişleri deterministik yapar. Yangın alarmında sensör verisini controller'a verip eşiklerden `NORMAL`, `WARNING`, `ALARM` durumlarını üretir ve kritik duruma öncelik veririm.”

