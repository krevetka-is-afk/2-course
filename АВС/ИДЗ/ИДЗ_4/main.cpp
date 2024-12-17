#include <iostream>
#include <pthread.h>
#include <queue>
#include <vector>
#include <random>
#include <chrono>
#include <unistd.h>
#include <algorithm>
#include <fstream>

using namespace std;

// Constants
constexpr int kNumDepartments = 3;                                  // Amount of departments
constexpr int kMinCustomerWaitMs = 1000;
constexpr int kMaxCustomerWaitMs = 3000;
constexpr int kMinSellerWaitMs = 1000;
constexpr int kMaxSellerWaitMs = 2000;

// Global variables
bool exit_flag = false;
pthread_mutex_t department_mutexes[kNumDepartments];                // Mutexes for departments
pthread_cond_t department_conds[kNumDepartments];                   // Condition variables for queues
queue<int> department_queues[kNumDepartments];                      // Queue for each department
pthread_mutex_t cout_mutex = PTHREAD_MUTEX_INITIALIZER;             // Mutex for safe output
bool sellers_free[kNumDepartments] = {true, true, true};            // Status of sellers

int current_customer_id = 1;                                        // Tracks the next customer allowed to enter the shop
pthread_mutex_t customer_order_mutex = PTHREAD_MUTEX_INITIALIZER;   // Mutex for sequential entry
pthread_cond_t customer_order_cond = PTHREAD_COND_INITIALIZER;

bool enable_logging = false;                                        // Whether logging enabled
ofstream log_file;                                                  // Log file stream

// Random sleep function to simulate work
void RandomSleep(int min_ms, int max_ms) {
    random_device rd;
    mt19937 gen(rd());
    uniform_int_distribution<> dist(min_ms, max_ms);
    usleep(dist(gen) * 1000);
}

// Safe print function for console output and optional logging
void SafeCout(const string& message) {
    pthread_mutex_lock(&cout_mutex);
    cout << message << endl;
    if (enable_logging && log_file.is_open()) {
        log_file << message << endl;
    }
    pthread_mutex_unlock(&cout_mutex);
}

// Customer thread function
void* CustomerThread(void* arg) {
    const int customer_id = *static_cast<int*>(arg);
    delete static_cast<int*>(arg);

    // Ensure customers enter the shop in sequence
    pthread_mutex_lock(&customer_order_mutex);
    while (customer_id != current_customer_id) {
        pthread_cond_wait(&customer_order_cond, &customer_order_mutex);
    }
    SafeCout("Customer " + to_string(customer_id) + " entered the shop.");
    current_customer_id++;
    pthread_cond_broadcast(&customer_order_cond);                   // Notify other customers
    pthread_mutex_unlock(&customer_order_mutex);

    // Randomize the order in which departments are visited
    vector<int> departments(kNumDepartments);
    iota(departments.begin(), departments.end(), 0);
    random_device rd;
    mt19937 gen(rd());
    shuffle(departments.begin(), departments.end(), gen);

    // Visit each department
    for (const int dep : departments) {
        pthread_mutex_lock(&department_mutexes[dep]);

        if (!sellers_free[dep]) {
            SafeCout("Customer " + to_string(customer_id) +
                     " is waiting in line at department " + to_string(dep) + ".");
            department_queues[dep].push(customer_id);

            // Wait until it's this customer's turn
            while (!sellers_free[dep] || department_queues[dep].front() != customer_id) {
                pthread_cond_wait(&department_conds[dep], &department_mutexes[dep]);
            }

            department_queues[dep].pop();
        }

        sellers_free[dep] = false;                                  // Seller becomes busy
        pthread_mutex_unlock(&department_mutexes[dep]);

        SafeCout("Customer " + to_string(customer_id) +
                 " is being served in department " + to_string(dep) + ".");
        RandomSleep(kMinCustomerWaitMs, kMaxCustomerWaitMs);        // Simulate service time

        pthread_mutex_lock(&department_mutexes[dep]);
        sellers_free[dep] = true;                                   // Seller becomes free
        pthread_cond_signal(&department_conds[dep]);                // Notify next customer in line
        pthread_mutex_unlock(&department_mutexes[dep]);

        SafeCout("Customer " + to_string(customer_id) +
                 " left department " + to_string(dep) + ".");
    }

    SafeCout("Customer " + to_string(customer_id) + " left the shop.");
    pthread_exit(nullptr);
}

// Seller thread function
void* SellerThread(void* arg) {
    int department_id = *static_cast<int*>(arg);
    delete static_cast<int*>(arg);

    while (!exit_flag) {
        pthread_mutex_lock(&department_mutexes[department_id]);
        if (!department_queues[department_id].empty()) {
            pthread_cond_signal(&department_conds[department_id]);
        }
        pthread_mutex_unlock(&department_mutexes[department_id]);

        RandomSleep(kMinSellerWaitMs, kMaxSellerWaitMs);            // Simulate idle time
    }

    SafeCout("Seller in department " + to_string(department_id) + " finished work.");
    pthread_exit(nullptr);
}

int main() {
    int num_customers;
    string log_file_name;

    // Input: number of customers
    cout << "Enter the number of customers: ";
    cin >> num_customers;

    // Input: whether logging is enabled
    cout << "Enable logging? (1 - Yes, 0 - No): ";
    int log_choice;
    cin >> log_choice;
    enable_logging = (log_choice == 1);

    // Input: log file name if logging is enabled
    if (enable_logging) {
        cout << "Enter log file name: ";
        cin >> log_file_name;
        log_file.open(log_file_name);
        if (!log_file.is_open()) {
            cerr << "Error opening log file. Logging disabled." << endl;
            enable_logging = false;
        }
    }

    // Initialize department mutexes and condition variables
    for (int i = 0; i < kNumDepartments; ++i) {
        pthread_mutex_init(&department_mutexes[i], nullptr);
        pthread_cond_init(&department_conds[i], nullptr);
    }

    // Create customer threads
    vector<pthread_t> customer_threads(num_customers);
    for (int i = 0; i < num_customers; ++i) {
        int* id = new int(i + 1);
        if (pthread_create(&customer_threads[i], nullptr, CustomerThread, id) != 0) {
            cerr << "Error creating thread for customer " << (i + 1) << endl;
            delete id;
        }
    }

    // Create seller threads
    vector<pthread_t> seller_threads(kNumDepartments);
    for (int i = 0; i < kNumDepartments; ++i) {
        int* id = new int(i);
        if (pthread_create(&seller_threads[i], nullptr, SellerThread, id) != 0) {
            cerr << "Error creating thread for seller in department " << i << endl;
            delete id;
        }
    }

    // Wait for all customer threads to finish
    for (const auto& thread : customer_threads) {
        pthread_join(thread, nullptr);
    }

    // Signal sellers to stop and wait for them to finish
    exit_flag = true;
    for (const auto& thread : seller_threads) {
        pthread_join(thread, nullptr);
    }

    // Destroy mutexes and condition variables
    for (int i = 0; i < kNumDepartments; ++i) {
        pthread_mutex_destroy(&department_mutexes[i]);
        pthread_cond_destroy(&department_conds[i]);
    }
    pthread_mutex_destroy(&cout_mutex);
    pthread_mutex_destroy(&customer_order_mutex);
    pthread_cond_destroy(&customer_order_cond);

    // Close the log file if it was opened
    if (log_file.is_open()) {
        log_file.close();
    }

    return 0;
}
