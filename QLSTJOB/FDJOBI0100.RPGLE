**free
/if not defined(jobi0100_t)
/define jobi0100_t
//===============================================================*
//  QUSRJOBI API - JOBI0100                                      *
//===============================================================*

dcl-ds jobi0100_t qualified based(pDummy);
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
  runPty     int(10);
  timeSlice  int(10);
  dftWait    int(10);
  purge      char(10);
end-ds;

/endif
