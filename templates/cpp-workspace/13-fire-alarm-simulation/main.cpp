#include <iomanip>
#include <iostream>
#include <string_view>
#include <vector>

enum class SystemState { NORMAL, WARNING, ALARM };

class Sensor {
  public:
    Sensor(const double temperature, const double smoke)
        : temperature_(temperature), smoke_(smoke) {}

    [[nodiscard]] double temperature() const {
        return temperature_;
    }

    [[nodiscard]] double smoke() const {
        return smoke_;
    }

  private:
    double temperature_; // Santigrat derece
    double smoke_;       // Yüzde cinsinden duman yoğunluğu
};

class AlarmController {
  public:
    void update(const Sensor& sensor) {
        const SystemState previousState = state_;
        state_ = evaluate(sensor);

        std::cout << std::fixed << std::setprecision(1) << "[SENSOR] temperature="
                  << sensor.temperature() << " C, smoke=" << sensor.smoke() << "%\n";

        if (previousState != state_) {
            std::cout << "[STATE] " << stateName(previousState) << " -> " << stateName(state_)
                      << '\n';
        } else {
            std::cout << "[STATE] " << stateName(state_) << " (değişmedi)\n";
        }
    }

  private:
    static constexpr double WARNING_TEMPERATURE = 50.0;
    static constexpr double ALARM_TEMPERATURE = 70.0;
    static constexpr double WARNING_SMOKE = 40.0;
    static constexpr double ALARM_SMOKE = 80.0;

    SystemState state_{SystemState::NORMAL};

    // En tehlikeli eşik önce kontrol edilir; böylece ALARM önceliklidir.
    [[nodiscard]] static SystemState evaluate(const Sensor& sensor) {
        if (sensor.temperature() >= ALARM_TEMPERATURE || sensor.smoke() >= ALARM_SMOKE) {
            return SystemState::ALARM;
        }
        if (sensor.temperature() >= WARNING_TEMPERATURE || sensor.smoke() >= WARNING_SMOKE) {
            return SystemState::WARNING;
        }
        return SystemState::NORMAL;
    }

    [[nodiscard]] static std::string_view stateName(const SystemState state) {
        switch (state) {
            case SystemState::NORMAL:
                return "NORMAL";
            case SystemState::WARNING:
                return "WARNING";
            case SystemState::ALARM:
                return "ALARM";
        }
        return "UNKNOWN";
    }
};

int main() {
    // Zaman içinde değişen sensör okumalarını sırayla simüle ediyoruz.
    const std::vector<Sensor> readings{
        {24.0, 5.0},
        {53.0, 12.0},
        {63.0, 48.0},
        {74.0, 85.0},
        {29.0, 8.0},
    };

    AlarmController controller;
    for (const Sensor& reading : readings) {
        controller.update(reading);
    }
    return 0;
}

