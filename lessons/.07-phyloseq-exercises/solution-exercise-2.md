# Solution: Exercise 2: Searching for the read counts

[← Back to Exercise](./exercise-2.md)

> Go to the `tax_table`: 
>
> ~~~ 
> View(merged_metagenomes@tax_table@.Data)
> ~~~ 
> {: .language-r}
> Take note of the OTU number for some species:
> <a href="{{ page.root }}/fig/03-07-04.png">
> <img src="{{ page.root }}/fig/03-07-04.png" alt="The OTU number is in the leftmost space of the table as a row name for the searched species." />
> </a>
> <em> Figure 4. The row of the `tax_table` corresponds to the species *Paracoccus zhejiangensis*. <em/>
>
> Search for the row of the `otu_table` with the row name you chose.  
> ~~~
> merged_metagenomes@otu_table@.Data["1077935",]
> ~~~
> {: .language-r}
> ~~~
> JC1A JP4D JP41 
> 42  782  257 
> ~~~
> {: .language-r}

---

[← Back to Lesson](../07-phyloseq.md#exercise-2-searching-for-the-read-counts)
