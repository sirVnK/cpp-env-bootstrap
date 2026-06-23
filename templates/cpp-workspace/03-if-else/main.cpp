#include <iostream>

int main() {
    const int temperature = 58;

    // Koşullar programın karar vermesini sağlar.
    if (temperature >= 70) {
        std::cout << "Alarm" << '\n';
    } else if (temperature >= 50) {
        std::cout << "Uyarı" << '\n';
    } else {
        std::cout << "Normal" << '\n';
    }
    return 0;
}

