#include <iostream>

void DivisionCalc(int &divident, int &divider) {
  int quotient = 0;
  int remainder = 0;

  if (divider != 0) {
    if (divident != 0) {
      int sign = ((divident < 0) ^ (divider < 0)) ? -1 : 1;
      int abs_divident = (divident < 0) ? -1 * divident : divident;
      int abs_divider = (divider < 0) ? -1 * divider : divider;

      if (abs_divident >= abs_divider) {
        remainder = abs_divident;
        while (remainder >= abs_divider) {
          remainder -= abs_divider;
          quotient++;
        }
      } else {
        remainder = abs_divider - abs_divident;
      }

      if (remainder != 0) {
        std::cout << sign * quotient << " Остаток " << sign * remainder << '\n';
      } else {
        std::cout << sign * quotient << '\n';
      }

    } else {
      std::cout << "0" << '\n';
    }

  } else {
    std::cout << "Division by ZERO" << '\n';
  }
}

// void ErrorOccured(int code) {
//   if (code != -1) {
//     std::cout << "result = " << code << '\n';
//   } else {
//     std::cout << "Divisin By ZERO!" << '\n';
//   }
// }

int main() {
  int divident = 0;
  int divider = 0;
  int condition = 1;
  while (condition) {
    std::cout << "input divident: ";
    std::cin >> divident;
    std::cout << "input divider: ";
    std::cin >> divider;

    DivisionCalc(divident, divider);
    std::cin >> condition;
  }
}