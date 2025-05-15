/* REXX */                                                              00010002
ADDRESS ISREDIT                                                         00020002
"MACRO (PARM)"                                                          00030002
                                                                        00040002
/**********************************************************************/00041003
/* VARIABLES                                                          */00042003
/*   JCL_CMT - A simple jcl comment line                              */00043003
/*   SCR_WDTH - The screen width (TODO: DYNAMIC, instead of STATIC?)  */00043103
/**********************************************************************/00044003
JCL_CMT = "//*"                                                         00045003
SCR_WDTH = 72                                                           00046003
PARM = TRANSLATE(PARM) /* Convert to uppercase */                       00050002
                                                                        00052002
SELECT                                                                  00053003
  WHEN PARM = 'JC' THEN DO                                              00054003
    CALL GENERATE_JOBCARD                                               00055003
  End                                                                   00056003
  OTHERWISE DO                                                          00057003
    MSG = 'Invalid parameter. use: jc'                                  00058003
    address ispexec "VPUT (MSG) SHARED"                                 00059003
    address ispexec "SETMSG MSG(ISPZ000)"                               00060003
  END                                                                   00070003
END                                                                     00100002
EXIT 0                                                                  00210002
                                                                        00220003
/**********************************************************************/00221003
/* FUNCTION: generate_jobcard                                         */00222003
/* PUrpose : generates a jcl job card header with stubbed comments    */00222103
/* RETURN  : NOne. writes to the top of the edit session.             */00222203
/**********************************************************************/00223003
                                                                        00224003
GENERATE_JOBCARD: procedure EXPOSE JCL_CMT SCR_WDTH                     00230003
  /* THE REMAINING COLUMNS MINUS THE START OF THE COMMENT */            00230103
  SCRN_LEFT = (SCR_WDTH - LENGTH(STRIP(JCL_CMT, 'T')))                  00231003
                                                                        00231103
  /* AN EMPTY COMMENT LINE THE WIDTH OF THE SCREEN */                   00232003
  CMT_LNE = JCL_CMT || COPIES(" ", SCRN_LEFT - 1) || "*"                00233003
  FULL_CMT_LNE = JCL_CMT || COPIES("*", SCRN_LEFT -1) || "*"            00234003
                                                                        00234103
  /* STRINGS */                                                         00234203
  PGM_NAME_LNE = "MAINFRAME" || COPIES(" ", 13) || "ASSIGNMENT N"       00234303
  DEV_NAME_LNE = "PROGRAMMER NAME: A. PROGRAMMER"                       00234403
  DUE_DATE_LNE = "DUE DATE: MM/DD/YYYY"                                 00235003
  PURPOSE_LNE = "PURPOSE: THE PURPOSE OF THIS JOB"                      00237003
                                                                        00238003
  JC1 = "//"USERID()"A JOB ,'your last name',MSGCLASS=H"                00240003
  JC2 = JCL_CMT                                                         00250003
  JC3 = FULL_CMT_LNE                                                    00250103
  JC4 = OVERLAY(PGM_NAME_LNE, CMT_LNE, LENGTH(JCL_CMT) + 2)             00250603
  JC5 = CMT_LNE                                                         00250703
  JC6 = OVERLAY(DEV_NAME_LNE, CMT_LNE, LENGTH(JCL_CMT) + 2)             00250803
  JC7 = OVERLAY(DUE_DATE_LNE, CMT_LNE, LENGTH(JCL_CMT) + 2)             00250903
  JC8 = CMT_LNE                                                         00251003
  JC9 = OVERLAY(PURPOSE_LNE, CMT_LNE, LENGTH(JCL_CMT) + 2)              00251103
  JC10 = FULL_CMT_LNE                                                   00251203
                                                                        00251303
  /* write the job card at the top of the JCL */                        00251403
  'line_after 0 = (JC1)'                                                00252003
  'LINE_AFTER 1 = (JC2)'                                                00253003
  'LINE_AFTER 2 = (JC3)'                                                00254003
  'LINE_AFTER 3 = (JC4)'                                                00255003
  'LINE_AFTER 4 = (JC5)'                                                00256003
  'LINE_AFTER 5 = (JC6)'                                                00257003
  'LINE_AFTER 6 = (JC7)'                                                00258003
  'LINE_AFTER 7 = (JC8)'                                                00259003
  'LINE_AFTER 8 = (JC9)'                                                00259103
  'LINE_AFTER 9 = (JC10)'                                               00259203
                                                                        00259303
RETURN                                                                  00260003
                                                                        00270003
                                                                        00280003
                                                                        00290003
                                                                        00300003
