//
// Created by Сергей Растворов on 15/12/24.
//
#include <pthread.h>
#include <iostream>
#include <queue>

void* ThreadFunction(void* arg) {
    const int id = *static_cast<int*>(arg);
    std::cout << "Hello from thread! ID: " << id << std::endl;
    return nullptr;
}

pthread_mutex_t mutex;
int counter = 0;

void* IncrementCounter(void* arg) {
    for (int i = 0; i < 1000; ++i) {
        pthread_mutex_lock(&mutex);
        ++counter;
        pthread_mutex_unlock(&mutex);
    }
    return nullptr;
}

pthread_mutex_t mutex_data;
std::queue<int> data_queue;
pthread_cond_t data_cond;       // create a condition
void *Producer(void *arg) {
    for (int i = 0; i < 20; ++i) {
        pthread_mutex_lock(&mutex_data);
        data_queue.push(i);
        std::cout << "Producer: " << i << std::endl;
        pthread_cond_signal(&data_cond);    // notification for consumer
        pthread_mutex_unlock(&mutex_data);
    }
    return nullptr;
}

void *Consumer(void *arg) {
    while (true) {
        pthread_mutex_lock(&mutex_data);

        while (data_queue.empty()) {
            pthread_cond_wait(&data_cond, &mutex_data);
        }

        const int value = data_queue.front();
        data_queue.pop();
        std::cout << "Consumed: " << value << std::endl;
        if (value == 19) {
            break;
        }
        pthread_mutex_unlock(&mutex_data);
    }
    return nullptr;
}

int main() {
    pthread_t thread1 = nullptr;
    pthread_t thread2 = nullptr;
    int id1 = 1;
    int id2 = 2;

    // Создаем два потока
    pthread_create(&thread1, nullptr, ThreadFunction, &id1);
    pthread_create(&thread2, nullptr, ThreadFunction, &id2);

    // Ожидаем завершения потоков
    pthread_join(thread1, nullptr);
    pthread_join(thread2, nullptr);

    // mutex sample
    pthread_t thread3 = nullptr;
    pthread_t thread4 = nullptr;
    pthread_mutex_init(&mutex, nullptr);    // mutex create
    pthread_create(&thread3, nullptr, IncrementCounter, nullptr);
    pthread_create(&thread4, nullptr, IncrementCounter, nullptr);
    pthread_join(thread3, nullptr);
    pthread_join(thread4, nullptr);
    pthread_mutex_destroy(&mutex);
    std::cout << "Final counter value: " << counter << std::endl;

    // conditional sample
    pthread_t producer_pthread = nullptr;
    pthread_t consumer_pthread = nullptr;
    pthread_mutex_init(&mutex_data, nullptr);   // mutex init
    pthread_cond_init(&data_cond, nullptr);     // condition init
    pthread_create(&producer_pthread, nullptr, Producer, nullptr);
    pthread_create(&consumer_pthread, nullptr, Consumer, nullptr);
    pthread_join(producer_pthread, nullptr);
    pthread_join(consumer_pthread, nullptr);
    pthread_mutex_destroy(&mutex_data);
    pthread_cond_destroy(&data_cond);

    std::cout << "All threads are completed." << std::endl;
    return 0;
}

