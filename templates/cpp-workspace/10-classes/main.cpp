#include <iostream>

class Rectangle {
  public:
    void setSize(const double width, const double height) {
        width_ = width;
        height_ = height;
    }

    [[nodiscard]] double area() const {
        return width_ * height_;
    }

  private:
    // private alanlar sınıfın iç durumunu kapsüller.
    double width_{0.0};
    double height_{0.0};
};

int main() {
    Rectangle rectangle;
    rectangle.setSize(4.0, 3.5);
    std::cout << "Alan: " << rectangle.area() << '\n';
    return 0;
}

