# Katkı rehberi

Katkılar küçük, güvenli ve yeniden çalıştırılabilir olmalıdır.

## Yerel geliştirme

1. Repoyu fork edin ve kendi branch'inizi açın.
2. Script değişikliklerinde `set -euo pipefail` davranışını koruyun.
3. Kullanıcı dosyalarını silen veya üzerine yazan komut eklemeyin.
4. Paket kurulumunu Ubuntu 22.04 ve 24.04 ile uyumlu tutun.
5. Değişiklikten sonra kontrolleri çalıştırın:

```bash
shellcheck setup.sh scripts/*.sh
./scripts/check_env.sh
./scripts/create_cpp_workspace.sh "$(mktemp -d)/cpp-lab"
./scripts/run_smoke_tests.sh
```

## C++ örnekleri

- C++17 ile derlenmelidir.
- `-Wall -Wextra -Wpedantic` altında uyarı üretmemelidir.
- Kısa Türkçe yorumlar içermeli, tek bir kavramı göstermelidir.
- Platforma özgü veya tanımsız davranıştan kaçınmalıdır.

## Pull request

PR açıklamasında problemi, çözümü, çalıştırılan testleri ve kullanıcıya görünen değişikliği yazın. Sistem ayarı değiştiren, dağıtım sıfırlayan veya kullanıcı onayı olmadan veri silen katkılar kabul edilmez.

