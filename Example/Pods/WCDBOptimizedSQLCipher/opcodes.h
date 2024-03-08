/* Automatically generated.  Do not edit */
/* See the tool/mkopcodeh.tcl script for details */
#define OP_Savepoint       0
#define OP_AutoCommit      1
#define OP_Transaction     2
#define OP_SorterNext      3 /* jump                                       */
#define OP_Prev            4 /* jump                                       */
#define OP_Next            5 /* jump                                       */
#define OP_Checkpoint      6
#define OP_JournalMode     7
#define OP_Vacuum          8
#define OP_VFilter         9 /* jump, synopsis: iplan=r[P3] zplan='P4'     */
#define OP_VUpdate        10 /* synopsis: data=r[P3@P2]                    */
#define OP_Goto           11 /* jump                                       */
#define OP_Gosub          12 /* jump                                       */
#define OP_InitCoroutine  13 /* jump                                       */
#define OP_Yield          14 /* jump                                       */
#define OP_MustBeInt      15 /* jump                                       */
#define OP_Jump           16 /* jump                                       */
#define OP_Once           17 /* jump                                       */
#define OP_If             18 /* jump                                       */
#define OP_Not            19 /* same as TK_NOT, synopsis: r[P2]= !r[P1]    */
#define OP_IfNot          20 /* jump                                       */
#define OP_IfNullRow      21 /* jump, synopsis: if P1.nullRow then r[P3]=NULL, goto P2 */
#define OP_SeekLT         22 /* jump, synopsis: key=r[P3@P4]               */
#define OP_SeekLE         23 /* jump, synopsis: key=r[P3@P4]               */
#define OP_SeekGE         24 /* jump, synopsis: key=r[P3@P4]               */
#define OP_SeekGT         25 /* jump, synopsis: key=r[P3@P4]               */
#define OP_IfNoHope       26 /* jump, synopsis: key=r[P3@P4]               */
#define OP_NoConflict     27 /* jump, synopsis: key=r[P3@P4]               */
#define OP_NotFound       28 /* jump, synopsis: key=r[P3@P4]               */
#define OP_Found          29 /* jump, synopsis: key=r[P3@P4]               */
#define OP_SeekRowid      30 /* jump, synopsis: intkey=r[P3]               */
#define OP_NotExists      31 /* jump, synopsis: intkey=r[P3]               */
#define OP_Last           32 /* jump                                       */
#define OP_IfSmaller      33 /* jump                                       */
#define OP_SorterSort     34 /* jump                                       */
#define OP_Sort           35 /* jump                                       */
#define OP_Rewind         36 /* jump                                       */
#define OP_IdxLE          37 /* jump, synopsis: key=r[P3@P4]               */
#define OP_IdxGT          38 /* jump, synopsis: key=r[P3@P4]               */
#define OP_IdxLT          39 /* jump, synopsis: key=r[P3@P4]               */
#define OP_IdxGE          40 /* jump, synopsis: key=r[P3@P4]               */
#define OP_RowSetRead     41 /* jump, synopsis: r[P3]=rowset(P1)           */
#define OP_RowSetTest     42 /* jump, synopsis: if r[P3] in rowset(P1) goto P2 */
#define OP_Or             43 /* same as TK_OR, synopsis: r[P3]=(r[P1] || r[P2]) */
#define OP_And            44 /* same as TK_AND, synopsis: r[P3]=(r[P1] && r[P2]) */
#define OP_Program        45 /* jump                                       */
#define OP_FkIfZero       46 /* jump, synopsis: if fkctr[P1]==0 goto P2    */
#define OP_IfPos          47 /* jump, synopsis: if r[P1]>0 then r[P1]-=P3, goto P2 */
#define OP_IfNotZero      48 /* jump, synopsis: if r[P1]!=0 then r[P1]--, goto P2 */
#define OP_DecrJumpZero   49 /* jump, synopsis: if (--r[P1])==0 goto P2    */
#define OP_IsNull         50 /* jump, same as TK_ISNULL, synopsis: if r[P1]==NULL goto P2 */
#define OP_NotNull        51 /* jump, same as TK_NOTNULL, synopsis: if r[P1]!=NULL goto P2 */
#define OP_Ne             52 /* jump, same as TK_NE, synopsis: IF r[P3]!=r[P1] */
#define OP_Eq             53 /* jump, same as TK_EQ, synopsis: IF r[P3]==r[P1] */
#define OP_Gt             54 /* jump, same as TK_GT, synopsis: IF r[P3]>r[P1] */
#define OP_Le             55 /* jump, same as TK_LE, synopsis: IF r[P3]<=r[P1] */
#define OP_Lt             56 /* jump, same as TK_LT, synopsis: IF r[P3]<r[P1] */
#define OP_Ge             57 /* jump, same as TK_GE, synopsis: IF r[P3]>=r[P1] */
#define OP_ElseNotEq      58 /* jump, same as TK_ESCAPE                    */
#define OP_IncrVacuum     59 /* jump                                       */
#define OP_VNext          60 /* jump                                       */
#define OP_Init           61 /* jump, synopsis: Start at P2                */
#define OP_PureFunc0      62
#define OP_Function0      63 /* synopsis: r[P3]=func(r[P2@P5])             */
#define OP_PureFunc       64
#define OP_Function       65 /* synopsis: r[P3]=func(r[P2@P5])             */
#define OP_Return         66
#define OP_EndCoroutine   67
#define OP_HaltIfNull     68 /* synopsis: if r[P3]=null halt               */
#define OP_Halt           69
#define OP_Integer        70 /* synopsis: r[P2]=P1                         */
#define OP_Int64          71 /* synopsis: r[P2]=P4                         */
#define OP_String         72 /* synopsis: r[P2]='P4' (len=P1)              */
#define OP_Null           73 /* synopsis: r[P2..P3]=NULL                   */
#define OP_SoftNull       74 /* synopsis: r[P1]=NULL                       */
#define OP_Blob           75 /* synopsis: r[P2]=P4 (len=P1)                */
#define OP_Variable       76 /* synopsis: r[P2]=parameter(P1,P4)           */
#define OP_Move           77 /* synopsis: r[P2@P3]=r[P1@P3]                */
#define OP_Copy           78 /* synopsis: r[P2@P3+1]=r[P1@P3+1]            */
#define OP_SCopy          79 /* synopsis: r[P2]=r[P1]                      */
#define OP_IntCopy        80 /* synopsis: r[P2]=r[P1]                      */
#define OP_ResultRow      81 /* synopsis: output=r[P1@P2]                  */
#define OP_CollSeq        82
#define OP_AddImm         83 /* synopsis: r[P1]=r[P1]+P2                   */
#define OP_RealAffinity   84
#define OP_Cast           85 /* synopsis: affinity(r[P1])                  */
#define OP_Permutation    86
#define OP_Compare        87 /* synopsis: r[P1@P3] <-> r[P2@P3]            */
#define OP_IsTrue         88 /* synopsis: r[P2] = coalesce(r[P1]==TRUE,P3) ^ P4 */
#define OP_Offset         89 /* synopsis: r[P3] = sqlite_offset(P1)        */
#define OP_Column         90 /* synopsis: r[P3]=PX                         */
#define OP_Affinity       91 /* synopsis: affinity(r[P1@P2])               */
#define OP_BitAnd         92 /* same as TK_BITAND, synopsis: r[P3]=r[P1]&r[P2] */
#define OP_BitOr          93 /* same as TK_BITOR, synopsis: r[P3]=r[P1]|r[P2] */
#define OP_ShiftLeft      94 /* same as TK_LSHIFT, synopsis: r[P3]=r[P2]<<r[P1] */
#define OP_ShiftRight     95 /* same as TK_RSHIFT, synopsis: r[P3]=r[P2]>>r[P1] */
#define OP_Add            96 /* same as TK_PLUS, synopsis: r[P3]=r[P1]+r[P2] */
#define OP_Subtract       97 /* same as TK_MINUS, synopsis: r[P3]=r[P2]-r[P1] */
#define OP_Multiply       98 /* same as TK_STAR, synopsis: r[P3]=r[P1]*r[P2] */
#define OP_Divide         99 /* same as TK_SLASH, synopsis: r[P3]=r[P2]/r[P1] */
#define OP_Remainder     100 /* same as TK_REM, synopsis: r[P3]=r[P2]%r[P1] */
#define OP_Concat        101 /* same as TK_CONCAT, synopsis: r[P3]=r[P2]+r[P1] */
#define OP_MakeRecord    102 /* synopsis: r[P3]=mkrec(r[P1@P2])            */
#define OP_BitNot        103 /* same as TK_BITNOT, synopsis: r[P2]= ~r[P1] */
#define OP_Count         104 /* synopsis: r[P2]=count()                    */
#define OP_ReadCookie    105
#define OP_String8       106 /* same as TK_STRING, synopsis: r[P2]='P4'    */
#define OP_SetCookie     107
#define OP_ReopenIdx     108 /* synopsis: root=P2 iDb=P3                   */
#define OP_OpenRead      109 /* synopsis: root=P2 iDb=P3                   */
#define OP_OpenWrite     110 /* synopsis: root=P2 iDb=P3                   */
#define OP_OpenDup       111
#define OP_OpenAutoindex 112 /* synopsis: nColumn=P2                       */
#define OP_OpenEphemeral 113 /* synopsis: nColumn=P2                       */
#define OP_SorterOpen    114
#define OP_SequenceTest  115 /* synopsis: if( cursor[P1].ctr++ ) pc = P2   */
#define OP_OpenPseudo    116 /* synopsis: P3 columns in r[P2]              */
#define OP_Close         117
#define OP_ColumnsUsed   118
#define OP_SeekHit       119 /* synopsis: seekHit=P2                       */
#define OP_Sequence      120 /* synopsis: r[P2]=cursor[P1].ctr++           */
#define OP_NewRowid      121 /* synopsis: r[P2]=rowid                      */
#define OP_Insert        122 /* synopsis: intkey=r[P3] data=r[P2]          */
#define OP_Delete        123
#define OP_ResetCount    124
#define OP_SorterCompare 125 /* synopsis: if key(P1)!=trim(r[P3],P4) goto P2 */
#define OP_SorterData    126 /* synopsis: r[P2]=data                       */
#define OP_RowData       127 /* synopsis: r[P2]=data                       */
#define OP_Rowid         128 /* synopsis: r[P2]=rowid                      */
#define OP_NullRow       129
#define OP_SeekEnd       130
#define OP_SorterInsert  131 /* synopsis: key=r[P2]                        */
#define OP_IdxInsert     132 /* synopsis: key=r[P2]                        */
#define OP_IdxDelete     133 /* synopsis: key=r[P2@P3]                     */
#define OP_DeferredSeek  134 /* synopsis: Move P3 to P1.rowid if needed    */
#define OP_IdxRowid      135 /* synopsis: r[P2]=rowid                      */
#define OP_Destroy       136
#define OP_Clear         137
#define OP_ResetSorter   138
#define OP_CreateBtree   139 /* synopsis: r[P2]=root iDb=P1 flags=P3       */
#define OP_SqlExec       140
#define OP_Real          141 /* same as TK_FLOAT, synopsis: r[P2]=P4       */
#define OP_ParseSchema   142
#define OP_LoadAnalysis  143
#define OP_DropTable     144
#define OP_DropIndex     145
#define OP_DropTrigger   146
#define OP_IntegrityCk   147
#define OP_RowSetAdd     148 /* synopsis: rowset(P1)=r[P2]                 */
#define OP_Param         149
#define OP_FkCounter     150 /* synopsis: fkctr[P1]+=P2                    */
#define OP_MemMax        151 /* synopsis: r[P1]=max(r[P1],r[P2])           */
#define OP_OffsetLimit   152 /* synopsis: if r[P1]>0 then r[P2]=r[P1]+max(0,r[P3]) else r[P2]=(-1) */
#define OP_AggInverse    153 /* synopsis: accum=r[P3] inverse(r[P2@P5])    */
#define OP_AggStep       154 /* synopsis: accum=r[P3] step(r[P2@P5])       */
#define OP_AggStep1      155 /* synopsis: accum=r[P3] step(r[P2@P5])       */
#define OP_AggValue      156 /* synopsis: r[P3]=value N=P2                 */
#define OP_AggFinal      157 /* synopsis: accum=r[P1] N=P2                 */
#define OP_Expire        158
#define OP_TableLock     159 /* synopsis: iDb=P1 root=P2 write=P3          */
#define OP_VBegin        160
#define OP_VCreate       161
#define OP_VDestroy      162
#define OP_VOpen         163
#define OP_VColumn       164 /* synopsis: r[P3]=vcolumn(P2)                */
#define OP_VRename       165
#define OP_Pagecount     166
#define OP_MaxPgcnt      167
#define OP_Trace         168
#define OP_CursorHint    169
#define OP_Noop          170
#define OP_Explain       171
#define OP_Abortable     172

