# cpp-env-bootstrap

Windows + WSL 2 + Ubuntu + VS Code üzerinde güvenli, tekrar çalıştırılabilir bir C++17/C++20 geliştirme ortamı hazırlar. Araçları kurar, ortamı kontrol eder, kısa mülakat örneklerinden oluşan `~/cpp-lab` çalışma alanını üretir ve gerçek derleme testleri çalıştırır.

## Bu proje ne işe yarar?

- Windows tarafında WSL, Ubuntu, WSL 2, VS Code ve `code` komutunu salt-okunur kontrollerle doğrular.
- Ubuntu tarafında `g++`, `gdb`, CMake, Ninja, Git, Clang ve yardımcı araçları kurar.
- Eksikleri açıkça raporlar ve başarı/başarısızlık için anlamlı exit code döndürür.
- C++ temellerinden gömülü sistem tarzı yangın alarmı durum makinesine uzanan bir çalışma alanı oluşturur.
- `g++` ve CMake + Ninja ile smoke test yapar.
- Var olan çalışma dosyalarını silmez veya üzerlerine yazmaz.

## Kimler için?

- Windows üzerinde ilk C++ ortamını kuranlar
- WSL ve VS Code ile Linux araç zinciri kullanmak isteyenler
- C++ mülakatına kısa ve sıralı örneklerle hazırlananlar
- Tekrarlanabilir bir eğitim ortamını ekip arkadaşlarıyla paylaşanlar

## Gereksinimler

- Windows 10 veya 11
- WSL 2
- Ubuntu 22.04 veya 24.04
- VS Code
- İnternet bağlantısı ve Ubuntu içinde `sudo` yetkisi
- Git

Windows kontrol scripti hiçbir WSL dağıtımını silmez/sıfırlamaz, WSL sürümünü değiştirmez ve sistem özelliğini otomatik açmaz. Eksiklerde uygulanacak komutu yalnızca önerir.

## Windows tarafında kullanım

PowerShell açın:

```powershell
git clone https://github.com/KULLANICI_ADI/cpp-env-bootstrap.git
cd cpp-env-bootstrap
powershell -ExecutionPolicy Bypass -File scripts/bootstrap_windows.ps1
```

Script başarısız olursa yazdığı önerileri uygulayın ve kontrolü yeniden çalıştırın. Yaygın ilk kurulum komutu yönetici PowerShell'de `wsl --install -d Ubuntu` komutudur; bu komutu bootstrap scripti kendiliğinden çalıştırmaz.

## WSL Ubuntu tarafında kullanım

Ubuntu terminalini Windows Başlat menüsünden veya PowerShell'de `wsl` yazarak açın. Repoyu Linux ev dizinine klonlamak dosya performansı açısından önerilir:

```bash
cd ~
git clone https://github.com/KULLANICI_ADI/cpp-env-bootstrap.git
cd cpp-env-bootstrap
chmod +x setup.sh scripts/*.sh
./setup.sh
```

`sudo apt update` ve eksik paketlerin kurulumu sırasında Ubuntu parolanız istenebilir.

## Tek komutla kurulum

Repo klonlandıktan ve çalıştırma izinleri verildikten sonra:

```bash
./setup.sh
```

Farklı bir çalışma alanı yolu da verilebilir:

```bash
./setup.sh ~/projects/cpp-lab
```

Script sırasıyla Ubuntu araçlarını kurar, ortamı kontrol eder, workspace'i oluşturur ve smoke testleri çalıştırır. Tekrar çalıştırmak güvenlidir; mevcut eğitim dosyalarınız korunur.

## Ortam kontrolü

Kurulum yapmadan yalnızca mevcut ortamı incelemek için:

```bash
./scripts/check_env.sh
echo $?
```

Tüm zorunlu komutlar varsa exit code `0`, eksik komut veya yanlış çalışma ortamı varsa `1` döner. Örnek satırlar:

```text
[OK] OK: g++ bulundu
[OK] OK: gdb bulundu
[ERROR] MISSING: ninja bulunamadı (Ubuntu paketi: ninja-build)
```

## C++ workspace oluşturma

Varsayılan konum `~/cpp-lab`:

```bash
./scripts/create_cpp_workspace.sh
```

Özel konum:

```bash
./scripts/create_cpp_workspace.sh ~/projects/cpp-lab
```

Script sadece eksik dosyaları kopyalar. Var olan `main.cpp`, VS Code ayarı veya CMake dosyasının üzerine yazmaz.

