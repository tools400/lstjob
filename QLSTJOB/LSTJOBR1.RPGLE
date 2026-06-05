**free
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  04.12.2003                                              *
//  E-mail  :  Thomas.Raddatz@Tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//  30.12.2004  Th.Raddatz    Changed LSTJOB to use service program    *
//                            BASICS1.                                 *
//                            Changed type of handle from POINTER      *
//                            to packed decimal.                       *
//                                                                     *
//  17.08.2007  Th.Raddatz    Replaced external data structures        *
//                            by copy books.                           *
//                            Added version number (V2.0) to           *
//                            copyright information.                   *
//                                                                     *
//  18.12.2008  Th.Raddatz    Changed program to /FREE and to work     *
//                            BASICS1 V1.10.                           *
//                                                                     *
//  05.04.2016  Th.Raddatz    Changed '*' to '*omit'.                  *
//                                                                     *
//=====================================================================*
//   >>PRE-COMPILER<<                                                  *
//     >>CRTCMD<<  CRTRPGMOD    MODULE(&LI/&OB) +                      *
//                              SRCFILE(&SL/&SF) SRCMBR(&SM);          *
//     >>IMPORTANT<<                                                   *
//       >>PARM<< TRUNCNBR(*NO);                                       *
//       >>PARM<< DBGVIEW(*LIST);                                      *
//       >>PARM<< TGTRLS(V7R3M0);                                      *
//       >>PARM<< OPTION(*EVENTF);                                     *
//     >>END-IMPORTANT<<                                               *
//     >>EXECUTE<<                                                     *
//   >>END-PRE-COMPILER<<                                              *
//=====================================================================*
ctl-opt nomain;
ctl-opt extbinint(*yes) bnddir('QC2LE');
ctl-opt datfmt(*iso) timfmt(*iso) debug(*yes);
/copy QLSTJOB,COPYRIGHT
//=====================================================================*

//  Exported procedures
/copy QLSTJOB,PLSTJOB ?

//  Imported procedures
/copy QLSTJOB,CLIB ?Prototypes for C-Library
/copy QLSTJOB,CEELIB ?Prototypes for CEE APIs
/copy QLSTJOB,FDQJOB ?Qualified job name
/copy QLSTJOB,GENLSTHDR ?Generic List Header for List APIs
/copy QLSTJOB,QUSLJOB ?List job(QUSLJOB) API
/copy QLSTJOB,QUSRJOBI ?Retrieve Job information(QUSRJOBI) API
/copy QBASICS1,PBASICS1 ?Tools/400 Runtime Library

//  Type definitions
dcl-ds handle_t qualified template;
  pUsrSpc  pointer;
  numE     int(10);
  reserved char(36);
end-ds;

//  Prototypes of internal used procedures
dcl-pr f_getEntry ind opdesc;
  i_handle like(lstJob_handle_t) value;
  o_data   char(32767) options(*varsize);
  i_length int(10) value;
end-pr;

dcl-pr f_jobSort ind;
  i_pUsrSpc pointer value;
  i_orderBy char(10) value;
  o_msg     likeds(msg_t);
end-pr;

dcl-pr f_jobSortByName int(10);
  i_pKey     pointer value;
  i_pElement pointer value;
end-pr;

dcl-pr f_jobSortByName_Desc int(10);
  i_pKey     pointer value;
  i_pElement pointer value;
end-pr;

dcl-pr f_jobSortByStatus int(10);
  i_pKey     pointer value;
  i_pElement pointer value;
end-pr;

//  Global Constants
dcl-c cLSTJOB_HANDLE_TYPE '*LSTJOB';

//==================================================================*
//  Open Job List
// -----------------------------------------------------------------
//  Using format:  JOBL0100
// -----------------------------------------------------------------

//  Return Value:

//  cTrue      - No error.
//  cFalse     - Error occured.

//  Parameter values:

//  i_job      - Job name,   Special values: *, *CURRENT, *ALL.
//  i_user     - User name,  Special values: *CURRENT, *ALL.
//  i_nbr      - Job number, Special values: *ALL
//  i_status   - Job status: *ACTIVE, *JOBQ, *OUTQ, *ALL
//  i_orderBy  - Sort sequence:
//               cLSTJOB_ORDERBY_NONE       no sort sequence
//               cLSTJOB_ORDERBY_NAME       sorted by job name (job/user/nbr)
//               cLSTJOB_ORDERBY_NAME_DESC  sorted by job name (job/user/nbr)
//               cLSTJOB_ORDERBY_STATUS     sorted by status
//  o_handle   - List handle for subsequent calls to f_getFirstJob() and
//               f_getNextJob().
//  o_msg      - Error message.

