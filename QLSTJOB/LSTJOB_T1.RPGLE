      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  04.12.2003                                              *
      *  E-mail  :  Thomas.Raddatz@Tools400.de                              *
      *  Homepage:  www.tools400.de                                         *
      *=====================================================================*
      *                                                                     *
      *  This software is free software, you can redistribute it and/or     *
      *  modify it under the terms of the GNU General Public License (GPL)  *
      *  as published by the Free Software Foundation.                      *
      *                                                                     *
      *  See GNU General Public License for details.                        *
      *          http://www.opensource.org                                  *
      *          http://www.opensource.org/licenses/gpl-license.html        *
      *                                                                     *
      *=====================================================================*
      *  History:                                                           *
      *                                                                     *
      *  Datum       Name          Änderung                                 *
      *  ----------  ------------  ---------------------------------------  *
      *  18.12.2008  Th.Raddatz    Changed program to work with LSTJOB 2.1. *
      *                                                                     *
      *=====================================================================*
      *   >>PRE-COMPILER<<                                                  *
      *     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
      *                              SRCFILE(&SL/&SF) SRCMBR(&SM);          *
      *     >>COMPILE<<                                                     *
      *       >>PARM<< TRUNCNBR(*NO);                                       *
      *       >>PARM<< DBGVIEW(*LIST);                                      *
      *       >>PARM<< TGTRLS(V6R1M0);                                      *
      *       >>PARM<< OPTION(*EVENTF);                                     *
      *     >>END-COMPILE<<                                                 *
      *     >>EXECUTE<<                                                     *
      *     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                         *
      *                              MODULE(*PGM) +                         *
      *                              BNDSRVPGM(&LI/LSTJOB) +                *
      *                              ACTGRP(*NEW) +                         *
      *                              DETAIL(*BASIC);                        *
      *   >>END-PRE-COMPILER<<                                              *
      *=====================================================================*
     H EXTBININT(*YES)
     H DATFMT(*ISO) TIMFMT(*ISO) DEBUG(*YES)
      *=====================================================================*
      *
      /COPY QBASICS1,PBASICS1                    ?Tools/400 Runtime Library
      /COPY QLSTJOB,PLSTJOB                      ?List Jobs Service Program
      /COPY QLSTJOB,QUSLJOB                      ?List Job (QUSLJOB) API
      /COPY QLSTJOB,FDJOBI0200                   ?QUSRJOBI API - JOBI0200
      *
      *  *ENTRY Parameterliste
     D LSTJOB_T1...
     D                 PR                  extpgm('LSTJOB_T')
     D  gi_job_1                     10A   const
     D  gi_job_2                     10A   const
      *
      *  Prototypen für interne Funktionen
     D p_main...
     D                 PR
     D  i_job_1                      10A   const
     D  i_job_2                      10A   const
      *
      ********************************************************************
      *  Hauptsteuerleiste des RPG
      ********************************************************************
      *
     D LSTJOB_T1...
     D                 PI
     D  gi_job_1                     10A   const
     D  gi_job_2                     10A   const
      *
     C                   Callp     p_main(gi_job_1: gi_job_2)
      *
     C                   Eval      *inlr = *on
      *
      *==================================================================*
      *  Main Prozedur
      *  (so hat man auch in der "Hauptsteuerleiste" lokale Variablen)
      *==================================================================*
      *
     P p_main...
     P                 B                   export
      *
     D p_main...
     D                 PI
     D  i_job_1                      10A   const
     D  i_job_2                      10A   const
      *
      *  Lokale Arbeitsfelder
     D isDone1         S               N   inz
     D isDone2         S               N   inz
      *
     D handle1         S                   like(lstJob_handle_t)  inz
     D handle2         S                   like(lstJob_handle_t)  inz
      *
     D data            S                   like(data_1)         inz
      *
     D data_1          DS                  likeds(jobl0100_t )  inz
      *
     D data_2          DS                  likeds(jobl0100_t )  inz
      *
     D jobi_1          DS                  likeds(jobi0200_t )  inz
      *
     D jobi_2          DS                  likeds(jobi0200_t )  inz
      *
     D screen_msg      DS
     D  blank1                        3A   inz
     D  col1                         10A   inz
     D  blank2                        4A   inz
     D  col2                          8A   inz
     D  blank3                        3A   inz
     D  col3                         10A   inz
     D  blank4                        4A   inz
     D  col4                          8A   inz
      *
     D ok              S              1A   inz
     D msg             S                   like(msg_t     )  inz
      *
      *-------------------------------------------------------------------
      *
      *  Ausgeben Überschrift
     C                   Clear                   screen_msg
     C     screen_msg    Dsply
     C                   Clear                   screen_msg
     C                   Eval      col1 = 'Job 1:'
     C                   Eval      col2 = 'SbsD 1:'
     C                   Eval      col3 = 'Job 2:'
     C                   Eval      col4 = 'SbsD 2:'
     C     screen_msg    Dsply
     C                   Clear                   screen_msg
     C                   Eval      col1 = *ALL'-'
     C                   Eval      col2 = *ALL'-'
     C                   Eval      col3 = *ALL'-'
     C                   Eval      col4 = *ALL'-'
     C     screen_msg    Dsply
      *
      *  Öffnen der 1. Liste
     C                   Eval      isDone1 = f_opnJobLst(i_job_1     :
     C                                                   '*ALL'      :
     C                                                   '*ALL'      :
     C                                                   '*ACTIVE'   :
     C                                                   '*NAME'     :
     C                                                   handle1     :
     C                                                   msg         )
      *
      *  Öffnen der 2. Liste
     C                   Eval      isDone2 = f_opnJobLst(i_job_2     :
     C                                                   '*ALL'      :
     C                                                   '*ALL'      :
     C                                                   '*ACTIVE'   :
     C                                                   '*STATUS'   :
     C                                                   handle2     :
     C                                                   msg         )
      *
      *  Lesen 1. Eintrag der 1. Liste
     C                   Eval      isDone1 = f_getFirstJob(handle1 :
     C                                                     data    )
     C                   If        isDone1
     C                   Eval      data_1  = data
     C                   Else
     C                   Clear                   data_1
     C                   Endif
      *
      *  Lesen 1. Eintrag der 2. Liste
     C                   Eval      isDone2 = f_getFirstJob(handle2 :
     C                                                     data    )
     C                   If        isDone2
     C                   Eval      data_2  = data
     C                   Else
     C                   Clear                   data_2
     C                   Endif
     C
      *
     C                   Dow       isDOne1 or isDone2
      *
      *  Abrufen Jobinformationen
     C                   If        isDOne1
     C                   Eval      jobi_1 = f_rtvJobA(data_1.intJobID:
     C                                                'JOBI0200'     )
     C                   Else
     C                   Clear                   jobi_1
     C                   Endif
      *
     C                   If        isDOne2
     C                   Eval      jobi_2 = f_rtvJobA(data_2.intJobID:
     C                                                'JOBI0200'     )
     C                   Else
     C                   Clear                   jobi_2
     C                   Endif
      *
      *  Anzeigen gelesene Einträge
     C                   Reset                   screen_msg
     C                   Eval      col1 = data_1.job
     C                   Eval      col2 = jobi_1.sbsDName
     C                   Eval      col3 = data_2.job
     C                   Eval      col4 = jobi_2.sbsDName
     C     screen_msg    Dsply
      *
      *  Lesen weitere Einträge Liste 1
     C                   Eval      isDone1 = f_getNextJob(handle1  :
     C                                                   data      )
     C                   If        isDone1
     C                   Eval      data_1  = data
     C                   Else
     C                   Clear                   data_1
     C                   Endif
      *
      *  Lesen weitere Einträge Liste 2
     C                   Eval      isDone2 = f_getNextJob(handle2  :
     C                                                   data      )
     C                   If        isDone2
     C                   Eval      data_2  = data
     C                   Else
     C                   Clear                   data_2
     C                   Endif
     C                   Enddo
      *
      *  Anzeigen "Ende" Nachricht
     C                   Clear                   screen_msg
     C                   Eval      col1 = 'Anzahl:'
     C                   Eval      col2 =
     C                               %trim(%editc(f_getNumJobAvl(handle1): 'Z'))
     C                   Eval      col4 =
     C                               %trim(%editc(f_getNumJobAvl(handle2): 'Z'))
     C     screen_msg    Dsply                   ok
      *
      *  Schließen 1. Liste
     C                   Eval      isDone1 = f_cloJobLst(handle1 )
      *
      *  Schließen 2. Liste
     C                   Eval      isDone2 = f_cloJobLst(handle2 )
      *
     C                   Return
      *
     P p_main...
     P                 E
      *
      *==================================================================*
      *
