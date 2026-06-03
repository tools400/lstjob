**free
/if NOT defined(QUSLJOB)
/define QUSLJOB

//  List Job (QUSLJOB) API
dcl-pr QUSLJOB extpgm('QUSLJOB');
  i_qUsrSpc   char(20) const;
  i_format    char(8) const;
  i_qJob      char(26) const;
  i_status    char(10) const;
  io_errCode  char(65535) options(*nopass: *varsize); // | optGrp 1
  i_jobType   char(1) options(*nopass) const; // | optGrp 2
  i_numFldRtn int(10) options(*nopass) const; // |
  i_keyFldRtn int(10) options(*nopass: *varsize) const
    // | dim(256);                                                         // |
  i_hContinue char(48) options(*nopass) const; // | optGrp 3
end-pr;

//  Input Parameter Section
dcl-ds QUSLJOB_inpParm_t qualified based(pDummy);
  qJobSpc    likeds(qJob_t);
  status     char(10);
  qUsrSpc    likeds(qObj_t);
  format     char(8);
  jobType    char(1);
  reserved_1 char(3);
  numFldRtn  int(10);
  keyFldRtn  int(10) dim(256);
  hContinue  char(48);
end-ds;

//  Header Section
dcl-ds QUSLJOB_header_t qualified based(pDummy);
  qJobUsed  likeds(qJob_t);
  hContinue char(48);
end-ds;

//  JOBL0100 Format
dcl-ds jobl0100_t qualified based(pDummy);
  job         char(10);
  user        char(10);
  nbr         char(6);
  intJobID    char(16);
  status      char(10);
  type        char(1);
  subType     char(1);
  reserved_01 char(2);
end-ds;

//  JOBL0200 Format
dcl-ds jobl0200_t qualified based(pDummy);
  job         char(10);
  user        char(10);
  nbr         char(6);
  intJobID    char(16);
  status      char(10);
  type        char(1);
  subType     char(1);
  reserved_01 char(2);
  jobInfSts   char(1);
  reserved_2  char(3);
  numFldRtn   int(10);
end-ds;
// field information                  likeds(jobl0201_t)

//  Field Information of Format JOBL0200
dcl-ds jobl0201_t qualified based(pDummy);
  length     int(10);
  key        int(10);
  dataType   char(1);
  reserved_1 char(3);
  dataLength int(10);
  data       char(256);
end-ds;

