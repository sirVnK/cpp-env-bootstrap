# Sorun giderme

## Doğru terminalde miyim?

```bash
uname -a
cat /etc/os-release
```

Hedef ortamda çekirdek Linux'tur, dağıtım Ubuntu'dur ve WSL altında `/proc/version` çoğunlukla Microsoft ifadesini içerir. `MINGW`, `MSYS` veya `CYGWIN` görüyorsanız Git Bash kullanıyorsunuz; Ubuntu uygulamasını açın.

## WSL bulunamadı

Yönetici PowerShell'de durum kontrolü:

```powershell
wsl --status
wsl --list --verbose
```

WSL eksikse Windows'un önerdiği yeniden başlatma adımlarını tamamlayarak `wsl --install -d Ubuntu` kullanın. Bootstrap scripti bu sistem değişikliğini sizin yerinize yapmaz.

## Ubuntu WSL 1 görünüyor

Önce tam dağıtım adını alın:

```powershell
wsl --list --verbose
```

Sonra adı birebir kullanın:

```powershell
wsl --set-version Ubuntu 2
```

Bu işlem sürebilir. Dağıtımı silmek veya unregister etmek gerekmez.

## `code` bulunamadı

Windows PowerShell'de:

```powershell
Get-Command code
code --version
```

Bulunmuyorsa VS Code kurulumunu `Add to PATH` seçeneğiyle onarın ve bütün terminal pencerelerini yeniden açın. Ardından WSL eklentisini kurun:

```powershell
code --install-extension ms-vscode-remote.remote-wsl
```

## `Permission denied: ./setup.sh`

```bash
chmod +x setup.sh scripts/*.sh
```

Repo `/mnt/c` altında ve izin davranışı beklenmedikse repoyu Linux ev dizinine (`~/cpp-env-bootstrap`) yeniden klonlamak daha sağlıklıdır.

## `apt` kilidi var

Başka bir Ubuntu güncellemesinin bitmesini bekleyin. Kilit dosyalarını elle silmeyin. Süreci görmek için:

```bash
ps aux | grep -E 'apt|dpkg'
```

Yarım kalmış meşru bir paket yapılandırması için hata mesajının önerdiği `sudo dpkg --configure -a` komutunu kullanın; önce çalışan başka paket yöneticisi olmadığından emin olun.

## Paket bulunamadı

```bash
sudo apt update
apt-cache policy cmake ninja-build clang-format
```

`/etc/apt/sources.list` veya proxy ayarlarını kurumsal ağ yöneticinizle doğrulayın. Rastgele üçüncü taraf depo eklemeyin.

## `ninja: command not found`

Ubuntu paket adı ile komut adı farklıdır:

```bash
sudo apt install ninja-build
ninja --version
```

## GDB breakpoint'e gelmiyor

- Aktif `main.cpp` dosyasını kaydedin.
- Build komutunda `-g` bulunduğunu doğrulayın.
- VS Code'u WSL penceresinde açın.
- `miDebuggerPath` değerinin `/usr/bin/gdb` olduğunu kontrol edin.
- Optimize edilmiş farklı bir binary yerine workspace kökündeki `app` dosyasının çalıştığından emin olun.

## CMake generator uyuşmazlığı

Aynı build klasörü daha önce başka generator ile oluşturulmuş olabilir. Yalnızca build çıktısı olduğundan emin olduğunuz proje klasöründe yeni bir ad kullanmak en güvenlisidir:

```bash
cmake -S . -B build-ninja -G Ninja
cmake --build build-ninja
./build-ninja/cmake_sample
```

## Script tekrar çalışınca dosyam değişmedi

Bu beklenen güvenlik davranışıdır. `create_cpp_workspace.sh` mevcut dosyaların üzerine yazmaz ve `Korundu, zaten var` mesajı verir. Güncel şablonla kendi dosyanızı `diff` kullanarak karşılaştırıp değişikliği elle birleştirin.

## Tanılama bilgisi toplama

```bash
./scripts/check_env.sh
g++ --version
cmake --version
ninja --version
printf 'WSL_DISTRO_NAME=%s\n' "${WSL_DISTRO_NAME:-yok}"
```

Hata bildirirken gizli bilgi içermediğini kontrol ederek komutu, tam hata çıktısını, Ubuntu sürümünü ve tekrar üretme adımlarını paylaşın.

