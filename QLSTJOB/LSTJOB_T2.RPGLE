**free
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  05.04.2016                                              *
//  E-mail  :  Thomas.Raddatz@Tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          nderung                                 *
//  ----------  ------------  ---------------------------------------  *
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
//                              SRCFILE(&SL/&SF) SRCMBR(&SM);          *
//     >>COMPILE<<                                                     *
//       >>PARM<< TRUNCNBR(*NO);                                       *
//       >>PARM<< DBGVIEW(*LIST);                                      *
//       >>PARM<< TGTRLS(V7R3M0);                                      *
//       >>PARM<< OPTION(*EVENTF);                                     *
//     >>END-COMPILE<<                                                 *
//     >>EXECUTE<<                                                     *
//     >>CMD<<     CRTPGM       PGM(&LI/&OB) +                         *
//                              MODULE(*PGM) +                         *
//                              BNDSRVPGM(&LI/LSTJOB) +                *
//                              ACTGRP(*NEW) +                         *
//                              DETAIL(*BASIC);                        *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
ctl-opt extbinint(*yes);
ctl-opt datfmt(*iso) timfmt(*iso) debug(*yes);
//=====================================================================*

/copy QLSTJOB,PLSTJOB List Jobs Service Program
/copy QLSTJOB,QUSLJOB List job(QUSLJOB) API
/copy QLSTJOB,FDJOBI0200 QUSRJOBI API - JOBI0200

//  *ENTRY Parameterliste
dcl-pr LSTJOB_T2 extpgm('LSTJOB_T2');
  gi_job char(10) const;
end-pr;

//  Prototypen fr interne Funktionen
dcl-pr p_main;
  i_job char(10) const;
end-pr;

//*******************************************************************
//  Hauptsteuerleiste des RPG
//*******************************************************************
dcl-pi LSTJOB_T2;
  gi_job char(10) const;
end-pi;
//-------------------------------------------------------------------

p_main(gi_job);
*inlr = *on;


//==================================================================*
//  Main Prozedur
//  (so hat man auch in der "Hauptsteuerleiste" lokale Variablen)
//==================================================================*
dcl-proc p_main export;
  dcl-pi *n;
    i_job char(10) const;
  end-pi;

  //  Lokale Arbeitsfelder
  dcl-s hasJob ind;
  dcl-s hJobs like(lstJob_handle_t) inz;
  dcl-ds jobl0100 likeds(jobl0100_t) inz;
  dcl-ds jobi0200 likeds(jobi0200_t) inz;
  dcl-ds msg likeds(msg_t) inz;
  //-------------------------------------------------------------------

  // ffnen Liste der Jobs
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

end-proc;
