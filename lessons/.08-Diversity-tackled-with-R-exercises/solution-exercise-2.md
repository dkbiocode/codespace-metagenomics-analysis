# Solution: Exercise 2: Exploring function flags.

[← Back to Exercise](./exercise-2.md)

> The code and the plot using the three options will look as follows:
> The "title" option adds a title to the figure.
> ~~~
> plot_richness(physeq = merged_metagenomes, 
> title = "Alpha diversity indexes for three samples from Cuatro Cienegas",
> measures = c("Observed","Chao1","Shannon"))
> ~~~
> {: .language-r}
>
> <a href="{{ page.root }}/fig/03-08-05.png">
> <img src="{{ page.root }}/fig/03-08-05.png" alt="" />
> </a>
> <em> Figure 5. Alpha diversity plot with the title. <em/>
>
> The "nrow" option arranges the graphics horizontally.
> ~~~
> plot_richness(physeq = merged_metagenomes,
> measures = c("Observed","Chao1","Shannon"),
> nrow=3)
> ~~~
> {: .language-r}
>
> <a href="{{ page.root }}/fig/03-08-06.png">
> <img src="{{ page.root }}/fig/03-08-06.png" alt="" />
> </a>
> <em> Figure 6. Alpha diversity plot with the three panels arranged in rows. <em/>
>
> The "sortby" option orders the samples from least to greatest diversity depending on the parameter. In this case, it is ordered by "Shannon" and tells us that the JP4D sample has the lowest diversity and the JP41 sample the highest.
> ~~~
> plot_richness(physeq = merged_metagenomes, 
> measures = c("Observed","Chao1","Shannon"),
> sortby = "Shannon") 
> ~~~
> {: .language-r}
>
> <a href="{{ page.root }}/fig/03-08-07.png">
> <img src="{{ page.root }}/fig/03-08-07.png" alt="The same panels as before, but now the samples are arranged horizontally according to the values in the Shannon index panel." />
> </a>
> <em> Figure 7. Samples sorted by Shannon in alpha diversity index plots. <em/>
>
>
> Considering those mentioned above, together with the three graphs, we can say that JP41 and JP4D present a high diversity concerning the JC1A. Moreover, the diversity of the sample JP41 is mainly given by singletons or doubletons. Instead, the diversity of JP4D is given by species in much greater abundance. Although the values of H (Shannon) above three are considered to have a lot of diversity.

---

[← Back to Lesson](../08-Diversity-tackled-with-R.md#exercise-2-exploring-function-flags)