//==================================================================*
dcl-proc f_opnJobLst export;
  dcl-pi *n ind opdesc;
    i_job     char(10) value;
    i_user    char(10) value;
    i_nbr     char(6) value;
    i_status  char(10) value;
    i_orderBy char(10) value;
    o_handle  like(lstJob_handle_t);
    o_msg     char(32767) options(*nopass: *varsize);
  end-pi;

  //  Return value
  dcl-s o_isDone ind inz(cFalse);

  //  Parameter positions
  dcl-c p_msg 7;

  //  Fields for optional parameters
  dcl-ds msg likeds(msg_t) inz;

  //  Helper fields
  dcl-s isUsrSpc ind inz;
  dcl-s pUsrSpc pointer inz;
  dcl-ds qUsrSpc likeds(qObj_t) inz;
  dcl-ds qJob likeds(qJob_t) inz;
  dcl-ds errCode likeds(errCode_t) inz;
  dcl-ds strInfMsg likeds(strInf_t) inz;

  //  Handle
  dcl-ds handle likeds(handle_t) based(pHandle);
  //-------------------------------------------------------------------

  o_handle = HANDLE_null();

  dou '1';

    //?Produce temporary object name
    qUsrSpc = f_getTmpName();
    if (qUsrSpc.name = '');
      msg = f_newMsg('CPF9898'
                     : 'Temporary object name +
                        could not be produced.'
                     : cMsg_Escape
                     : 'QCPFMSG'
                     : '*LIBL');
      leave;
    endif;

    //?Create user space
    if (not f_crtUsrSpc(qUsrSpc.name
                        : qUsrSpc.lib
                        : 'List Jobs, JOBL0100, ' +
                           i_orderBy
                        : 65536
                        : 'TEMP'
                        : '*USE'
                        : msg));
      leave;
    endif;

    isUsrSpc = cTrue;

    //?List jobs
    qJob.name = i_job;
    qJob.user = i_user;
    qJob.nbr  = i_nbr;
    errCode = f_newApiErrCode(cTrue);
    QUSLJOB(qUsrSpc: 'JOBL0100': qJob: i_status: errCode);

    if (f_isApiError(errCode));
      msg = f_cvtApiErrCodeToMsg(errCode);
      leave;
    endif;

    //?Retrieve user space pointer
    pUsrSpc = f_rtvUsrSpcPtr(qUsrSpc.name: qUsrSpc.lib: msg);
    if (msg.ID <> cMSG_ID_OK);
      leave;
    endif;

    //?Sort job list in user space
    if (not f_jobSort(pUsrSpc: i_orderBy: msg));
      leave;
    endif;

    //?Produce handle
    o_handle = HANDLE_new(cLSTJOB_HANDLE_TYPE: %size(handle));
    pHandle = HANDLE_getPointer(o_handle);
    handle.pUsrSpc  = pUsrSpc;
    handle.numE     = 0;
    handle.reserved = *ALLx'00';

    o_isDone = cTrue;
  enddo;

  if (not o_isDone and isUsrSpc);
    f_dltUsrSpc(qUsrSpc.name: qUsrSpc.lib);
    isUsrSpc = cFalse;
  endif;

  //?Return message to caller
  if (%parms() >= p_msg);
    CEEGSI(p_msg: strInfMsg.dataType
                : strInfMsg.curlen
                : strInfMsg.maxlen: *omit);
    %subst(o_msg: 1: strInfMsg.curlen) = msg;
  endif;

  return o_isDone;


end-proc;

//==================================================================*
//  Close Job List
// -----------------------------------------------------------------

//  Return value:

//  cTrue      - No error.
//  cFalse     - Error occured.

//  Parameter values:

//  io_handle  - List handle returned by f_opnJobLst().

//==================================================================*
dcl-proc f_cloJobLst export;
  dcl-pi *n ind;
    io_handle like(lstJob_handle_t);
  end-pi;

  //  Return value
  dcl-s o_isDone ind inz(cFalse);

  //  Handle
  dcl-ds handle likeds(handle_t) based(pHandle);

  //  Generic List Header for List APIs
  dcl-ds genLstHdr likeds(genLstHdr_t) based(pGenLstHdr);

  //  Input Section of QUSLJOB API
  dcl-ds inpSct likeds(QUSLJOB_inpParm_t) based(pInpSct);
  //-------------------------------------------------------------------

  pHandle = HANDLE_getPointer(io_handle);

  //?Get user space name
  pGenLstHdr = handle.pUsrSpc;
  pInpSct    = handle.pUsrSpc + genLstHdr.ofsInpSct;

  //?Delete user space
  o_isDone = f_dltUsrSpc(inpSct.qUsrSpc.name: inpSct.qUsrSpc.lib);

  //?Delete handle
  HANDLE_delete(io_handle);

  return o_isDone;


