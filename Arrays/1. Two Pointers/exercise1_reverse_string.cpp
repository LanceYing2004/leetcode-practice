#include <vector>
#include <iostream>
#include <algorithm>

using namespace std;

class Solution {
    public:
        void reverseString(vector<char>& s) {
            // initilize 2 pointers
            int left = 0;
            int right = s.size() - 1;


            // swap single one of them until the process is complete
            while (left < right) {
                std::swap(s[left], s[right]);
                left++;
                right--;
            }
        }
};