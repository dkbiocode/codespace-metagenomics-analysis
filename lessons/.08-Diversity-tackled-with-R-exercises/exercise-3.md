# Exercise 3: Add metadata to beta diversity visualization

[← Back to Lesson](../08-Diversity-tackled-with-R.md#exercise-3-add-metadata-to-beta-diversity-visualization)

> In the following figure, the beta diversity graph we produced earlier has been enriched. 
> Look at the code below and answer:    
> 1) Which instruction colored the samples by their corresponding treatment?  
> 2) What did the instruction `geom_text` do?   
> 3) What other difference do you notice with our previous graph?  
> 4) Do you see some clustering of the samples according to their treatment?   
><a href="{{ page.root }}/fig/03-08-09.png">
> <img src="{{ page.root }}/fig/03-08-09.png" alt="The distance between the three samples, JC1A, JP4D and JP41 is shown in a plane. Each sample has a legend and a color. The color is according to the metadata treatment. There are three possible treatments in the legend: Control mesocosm, Fertilized pond, and Unenriched pond" />
> ~~~
> metadata_cuatroc <- data.frame(Sample=c("JC1A", "JP4D", "JP41"), Treatment=c("Control mesocosm", "Fertilized pond", "Unenriched pond")) # Making dataframe with metadata  
> rownames(metadata_cuatroc) <- metadata_cuatroc$Sample # Using sample names as row names  
> percentages@sam_data <- sample_data(metadata_cuatroc) # Adding metadata to sam_data table of phyloseq object percentages  
> meta_ord <- ordinate(physeq = percentages, method = "NMDS", distance = "bray") # Calculating beta diversity    
> plot_ordination(physeq = percentages, ordination = meta_ord, color = "Treatment") + # Plotting beta diversity.  
>     geom_text(mapping = aes(label = Sample), size = 3, vjust = 1.5)   
> ~~~
> {: .language-r}

---

**[View Solution](./solution-exercise-3.md)**
