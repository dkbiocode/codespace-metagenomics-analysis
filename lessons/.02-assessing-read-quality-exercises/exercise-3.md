# Exercise 3: Downloading files by scp (optional)

[← Back to Lesson](../02-assessing-read-quality.md#exercise-3-downloading-files-by-scp-optional)

>
> Suppose you only have access to a terminal and there is not a web browser available at the remote machine.
> The following are the steps needed to download your files to your computer.
>
> **Step 1:** Open a new terminal on your local computer.
>
> **Step 2:** Make a new local directory on your computer to store the HTML files.
>
> Choose the command for your operating system:
>
> - **Mac/Linux or Windows (Git Bash/WSL):**
>   ```
>   $ mkdir -p ~/Desktop/fastqc_html
>   ```
>
> - **Windows (PowerShell or Command Prompt):**
>   ```
>   > mkdir %USERPROFILE%\Desktop\fastqc_html
>   ```
>
> **Step 3:** Transfer the HTML files to your local computer using `scp`.
>
> Choose the command for your operating system:
>
> - **Mac/Linux or Windows (Git Bash/WSL):**
>   ```
>   $ scp dcuser@ec2-34-238-162-94.compute-1.amazonaws.com:~/dc_workshop/results/fastqc_untrimmed_reads/*.html ~/Desktop/fastqc_html
>   ```
>
> - **Windows (PowerShell or Command Prompt):**
>   ```
>   > scp dcuser@ec2-34-238-162-94.compute-1.amazonaws.com:~/dc_workshop/results/fastqc_untrimmed_reads/*.html %USERPROFILE%\Desktop\fastqc_html
>   ```
>
> **Questions:** Answer true/false for each statement about the `scp` command:
>
> A) `dcuser` is your local user
> B) `ec2-34-238-162-94.compute-1.amazonaws.com` is the address of your remote machine
> C) The current address of the file goes after the second space in the `scp` command
> D) `~/dc_workshop/results/fastqc_untrimmed_reads/*.html` is the path of the file you want to download
> E) `~/Desktop/fastqc_html` (or `%USERPROFILE%\Desktop\fastqc_html` on Windows) is a remote path
> F) `:` divides the host name of your local computer and the path of the file
>
>
> **[View Exercise with Solution](.02-assessing-read-quality-exercises/exercise-3.md)**>
