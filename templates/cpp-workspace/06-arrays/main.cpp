#include <array>
#include <iostream>

int main() {
    // std::array sabit boyutlu ve tür güvenli bir dizidir.
    const std::array<int, 5> samples{3, 5, 8, 13, 21};
    int total = 0;

    for (const int sample : samples) {
        total += sample;
    }

    std::cout << "Toplam: " << total << '\n';
    return 0;
}

