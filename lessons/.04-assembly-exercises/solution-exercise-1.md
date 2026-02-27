# Solution: Exercise 1: Rename all files in a folder (needed in the next episode)

[← Back to Exercise](./exercise-1.md)

> A)  No, this option is going to give you as error `mv: target 'JC1A_' is not a directory` 
> This is because `mv` has two options:  
> `mv file_1 file_2`  
> `mv file_1, file_2, ..... file_n directory`   
> When a list of files is passed to `mv`, the `mv` expects the last parameters to be a directory.  
> Here, `*` gives you a list of all the files in the directory. The last parameter is `JC1A_` (which `mv` expects to be a directory).   
> B)  No. Again, every file is sent to the same file.  
> C)  No, every file is sent to the same file JC1A_  
> D)  Yes, this is one of the possible solutions.  
>
> ¿Do you have another solution?

---

[← Back to Lesson](../04-assembly.md#exercise-1-rename-all-files-in-a-folder-needed-in-the-next-episode)
