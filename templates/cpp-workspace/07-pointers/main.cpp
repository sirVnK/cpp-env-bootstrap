#include <iostream>

int main() {
    int value = 10;
    int* valuePointer = &value;

    // Pointer bir nesnenin bellek adresini tutar; * ile değere erişiriz.
    *valuePointer = 25;
    std::cout << "Değer: " << value << ", adres: " << valuePointer << '\n';
    return 0;
}

