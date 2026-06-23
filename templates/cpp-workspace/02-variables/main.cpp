#include <iostream>
#include <string>

int main() {
    // Değişkenin türü, bellekte nasıl yorumlanacağını belirler.
    const std::string name = "Ada";
    int experienceYears = 2;
    double score = 87.5;

    std::cout << name << " | deneyim: " << experienceYears << " | puan: " << score << '\n';
    return 0;
}

