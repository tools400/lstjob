**free
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  04.12.2003                                              *
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
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//  18.12.2008  Th.Raddatz    Changed program to work with LSTJOB 2.1. *
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

/copy QBASICS1,PBASICS1 ?Tools/400 Runtime Library
/copy QLSTJOB,PLSTJOB ?List Jobs Service Program
/copy QLSTJOB,QUSLJOB ?List job(QUSLJOB) API
/copy QLSTJOB,FDJOBI0200 ?QUSRJOBI API - JOBI0200

//  *ENTRY Parameterliste
dcl-pr LSTJOB_T1 extpgm('LSTJOB_T');
  gi_job_1 char(10) const;
  gi_job_2 char(10) const;
end-pr;

//  Prototypen für interne Funktionen
dcl-pr p_main;
  i_job_1 char(10) const;
  i_job_2 char(10) const;
end-pr;

//*******************************************************************
//  Hauptsteuerleiste des RPG
//*******************************************************************
dcl-pi LSTJOB_T1;
  gi_job_1 char(10) const;
  gi_job_2 char(10) const;
end-pi;

p_main(gi_job_1: gi_job_2);

*inlr = *on;

//==================================================================*
//  Main Prozedur
//  (so hat man auch in der "Hauptsteuerleiste" lokale Variablen)
//==================================================================*

dcl-proc p_main export;
  dcl-pi *n;
    i_job_1 char(10) const;
    i_job_2 char(10) const;
  end-pi;

  //  Lokale Arbeitsfelder
  dcl-s isDone1 ind inz;
  dcl-s isDone2 ind inz;

  dcl-s handle1 like(lstJob_handle_t) inz;
  dcl-s handle2 like(lstJob_handle_t) inz;

  dcl-s data like(data_1) inz;

  dcl-ds data_1 likeds(jobl0100_t) inz;

  dcl-ds data_2 likeds(jobl0100_t) inz;

  dcl-ds jobi_1 likeds(jobi0200_t) inz;

  dcl-ds jobi_2 likeds(jobi0200_t) inz;

  dcl-ds screen_msg;
    blank1 char(3) inz;
    col1   char(10) inz;
    blank2 char(4) inz;
    col2   char(8) inz;
    blank3 char(3) inz;
    col3   char(10) inz;
    blank4 char(4) inz;
    col4   char(8) inz;
  end-ds;

  dcl-s ok char(1) inz;
  dcl-s msg like(msg_t) inz;

  //-------------------------------------------------------------------

  //  Ausgeben überschrift
  Clear screen_msg;
  Dsply screen_msg;
  Clear screen_msg;
  col1 = 'Job 1:';
  col2 = 'SbsD 1:';
  col3 = 'Job 2:';
  col4 = 'SbsD 2:';
  Dsply screen_msg;
  Clear screen_msg;
  col1 = *ALL'-';
  col2 = *ALL'-';
  col3 = *ALL'-';
  col4 = *ALL'-';
  Dsply screen_msg;

  //  öffnen der 1. Liste
  isDone1 = f_opnJobLst(i_job_1     :
                       '*ALL'      :
                       '*ALL'      :
                       '*ACTIVE'   :
                       '*NAME'     :
                       handle1     :
                       msg         );

  //  öffnen der 2. Liste
  isDone2 = f_opnJobLst(i_job_2     :
                       '*ALL'      :
                       '*ALL'      :
                       '*ACTIVE'   :
                       '*STATUS'   :
                       handle2     :
                       msg         );

  //  Lesen 1. Eintrag der 1. Liste
  isDone1 = f_getFirstJob(handle1 :
                         data    );
  If isDone1;
    data_1  = data;
  Else;
    Clear data_1;
  Endif;

  //  Lesen 1. Eintrag der 2. Liste
  isDone2 = f_getFirstJob(handle2 :
                         data    );
  If isDone2;
    data_2  = data;
  Else;
    Clear data_2;
  Endif;


  Dow isDOne1 or isDone2;

    //  Abrufen Jobinformationen
    If isDOne1;
      jobi_1 = f_rtvJobA(data_1.intJobID:
                        'JOBI0200'     );
    Else;
      Clear jobi_1;
    Endif;

    If isDOne2;
      jobi_2 = f_rtvJobA(data_2.intJobID:
                        'JOBI0200'     );
    Else;
      Clear jobi_2;
    Endif;

    //  Anzeigen gelesene Einträge
    Reset screen_msg;
    col1 = data_1.job;
    col2 = jobi_1.sbsDName;
    col3 = data_2.job;
    col4 = jobi_2.sbsDName;
    Dsply screen_msg;

    //  Lesen weitere Einträge Liste 1
    isDone1 = f_getNextJob(handle1  :
                         data      );
    If isDone1;
      data_1  = data;
    Else;
      Clear data_1;
    Endif;

    //  Lesen weitere Einträge Liste 2
    isDone2 = f_getNextJob(handle2  :
                         data      );
    If isDone2;
      data_2  = data;
    Else;
      Clear data_2;
    Endif;
  Enddo;

  //  Anzeigen "Ende" Nachricht
  Clear screen_msg;
  col1 = 'Anzahl:';
  col2 =
   %trim(%editc(f_getNumJobAvl(handle1): 'Z'));
  col4 =
   %trim(%editc(f_getNumJobAvl(handle2): 'Z'));
  Dsply screen_msg ok;

  //  Schließen 1. Liste
  isDone1 = f_cloJobLst(handle1 );

  //  Schließen 2. Liste
  isDone2 = f_cloJobLst(handle2 );

  Return;

end-proc;

//==================================================================*

