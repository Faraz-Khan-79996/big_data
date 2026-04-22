// ============================================================
// Assignment 4 - Q2: Anagram Finder using MapReduce
// ============================================================
// Student Name  : Arin Zingade
// Enrollment No : 0801IT221035
// Subject       : Big Data
// ============================================================

import java.io.IOException;
import java.util.Arrays;

import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.Path;
import org.apache.hadoop.io.Text;
import org.apache.hadoop.mapreduce.Job;
import org.apache.hadoop.mapreduce.Mapper;
import org.apache.hadoop.mapreduce.Reducer;
import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;
import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

public class Anagram {

    // ── Mapper: sorts characters of each word alphabetically and emits
    //           (sortedKey, originalWord)
    //   Example: "listen" → key="eilnst", value="listen"
    //            "silent" → key="eilnst", value="silent"
    public static class AnagramMapper
            extends Mapper<Object, Text, Text, Text> {

        @Override
        public void map(Object key, Text value, Context context)
                throws IOException, InterruptedException {

            String[] words = value.toString().trim().split("\\s+");

            for (String w : words) {
                if (w.isEmpty()) continue;

                String cleaned = w.toLowerCase().replaceAll("[^a-z]", "");
                if (cleaned.isEmpty()) continue;

                // Canonical key = sorted characters of the word
                char[] charArray = cleaned.toCharArray();
                Arrays.sort(charArray);
                String sortedKey = new String(charArray);

                context.write(new Text(sortedKey), new Text(w));
            }
        }
    }

    // ── Reducer: collects all words that share the same sorted-character key
    //            and groups them as anagrams
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

            // Only output groups with more than one word (actual anagram groups)
            String group = sb.toString();
            if (group.contains(",")) {
                context.write(key, new Text(group));
            }
        }
    }

    // ── Driver: configures and submits the Anagram MapReduce job
    public static void main(String[] args) throws Exception {

        System.out.println("========================================");
        System.out.println("  Anagram Finder MapReduce");
        System.out.println("  Student : Arin Zingade");
        System.out.println("  Enroll  : 0801IT221035");
        System.out.println("========================================");

        if (args.length != 2) {
            System.err.println("Usage: Anagram <input path> <output path>");
            System.exit(-1);
        }

        Configuration conf = new Configuration();
        Job job = Job.getInstance(conf, "anagram finder");

        job.setJarByClass(Anagram.class);
        job.setMapperClass(AnagramMapper.class);
        job.setReducerClass(AnagramReducer.class);

        job.setOutputKeyClass(Text.class);
        job.setOutputValueClass(Text.class);

        FileInputFormat.addInputPath(job, new Path(args[0]));
        FileOutputFormat.setOutputPath(job, new Path(args[1]));

        System.exit(job.waitForCompletion(true) ? 0 : 1);
    }
}
