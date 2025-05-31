#include <vector>
#include <iostream>
#include <random>


#include "timer.h"

using namespace std;

vector<int> combine(vector<int>& arr1, vector<int>& arr2) {
    int arr1_counter = 0;
    int arr2_counter = 0;

    vector<int> new_array;

    while (arr1_counter < arr1.size() && arr2_counter < arr2.size()) {
        if (arr1[arr1_counter] < arr2[arr2_counter]) {
            new_array.push_back(arr1[arr1_counter]);
            arr1_counter++;
        } else if (arr2[arr2_counter] < arr1[arr1_counter]) {
            new_array.push_back(arr2[arr2_counter]);
            arr2_counter++;
        } else {
            new_array.push_back(arr1[arr1_counter]);
            new_array.push_back(arr2[arr2_counter]);
            arr1_counter++;
            arr2_counter++;
        }
    }

    while (arr1_counter < arr1.size()) {
        new_array.push_back(arr1[arr1_counter]);
        arr1_counter++;
    }

    while (arr2_counter < arr2.size()) {
        new_array.push_back(arr2[arr2_counter]);
        arr2_counter++;
    }

    return new_array;
}

int main() {

    vector<int> arr1 {1, 4, 7, 20};
    vector<int> arr2 {3, 5, 6};

    vector<int> final_result = combine(arr1, arr2);

    for (int element : final_result) {
        cout << element << " ";
    }

    return 0;
}