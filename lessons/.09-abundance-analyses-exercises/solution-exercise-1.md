# Solution: Exercise 2: Recap of abundance plotting

[← Back to Exercise](./exercise-1.md)

> ~~~
> # Create a phyloseq object only with the reads assigned to a certain phylum.
> proteo <- subset_taxa(merged_metagenomes, Phylum == "Proteobacteria")
> # Look at the phyla present in your phyloseq object
> unique(proteo@tax_table@.Data[,2])
> # Convert the abundance counts to the relative abundance
> proteo_percentages <- transform_sample_counts(proteo, function(x) x*100 / sum(x) )
> # Make just one row that groups all the observations of the same genus.
> proteo_glom <- tax_glom(proteo_percentages, taxrank = "Genus")
> # Transform the phyloseq object to a data frame
> proteo_df <- psmelt(proteo_glom)
> # Convert all the genera that have less than 3% of abundance into only one label
> proteo_df$Genus[proteo_df$Abundance < 3] <- "Genera < 3% abund"
> # Convert the Genus column into the factor structure
> proteo_df$Genus <- as.factor(proteo_df$Genus)
> # Make a palette with the appropriate colors for the number of genera
> genus_colors_proteo<- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(proteo_df$Genus)))
> # Plot the relative abundance at the genus levels
> plot_proteo <- ggplot(data=proteo_df, aes(x=Sample, y=Abundance, fill=Genus))+ 
> geom_bar(aes(), stat="identity", position="stack")+
> scale_fill_manual(values = genus_colors_proteo)
> # Show the plot
> plot_proteo  
> ~~~
> {: .language-r} 
> <a href="{{ page.root }}/fig/03-09-06.png">
> <img src="{{ page.root }}/fig/03-09-06.png" alt="A new plot with three bars

---

[← Back to Lesson](../09-abundance-analyses.md#exercise-2-recap-of-abundance-plotting)
