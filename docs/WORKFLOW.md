# Önerilen çalışma akışı

## 1. Windows ön kontrolü

PowerShell içinde repoya girin ve yalnızca ön koşulları denetleyin:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/bootstrap_windows.ps1
```

Bu adım Windows ayarlarını değiştirmez. Eksik WSL, Ubuntu, WSL 2 veya VS Code bileşeni için uygulanabilir yönerge verir.

## 2. Ubuntu kurulumu

WSL Ubuntu terminalinde:

```bash
chmod +x setup.sh scripts/*.sh
./setup.sh
```

Akış şöyledir:

```text
bootstrap_ubuntu -> check_env -> create_cpp_workspace -> run_smoke_tests
```

Kurulum scripti her çalıştırmada paket indeksini günceller, yalnızca eksik paketleri kurar ve araç sürümlerini raporlar. Workspace scripti mevcut dosyalara dokunmaz.

## 3. Günlük çalışma

```bash
cd ~/cpp-lab
code .
```

Bir `main.cpp` dosyasını aktif edin:

- `Ctrl+Shift+B`: C++17 build
- `F5`: GDB ile debug
- Kaydetme: `clang-format` ile otomatik biçimlendirme

Terminalden manuel çalışmak için:

```bash
cd ~/cpp-lab/05-functions
g++ -std=c++17 -Wall -Wextra -g main.cpp -o app
./app
```

## 4. Öğrenme döngüsü

Her örnekte aynı kısa döngüyü uygulayın:

1. Kodu çalıştırmadan önce çıktıyı tahmin edin.
2. Kodu kendi cümlelerinizle açıklayın.
3. Derleyici uyarılarını açarak build edin.
4. Tek bir davranışı değiştirin.
5. Breakpoint koyup değişkenleri GDB'de izleyin.
6. Konuyu 60 saniyede anlatmayı deneyin.

## 5. Düzenli sağlık kontrolü

Araç güncellemesi veya Ubuntu yükseltmesi sonrasında:

```bash
./scripts/check_env.sh
./scripts/run_smoke_tests.sh
```

`~/cpp-lab` şablonuna yeni eksik dosyalar eklemek için workspace scriptini yeniden çalıştırabilirsiniz; kendi dosyalarınız korunur.

