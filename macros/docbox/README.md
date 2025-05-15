## The Problem
I frequently need to add comments to my code for various langauges. In <abbr title="Visual Studio Code">VSCode</abbr>, I can easily accomplish these tasks using a snippet. 

## The Solution
Because as of this writing I don't know how to create snippets for the ISPF Editor, or if it's even possible, I decided to teach myself help to write an edit macro. 

This macro accepts one argument, for now, called JC (e.g, Job Card). When this parameter is recognized, it calls a procedure to generate the block comment at the top of the JCL.

Once it's generated, your should see a comment at the top of your JCL.
```jcl
//USERIDA JOB ,'YOUR LAST NAME',MSGCLASS=H                             
//*                                                                     
//**********************************************************************
//* MAINFRAME             ASSIGNMENT N                                 *
//*                                                                    *
//* PROGRAMMER NAME: A. PROGRAMMER                                     *
//* DUE DATE: MM/DD/YYYY                                               *
//*                                                                    *
//* PURPOSE: THE PURPOSE OF THIS JOB                                   *
//**********************************************************************
//STEP1    EXEC PGM=IEFBR14                                             

```

## How to use this
Let’s get that DOCBOX macro fired up! You'll need a mainframe, the big kahuna of computers that tackles heavy-duty jobs. My macro hangs out in a dataset called `REXX.EXEC`, like a storage box stuffed with programs. Inside, `DOCBOX` is one handy tool, ready to roll. To use it, we gotta tell the mainframe where this dataset lives so you can type `DOCBOX JC` in the ISPF editor and pop out a clean JCL header.

```
 TSO ALLOC FI(SYSEXEC) DA(REXX.EXEC) SHR REUSE  
```

The above command tells the mainframe, "Yo, my REXX.EXEC dataset has got a bunch of stuff you can run, like DOCBOX." It's like slapping a Post-it note on the storage box labeled SYSEXEC so the system knows where to look. The SHR bit lets others peek at the dataset too, and REUSE says, "Got an old map? Just update it."




