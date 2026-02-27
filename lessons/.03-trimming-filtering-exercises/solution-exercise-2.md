# Solution: Bonus Exercise (Advanced): Quality test after trimming

[← Back to Exercise](./exercise-2.md)

> In your Codespace terminal window, do the following:
>
> ~~~
> $ fastqc ~/dc_workshop/data/trimmed_fastq/*.fastq*
> ~~~
>
>
> In a terminal standing on your local computer, do:
>
> ~~~
> $ mkdir ~/Desktop/fastqc_html/trimmed
> $ scp dcuser@ec2-34-203-203-131.compute-1.amazonaws.com:~/dc_workshop/data/trimmed_fastq/*.html ~/Desktop/fastqc_html/trimmed
> ~~~
>
>
> Then take a look at the html files in your browser.
>
> Remember to replace everything between the `@` and `:` in your scp
> command with your Codespace instance address.
>
> After trimming and filtering, our overall quality is much higher, 
> we have a distribution of sequence lengths, and more samples pass 
> adapter content. However, quality trimming is not perfect, and some
> programs are better at removing some sequences than others. Trimmomatic 
> did pretty well, though, and its performance is good enough for our workflow.

---

[← Back to Lesson](../03-trimming-filtering.md#bonus-exercise-advanced-quality-test-after-trimming)
