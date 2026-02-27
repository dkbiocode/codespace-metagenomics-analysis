# Exercise 2: Recap of abundance plotting

[← Back to Lesson](../09-abundance-analyses.md#exercise-2-recap-of-abundance-plotting)

> 
> Match the chunk of code with its description and put them in the correct order to 
>  create a relative abundance plot at the genus level of a particular phylum. がんばって! (ganbatte; *good luck*):
>
>| Description      | Command |  
>  | ----------- | ----------- |  
>  | plot the relative abundance at the genus levels. | `plot_proteo` |  
>  | Convert all the genera with less than 3% abundance into only one label. | `proteo_percentages <- transform_sample_counts(proteo, function(x) >x*100 / sum(x) )`  |  
>  | Make just one row that groups all the observations of the same genus.| `proteo <- subset_taxa(merged_metagenomes, Phylum == "Proteobacteria")` |  
>  | Create a phyloseq object only with the reads assigned to a certain phylum.| `unique(proteo@tax_table@.Data[,2])` |  
>  | Show the plot. | `proteo_glom <- tax_glom(proteo_percentages, taxrank = "Genus")` |  
>  | Transform the phyloseq object to a data frame. | `plot_proteo <- ggplot(data=proteo_df, aes(x=Sample, y=Abundance, fill=Genus))+` |  
>  | | `geom_bar(aes(), stat="identity", position="stack")+`|  
>  | | `scale_fill_manual(values = genus_colors_proteo)` |  
>  | Convert the Genus column into the factor structure. | `proteo_df$Genus[proteo_df$Abundance < 3] <- "Genera < 3% abund"` |  
>  | Look at the phyla present in your phyloseq object. | `proteo_df <- psmelt(proteo_glom)` |  
>  | Convert the abundance counts to relative abundance. | `genus_colors_proteo<- colorRampPalette(brewer.pal(8,"Dark2")) (length(levels(proteo_df$Genus)))` |  
>  | Make a palette with the appropriate colors for the number of genera. | `proteo_df$Genus <- as.factor(proteo_df$Genus)` |  
>

---

**[View Solution](./solution-exercise-1.md)**
