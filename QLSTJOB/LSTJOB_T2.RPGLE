      *=====================================================================*
      *  Author  :  Thomas Raddatz                                          *
      *  Date    :  05.04.2016                                              *
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
      /COPY QLSTJOB,PLSTJOB                       List Jobs Service Program
      /COPY QLSTJOB,QUSLJOB                       List Job (QUSLJOB) API
      /COPY QLSTJOB,FDJOBI0200                    QUSRJOBI API - JOBI0200
      *
      *  *ENTRY Parameterliste
     D LSTJOB_T2...
     D                 PR                  extpgm('LSTJOB_T2')
     D  gi_job                       10A   const
      *
      *  Prototypen für interne Funktionen
     D p_main...
     D                 PR
     D  i_job                        10A   const
      *
      ********************************************************************
      *  Hauptsteuerleiste des RPG
      ********************************************************************
     D LSTJOB_T2...
     D                 PI
     D  gi_job                       10A   const
      *-------------------------------------------------------------------
      /free

         p_main(gi_job);
         *inlr = *on;

      /end-free

      *==================================================================*
      *  Main Prozedur
      *  (so hat man auch in der "Hauptsteuerleiste" lokale Variablen)
      *==================================================================*
     P p_main...
     P                 B                   export
     D                 PI
     D  i_job                        10A   const
      *
      *  Lokale Arbeitsfelder
     D hasJob          S               N
     D hJobs           S                   like(lstJob_handle_t) inz
     D jobl0100        DS                  likeds(jobl0100_t) inz
     D jobi0200        DS                  likeds(jobi0200_t) inz
     D msg             DS                  likeds(msg_t) inz
      *-------------------------------------------------------------------
      /free

         // Öffnen Liste der Jobs
         hasJob = f_opnJobLst(i_job: '*ALL': '*ALL': '*ACTIVE'
                              : cLSTJOB_ORDERBY_NONE: hJobs);

         // Lesen 1. Job der Liste
         hasJob = f_getFirstJob(hJobs: jobl0100);
         dow hasJob;

            // Abrufen Jobinformationen
            jobi0200 = f_rtvJobA(jobl0100.intJobID: 'JOBI0200': msg);
            if (msg.ID <> cMSG_ID_OK);
               // Fehler beim Abrufen der Jobinformationen
            else;
               if (jobi0200.actJobSts = 'DSC');
                  // Job Status = DISCONNECTED
               endif;
            endif;

            hasJob = f_getNextJob(hJobs: jobl0100);
         enddo;

         f_cloJobLst(hJobs);

      /end-free
     P                 E
