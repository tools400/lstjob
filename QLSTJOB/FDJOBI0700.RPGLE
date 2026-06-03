**free
/if not defined(jobi0700_t)
/define jobi0700_t
//===============================================================*
//  QUSRJOBI API - JOBI0700                                      *
//===============================================================*

dcl-ds jobi0700_t qualified based(pDummy);
  bytRet     int(10);
  bytAvl     int(10);
  job        char(10);
  user       char(10);
  nbr        char(6);
  intJobID   char(16);
  status     char(10);
  type       char(1);
  subType    char(1);
  reserved_1 char(2);
  numSysLibE int(10);
  numPrdLibE int(10);
  numCurLibE int(10);
  numUsrLibE int(10);
end-ds;

/endif
