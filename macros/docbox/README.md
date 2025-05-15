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