end-proc;

//==================================================================*
//  Get First Job
// -----------------------------------------------------------------

//  Return value:

//  cTrue      - No error.
//  cFalse     - Error occured.

//  Parameter values:

//  i_handle   - List handle returned by f_opnJobLst().
//  o_data     - list entry data of type JOBL0100.

//==================================================================*
dcl-proc f_getFirstJob export;
  dcl-pi *n ind opdesc;
    i_handle like(lstJob_handle_t) value;
    o_data   char(32767) options(*varsize);
  end-pi;

  //  Return value
  dcl-s o_isDone ind inz(cFalse);

  //  Parameter positions
  dcl-c p_data 2;

  //  Handle
  dcl-ds handle likeds(handle_t) based(pHandle);

  //  Helper fields
  dcl-ds strInfData likeds(strInf_t) inz;
  //-------------------------------------------------------------------

  pHandle = HANDLE_getPointer(i_handle);

  //?Get length of o_data
  CEEGSI(p_data: strInfData.datatype
               : strInfData.curlen
               : strInfData.maxlen
               : *omit);

  //?Get first entry
  handle.numE = 0;

  //?Retrieve entry data
  o_isDone = f_getEntry(i_handle: o_data: strInfData.curlen);

  return o_isDone;


end-proc;

//==================================================================*
//  Get Next Job
// -----------------------------------------------------------------

//  Return value:

//  cTrue      - No error.
//  cFalse     - Error occured.

//  Parameter values:

//  i_handle   - List handle returned by f_opnJobLst().
//  o_data     - list entry data of type JOBL0100.

//==================================================================*
dcl-proc f_getNextJob export;
  dcl-pi *n ind opdesc;
    i_handle like(lstJob_handle_t) value;
    o_data   char(32767) options(*varsize);
  end-pi;

  //  Return value
  dcl-s o_isDone ind inz(cFalse);

  //  Parameter positions
  dcl-c p_data 2;

  //  Helper fields
  dcl-ds strInfData likeds(strInf_t) inz;
  //-------------------------------------------------------------------

  //?Get length of o_data
  CEEGSI(p_data: strInfData.datatype
               : strInfData.curlen
               : strInfData.maxlen
               : *omit);

  //?Retrieve entry data
  o_isDone = f_getEntry(i_handle: o_data: strInfData.curlen);

  return o_isDone;


end-proc;

//==================================================================*
//  Get Number of Jobs available
// -----------------------------------------------------------------

//  Return value:

//  numEntries - Number of entries in the list.

//  Parameter values:

//  i_handle   - List handle returned by f_opnJobLst().

//==================================================================*
dcl-proc f_getNumJobAvl export;
  dcl-pi *n int(10);
    i_handle like(lstJob_handle_t) value;
  end-pi;

  //  Return value
  dcl-s numJobAvl int(10) inz;

  //  Handle
  dcl-ds handle likeds(handle_t) based(pHandle);

  //  Generic List Header for List APIs
  dcl-ds genLstHdr likeds(genLstHdr_t) based(handle.pUsrSpc);
  //-------------------------------------------------------------------

  pHandle = HANDLE_getPointer(i_handle);

  return genLstHdr.numE;


end-proc;

//==================================================================*
//  Retrieve Job Attributes
// -----------------------------------------------------------------

//  Return value:

//  rtnValue   - The job attributes retrieved from the job.

//  Parameter values:

//  i_intJobID - Internal job ID returned by f_getFirstJob() or
//               f_getNextJob().
//  i_format   - The format of the job list to be returned.
//  o_msg      - Error message.

