      /IF NOT DEFINED(PLSTJOB)
      /DEFINE PLSTJOB
      *===============================================================*
      *                                                               *
      *  (c) 2000, Thomas Raddatz                                     *
      *                                                               *
      *  Bereich  : LSTJOB                                            *
      *  Exp.Liste: LSTJOB_P                                          *
      *  Typ      : RPGLE                                             *
      *                                                               *
      *  erstellt : 04.12.2003  Thomas Raddatz                        *
      *                                                               *
      *===============================================================*
      *                                                               *
      *  Kurzdokumentation :                                          *
      *                                                               *
      *  Prototypen für Serviceprogramm LSTJOB                        *
      *                                                               *
      *===============================================================*
      *
      *===============================================================*
      *  External ressources
      *===============================================================*
      /COPY QBASICS1,PBASICS1                     Tools/400 Runtime Library
      *
      *===============================================================*
      *  Reference fields
      *===============================================================*
     D lstJob_handle_t...
     D                 S                   based(pDummy)
     D                                     like(HANDLE_handle_t)
      *
     D cLSTJOB_ORDERBY_NONE...
     D                 C                   const('*NONE')
     D cLSTJOB_ORDERBY_NAME...
     D                 C                   const('*NAME')
     D cLSTJOB_ORDERBY_NAME_DESC...
     D                 C                   const('*NAME_DESC')
     D cLSTJOB_ORDERBY_STATUS...
     D                 C                   const('*STATUS')
      *
     D cLSTJOB_STATUS_ACTIVE...
     D                 C                   const('*ACTIVE')
     D cLSTJOB_STATUS_JOBQ...
     D                 C                   const('*JOBQ')
     D cLSTJOB_STATUS_OUTQ...
     D                 C                   const('*OUTQ')
     D cLSTJOB_STATUS_ALL...
     D                 C                   const('*ALL')
      *
      /COPY QLSTJOB,FDQJOB
      *
      *  Open List Of Jobs
     D f_opnJobLst...
     D                 PR              N   opdesc
     D                                     extproc('LSTJOBR1+
     D                                     _f_opnJobLst+
     D                                     ')
     D  i_job                        10A   value
     D  i_user                       10A   value
     D  i_nbr                         6A   value
     D  i_status                     10A   value
     D  i_orderBy                    10A   value
     D  o_handle                                  like(lstJob_handle_t)
     D  o_msg                     32767A          options(*nopass :
     D                                                    *varsize)
      *
      *  Close List Of Jobs
     D f_cloJobLst...
     D                 PR              N
     D                                     extproc('LSTJOBR1+
     D                                     _f_cloJobLst+
     D                                     ')
     D  io_handle                                 like(lstJob_handle_t)
      *
      *  Get First Job
     D f_getFirstJob...
     D                 PR              N   opdesc
     D                                     extproc('LSTJOBR1+
     D                                     _f_getFirstJob+
     D                                     ')
     D  i_handle                           value  like(lstJob_handle_t)
     D  o_data                    32767A          options(*varsize)
      *
      *  Get Next Job
     D f_getNextJob...
     D                 PR              N   opdesc
     D                                     extproc('LSTJOBR1+
     D                                     _f_getNextJob+
     D                                     ')
     D  i_handle                           value  like(lstJob_handle_t)
     D  o_data                    32767A          options(*varsize)
      *
      *  Get Number of Jobs available
     D f_getNumJobAvl...
     D                 PR            10I 0
     D                                     extproc('LSTJOBR1+
     D                                     _f_getNumJobAvl+
     D                                     ')
     D  i_handle                           value  like(lstJob_handle_t)
      *
      *  Retrieve Job Attributes
     D f_rtvJobA...
     D                 PR          8191A   opdesc varying
     D                                     extproc('LSTJOBR1+
     D                                     _f_rtvJobA+
     D                                     ')
     D  i_intJobID                   16A   const
     D  i_format                      8A   const
     D  o_msg                     32767A          options(*nopass :
     D                                                    *varsize)
      *
      /ENDIF