/* Properties such as "out2" or "jump" that are specified in
** comments following the "case" for each opcode in the vdbe.c
** are encoded into bitvectors as follows:
*/
#define OPFLG_JUMP        0x01  /* jump:  P2 holds jmp target */
#define OPFLG_IN1         0x02  /* in1:   P1 is an input */
#define OPFLG_IN2         0x04  /* in2:   P2 is an input */
#define OPFLG_IN3         0x08  /* in3:   P3 is an input */
#define OPFLG_OUT2        0x10  /* out2:  P2 is an output */
#define OPFLG_OUT3        0x20  /* out3:  P3 is an output */
#define OPFLG_INITIALIZER {\
/*   0 */ 0x00, 0x00, 0x00, 0x01, 0x01, 0x01, 0x00, 0x10,\
/*   8 */ 0x00, 0x01, 0x00, 0x01, 0x01, 0x01, 0x03, 0x03,\
/*  16 */ 0x01, 0x01, 0x03, 0x12, 0x03, 0x01, 0x09, 0x09,\
/*  24 */ 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09, 0x09,\
/*  32 */ 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,\
/*  40 */ 0x01, 0x23, 0x0b, 0x26, 0x26, 0x01, 0x01, 0x03,\
/*  48 */ 0x03, 0x03, 0x03, 0x03, 0x0b, 0x0b, 0x0b, 0x0b,\
/*  56 */ 0x0b, 0x0b, 0x01, 0x01, 0x01, 0x01, 0x00, 0x00,\
/*  64 */ 0x00, 0x00, 0x02, 0x02, 0x08, 0x00, 0x10, 0x10,\
/*  72 */ 0x10, 0x10, 0x00, 0x10, 0x10, 0x00, 0x00, 0x10,\
/*  80 */ 0x10, 0x00, 0x00, 0x02, 0x02, 0x02, 0x00, 0x00,\
/*  88 */ 0x12, 0x20, 0x00, 0x00, 0x26, 0x26, 0x26, 0x26,\
/*  96 */ 0x26, 0x26, 0x26, 0x26, 0x26, 0x26, 0x00, 0x12,\
/* 104 */ 0x10, 0x10, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00,\
/* 112 */ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,\
/* 120 */ 0x10, 0x10, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,\
/* 128 */ 0x10, 0x00, 0x00, 0x04, 0x04, 0x00, 0x00, 0x10,\
/* 136 */ 0x10, 0x00, 0x00, 0x10, 0x00, 0x10, 0x00, 0x00,\
/* 144 */ 0x00, 0x00, 0x00, 0x00, 0x06, 0x10, 0x00, 0x04,\
/* 152 */ 0x1a, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,\
/* 160 */ 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x10, 0x10,\
/* 168 */ 0x00, 0x00, 0x00, 0x00, 0x00,}

/* The sqlite3P2Values() routine is able to run faster if it knows
** the value of the largest JUMP opcode.  The smaller the maximum
** JUMP opcode the better, so the mkopcodeh.tcl script that
** generated this include file strives to group all JUMP opcodes
** together near the beginning of the list.
*/
#define SQLITE_MX_JUMP_OPCODE  61  /* Maximum JUMP opcode */