//==================================================================*
dcl-proc f_rtvJobA export;
  dcl-pi *n varchar(8191) opdesc;
    i_intJobID char(16) const;
    i_format   char(8) const;
    o_msg      char(32767) options(*nopass: *varsize);
  end-pi;

  //  Return value
  dcl-s rtnValue char(8192) inz;

  //  Parameter positions
  dcl-c p_msg 3;

  //  Fields for optional parameters
  dcl-ds msg likeds(msg_t) inz;

  //  Local fields
  dcl-ds errCode likeds(errCode_t) inz;

  //  Helper fields
  dcl-ds strInfMsg likeds(strInf_t) inz;
  //-------------------------------------------------------------------

  //?If o_msg was passed, ...
  if (%parms() >= p_msg);
    //?... then initialize API error code to return error information
    errCode = f_newApiErrCode(cTrue);
  else;
    //?... else initialize API error code to send an ESCAPE message
    errCode = f_newApiErrCode(cFalse);
  endif;

  //?Retrieve job attributes
  Clear rtnValue;
  QUSRJOBI(rtnvalue: %size(rtnValue): i_format
           : '*INT': i_intJobID: errCode);

  //?Convert API error code information to message
  msg = f_cvtApiErrCodeToMsg(errCode);

  //?If o_msg was passed, ...
  if (%parms() >= p_msg);
    //?... then pass back error information
    CEEGSI(p_msg: strInfMsg.datatype
                : strInfMsg.curlen
                : strInfMsg.maxlen
                : *omit);
    %subst(o_msg: 1: strInfMsg.curlen) = msg;
  endif;

  return %trimR(rtnValue);


end-proc;

//==================================================================*
//  Get Entry
//==================================================================*
dcl-proc f_getEntry;
  dcl-pi *n ind opdesc;
    i_handle like(lstJob_handle_t) value;
    o_data   char(32767) options(*varsize);
    i_length int(10) value;
  end-pi;

  //  Return value
  dcl-s o_isDone ind inz(cFalse);

  //  Handle
  dcl-ds handle likeds(handle_t) based(pHandle);

  //  Local fields
  dcl-s pDest pointer inz;
  dcl-s pSrc pointer inz;
  dcl-s count int(10) inz;

  //  Generic List Header for List APIs
  dcl-ds genLstHdr likeds(genLstHdr_t) based(handle.pUsrSpc);
  //-------------------------------------------------------------------

  pHandle = HANDLE_getPointer(i_handle);

  //?Return to caller if there are no entries left
  if (handle.numE >= genLstHdr.numE);
    o_isDone = cFalse;
    return o_isDone;
  endif;

  //?Copy entry to o_data
  pDest = %addr(o_data);
  pSrc  = handle.pUsrSpc + genLstHdr.ofsLstSct   +
                           (handle.numE * genLstHdr.sizeE);

  if (i_length < genLstHdr.sizeE);
    count = i_length;
  else;
    count = genLstHdr.sizeE;
  endif;

  memCpy(pDest: pSrc: count);

  //?Increase number of entries returned
  handle.numE = handle.numE + 1;

  //?Return return value
  o_isDone = cTrue;

  return o_isDone;


end-proc;

//==================================================================*
//  Sort User Space
//==================================================================*
dcl-proc f_jobSort;
  dcl-pi *n ind;
    i_pUsrSpc pointer value;
    i_orderBy char(10) value;
    o_msg     likeds(msg_t);
  end-pi;

  //  Return value
  dcl-s o_isDone ind inz(cFalse);

  //  Helper fields
  dcl-s pCompFunc pointer(*proc) inz;

  //  Generic List Header for List APIs
  dcl-ds genLstHdr likeds(genLstHdr_t) based(i_pUsrSpc);
  //-------------------------------------------------------------------

  //?Get address of sort procedure ...
  select;

  //?... do not sort
  when (i_orderBy = cLSTJOB_ORDERBY_NONE);
    pCompFunc = *NULL;
    o_isDone = cTrue;
    o_msg    = f_newMsg(cMSG_ID_OK);

  //?... sort by name
  when (i_orderBy = cLSTJOB_ORDERBY_NAME);
    pCompFunc = %paddr('F_JOBSORTBYNAME');
    o_isDone = cTrue;
    o_msg    = f_newMsg(cMSG_ID_OK);

  //?... sort by name (descending)
  when (i_orderBy = cLSTJOB_ORDERBY_NAME_DESC);
    pCompFunc = %paddr('F_JOBSORTBYNAME_DESC');
    o_isDone = cTrue;
    o_msg    = f_newMsg(cMSG_ID_OK);

  //?... sort by status
  when (i_orderBy = cLSTJOB_ORDERBY_STATUS);
    pCompFunc = %paddr('F_JOBSORTBYSTATUS');
    o_isDone = cTrue;
    o_msg    = f_newMsg(cMSG_ID_OK);

  //?... ... unsupported sort value
  other;
    pCompFunc = *NULL;
    o_isDone  = cFalse;
    o_msg    = f_newMsg('CPF9898'
                 : 'Value ' + %trim(i_orderBy) +
                    ' for parameter ''orderBy'' +
                    not supported'
                 : cMsg_Escape
                 : 'QCPFMSG'
                 : '*LIBL');
  endsl;

  //?Sort user space
  if (pCompFunc <> *NULL);
    qsort(i_pUsrSpc + genLstHdr.ofsLstSct     //?basing pointer
          : genLstHdr.numE                    //?number of entries
          : genLstHdr.sizeE                   //?length of entry
          : pCompFunc);                       //?compare procedure
  endif;

  return o_isDone;


