#include <iostream>
#include <vector>
#include <stdexcept>
#include <initializer_list>

struct TestCase {
  int dividend;
  int divisor;
};

struct TestResult {
  int dividend;
  int divisor;
  int quotient;
  int remainder;
  bool error;
};

// Функция для целочисленного деления с вычислением остатка
TestResult Divide(int dividend, int divisor) {
  TestResult result = {dividend, divisor, 0, 0, false};

  // Проверка на деление на ноль
  if (divisor == 0) {
    result.error = true;
    return result;
  }

  // Определение знака частного
  int sign = ((dividend < 0) ^ (divisor < 0)) ? -1 : 1;

  // Абсолютные значения для выполнения операций
  int abs_dividend = dividend < 0 ? -dividend : dividend;
  int abs_divisor = divisor < 0 ? -divisor : divisor;

  // Целочисленное деление через вычитание
  int quotient = 0;
  int remainder = abs_dividend;
  while (remainder >= abs_divisor) {
    remainder -= abs_divisor;
    quotient++;
  }

  // Применение знака к частному
  quotient *= sign;

  // Приведение остатка к знаку делимого
  if (dividend < 0) {
    remainder = -remainder;
  }

  result.quotient = quotient;
  result.remainder = remainder;
  return result;
}

// Функция для автоматизированного тестирования
void RunTests(const std::vector<TestCase>& test_cases) {
  for (const auto& test_case : test_cases) {
    TestResult result = Divide(test_case.dividend, test_case.divisor);

    std::cout << "Test Case: Dividend = " << test_case.dividend << ", Divisor = " << test_case.divisor << std::endl;

    if (result.error) {
      std::cout << "Error: Division by zero!" << std::endl;
    } else {
      std::cout << "Quotient = " << result.quotient << ", Remainder = " << result.remainder << std::endl;
    }

    std::cout << "-----------------------------" << std::endl;
  }
}

int main() {
  // Набор тестов
  std::vector<TestCase> test_cases = {
      {10, 3},    // Оба положительные
      {-10, -3},  // Оба отрицательные
      {10, -3},   // Положительное делимое, отрицательный делитель
      {-10, 3},   // Отрицательное делимое, положительный делитель
      {10, 0},    // Деление на ноль
      {-10, 0},   // Отрицательное деление на ноль
      {0, 3},     // Ноль делимое
      {0, -3}     // Ноль делимое с отрицательным делителем
  };

  // Запуск тестов
  RunTests(test_cases);

  return 0;
}
