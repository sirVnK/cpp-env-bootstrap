# Windows, WSL 2, Ubuntu ve Git Kurulum Kılavuzu

Bu kılavuz, projeyi Windows 11 bilgisayarında ilk kez kuracak kullanıcılar içindir. Önerilen çalışma düzeni şöyledir:

```text
Windows 11
└── WSL 2
    └── Ubuntu
        ├── Git ile repository clone
        ├── Bash setup scriptleri
        └── C++ araç zinciri ve ~/cpp-lab
```

Projenin `.sh` dosyaları Windows PowerShell'de değil, WSL içindeki Ubuntu terminalinde çalıştırılır.

## 1. Windows sürümünü kontrol edin

Başlat menüsünde `winver` aratıp çalıştırın. Güncel bir Windows 11 kurulumu önerilir. Windows Update üzerinden bekleyen güncellemeleri tamamlayın ve gerekirse bilgisayarı yeniden başlatın.

## 2. WSL durumunu kontrol edin

PowerShell'i açın ve şu komutları çalıştırın:

```powershell
wsl --status
wsl -l -v
```

Ubuntu listeleniyor ve `VERSION` sütununda `2` görünüyorsa doğrudan [Ubuntu içinde Git kurulumu](#5-ubuntu-içinde-git-kurulumu) bölümüne geçebilirsiniz.

## 3. WSL 2 ve Ubuntu'yu kurun

WSL veya Ubuntu kurulu değilse PowerShell'i **Yönetici olarak çalıştırın** ve şu komutu kullanın:

```powershell
wsl --install -d Ubuntu
```

Windows yeniden başlatma isterse yeniden başlatın. Ardından Başlat menüsünden **Ubuntu** uygulamasını açın. İlk açılışta Ubuntu sizden bir Linux kullanıcı adı ve parola ister.

- Bu kullanıcı adı Windows hesabından farklı olabilir.
- Parolayı yazarken ekranda karakter veya yıldız görünmez; bu normaldir.
- Bu parola daha sonra `sudo` komutlarında kullanılır.

Kurulumu PowerShell'den doğrulayın:

```powershell
wsl --status
wsl -l -v
```

Örnek beklenen görünüm:

```text
  NAME      STATE           VERSION
* Ubuntu    Running         2
```

## 4. Ubuntu WSL 1 kullanıyorsa WSL 2'ye geçirin

Önce tam dağıtım adını öğrenin:

```powershell
wsl -l -v
```

Sonra listelenen adı kullanarak dönüştürün:

```powershell
wsl --set-version Ubuntu 2
```

Dağıtım adı `Ubuntu-22.04` gibi farklıysa komutta o adı kullanın. İşlem tamamlandıktan sonra `wsl -l -v` ile tekrar kontrol edin. Dağıtımı silmeniz, sıfırlamanız veya `unregister` etmeniz gerekmez.

## 5. Ubuntu içinde Git kurulumu

Repository'yi klonlayabilmek için Git'in clone işleminden **önce** Ubuntu içinde kurulu olması gerekir. Ubuntu terminalini açın ve kontrol edin:

```bash
git --version
```

Komut bulunamazsa Git'i Ubuntu paketlerinden kurun:

```bash
sudo apt update
sudo apt install -y git
git --version
```

Bu proje repoyu WSL içindeki Linux ev dizinine klonlamayı önerir. Bu nedenle gerekli olan Git, **Ubuntu içindeki Git** paketidir.

### Git for Windows gerekli mi?

Önerilen WSL akışı için Git for Windows zorunlu değildir. PowerShell veya Windows uygulamaları içinden ayrıca Git kullanmak istiyorsanız [git-scm.com](https://git-scm.com/download/win) adresinden Git for Windows kurabilirsiniz.

Git for Windows ile Ubuntu içindeki Git iki ayrı kurulumdur:

- PowerShell'deki `git.exe`, Windows dosya sistemi için çalışır.
- Ubuntu terminalindeki `/usr/bin/git`, WSL Linux ortamı için çalışır.
- Git for Windows kurmak, Ubuntu içindeki Git ihtiyacını ortadan kaldırmaz.

## 6. Repository'yi doğru konuma klonlayın

Ubuntu terminalinde Linux ev dizinine geçin ve projeyi klonlayın:

```bash
cd ~
git clone https://github.com/sirVnK/cpp-env-bootstrap.git
cd cpp-env-bootstrap
```

Konumu doğrulayın:

```bash
pwd
```

Çıktı yaklaşık olarak `/home/kullanici/cpp-env-bootstrap` olmalıdır. `/mnt/c/...` altında olmamalıdır.

Linux ev dizini önerilir çünkü `/mnt/c` altında dosya izinleri, CRLF satır sonları, sembolik bağlantılar ve yoğun derleme performansı konusunda sorun yaşanabilir.

## 7. Kurulum scriptini çalıştırın

Ubuntu terminalinde repository klasöründeyken:

```bash
chmod +x setup.sh scripts/*.sh
./setup.sh
```

Ubuntu parolanız istenebilir. Yazarken karakter görünmemesi normaldir.

Kurulum başarıyla tamamlandığında şu mesajları görürsünüz:

```text
[OK] Ubuntu C++ araç zinciri hazır.
[OK] C++ WSL development environment is ready.
[OK] Kurulum ve testler tamamlandı.
```

`[WARN] Korundu, zaten var` mesajı hata değildir. Daha önce oluşturulmuş bir çalışma dosyasının üzerine yazılmadığını belirtir.

## 8. Ortamı doğrulayın

```bash
./scripts/check_env.sh
./scripts/run_smoke_tests.sh
```

Araç sürümlerini ayrıca kontrol edebilirsiniz:

```bash
g++ --version
cmake --version
ninja --version
gdb --version
```

## 9. Visual Studio Code kurulumu

Visual Studio Code'u Windows'a kurun. Kurulum sırasında mümkünse **Add to PATH** seçeneğini etkinleştirin.

PowerShell'de WSL eklentisini kurun:

```powershell
code --install-extension ms-vscode-remote.remote-wsl
```

Microsoft C/C++ eklentisini de kurabilirsiniz:

```powershell
code --install-extension ms-vscode.cpptools
```

Sonra Ubuntu terminalinde oluşturulan çalışma alanını açın:

```bash
cd ~/cpp-lab
code .
```

VS Code'un sol alt köşesinde şu ifade görünmelidir:

```text
WSL: Ubuntu
```

Bu ifade görünmüyorsa VS Code komut paletinden **WSL: Reopen Folder in WSL** komutunu kullanın.

## 10. İlk C++ programını derleyin

Ubuntu veya VS Code'un WSL terminalinde:

```bash
cd ~/cpp-lab/01-hello-world
g++ -std=c++17 -Wall -Wextra main.cpp -o app
./app
```

Tek satırlık biçim:

```bash
g++ -std=c++17 -Wall -Wextra main.cpp -o app && ./app
```

## 11. CMake ve Ninja örneğini çalıştırın

```bash
cd ~/cpp-lab/cmake-sample
cmake -S . -B build -G Ninja
cmake --build build
./build/cmake_sample
```

## Sık karşılaşılan sorunlar

### PowerShell'de `g++ is not recognized`

`g++` Windows PowerShell yerine Ubuntu terminalinde çalıştırılmalıdır. Başlat menüsünden Ubuntu'yu açın veya PowerShell'de `wsl` komutunu kullanın.

### `git: command not found`

Ubuntu terminalinde:

```bash
sudo apt update
sudo apt install -y git
```

### `Permission denied: ./setup.sh`

```bash
chmod +x setup.sh scripts/*.sh
```

### `/usr/bin/env: 'bash\r': No such file or directory`

```bash
sed -i 's/\r$//' setup.sh scripts/*.sh
chmod +x setup.sh scripts/*.sh
```

### `code: command not found`

VS Code'u Windows'a kurun, `Add to PATH` seçeneğini etkinleştirin, terminalleri yeniden açın ve WSL eklentisini kurun.

### Repository yanlışlıkla `/mnt/c` altına klonlandı

Kişisel dosyalarınızı koruyun. Ardından Ubuntu terminalinde bu kılavuzdaki `cd ~` adımını kullanarak repository'yi Linux ev dizinine yeniden klonlayın. Mevcut klasörü otomatik olarak silmeyin.

Daha ayrıntılı hata çözümleri için [TROUBLESHOOTING.md](TROUBLESHOOTING.md) belgesine bakın.

