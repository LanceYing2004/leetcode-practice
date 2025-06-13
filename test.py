word = "hello world"
result = list(word)
left = 0
right = len(result) - 1
while left < right:
    result[right], result[left] = result[left], result[right]
    left += 1
    right -= 1
print(result)