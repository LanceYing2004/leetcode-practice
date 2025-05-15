#include <vector>
#include <iostream>

using namespace std;

class Solution {
    public:
        vector<int> sortedSquares(vector<int>& nums) {
            int current = nums.size() / 2;
            int min = abs(nums[current]);
            int probe = current;
            
            if (nums.size() == 2) {
                if (abs(nums[0]) < abs(nums[1])) {
                    min = abs(nums[0]);
                    probe = current = 0;
                }
            }
            
            

            cout << probe << endl;
            while (probe < nums.size() - 1 && abs(nums[probe + 1]) <= min ) {
                probe++;
                min = abs(nums[probe]);
                current = probe;
            }

            while (probe > 0 && abs(nums[probe - 1]) <= min) {
                probe--;
                min = abs(nums[probe]);
                current = probe;
            }

            
            int left = current;
            int right = current;
            

            
            vector<int>arr;
            arr.reserve(nums.size());

            arr.push_back(nums[current] * nums[current]);
            left--;
            right++;
            

            while (left > -1 && right < nums.size()) {
                if (abs(nums[left]) < abs(nums[right])) {
                    arr.push_back(nums[left] * nums[left]);
                    left--;
                } else {
                    arr.push_back(nums[right] * nums[right]);
                    right++;
                }
            }

            while (left > -1) {
                arr.push_back(nums[left] * nums[left]);
                left--;
            }

            while (right < nums.size()) {
                arr.push_back(nums[right] * nums[right]);
                right++;
            }
            return arr;

        }
};