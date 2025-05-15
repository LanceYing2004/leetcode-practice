#include <chrono>

/**
 * A simple Timer built on the C++11 chrono library.
 * Credit: Amir Kamil
 * Code from Lecture 3 Demo
 */
class Timer {
    std::chrono::time_point<std::chrono::system_clock> cur;
    std::chrono::duration<double> elap;
public:
    Timer() : cur(), elap(std::chrono::duration<double>::zero()) {}

    void start() {
        cur = std::chrono::system_clock::now();
    } // start()

    void stop() {
        elap += std::chrono::system_clock::now() - cur;
    } // stop()

    void reset() {
        elap = std::chrono::duration<double>::zero();
    } // reset()

    double seconds() {
        return elap.count();
    } // seconds()
}; // class Timer