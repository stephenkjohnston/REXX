/* REXX */                                                              00010012
ADDRESS ISREDIT "MACRO (PARM)"                                          00020012
                                                                        00030012
/* CONFIGURE ISPF TO HANDLE ERRORS PROGRAMMATICALLY */                  00040012
ADDRESS ISPEXEC "CONTROL ERRORS RETURN"                                 00050012
                                                                        00060012
/* Save the user state */                                               00070012
ADDRESS ISREDIT "(STATE) = USER_STATE"                                  00080012
                                                                        00090012
/* Reset the bounds */                                                  00100012
ADDRESS ISREDIT "BOUNDS"                                                00110012
                                                                        00120012
/* Convert the parameters to uppercase */                               00130012
PARM = TRANSLATE(PARM)                                                  00140012
                                                                        00150012
/* THE SUPPORTED LANGAUGES */                                           00160012
VALID_LANGS = "COB JCL"                                                 00170012
                                                                        00180012
/* CHECK THAT PARAMETER WAS PASSED IN */                                00190012
IF PARM = "" THEN DO                                                    00200012
  ZEDSMSG = "INVALID PARAMS"                                            00210012
  ZEDLMSG = "USAGE: DOCBOX [COB|JCL]"                                   00220012
  ADDRESS ISPEXEC "SETMSG MSG(ISRZ001)"                                 00230012
  EXIT                                                                  00240012
END                                                                     00250012
                                                                        00260012
/* EXTRACT THE LANGUAGE */                                              00270012
PARSE UPPER VAR PARM LANG ARGS .                                        00280012
                                                                        00290012
/* VALIDATE A SUPPORTED LANGUAGE WAS PASSED IN */                       00300012
IF WORD(POS(LANG,VALID_LANGS),1) = 0 THEN DO                            00310012
  ZEDSMSG = "INVALID LANGUAGE"                                          00320012
  ZEDLMSG = "USAGE: DOCBOX [COB|JCL]"                                   00330012
  ADDRESS ISPEXEC "SETMSG MSG(ISRZ001)"                                 00340012
  EXIT                                                                  00350012
END                                                                     00360012
                                                                        00370012
SELECT                                                                  00380012
  WHEN LANG = "JCL" THEN DO                                             00390012
    CALL PROCESS_JCL ARGS                                               00400012
  END                                                                   00410012
  WHEN LANG = "COB" THEN DO                                             00420012
    CALL PROCESS_COB ARGS                                               00430012
  END                                                                   00440012
END                                                                     00450012
                                                                        00460012
/* RESTORE THE USER'S STATE */                                          00470012
ADDRESS ISREDIT "USER_STATE = (STATE)"                                  00480012
                                                                        00490012
EXIT 0                                                                  00500012
                                                                        00510012
/*******************************************************************/   00520012
/* FUNCTION: PROCESS_JCL                                           */   00530012
/* PURPOSE : HANDLES COMMENT CREATION FOR JCL                      */   00540012
/* RETURN  : NONE.                                                 */   00550012
/*******************************************************************/   00560012
PROCESS_JCL: PROCEDURE                                                  00570012
  PARSE ARG ARGS                                                        00580012
                                                                        00590012
  SELECT                                                                00600012
    WHEN ARGS = "JC" THEN DO                                            00610012
      CALL GENERATE_JOBCARD                                             00620012
    END                                                                 00630012
    WHEN ARGS = "LINE" THEN DO                                          00640012
      CALL GENERATE_LINE_COMMENT JCL                                    00650012
    END                                                                 00660012
    WHEN ARGS = "BLOCK" THEN DO                                         00661013
      CALL GENERATE_FLOWERBOX JCL                                       00662013
    END                                                                 00663013
    OTHERWISE DO                                                        00670012
      ZEDSMSG = "INVALID SYNTAX"                                        00680012
      ZEDLMSG = "USE: DOCBOX JCL [JC|LINE|BLOCK]"                       00690012
      ADDRESS ISPEXEC "SETMSG MSG(ISRZ000)"                             00700012
    END                                                                 00710012
  END                                                                   00720012
                                                                        00730012
RETURN                                                                  00740012
                                                                        00750012
