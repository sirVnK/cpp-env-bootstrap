#include <iostream>
#include <string_view>

enum class State { Idle, Running, Stopped };
enum class Event { Start, Stop };

State transition(const State current, const Event event) {
    // Durum makinesi, geçerli durum ve olaya göre sıradaki durumu seçer.
    if (current == State::Idle && event == Event::Start) {
        return State::Running;
    }
    if (current == State::Running && event == Event::Stop) {
        return State::Stopped;
    }
    return current;
}

std::string_view stateName(const State state) {
    switch (state) {
        case State::Idle:
            return "IDLE";
        case State::Running:
            return "RUNNING";
        case State::Stopped:
            return "STOPPED";
    }
    return "UNKNOWN";
}

int main() {
    State state = State::Idle;
    state = transition(state, Event::Start);
    std::cout << "Durum: " << stateName(state) << '\n';
    state = transition(state, Event::Stop);
    std::cout << "Durum: " << stateName(state) << '\n';
    return 0;
}

