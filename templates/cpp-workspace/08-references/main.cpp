#include <iostream>

// Referans, var olan nesneye başka bir isim verir ve null olamaz.
void swapValues(int& left, int& right) {
    const int temporary = left;
    left = right;
    right = temporary;
}

int main() {
    int first = 7;
    int second = 11;
    swapValues(first, second);
    std::cout << "first=" << first << ", second=" << second << '\n';
    return 0;
}

