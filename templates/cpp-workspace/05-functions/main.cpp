#include <iostream>

// Fonksiyon, tek bir işi isimlendirip tekrar kullanmamızı sağlar.
int maxValue(const int left, const int right) {
    return left > right ? left : right;
}

int main() {
    std::cout << "Büyük değer: " << maxValue(17, 42) << '\n';
    return 0;
}

