**README - Student Andrei Sugubete 315CA**

**Task 1 - Reversing Vowels (25p)**

**Objective:**
The goal of this task is to implement a function that reverses the vowels in a given string using only stack operations (push and pop) to work with memory.

**Function Signature:**
```c
void reverse_vowels(char *string);
```

**Description:**
In this task, the objective is to reverse the vowels in a string using a stack. Ferrari, after their success in Baku, decided to encrypt their messages to maintain their advantage over Mercedes. They wanted to make it difficult for Red Bull to understand their messages, so they devised a simple encryption method. They decided to take all the vowels in their message and display them in reverse order. For example, "red bull" with reversed vowels becomes "rud bell". This way, Red Bull will never know when they are being discussed. 

**Example:**
- Input: "hello"
- Output: "holle"

**Task 2 - Pwd (25p)**

**Objective:**
Implement a function that takes an array of directory names, the number of directories, and an output string. The function should simulate the behavior of the 'cd' command in Linux and construct the resulting path.

**Function Signature:**
```c
void pwd(char **directories, int n, char *output);
```

**Description:**
The function should add directories to the output string based on the given input array of directory names. It should handle special directories '.' (current folder) and '..' (parent folder) appropriately.

**Example:**
- Input: n = 5, directories = {"home", "folder1", ".", "folder2", "..", "folder3"}
- Output: "/home/folder1/folder3"

**Task 3 - Word Sorting (25p)**

**Objective:**
Separate a text into words based on delimiters and sort these words using the qsort function. Sort first by word length and then lexicographically in case of equal lengths.

**Function Signatures:**
```c
void get_words(char *s, char **words, int number_of_words);
void sort(char **words, int number_of_words, int size);
```

**Description:**
The first function splits the input text into words and stores them in the 'words' array. The second function sorts the words using the qsort function, first by length and then lexicographically.

**Example:**
- Input: "Ana are 27 de mere, si 32 de pere."
- After get_words: words = ["Ana", "are", "27", "de", "mere", "si", "32", "de", "pere"]
- After sort: words = ["27", "32", "de", "de", "si", "Ana", "are", "mere", "pere"]

**Task 4 - Binary Tree (25p)**

**Objective:**
Implement functions to work with a binary tree. The nodes of the tree have the structure:
```c
struct node {
    int value;
    struct node *left;
    struct node *right;
} __attribute__((packed));
```

**Exercise I - Inorder Traversal and Storing Values:**
```c
void inorder_parc(struct node *node, int *array);
```
This function performs an in-order traversal of the binary search tree and stores the values in the given array.

**Exercise II - Inorder Traversal for Nodes not Following BST Property:**
```c
void inorder_intruders(struct node *node, struct node *parent, int *array);
```
This function performs an in-order traversal and stores values of nodes that do not follow the binary search tree property.

**Exercise III - Fixing Values of Nodes not Following BST Property:**
```c
void inorder_fixing(struct node *node, struct node *parent);
```
This function performs an in-order traversal and modifies values of nodes that do not follow the binary search tree property based on the given rules.

**Checker Usage:**

You can use the checker individually for each exercise after compiling the sources using 'make':
```bash
./checker 1
./checker 2
./checker 3
```
To verify all exercises simultaneously, use:
```bash
./checker
```

**Note:**
- The array should be pre-allocated for Exercise I, II, and III.
- The array index variables (array_idx_1 and array_idx_2) are set to 0 before each test.
- The tree should not be modified in Exercise II and III. Only the values should be adjusted.

*You will receive feedback (failed/passed) for each test, and a provisional score at the end.*
