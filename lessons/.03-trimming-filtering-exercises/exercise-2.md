# Bonus Exercise (Advanced): Quality test after trimming

[← Back to Lesson](../03-trimming-filtering.md#bonus-exercise-advanced-quality-test-after-trimming)

>
> Now that our samples have gone through quality control, they should perform
> better on the quality tests run by FastQC. 
> 
> Sort the following chunks of code to re-run
> FastQC on your trimmed FASTQ files and visualize the HTML files
> to see whether your per base sequence quality is higher after
> trimming. 
> ~~~
> $ scp dcuser@ec2-34-203-203-131.compute-1.amazonaws.com:~/dc_workshop/data/trimmed_fastq/*.html ~/Desktop/fastqc_html/trimmed
> ~~~
> 
> 
> ~~~
> $ fastqc ~/dc_workshop/data/trimmed_fastq/*.fastq*
> ~~~
> 
> 
> ~~~
> $ mkdir ~/Desktop/fastqc_html/trimmed
> ~~~
> 
>

---

**[View Solution](./solution-exercise-2.md)**
