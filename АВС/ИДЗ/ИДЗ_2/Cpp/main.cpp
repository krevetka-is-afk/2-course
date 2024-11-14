#include <iostream>
#include <cmath>

double exp_inverse(double x, double tolerance = 0.0005) {
    double term = 1.0;   // Начальный член ряда
    double sum = term;   // Начальная сумма
    int n = 1;           // Счётчик для факториала и степени

    while (fabs(term) > tolerance * sum) {
        term *= -x / n;  // Рассчитываем следующий член ряда
        sum += term;     // Добавляем его к сумме
        n++;             // Переход к следующему члену ряда
    }

    return sum;
}

int main() {
    double x;
    std::cout << "Введите значение x: ";
    std::cin >> x;

    double result = exp_inverse(x);
    std::cout << "Значение 1/e^" << x << " приближенно равно: " << result << std::endl;

    return 0;
}
