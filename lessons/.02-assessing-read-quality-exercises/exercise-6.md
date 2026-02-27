# Bonus Exercise: Automating a quality control workflow

[← Back to Lesson](../02-assessing-read-quality.md#bonus-exercise-automating-a-quality-control-workflow)

>
> If you lose your FastQC analysis results. How would you do it again but faster than the first time?
> As we have seen in a previous lesson, making scripts for repetitive tasks is a very efficient practice during bioinformatic pipelines.  
>
> > ## Solution
> > Make a new script with nano
> > ~~~
> > nano quality_control.sh
> > ~~~
> > 
> > 
> > Paste inside the commands that we used along with `echo` commands that shows you how the script is running. 
> > ~~~
> > set -e # This will ensure that our script will exit if an error occurs
> > cd ~/dc_workshop/data/untrimmed_fastq/
> > 
> > echo "Running FastQC ..."
> > fastqc *.fastq*
> > 
> > mkdir -p ~/dc_workshop/results/fastqc_untrimmed_reads
> > 
> > echo "Saving FastQC results..."
> > mv *.zip ~/dc_workshop/results/fastqc_untrimmed_reads/
> > mv *.html ~/dc_workshop/results/fastqc_untrimmed_reads/
> > 
> > cd ~/dc_workshop/results/fastqc_untrimmed_reads/
> > 
> > echo "Unzipping..."
> > for filename in *.zip
> >     do
> >     unzip $filename
> >     done
> > 
> > echo "Saving summary..."
> > mkdir -p ~/dc_workshop/docs
> > cat */summary.txt > ~/dc_workshop/docs/fastqc_summaries.txt
> > ~~~
> > 
> > 
> > If we were to run this script, it would ask us for confirmation to redo several steps because we already did all of them. If you want to, you can run it to check that it works, but it is not necessary if you already completed every step of the previous episode.