## Smoke test çalıştırma

```bash
./scripts/run_smoke_tests.sh
```

Bu test ortam kontrolünü çalıştırır, geçici bir C++17 programını `g++` ile derleyip çıktısını doğrular ve CMake örneğini Ninja ile build eder. Başarı mesajı:

```text
C++ WSL development environment is ready.
```

## VS Code ile açma

WSL Ubuntu terminalinde:

```bash
cd ~/cpp-lab
code .
```

VS Code pencerenizin sol alt köşesinde `WSL: Ubuntu` yazmalıdır. Yoksa `WSL` eklentisini kurun ve komut paletinden `WSL: Reopen Folder in WSL` seçin. C/C++ eklentisi için:

```bash
code --install-extension ms-vscode.cpptools
```

## Debug nasıl yapılır?

1. Örneğin `01-hello-world/main.cpp` dosyasını editörde aktif edin.
2. Bir satırın soluna tıklayıp breakpoint koyun.
3. `Ctrl+Shift+B` ile aktif dosyayı C++17 olarak derleyin.
4. `F5` tuşuna basıp `C++: aktif örneği GDB ile çalıştır` yapılandırmasını seçin.

Build görevi aktif C++ dosyasını `g++ -std=c++17 -Wall -Wextra -g` ile derleyip workspace kökündeki `app` dosyasını üretir. Debug yapılandırması aynı dosyayı önce build eder, sonra GDB ile açar.

## Sık hatalar

### `Permission denied`

```bash
chmod +x setup.sh scripts/*.sh
```

### `sudo: command not found`

Ubuntu yerine Git Bash kullanıyor olabilirsiniz. `uname -a` çıktısında Linux ve Microsoft/WSL ifadelerini kontrol edin.

### `code: command not found`

VS Code'u Windows PATH seçeneği etkin şekilde kurun, terminali yeniden açın ve Windows PowerShell'de `code --version` doğrulayın.

### VS Code Windows derleyicisini görüyor

Klasörü WSL penceresinde açın. Sol altta `WSL: Ubuntu` görünmeli; terminalde `which g++` çıktısı `/usr/bin/g++` olmalıdır.

### CMake eski veya yanlış generator kullanıyor

Eski build klasörünü yalnızca kendi projenizde ve içeriğinden eminseniz kaldırın; ardından `cmake -S . -B build -G Ninja` çalıştırın. Ayrıntılı çözümler [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) içindedir.

## Mülakat için önerilen çalışma sırası

Her klasörü okuyun, tahmin ettiğiniz çıktıyı yazın, derleyin ve sonra küçük bir değişiklik yapın:

1. `01-hello-world` — `main` ve temel çıktı
2. `02-variables` — türler, `const`, yaşam süresi
3. `03-if-else` — karar yapıları
4. `04-loops` — döngüler ve koleksiyonlar
5. `05-functions` — parametre ve dönüş değeri
6. `06-arrays` — sabit boyutlu diziler
7. `07-pointers` — adres ve dereference
8. `08-references` — referansla parametre geçirme
9. `09-struct-enum` — veri ve durum modelleme
10. `10-classes` — kapsülleme
11. `11-constructors` — nesne başlatma
12. `12-state-machine` — deterministik durum geçişi
13. `13-fire-alarm-simulation` — sensör, eşik ve gömülü sistem simülasyonu

Ezber akışı ve her başlık için konuşma notları [docs/INTERVIEW_PREP_CPP.md](docs/INTERVIEW_PREP_CPP.md) dosyasındadır.

## Manuel kabul testleri

```bash
cd ~/cpp-lab/01-hello-world
g++ -std=c++17 -Wall -Wextra -g main.cpp -o app
./app

cd ~/cpp-lab/13-fire-alarm-simulation
g++ -std=c++17 -Wall -Wextra -g main.cpp -o app
./app

cd ~/cpp-lab/cmake-sample
cmake -S . -B build -G Ninja
cmake --build build
./build/cmake_sample
```

## Ek belgeler

- [Günlük çalışma akışı](docs/WORKFLOW.md)
- [Sorun giderme](docs/TROUBLESHOOTING.md)
- [C++ mülakat hazırlığı](docs/INTERVIEW_PREP_CPP.md)
- [Katkı rehberi](CONTRIBUTING.md)

## Lisans

MIT — ayrıntılar [LICENSE](LICENSE) dosyasındadır.

