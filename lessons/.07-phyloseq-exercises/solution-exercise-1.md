# Solution: Exercise 1: Explore a phylum

[← Back to Exercise](./exercise-1.md)

> Change the name of a new phylum wherever needed and the name of the rank we are asking for to get the result.
> As an example, here is the solution for Proteobacteria:
> ~~~ 
> sum(merged_metagenomes@tax_table@.Data[,"Phylum"] == "Proteobacteria")
> ~~~ 
> {: .language-r}
> ~~~
> unique(merged_metagenomes@tax_table@.Data[merged_metagenomes@tax_table@.Data[,"Phylum"] == "Proteobacteria", "Genus"])
> ~~~
> {: .language-r}

---

[← Back to Lesson](../07-phyloseq.md#exercise-1-explore-a-phylum)
