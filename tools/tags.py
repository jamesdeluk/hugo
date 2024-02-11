import sys
from collections import Counter

# Step 1: Get input from the user
input_string = input("Enter a list of words separated by spaces and commas: ")

# Step 2: Split the input into words
words = input_string.split(', ')

# Step 3: Find duplicates and remove them
word_counts = Counter(words)
duplicates = [word for word, count in word_counts.items() if count > 1]
unique_words = list(set(words))

# Output the duplicated words
duplicates_string = ', '.join(duplicates)
print("\nDuplicates")
print(duplicates_string)

uniques_string = ', '.join(unique_words)
print("\nUniques")
print(uniques_string)

# Step 4: Sort alphabetically
sorted_words = sorted(unique_words)

# Step 5: Wrap in quotes and remove spaces
formatted_words = ['"' + word + '"' for word in sorted_words]

# Output the result
output_string = ','.join(formatted_words)
print("\nOutput")
print(output_string)

