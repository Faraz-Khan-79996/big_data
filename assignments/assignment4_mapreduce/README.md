# Assignment 4: MapReduce Programming with Java

> **Subject:** Big Data  
> **Student Name:** Arin Zingade  
> **Enrollment No:** 0801IT221035

---

## Objective

Develop and execute two MapReduce programs in Java on a Hadoop cluster:
1. **Q1: Word Count** — Count the frequency of each word in a text file.
2. **Q2: Anagram Finder** — Group words that are anagrams of each other.

---

## Environment

| Component  | Details                      |
|------------|------------------------------|
| OS         | Ubuntu 20.04 (WSL2)          |
| Java       | OpenJDK 8                    |
| Hadoop     | 3.3.6 (Multi-Node Cluster)   |

---

## MapReduce Architecture

```
        ┌─────────────┐
Input   │             │
Files ─►│   MAPPER    │─► (Key, Value) pairs
        │             │
        └─────────────┘
              │ Shuffle & Sort
              ▼
        ┌─────────────┐
        │   REDUCER   │─► Final Output
        │             │
        └─────────────┘
```

---

## Q1: Word Count

### How It Works

| Phase   | Input            | Operation                           | Output              |
|---------|------------------|-------------------------------------|---------------------|
| Mapper  | Line of text     | Tokenize each word → emit (word, 1) | `("hadoop", 1)` per word |
| Shuffle | (word, [1,1,...])| Group by key                        | `("hadoop", [1,1,1])` |
| Reducer | (word, [counts]) | Sum all counts                      | `("hadoop", 3)`     |

### Source Code

```java
public static class TokenizerMapper
        extends Mapper<Object, Text, Text, IntWritable> {

    private final static IntWritable one = new IntWritable(1);
    private Text word = new Text();

    @Override
    public void map(Object key, Text value, Context context)
            throws IOException, InterruptedException {
        StringTokenizer itr = new StringTokenizer(value.toString());
        while (itr.hasMoreTokens()) {
            word.set(itr.nextToken().toLowerCase());
            context.write(word, one);
        }
    }
}

public static class IntSumReducer
        extends Reducer<Text, IntWritable, Text, IntWritable> {

    private IntWritable result = new IntWritable();

    @Override
    public void reduce(Text key, Iterable<IntWritable> values, Context context)
            throws IOException, InterruptedException {
        int sum = 0;
        for (IntWritable val : values) {
            sum += val.get();
        }
        result.set(sum);
        context.write(key, result);
    }
}
```

### Compile, Package & Run

```bash
# Step 1: Compile
javac -classpath $(hadoop classpath) -d . WordCount.java

# Step 2: Create JAR
jar -cvf wordcount.jar *.class

# Step 3: Upload input to HDFS
hdfs dfs -mkdir -p /ass4_word_count_input
hdfs dfs -put input/sample_input.txt /ass4_word_count_input/

# Step 4: Run MapReduce Job
hadoop jar wordcount.jar WordCount /ass4_word_count_input /wc_output

# Step 5: View Output
hdfs dfs -cat /wc_output/part-r-00000
```

### Sample Output

```
amazing     1
apache      1
big         2
data        2
distributed 1
framework   1
hadoop      4
is          2
mapreduce   2
model       1
...
```

---

## Q2: Anagram Finder

### How It Works

| Phase   | Input            | Operation                                       | Output                          |
|---------|------------------|-------------------------------------------------|---------------------------------|
| Mapper  | Words in a line  | Sort chars of each word → emit (sortedKey, word) | `("eilnst", "listen")`         |
| Shuffle | Group by sortedKey| All anagrams share the same key                | `("eilnst", ["listen","silent"])` |
| Reducer | (key, [words])   | Join words with comma                           | `("eilnst", "listen, silent")`  |

**Key Idea:** All anagrams of a word produce the **same sorted character string**, which becomes the Map key.

Example:
- `"listen"` → sort → `"eilnst"`
- `"silent"` → sort → `"eilnst"`
- `"enlist"` → sort → `"eilnst"`

### Source Code

```java
public static class AnagramMapper
        extends Mapper<Object, Text, Text, Text> {

    @Override
    public void map(Object key, Text value, Context context)
            throws IOException, InterruptedException {
        String[] words = value.toString().trim().split("\\s+");
        for (String w : words) {
            String cleaned = w.toLowerCase().replaceAll("[^a-z]", "");
            if (cleaned.isEmpty()) continue;

            char[] charArray = cleaned.toCharArray();
            Arrays.sort(charArray);
            String sortedKey = new String(charArray);

            context.write(new Text(sortedKey), new Text(w));
        }
    }
}

public static class AnagramReducer
        extends Reducer<Text, Text, Text, Text> {

    @Override
    public void reduce(Text key, Iterable<Text> values, Context context)
            throws IOException, InterruptedException {
        StringBuilder sb = new StringBuilder();
        for (Text val : values) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(val.toString());
        }
        // Only output actual anagram groups (more than one word)
        if (sb.toString().contains(",")) {
            context.write(key, new Text(sb.toString()));
        }
    }
}
```

### Compile, Package & Run

```bash
# Step 1: Compile
javac -classpath $(hadoop classpath) -d . Anagram.java

# Step 2: Create JAR
jar -cvf anagram.jar *.class

# Step 3: Upload input to HDFS
hdfs dfs -mkdir -p /anagram_input
hdfs dfs -put input/sample_input.txt /anagram_input/

# Step 4: Run MapReduce Job
hadoop jar anagram.jar Anagram /anagram_input /anagram_output

# Step 5: View Output
hdfs dfs -cat /anagram_output/part-r-00000
```

### Sample Output

```
act     act, tac, cat
aet     eat, tea, ate
art     art, rat, tar
dgo     god, dog
eilnst  enlist, silent, listen
eilmsv  evil, vile
```

---

## Project Structure

```
assignment4_mapreduce/
│
├── WordCount/
│   ├── WordCount.java           # MapReduce Word Count program
│   └── input/
│       └── sample_input.txt     # Sample text input
│
├── Anagram/
│   ├── Anagram.java             # MapReduce Anagram Finder program
│   └── input/
│       └── sample_input.txt     # Sample words input
│
└── run_all.sh                   # Script to build and run both programs
```

---

## Conclusion

Two complete MapReduce programs were developed in Java and executed on the Hadoop cluster. The **Word Count** program demonstrates the canonical MapReduce pattern of tokenizing → counting → aggregating. The **Anagram Finder** demonstrates a more advanced use of custom map keys (character-sorted canonical forms) to group semantically related data. Both programs successfully processed input from HDFS and wrote results back to HDFS.
