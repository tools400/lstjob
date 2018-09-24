/* --------------------------------------------------------------- */
/* LSTJOB     - SCRIPT MEMBER                                      */
/* Use commands  xmlgenINC (generate text for install pgm)         */
/*               xmlgenMBR (to define source members               */
/*               xmlgenCMD (execute qcmdexc at run time            */
/* Put &TOLIB where you want user selected lib at run time.        */
   DCL &TOLIB *CHAR 10
/* --------------------------------------------------------------- */
             XMLGENINC  XINCLUDE(*YES)

             XMLGENVRS XSRCFILE(QLSTJOB) XSRCLIB(TOOLS400) XSRCMBR(COPYRIGHT)

             XMLGENCND  XMSG('Create sample programs? (YES, NO)') +
                          XVALUES(YES NO) XVAR(&CRTTSTPGM)

             XMLGENSET  XVAR(&SRCFILE) XVALUE(QLSTJOB)

/* ---------------------------------- */
/*  Deploy source member              */
/* ---------------------------------- */
             XMLGENMBR  XMBR(A_INSTALL ) XMBRATR(CLLE  ) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(A_README  ) XMBRATR(TXT) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*PGM) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CEELIB    ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(CLIB      ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(COPYRIGHT ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDJOBI0100) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDJOBI0200) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDJOBI0400) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDJOBI0600) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDJOBI0700) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDJOBL0100) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(FDQJOB    ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(GENLSTHDR ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*FILE  ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LSTJOB    ) XMBRATR(BND  ) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LSTJOB_T1) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LSTJOB_T2) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(LSTJOBR1 ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(PLSTJOB   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(QUSLJOB   ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

             XMLGENMBR  XMBR(QUSRJOBI  ) XMBRATR(RPGLE) +
                          XFROMSRCF(QLSTJOB   ) XFROMSRCL(TOOLS400) +
                          XTOSRCF(QLSTJOB   ) XOBJTYPE(*PGM   ) +
                          XGENCRT(*NO ) XPARAM(*BLANK)

/* ---------------------------------- */
/*  Create objects                    */
/* ---------------------------------- */
             XMLGENCMD  XCMD(CRTBNDCL PGM(&TOLIB/A_INSTALL) +
                          SRCFILE(&TOLIB/QLSTJOB) SRCMBR(*PGM) +
                          DFTACTGRP(*NO) ACTGRP(*NEW) +
                          DBGVIEW(*LIST)) XDLTSPLF(A_INSTALL)

             XMLGENCMD  XCMD(CALL PGM(&TOLIB/A_INSTALL) +
                             PARM('&TGTRLS' '&SRCFILE' '&TOLIB' '&CRTTSTPGM'))
             XMLGENCMD  XCMD(DLTPGM PGM(&TOLIB/A_INSTALL))