/*******************************************************************/   00760012
/* FUNCTION: PROCESS_COB                                           */   00770012
/* PURPOSE : HANDLES COMMENT CREATION FOR COBOL                    */   00780012
/* RETURN  : NONE.                                                 */   00790012
/*******************************************************************/   00800012
PROCESS_COB: PROCEDURE                                                  00810012
  PARSE ARG ARGS                                                        00820012
                                                                        00830012
  SELECT                                                                00840012
    WHEN ARGS = "LINE" THEN DO                                          00850012
      CALL GENERATE_LINE_COMMENT COB                                    00860012
    END                                                                 00870012
    WHEN ARGS = "BLOCK" THEN DO                                         00871013
      CALL GENERATE_FLOWERBOX COB                                       00872013
    END                                                                 00873013
    OTHERWISE DO                                                        00880012
      ZEDSMSG = "INVALID SYNTAX"                                        00890012
      ZEDLMSG = "USE: DOCBOX COB [LINE|BLOCK]"                          00900012
      ADDRESS ISPEXEC "SETMSG MSG(ISRZ000)"                             00910012
    END                                                                 00920012
  END                                                                   00930012
                                                                        00940012
RETURN                                                                  00950012
                                                                        00960012
/*******************************************************************/   00970012
/* FUNCTION: GENERATE_JOBCARD                                      */   00980012
/* PURPOSE : GENERATES A JCL JOB CARD HEADER WITH STUBBED COMMENTS */   00990012
/* RETURN  : NONE. WRITES TO THE TOP OF THE EDIT SESSION.          */   01000012
/*******************************************************************/   01010012
GENERATE_JOBCARD: PROCEDURE                                             01020012
                                                                        01030012
/* CHECK IF THIS IS AN EMPTY MEMBER */                                  01040012
  ADDRESS ISREDIT "(LINES) = LINENUM .ZLAST"                            01050012
                                                                        01060012
/* IF THE MEMBER IS NOT EMPTY MOVE TO THE TOP */                        01070012
  IF RC \=0 THEN DO                                                     01080012
    ADDRESS ISREDIT "UP MAX"                                            01090012
  END                                                                   01100012
                                                                        01110012
/* STORE THE CURRENT BOUNDS */                                          01120012
  ADDRESS ISREDIT "(LCOL,RCOL) = BOUNDS"                                01130012
                                                                        01140012
/* VARIABLES */                                                         01150012
  LN_EMPTY_CMT = "//*" || COPIES(" ", RCOL - 15) || "*"                 01160012
  LN_FULL_CMT  = "//*" || COPIES("*", RCOL - 15) || "*"                 01170012
  LN_PGM_NAME  = "PROGRAM: A JCL PROGRAM"                               01180012
  LN_DEV_NAME  = "PROGRAMMER NAME: A. PROGRAMMER"                       01190012
  LN_DATE      = "DATE:" DATE("E")                                      01200012
  LN_PURPOSE   = "PURPOSE:"                                             01210012
                                                                        01220012
/* STORE THE LAYOUT FOR THE JOB CARD */                                 01230012
  LN1 = "//"USERID()"A JOB ,'A. PROGRAMMER',MSGCLASS=H"                 01240012
  LN2 = "//*"                                                           01250012
  LN3 = LN_FULL_CMT                                                     01260012
  LN4 = LN_EMPTY_CMT                                                    01270012
  LN5 = OVERLAY(LN_PGM_NAME, LN_EMPTY_CMT, 5)                           01280012
  LN6 = LN_EMPTY_CMT                                                    01290012
  LN7 = OVERLAY(LN_DEV_NAME, LN_EMPTY_CMT, 5)                           01300012
  LN8 = LN_EMPTY_CMT                                                    01310012
  LN9 = OVERLAY(LN_DATE, LN_EMPTY_CMT, 5)                               01320012
  LN10 = LN_EMPTY_CMT                                                   01330012
  LN11 = OVERLAY(LN_PURPOSE, LN_EMPTY_CMT, 5)                           01340012
  LN12 = LN_FULL_CMT                                                    01350012
                                                                        01360012
/* WRITE THE JOB CARD TO THE TOP OF THE FILE */                         01370012
  ISREDIT "LINE_AFTER 0  = (LN1)"                                       01380012
  ISREDIT "LINE_AFTER 1  = (LN2)"                                       01390012
  ISREDIT "LINE_AFTER 2  = (LN3)"                                       01400012
  ISREDIT "LINE_AFTER 3  = (LN4)"                                       01410012
  ISREDIT "LINE_AFTER 4  = (LN5)"                                       01420012
  ISREDIT "LINE_AFTER 5  = (LN6)"                                       01430012
  ISREDIT "LINE_AFTER 6  = (LN7)"                                       01440012
  ISREDIT "LINE_AFTER 7  = (LN8)"                                       01450012
  ISREDIT "LINE_AFTER 8  = (LN9)"                                       01460012
  ISREDIT "LINE_AFTER 9  = (LN10)"                                      01470012
  ISREDIT "LINE_AFTER 10 = (LN11)"                                      01480012
  ISREDIT "LINE_AFTER 11 = (LN12)"                                      01490012
                                                                        01500012