end-proc;

//==================================================================*
//  Job List: Sort By Name
//==================================================================*
dcl-proc f_jobSortByName;
  dcl-pi *n int(10);
    i_pKey     pointer value;
    i_pElement pointer value;
  end-pi;

  //  Define key
  dcl-ds key based(i_pKey) likeds(jobl0100_t);

  dcl-ds keyValue qualified;
    job  like(key.job);
    user like(key.user);
    nbr  like(key.nbr);
  end-ds;

  //  Define element
  dcl-ds element based(i_pElement) likeds(jobl0100_t);

  dcl-ds elementValue qualified;
    job  like(element.job);
    user like(element.user);
    nbr  like(element.nbr);
  end-ds;

  //  Return value
  dcl-s o_result int(10) inz;
  //-------------------------------------------------------------------

  keyValue.job  = key.job;
  keyValue.user = key.user;
  keyValue.nbr  = key.nbr;

  elementValue.job  = element.job;
  elementValue.user = element.user;
  elementValue.nbr  = element.nbr;

  select;
  when (keyValue < elementValue);
    o_result = -1;
  when (keyValue > elementValue);
    o_result =  1;
  other;
    o_result =  0;
  endsl;

  return o_result;


end-proc;

//==================================================================*
//  Job List: Sort By Name (descending)
//==================================================================*
dcl-proc f_jobSortByName_Desc;
  dcl-pi *n int(10);
    i_pKey     pointer value;
    i_pElement pointer value;
  end-pi;

  //  Define key
  dcl-ds key based(i_pKey) likeds(jobl0100_t);

  dcl-ds keyValue qualified;
    job  like(key.job);
    user like(key.user);
    nbr  like(key.nbr);
  end-ds;

  //  Define element
  dcl-ds element based(i_pElement) likeds(jobl0100_t);

  dcl-ds elementValue qualified;
    job  like(element.job);
    user like(element.user);
    nbr  like(element.nbr);
  end-ds;

  //  Return value
  dcl-s o_result int(10) inz;
  //-------------------------------------------------------------------

  keyValue.job  = key.job;
  keyValue.user = key.user;
  keyValue.nbr  = key.nbr;

  elementValue.job  = element.job;
  elementValue.user = element.user;
  elementValue.nbr  = element.nbr;

  select;
  when (keyValue > elementValue);
    o_result = -1;
  when (keyValue < elementValue);
    o_result =  1;
  other;
    o_result =  0;
  endsl;

  return o_result;


end-proc;

//==================================================================*
//  Job List: Sort By Status
//==================================================================*
dcl-proc f_jobSortByStatus;
  dcl-pi *n int(10);
    i_pKey     pointer value;
    i_pElement pointer value;
  end-pi;

  //  Define key
  dcl-ds key based(i_pKey) likeds(jobl0100_t);

  dcl-ds keyValue qualified;
    status like(key.status);
    job    like(key.job);
    user   like(key.user);
    nbr    like(key.nbr);
  end-ds;

  //  Define element
  dcl-ds element based(i_pElement) likeds(jobl0100_t);

  dcl-ds elementValue qualified;
    status like(element.status);
    job    like(element.job);
    user   like(element.user);
    nbr    like(element.nbr);
  end-ds;

  //  Return value
  dcl-s o_result int(10) inz;
  //-------------------------------------------------------------------

  keyValue.status = key.status;
  keyValue.job    = key.job;
  keyValue.user   = key.user;
  keyValue.nbr    = key.nbr;

  elementValue.status = element.status;
  elementValue.job    = element.job;
  elementValue.user   = element.user;
  elementValue.nbr    = element.nbr;

  select;
  when (keyValue < elementValue);
    o_result = -1;
  when (keyValue > elementValue);
    o_result =  1;
  other;
    o_result =  0;
  endsl;

  return o_result;


end-proc;

