#include <iostream>
#include <string>

enum class DeviceState { Off, Ready, Error };

struct Device {
    std::string name;
    DeviceState state;
};

int main() {
    // struct ilişkili verileri, enum class ise sınırlı durumları modeller.
    const Device sensor{"Sıcaklık sensörü", DeviceState::Ready};
    const bool isReady = sensor.state == DeviceState::Ready;
    std::cout << sensor.name << ": " << (isReady ? "hazır" : "hazır değil") << '\n';
    return 0;
}

