#include <iostream>
#include <string>
#include <utility>

class Employee {
  public:
    // Constructor nesneyi ilk andan geçerli bir duruma getirir.
    Employee(std::string name, const int level) : name_(std::move(name)), level_(level) {}

    void introduce() const {
        std::cout << name_ << ", seviye " << level_ << '\n';
    }

  private:
    std::string name_;
    int level_;
};

int main() {
    const Employee developer{"Deniz", 3};
    developer.introduce();
    return 0;
}

