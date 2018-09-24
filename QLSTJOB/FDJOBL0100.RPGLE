      /if not defined(jobl0100_t)
      /define jobl0100_t
      *===============================================================*
      *  QUSLJOB  API - JOBL0100                                      *
      *===============================================================*
      *
     d jobl0100_t      ds                  qualified           based(pDummy)
     d  job                          10a
     d  user                         10a
     d  nbr                           6a
     d  intJobID                     16a
     d  status                       10a
     d  type                          1a
     d  subType                       1a
     d  reserved_01                   2a
      *
      /endif
