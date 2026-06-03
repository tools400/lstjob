**free
/if NOT defined(qJob_t)
/define qJob_t
// ============================================================= *
//   Qualified job name                                          *
//===============================================================*

dcl-ds qJob_t qualified based(pDummy);
  name char(10);
  user char(10);
  nbr  char(6);
end-ds;

/endif
