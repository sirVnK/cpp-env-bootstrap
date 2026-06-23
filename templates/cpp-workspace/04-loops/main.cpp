#include <iostream>
#include <vector>

int main() {
    const std::vector<int> readings{21, 24, 27, 31};

    // Range-based for, koleksiyondaki her elemanı sırayla işler.
    for (const int reading : readings) {
        std::cout << "Ölçüm: " << reading << '\n';
    }
    return 0;
}

