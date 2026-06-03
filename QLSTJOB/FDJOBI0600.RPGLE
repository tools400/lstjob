**free
/if not defined(jobi0600_t)
/define jobi0600_t
//===============================================================*
//  QUSRJOBI API - JOBI0600                                      *
//===============================================================*

dcl-ds jobi0600_t qualified template;
  bytRet      int(10);
  bytAvl      int(10);
  job         char(10);
  user        char(10);
  nbr         char(6);
  intJobID    char(16);
  status      char(10);
  type        char(1);
  subType     char(1);
  jobSws      char(8);
  endStatus   char(1);
  sbsD        char(10);
  sbsDLib     char(10);
  curUser     char(10);
  dbcs        char(1);
  exitKey     char(1);
  cancelKey   char(1);
  prdRetCode  int(10);
  userRetCode int(10);
  pgmretCode  int(10);
  spcEnv      char(10);
  device      char(10);
  grpPrf      char(10);
  grpPrfAry   char(10) dim(15);
  jobUsrID    char(10);
  jobUsrIDStg char(1);
end-ds;

/endif
