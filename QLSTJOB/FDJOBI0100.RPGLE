      /if not defined(jobi0100_t)
      /define jobi0100_t
      *===============================================================*
      *  QUSRJOBI API - JOBI0100                                      *
      *===============================================================*
      *
     d jobi0100_t      ds                  qualified           based(pDummy)
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
     d  runPty                       10i 0
     d  timeSlice                    10i 0
     d  dftWait                      10i 0
     d  purge                        10a
      *
      /endif
