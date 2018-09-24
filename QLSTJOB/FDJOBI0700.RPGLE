      /if not defined(jobi0700_t)
      /define jobi0700_t
      *===============================================================*
      *  QUSRJOBI API - JOBI0700                                      *
      *===============================================================*
      *
     d jobi0700_t      ds                  qualified           based(pDummy)
     d  bytRet                       10i 0
     d  bytAvl                       10i 0
     d  job                          10a
     d  user                         10a
     d  nbr                           6a
     d  intJobID                     16a
     d  status                       10a
     d  type                          1a
     d  subType                       1a
     d  reserved_1                    2a
     d  numSysLibE                   10i 0
     d  numPrdLibE                   10i 0
     d  numCurLibE                   10i 0
     d  numUsrLibE                   10i 0
      *
      /endif
