      /if not defined(jobi0200_t)
      /define jobi0200_t
      *===============================================================*
      *  QUSRJOBI API - JOBI0200                                      *
      *===============================================================*
      *
     d jobi0200_t      ds                  qualified           based(pDummy)
     d  bytRet                       10i 0
     d  bytAvl                       10i 0
     d  job                          10a
     d  user                         10a
     d  nbr                           6a
     d  intJobID                     16a
     d  status                       10a
     d  type                          1a
     d  subType                       1a
     d  sbsDName                     10a
     d  runPty                       10i 0
     d  sysPoolID                    10i 0
     d  prcTimeUsd                   10i 0
     d  numAuxIORq                   10i 0
     d  numIntTact                   10i 0
     d  rspTimeTot                   10i 0
     d  fncType                       1a
     d  fncName                      10a
     d  actJobSts                     4a
     d  numDBLckW                    10i 0
     d  numIntLckW                   10i 0
     d  numNonDBLckW                 10i 0
     d  timeDBLckW                   10i 0
     d  timeIntLckW                  10i 0
     d  timeNonDBLckW                10i 0
     d  reserved_01                   1a
     d  currSysPoolID                10i 0
     d  thrdCount                    10i 0
     d  prcUntTmUsd                  20U 0
     d  numAuxIORqLng                20U 0
     d  prcUntTmUsdDB                20U 0
     d  pageFaults                   20U 0
     d  actJobStsJobEnd...
     d                                4a
     d  memPoolName                  10a
     d  msgRply                       1a
      *
      /endif
