      /if not defined(jobi0600_t)
      /define jobi0600_t
      *===============================================================*
      *  QUSRJOBI API - JOBI0600                                      *
      *===============================================================*
      *
     d jobi0600_t      ds                  qualified           based(pDummy)
     d  bytRet                       10i 0
     d  bytAvl                       10i 0
     d  job                          10a
     d  user                         10a
     d  nbr                           6a
     d  intJobID                     16a
     d  status                       10a
     d  type                          1a
     d  subType                       1a
     d  jobSws                        8a
     d  endStatus                     1a
     d  sbsD                         10a
     d  sbsDLib                      10a
     d  curUser                      10a
     d  dbcs                          1a
     d  exitKey                       1a
     d  cancelKey                     1a
     d  prdRetCode                   10i 0
     d  userRetCode                  10i 0
     d  pgmretCode                   10i 0
     d  spcEnv                       10a
     d  device                       10a
     d  grpPrf                       10a
     d  grpPrfAry                    10a   dim(15)
     d  jobUsrID                     10a
     d  jobUsrIDStg                   1a
      *
      /endif
