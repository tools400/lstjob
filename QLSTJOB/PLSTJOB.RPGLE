**free
/if NOT defined(PLSTJOB)
/define PLSTJOB
//===============================================================*
//                                                               *
//  (c) 2000, Thomas Raddatz                                     *
//                                                               *
//  Bereich  : LSTJOB                                            *
//  Exp.Liste: LSTJOB_P                                          *
//  Typ      : RPGLE                                             *
//                                                               *
//  erstellt : 04.12.2003  Thomas Raddatz                        *
//                                                               *
//===============================================================*
//                                                               *
//  Kurzdokumentation :                                          *
//                                                               *
//  Prototypen fr Serviceprogramm LSTJOB                        *
//                                                               *
//===============================================================*

//===============================================================*
//  External ressources
//===============================================================*
/copy QBASICS1,PBASICS1 Tools/400 Runtime Library

//===============================================================*
//  Reference fields
//===============================================================*
dcl-s lstJob_handle_t based(pDummy) like(HANDLE_handle_t);

dcl-c cLSTJOB_ORDERBY_NONE '*NONE';
dcl-c cLSTJOB_ORDERBY_NAME '*NAME';
dcl-c cLSTJOB_ORDERBY_NAME_DESC '*NAME_DESC';
dcl-c cLSTJOB_ORDERBY_STATUS '*STATUS';

dcl-c cLSTJOB_STATUS_ACTIVE '*ACTIVE';
dcl-c cLSTJOB_STATUS_JOBQ '*JOBQ';
dcl-c cLSTJOB_STATUS_OUTQ '*OUTQ';
dcl-c cLSTJOB_STATUS_ALL '*ALL';

/copy QLSTJOB,FDQJOB

//  Open List Of Jobs
dcl-pr f_opnJobLst ind opdesc extproc('LSTJOBR1_f_opnJobLst');
  i_job     char(10) value;
  i_user    char(10) value;
  i_nbr     char(6) value;
  i_status  char(10) value;
  i_orderBy char(10) value;
  o_handle  like(lstJob_handle_t);
  o_msg     char(32767) options(*nopass: *varsize);
end-pr;

//  Close List Of Jobs
dcl-pr f_cloJobLst ind extproc('LSTJOBR1_f_cloJobLst');
  io_handle like(lstJob_handle_t);
end-pr;

//  Get First Job
dcl-pr f_getFirstJob ind opdesc extproc('LSTJOBR1_f_getFirstJob');
  i_handle like(lstJob_handle_t) value;
  o_data   char(32767) options(*varsize);
end-pr;

//  Get Next Job
dcl-pr f_getNextJob ind opdesc extproc('LSTJOBR1_f_getNextJob');
  i_handle like(lstJob_handle_t) value;
  o_data   char(32767) options(*varsize);
end-pr;

//  Get Number of Jobs available
dcl-pr f_getNumJobAvl int(10) extproc('LSTJOBR1_f_getNumJobAvl');
  i_handle like(lstJob_handle_t) value;
end-pr;

//  Retrieve Job Attributes
dcl-pr f_rtvJobA varchar(8191) opdesc extproc('LSTJOBR1_f_rtvJobA');
  i_intJobID char(16) const;
  i_format   char(8) const;
  o_msg      char(32767) options(*nopass: *varsize);
end-pr;

/endif
