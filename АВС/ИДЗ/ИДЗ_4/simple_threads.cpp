// //
// // Created by Сергей Растворов on 13/12/24.
// //
// #include <iostream>
// #include <thread>
// #include <chrono>
// #include <mutex>
//
// // simple func
// void PrintSum(int a, int b) {
//     std::cout << "Сумма: " << a + b << std::endl;
// }
//
// // simple ref func
// void Increment(int& x) {
//     x++;
// }
//
// // simple this_thread and sleep_for example with chrono
// void BackgroundTask() {
//     for (int i = 0; i < 5; i++) {
//         std::cout << "backgroundTask" << std::endl;
//         std::this_thread::sleep_for(std::chrono::milliseconds(500));
//     }
// }
//
// // mutex lock_guard
// std::mutex mtx;
// void PrintSafe(const std::string& msg) {
//     std::lock_guard<std::mutex> lock(mtx);  // automatically blocking
//     std::cout << msg << std::endl;
// }
//
// void CalculateSum(const std::vector<int>& data, int start, int end, int& result) {
//     result = 0;
//     for (int i = start; i < end; i++) {
//         result += data[i];
//     }
// }
//
// int main() {
//     std::thread t(PrintSum, 5, 10); // Передача аргументов в поток
//     t.join();
//
//     // lambda func ([](){};);
//     std::thread t1([]() {
//         std::cout << "Привет из лямбда-функции!" << std::endl;
//     });
//     t1.join();
//
//     // args init
//     std::thread t2([]() {PrintSum(5, 10); });
//     t2.join();
//
//     // ref value example
//     int value = 0;
//     std::cout << "value: " << value << std::endl;
//     std::thread t3(Increment, std::ref(value));
//     t3.join();
//     std::cout << "value: " << value << std::endl;
//
//     // simple detaching thread
//     std::thread t4(BackgroundTask);
//     t4.detach();
//     std::cout << "main thread done" << std::endl;
//     std::this_thread::sleep_for(std::chrono::seconds(4));
//
//     // safe thread usage
//     std::thread t5(PrintSafe, "msg from thread t5");
//     std::thread t6(PrintSafe, "msg from thread t6");
//     t5.join();
//     t6.join();
//
//     // count of treads amount
//     const unsigned int n = std::thread::hardware_concurrency();
//     std::cout << "threads available: " << n << std::endl;
//
//     // multi threads counting
//     std::vector<int> data(1000, 1);
//     int sum1 = 0, sum2 = 0;
//     std::thread t7(CalculateSum, std::cref(data), 0, 500, std::ref(sum1));
//     std::thread t8(CalculateSum, std::cref(data), 0, 500, std::ref(sum2));
//     t7.join();
//     t8.join();
//     std::cout << "sum1: " << sum1 << std::endl;
//     std::cout << "sum2: " << sum2 << std::endl;
//     std::cout << "all: " << sum1 + sum2 << std::endl;
//
//     return 0;
// }
