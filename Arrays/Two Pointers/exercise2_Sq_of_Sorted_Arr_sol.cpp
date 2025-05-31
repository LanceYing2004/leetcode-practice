#include <vector>

using namespace std;

class Solution
{
public:
    vector<int> sortedSquares(vector<int>& nums) {
        int n = nums.size();

        int left = 0;
        int right = n - 1;

        vector<int> result (n);

        for (int i = n - 1; i >=0; i--) {
            int square;
            // fill in the result array from largest to smallest, depending on their absolute value
            // that is, if right > left, use the [right] value to fill into the i's location
            // or if left > right, use the [left] value to fill into the i's location
            if (abs(nums[left]) < abs(nums[right])) {
                square = nums[right];
                right--;
            } else {
                square = nums[left];
                left++;
            }
            result[i] = square * square;
        }
        return result;
    }
};
