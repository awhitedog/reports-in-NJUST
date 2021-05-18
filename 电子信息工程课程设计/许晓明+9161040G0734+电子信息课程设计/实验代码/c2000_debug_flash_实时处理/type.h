/*****************************************************************************/
/* TYPE.H	v1.00														     */
/* ��Ȩ(c)	2003-   	�������ڴ���Ӽ����������ι�˾						 */
/* �����:	������															 */
/*****************************************************************************/

#if !defined( TYPE__H )
#define       TYPE__H

typedef enum                                      /* boolean */
{
   FALSE = 0x0000,                                /* false */
   TRUE  = 0x0001                                 /* true */
} BOOL;

typedef void* HANDLE;

typedef unsigned char	BYTE;
typedef unsigned short	WORD;
typedef unsigned long	DWORD;
typedef unsigned int    u16;


#undef  OK
#define OK                             0

#undef  ERROR
#define ERROR                         -1

#endif
