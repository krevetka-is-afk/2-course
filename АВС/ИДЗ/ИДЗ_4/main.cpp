#include <iostream>
#include <pthread.h>
#include <queue>
#include <vector>
#include <random>
#include <chrono>
#include <unistd.h>
#include <algorithm>

using namespace std;

// Константы
const int NUM_DEPARTMENTS = 3; // Количество отделов
bool exit_flag = false;        // Флаг завершения программы

// Глобальные переменные
pthread_mutex_t department_mutexes[NUM_DEPARTMENTS];  // Мьютексы для отделов
pthread_cond_t department_conds[NUM_DEPARTMENTS];     // Условные переменные для очередей
queue<int> department_queues[NUM_DEPARTMENTS];        // Очереди покупателей в каждом отделе
pthread_mutex_t cout_mutex = PTHREAD_MUTEX_INITIALIZER; // Мьютекс для вывода

bool sellers_free[NUM_DEPARTMENTS] = {true, true, true}; // Статус продавцов

// Функция для случайной задержки (симуляция работы)
void RandomSleep(int min_ms, int max_ms) {
    std::random_device rd;
    std::mt19937 gen(rd());
    std::uniform_int_distribution<> dist(min_ms, max_ms);
    usleep(dist(gen) * 1000);
}

// Безопасный вывод
void SafeCout(const string& message) {
    pthread_mutex_lock(&cout_mutex);
    cout << message << endl;
    pthread_mutex_unlock(&cout_mutex);
}

// Поток покупателя
void* CustomerThread(void* arg) {
    int customer_id = *(int*)arg;
    delete (int*)arg;  // Освобождаем память

    SafeCout("Покупатель " + to_string(customer_id) + " зашел в магазин.");

    // Случайный порядок посещения отделов
    vector<int> departments(NUM_DEPARTMENTS);
    iota(departments.begin(), departments.end(), 0);
    random_device rd;
    mt19937 gen(rd());
    ranges::shuffle(departments, gen);

    for (int dep : departments) {
        pthread_mutex_lock(&department_mutexes[dep]);

        if (!sellers_free[dep]) {
            SafeCout("Покупатель " + to_string(customer_id) +
                     " ждет в очереди у отдела " + to_string(dep) + ".");
            department_queues[dep].push(customer_id);

            while (!sellers_free[dep] || department_queues[dep].front() != customer_id) {
                pthread_cond_wait(&department_conds[dep], &department_mutexes[dep]);
            }

            department_queues[dep].pop();
        }

        sellers_free[dep] = false; // Продавец занят
        pthread_mutex_unlock(&department_mutexes[dep]);

        SafeCout("Покупатель " + to_string(customer_id) +
                 " обслуживается в отделе " + to_string(dep) + ".");
        RandomSleep(1000, 3000); // Симуляция обслуживания

        pthread_mutex_lock(&department_mutexes[dep]);
        sellers_free[dep] = true; // Продавец освобождается
        pthread_cond_signal(&department_conds[dep]); // Будим следующего покупателя
        pthread_mutex_unlock(&department_mutexes[dep]);

        SafeCout("Покупатель " + to_string(customer_id) +
                 " покидает отдел " + to_string(dep) + ".");
    }

    SafeCout("Покупатель " + to_string(customer_id) + " покидает магазин.");
    pthread_exit(nullptr);
}

// Поток продавца
void* SellerThread(void* arg) {
    int department_id = *(int*)arg;
    delete (int*)arg;

    while (!exit_flag) {
        pthread_mutex_lock(&department_mutexes[department_id]);
        if (!department_queues[department_id].empty()) {
            pthread_cond_signal(&department_conds[department_id]);
        }
        pthread_mutex_unlock(&department_mutexes[department_id]);

        RandomSleep(1000, 2000); // Продавец "отдыхает"
    }

    SafeCout("Продавец отдела " + to_string(department_id) + " завершает работу.");
    pthread_exit(nullptr);
}

int main() {
    int num_customers = 0;
    cout << "Введите количество покупателей: ";
    cin >> num_customers;

    // Инициализация мьютексов и условных переменных
    for (int i = 0; i < NUM_DEPARTMENTS; ++i) {
        pthread_mutex_init(&department_mutexes[i], nullptr);
        pthread_cond_init(&department_conds[i], nullptr);
    }

    // Создаем потоки покупателей
    vector<pthread_t> customer_threads(num_customers);
    for (int i = 0; i < num_customers; ++i) {
        int* id = new int(i + 1);
        if (pthread_create(&customer_threads[i], nullptr, CustomerThread, id) != 0) {
            cerr << "Ошибка создания потока покупателя " << (i + 1) << endl;
        }
    }

    // Создаем потоки продавцов
    vector<pthread_t> seller_threads(NUM_DEPARTMENTS);
    for (int i = 0; i < NUM_DEPARTMENTS; ++i) {
        int* id = new int(i);
        pthread_create(&seller_threads[i], nullptr, SellerThread, id);
    }

    // Ждем завершения потоков покупателей
    for (auto& thread : customer_threads) {
        pthread_join(thread, nullptr);
    }

    // Завершаем потоки продавцов
    exit_flag = true;
    for (auto& thread : seller_threads) {
        pthread_join(thread, nullptr);
    }

    // Уничтожение мьютексов и условных переменных
    for (int i = 0; i < NUM_DEPARTMENTS; ++i) {
        pthread_mutex_destroy(&department_mutexes[i]);
        pthread_cond_destroy(&department_conds[i]);
    }
    pthread_mutex_destroy(&cout_mutex);

    return 0;
}