//  Valid Keys                                                             Data type
dcl-c cJOBL_ACTIVE_JOB_STATUS 0101; // CHAR(4)
dcl-c cJOBL_ALLOW_MULTIPLE_THREADS 0102; // CHAR(1)
dcl-c cJOBL_ACTIVE_JOB_STATUS_FOR_JOBS_ENDING 0103; // CHAR(4)
dcl-c cJOBL_BREAK_MESSAGE_HANDLING 0201; // CHAR(10)
dcl-c cJOBL_CANCEL_KEY 0301; // CHAR(1)
dcl-c cJOBL_CCSID 0302; // BINARY(4)
dcl-c cJOBL_COUNTRY_OR_REGION_ID 0303; // CHAR(2)
dcl-c cJOBL_PROCESSING_UNIT_TIME 0304; // BINARY(4)
dcl-c cJOBL_CURRENT_USER_PROFILE 0305; // CHAR(10)
dcl-c cJOBL_COMPLETION_STATUS 0306; // CHAR(1)
dcl-c cJOBL_CURRENT_SYSTEM_POOL_IDENTIFIER 0307; // BINARY(4)
dcl-c cJOBL_CHARACTER_IDENTIFIER_CONTROL 0311; // CHAR(10)
dcl-c cJOBL_PROCESSING_UNIT_TIME_USED_TOTAL_JOB 0312; // BINARY(8), UIN
dcl-c cJOBL_PROCESSING_UNIT_TIME_USED_TOTAL_DB 0313; // BINARY(8), UIN
dcl-c cJOBL_DATE_TIME_JOB_BECAME_ACTIVE 0401; // CHAR(13)
dcl-c cJOBL_DATE_TIME_JOB_ENTERED_SYSTEM 0402; // CHAR(13)
dcl-c cJOBL_DATE_TIME_JOB_IS_SCHEDULED_TO_RUN 0403; // CHAR(8)
dcl-c cJOBL_DATE_TIME_JOB_WAS_PUT_ON_THIS_JOB_QUEUE 0404; // CHAR(8)
dcl-c cJOBL_DATE_FORMAT 0405; // CHAR(4)
dcl-c cJOBL_DATE_SEPARATOR 0406; // CHAR(1)
dcl-c cJOBL_DBCS_CAPABLE 0407; // CHAR(1)
dcl-c cJOBL_DDM_CONVERSATION_HANDLING 0408; // CHAR(10)
dcl-c cJOBL_DEFAULT_WAIT 0409; // BINARY(4)
dcl-c cJOBL_DEVICE_RECOVERY_ACTION 0410; // CHAR(13)
dcl-c cJOBL_DEVICE_NAME 0411; // CHAR(10)
dcl-c cJOBL_DEFAULT_CCSID 0412; // BINARY(4)
dcl-c cJOBL_DECIMAL_FORMAT 0413; // CHAR(1)
dcl-c cJOBL_DATE_TIME_JOB_ENDED 0418; // CHAR(13)
dcl-c cJOBL_END_SEVERITY 0501; // BINARY(4)
dcl-c cJOBL_END_STATUS 0502; // CHAR(1)
dcl-c cJOBL_EXIT_KEY 0503; // CHAR(1)
dcl-c cJOBL_FUNCTION_NAME 0601; // CHAR(10)
dcl-c cJOBL_FUNCTION_TYPE 0602; // CHAR(1)
dcl-c cJOBL_SIGNED_ON_JOB 0701; // CHAR(1)
dcl-c cJOBL_GROUP_PROFILE_NAME 0702; // CHAR(10)
dcl-c cJOBL_GROUP_PROFILE_NAME_SUPPLEMENTAL 0703; // CHAR(150)
dcl-c cJOBL_INQUIRY_MESSAGE_REPLY 0901; // CHAR(10)
dcl-c cJOBL_JOB_ACCOUNTING_CODE 1001; // CHAR(15)
dcl-c cJOBL_JOB_DATE 1002; // CHAR(7)
dcl-c cJOBL_JOB_DESCRIPTION_NAME 1003; // CHAR(20)
dcl-c cJOBL_JOB_QUEUE_NAME 1004; // CHAR(20)
dcl-c cJOBL_JOB_QUEUE_PRIORITY 1005; // CHAR(2)
dcl-c cJOBL_JOB_SWITCHES 1006; // CHAR(8)
dcl-c cJOBL_JOB_MESSAGE_QUEUE_FULL_ACTION 1007; // CHAR(10)
dcl-c cJOBL_JOB_MESSAGE_QUEUE_MAXIMUM_SIZE 1008; // BINARY(4)
dcl-c cJOBL_JOB_USER_IDENTITY 1012; // CHAR(10)
dcl-c cJOBL_JOB_USER_IDENTITY_SETTING 1013; // CHAR(1)
dcl-c cJOBL_JOB_END_REASON 1014; // BINARY(4)
dcl-c cJOBL_JOB_LOG_PENDING 1015; // CHAR(1)
dcl-c cJOBL_JOB_TYPE_ENHANCED 1016; // BINARY(4)
dcl-c cJOBL_JOB_LOCAL_TIME 1017; // CHAR(8)
dcl-c cJOBL_JOB_LOG_OUTPUT 1018; // CHAR(10)
dcl-c cJOBL_LANGUAGE_ID 1201; // CHAR(3)
dcl-c cJOBL_LOGGING_LEVEL 1202; // CHAR(1)
dcl-c cJOBL_LOGGING_OF_CL_PROGRAMS 1203; // CHAR(10)
dcl-c cJOBL_LOGGING_SEVERITY 1204; // BINARY(4)
dcl-c cJOBL_LOGGING_TEXT 1205; // CHAR(10)
dcl-c cJOBL_MODE_NAME 1301; // CHAR(8)
dcl-c cJOBL_MAXIMUM_PROCESSING_UNIT_TIME 1302; // BINARY(4)
dcl-c cJOBL_MAXIMUM_TEMPORARY_STORAGE_IN_KB 1303; // BINARY(4)
dcl-c cJOBL_MAXIMUM_THREADS 1304; // BINARY(4)
dcl-c cJOBL_MAXIMUM_TEMPORARY_STORAGE_IN_MM 1305; // BINARY(4)
dcl-c cJOBL_MEMORY_POOL_NAME 1306; // CHAR(10)
dcl-c cJOBL_MESSAGE_REPLY 1307; // CHAR(1)
dcl-c cJOBL_NUMBER_OF_AUXILIARY_IO_REQUESTS 1401; // BINARY(4)
dcl-c cJOBL_NUMBER_OF_INTERACTIVE_TRANSACTIONS 1402; // BINARY(4)
dcl-c cJOBL_NUMBER_OF_DATABASE_LOCK_WAITS 1403; // BINARY(4)
dcl-c cJOBL_NUMBER_OF_INTERNAL_MACHINE_LOCK_WAITS 1404; // BINARY(4)
dcl-c cJOBL_NUMBER_OF_NONDATABASE_LOCK_WAITS 1405; // BINARY(4)
dcl-c cJOBL_NUMBER_OF_AUXILIARY_IO_REQUESTS_UINT 1406; // BINARY(8), UIN
dcl-c cJOBL_OUTPUT_QUEUE_NAME 1501; // CHAR(20)
dcl-c cJOBL_OUTPUT_QUEUE_PRIORITY 1502; // CHAR(2)
dcl-c cJOBL_PRINT_KEY_FORMAT 1601; // CHAR(10)
dcl-c cJOBL_PRINT_TEXT 1602; // CHAR(30)
dcl-c cJOBL_PRINTER_DEVICE_NAME 1603; // CHAR(10)
dcl-c cJOBL_PURGE 1604; // CHAR(10)
dcl-c cJOBL_PRODUCT_RETURN_CODE 1605; // BINARY(4)
dcl-c cJOBL_PROGRAM_RETURN_CODE 1606; // BINARY(4)
dcl-c cJOBL_PENDING_SIGNAL_SET 1607; // CHAR(8)
dcl-c cJOBL_PROCESS_ID_NUMBER 1608; // BINARY(4)
dcl-c cJOBL_RESPONSE_TIME_TOTAL 1801; // BINARY(4)
dcl-c cJOBL_RUN_PRIORITY 1802; // BINARY(4)
dcl-c cJOBL_ROUTING_DATA 1803; // CHAR(80)
dcl-c cJOBL_SORT_SEQUENCE_TABLE 1901; // CHAR(20)
dcl-c cJOBL_STATUS_MESSAGE_HANDLING 1902; // CHAR(10)
dcl-c cJOBL_STATUS_OF_JOB_ON_THE_JOB_QUEUE 1903; // CHAR(10)
dcl-c cJOBL_SUBMITTERS_JOB_NAME 1904; // CHAR(26)
dcl-c cJOBL_SUBMITTERS_MESSAGE_QUEUE_NAME 1905; // CHAR(20)
dcl-c cJOBL_SUBSYSTEM_DESCRIPTION_NAME 1906; // CHAR(20)
dcl-c cJOBL_SYSTEM_POOL_IDENTIFIER 1907; // BINARY(4)
dcl-c cJOBL_SPECIAL_ENVIRONMENT 1908; // CHAR(10)
dcl-c cJOBL_SIGNAL_BLOCKING_MASK 1909; // CHAR(8)
dcl-c cJOBL_SIGNAL_STATUS 1910; // BINARY(4)
dcl-c cJOBL_SERVER_TYPE 1911; // CHAR(30)
dcl-c cJOBL_SPOOLED_FILE_ACTION 1982; // CHAR(10)
dcl-c cJOBL_TIME_SEPARATOR 2001; // CHAR(1)
dcl-c cJOBL_TIME_SLICE 2002; // BINARY(4)
dcl-c cJOBL_TIME_SLICE_END_POOL 2003; // CHAR(10)
dcl-c cJOBL_TEMPORARY_STORAGE_USED_IN_KILOBYTES 2004; // BINARY(4)
dcl-c cJOBL_TIME_SPENT_ON_DATABASE_LOCK_WAITS 2005; // BINARY(4)
dcl-c cJOBL_TIME_SPENT_ON_INTERNAL_MACHINE_LOCK_WAITS 2006; // BINARY(4)
dcl-c cJOBL_TIME_SPENT_ON_NONDATABASE_LOCK_WAITS 2007; // BINARY(4)
dcl-c cJOBL_THREAD_COUNT 2008; // BINARY(4)
dcl-c cJOBL_TEMPORARY_STORAGE_USED_IN_MEGABYTES 2009; // BINARY(4)
dcl-c cJOBL_TIME_ZONE_CURRENT_ABBREVIATED_NAME 2020; // CHAR(10)
dcl-c cJOBL_TIME_ZONE_CURRENT_FULL_NAME 2021; // CHAR(50)
dcl-c cJOBL_TIME_ZONE_CURRENT_MESSAGE_IDENTIFIER 2022; // CHAR(7)
dcl-c cJOBL_TIME_ZONE_CURRENT_OFFSET 2023; // BINARY(4)
dcl-c cJOBL_TIME_ZONE_DESCRIPTION_NAME 2024; // CHAR(10)
dcl-c cJOBL_TIME_MESSAGE_FILE_NAME 2025; // CHAR(20)
dcl-c cJOBL_TIME_DAYLIGHT_SAVING_TIME_INDICATOR 2026; // CHAR(1)
dcl-c cJOBL_UNIT_OF_WORK_ID 2101; // CHAR(24)
dcl-c cJOBL_USER_RETURN_CODE 2102; // BINARY(4)

/endif
