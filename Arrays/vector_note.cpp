#include <iostream>
#include <vector>

using namespace std;

vector<int> nums {1, 2, 3, 4, 5};

void vector_initialize(const vector <int>& nums) {
    // 1. Default (empty) constructor
    std::vector<int> v1;          // v1 is empty

    // 2. Size-only constructor (value-initialized elements)
    std::vector<int> v2(5);       // v3 = {0, 0, 0, 0, 0}

    // 3. Fill constructor (size, fill with what number)
    std::vector<int> v3(5, 42);   // v2 = {42, 42, 42, 42, 42}

    // 4. Initializer‐list constructor
    std::vector<int> v4 = {1, 4, 7, 20};

    // 5. Range constructor (using iterators)
    std::vector<int> source = {1,2,3,4};
    std::vector<int> v5(source.begin() + 1, source.end() - 1);
    // v5 = {2,3}

    // 6. Copy constructor
    std::vector<int> v6(source);
    // v is a copy of source

    // 7. 
}

// RESERVE - pre-allocate capacity, size stays the same.
void vector_resize(const vector <int>& nums) {
    std::vector<int> vector_a;
    vector_a.reserve(10);
    for (int i = 0; i < vector_a.size(); i++) {
        vector_a.push_back(i);
    }
}


// RESIZE - change the size to n, constructing or destroying elements.
void vector_resize(const vector <int>& nums) {
    std::vector<int> vector_b;
    vector_b.resize(nums.size());    // size() == nums.size(), all zeros
}

struct Foo {
    Foo(int, double);
};

/*
Use emplace_back whenever you can supply constructor arguments directly and avoid an extra copy or move.
emplace_back constructs once in-place, so it can be more efficient by eliminating one temporary and one copy/move.
*/

/*
Use push_back when you already have an object (or want to rely on move semantics):
push_back may invoke a copy- or move-constructor. If your type is heavy to move or copy, this can cost extra work.
*/

void vector_push_emplace_back() {
    Foo f(1, 2.0);

    std::vector<Foo> vector_c;

    // Takes an existing object (l-value or r-value) of the vector’s element type
	// Copies (or moves, if you pass an r-value) that object into the vector
    vector_c.push_back(f);
    vector_c.push_back(Foo{3, 4.0});

    // Directly calls Foo(1, 2.0) inside the vector’s memory.
    // No intermediate Foo object, no copy/move needed.
    vector_c.emplace_back(1, 2.0);
}
