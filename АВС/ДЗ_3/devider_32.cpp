#include <iostream>

int DivisionCalc(int &divident, int &divider) {
  int quotient = 0;
  int remainder = 0;

  if (divider != 0) {
    if (divident != 0) {
      int sign = ((divident < 0) & (divider < 0)) ? 1 : -1;
      divident = (divident < 0) ? -1*divident : divident;
      divider = (divider < 0) ? -1*divider : divider;


      while (divident > divider) {

      }
    } else {
      return 0;
    }
    
  } else {
    return -1;
  }

  

}



int main() {
  int divident = 0;
  int divider = 0;

  std::cout << "input divident: ";
   std::cin >> divident;
  std::cout << "input divider: ";
  std::cin >> divider;
}