/* SHOW THE SUCCESS MESSAGE */                                          01510012
  ZEDSMSG = "JOB CARD ADDED"                                            01520012
  ZEDLMSG = "JOB CARD ADDED TO TOP"                                     01530012
  ADDRESS ISPEXEC "SETMSG MSG(ISRZ000)"                                 01540012
                                                                        01550012
RETURN                                                                  01560012
                                                                        01570012
GENERATE_LINE_COMMENT: PROCEDURE                                        01580012
  PARSE ARG LANG                                                        01590012
                                                                        01600012
  SELECT                                                                01610012
    WHEN LANG = "JCL" THEN DO                                           01620012
      NEWLINE = "//*"                                                   01630012
      ADDRESS ISREDIT "LINE_AFTER .ZCSR = (NEWLINE)"                    01631013
    END                                                                 01640012
    WHEN LANG = "COB" THEN DO                                           01650012
      NEWLINE = copies(" ", 6) || "*"                                   01660013
      ADDRESS ISREDIT "LINE_AFTER .ZCSR = (NEWLINE)"                    01680012
    END                                                                 01690012
  END                                                                   01700012
                                                                        01710012
RETURN                                                                  01860012
                                                                        01870013
/*******************************************************************/   01880013
/* FUNCTION: GENERATE_FLOWERBOX                                    */   01890013
/* PURPOSE : GENERATES A COMMENT FLOWER BOX FOR JCL AND COBOL.     */   01900013
/* RETURN  : STRING.                                               */   01910013
/*******************************************************************/   01920013
GENERATE_FLOWERBOX: PROCEDURE                                           01930013
  PARSE ARG LANG                                                        01930113
                                                                        01931913
 /* STORE THE CURRENT BOUNDS */                                         01932313
  ADDRESS ISREDIT "(LCOL,RCOL) = BOUNDS"                                01932413
                                                                        01932513
  SELECT                                                                01933013
    WHEN LANG = "JCL" THEN DO                                           01933113
      LN_EMPTY_CMT = "//*" || COPIES(" ", RCOL - 15) || "*"             01933213
      LN_FULL_CMT  = "//*" || COPIES("*", RCOL - 15) || "*"             01933313
      LN_SPACER_CMT = "//*"                                             01933413
                                                                        01933513
      LN01 = LN_FULL_CMT                                                01933613
      LN02 = LN_EMPTY_CMT                                               01933713
      LN03 = LN_FULL_CMT                                                01933813
      LN04 = "//*"                                                      01933913
                                                                        01934013
      ADDRESS ISREDIT "LINE_AFTER .ZCSR = (LN04)"                       01934113
      ADDRESS ISREDIT "LINE_AFTER .ZCSR = (LN01)"                       01934213
      ADDRESS ISREDIT "LINE_AFTER .ZCSR = (LN02)"                       01934313
      ADDRESS ISREDIT "LINE_AFTER .ZCSR = (LN03)"                       01934413
      ADDRESS ISREDIT "LINE_AFTER .ZCSR = (LN04)"                       01934513
                                                                        01934613
    END                                                                 01934713
    WHEN LANG = "COB" THEN DO                                           01934813
      COB_CMT_SPACE = COPIES(" ", 6)                                    01934913
      COB_FULL_CMT = COPIES("*", RCOL - 13)                             01935013
      COB_MPTY_CMT = COPIES(" ", RCOL - 15)                             01935113
                                                                        01935213
      LN01 = COB_CMT_SPACE || COB_FULL_CMT                              01935313
      LN02 = COB_CMT_SPACE || "*" || COB_MPTY_CMT || "*"                01935413
                                                                        01935513
      ADDRESS ISREDIT "LINE_AFTER .ZCSR = (LN01)"                       01935613
      ADDRESS ISREDIT "LINE_AFTER .ZCSR = (LN02)"                       01935713
      ADDRESS ISREDIT "LINE_AFTER .ZCSR = (LN01)"                       01935813
                                                                        01935913
    END                                                                 01936013
  END                                                                   01936113
                                                                        01936213
RETURN                                                                  01937013
