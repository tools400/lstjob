      /IF NOT DEFINED(genLstHdr_t)
      /DEFINE genLstHdr_t
      * ============================================================= *
      *   Generic List Header for List APIs                           *
      *===============================================================*
      *
     D genLstHdr_t...
     D                 DS                  qualified               based(pDummy)
     D  userArea               1     64A
     D  size                  65     68I 0
     D  release               69     72A
     D  format                73     80A
     D  API                   81     90A
     D  crtDate               91    103A
     D  infStat              104    104A
     D  sizeUsrSpc           105    108I 0
     D  ofsInpSct            109    112I 0
     D  sizeInpSct           113    116I 0
     D  ofsHdrSct            117    120I 0
     D  sizeHdrSct           121    124I 0
     D  ofsLstSct            125    128I 0
     D  sizeLstSct           129    132I 0
     D  numE                 133    136I 0
     D  sizeE                137    140I 0
     D  CCSID                141    144I 0
     D  cntryID              145    146A
     D  lngID                147    149A
     D  subLstInd            150    150A
     D  reserved_01          151    192A
      *  Additional Format 0300 Fields
     D  APIEntryPoint        193    448A
     D  reserved_02          449    576A
      *
      /ENDIF
