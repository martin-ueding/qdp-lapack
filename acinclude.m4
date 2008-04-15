dnl Kostas Orginos, 15/5/2008
dnl copied from George T. Fleming, 03/03/2003
dnl
dnl Stole this from mpich-1.2.4/mpe
dnl
dnl PAC_QMP_LINK_CC_FUNC(
dnl   QMP_CFLAGS,
dnl   QMP_LDFLAGS,
dnl   QMP_LIBS,
dnl   QMP_VARS,
dnl   QMP_FUNC,
dnl   [action if working],
dnl   [action if not working]
dnl )
dnl
dnl  QMP_CFLAGS   is the include option (-I) for QMP includes
dnl  QMP_LDFLAGS  is the link path (-L) option for QMP libraries
dnl  QMP_LIBS     is the library (-l) option for QMP libaries
dnl  QMP_VARS     is the the declaration of variables needed to call QMP_FUNC
dnl  QMP_FUNC     is the body of QMP function call to be checked for existence
dnl               e.g.  QMP_VARS="QMP_u32_t foo;"
dnl                     QMP_FUNC="foo = QMP_get_SMP_count();"
dnl               if QMP_FUNC is empty, assume linking with basic MPI program.
dnl               i.e. check if QMP definitions are valid
dnl
AC_DEFUN(
  PAC_QMP_COMPILE_CC_FUNC,
  [
dnl - set local parallel compiler environments
dnl   so input variables can be CFLAGS, LDFLAGS or LIBS
    pac_QMP_CFLAGS="$1"
    pac_QMP_LDFLAGS="$2"
    pac_QMP_LIBS="$3"
    AC_LANG_SAVE
dnl - save the original environment
    pac_saved_CFLAGS="$CFLAGS"
    pac_saved_LDFLAGS="$LDFLAGS"
    pac_saved_LIBS="$LIBS"
dnl - set the parallel compiler environment
    CFLAGS="$CFLAGS $pac_QMP_CFLAGS"
    LDFLAGS="$LDFLAGS $pac_QMP_LDFLAGS"
    LIBS="$LIBS $pac_QMP_LIBS"
    AC_COMPILE_IFELSE(
      [#include "qmp.h"
        int main() {
        int argc ; char **argv ;
        QMP_thread_level_t prv;
        $4;
        QMP_init_msg_passing(&argc, &argv, QMP_THREAD_SINGLE, &prv) ;
        $5;
        QMP_finalize_msg_passing() ;
        }
      ],
      [pac_qmp_working=yes],
      [pac_qmp_working=no]
    )
    CFLAGS="$pac_saved_CFLAGS"
    LDFLAGS="$pac_saved_LDFLAGS"
    LIBS="$pac_saved_LIBS"
    AC_LANG_RESTORE
    if test "X${pac_qmp_working}X" = "XyesX" ; then
       ifelse([$6],,:,[$6])
    else
       ifelse([$7],,:,[$7])
    fi
  ]
)

dnl George T. Fleming, 13 February 2003
dnl
dnl Descended originally from mpich-1.2.4/mpe
dnl
dnl PAC_QDPXX_LINK_CXX_FUNC(
dnl   QDPXX_CXXFLAGS,
dnl   QDPXX_LDFLAGS,
dnl   QDPXX_LIBS,
dnl   QDPXX_VARS,
dnl   QDPXX_FUNC,
dnl   [action if working],
dnl   [action if not working]
dnl )
dnl
dnl  QDPXX_CXXFLAGS for the necessary includes paths (-I)
dnl  QDPXX_LDFLAGS  for the necessary library search paths (-L)
dnl  QDPXX_LIBS     for the libraries (-l<lib> etc)
dnl  QDPXX_VARS     for the declaration of variables needed
dnl                 to call QDPXX_FUNC code fragment
dnl  QDPXX_FUNC     for the body of a QDP++ function call or even general code
dnl                 fragment on which to run a compile/link test.
dnl                 If QDPXX_VARS and QDPXX_FUNC are empty, a basic test
dnl                 of compiling and linking a QDP++ program is run.
dnl
AC_DEFUN(
  PAC_QDPXX_LINK_CXX_FUNC,
  [
dnl - set local parallel compiler environments
dnl - so input variables can be CXXFLAGS, LDFLAGS or LIBS
    pac_QDPXX_CXXFLAGS="$1"
    pac_QDPXX_LDFLAGS="$2"
    pac_QDPXX_LIBS="$3"
    AC_LANG_SAVE
    AC_LANG_CPLUSPLUS
dnl - save the original environment
    pac_saved_CXXFLAGS="$CXXFLAGS"
    pac_saved_LDFLAGS="$LDFLAGS"
    pac_saved_LIBS="$LIBS"
dnl - set the parallel compiler environment
    CXXFLAGS="$CXXFLAGS $pac_QDPXX_CXXFLAGS"
    LDFLAGS="$LDFLAGS $pac_QDPXX_LDFLAGS"
    LIBS="$LIBS $pac_QDPXX_LIBS"
    AC_TRY_LINK(
      [
        #include <qdp.h>
        using namespace QDP;
      ], [
        int argc ; char **argv ;
        // Turn on the machine
        QDP_initialize(&argc, &argv) ;
        // Create the layout
        const int foo[] = {2,2,2,2} ;
        multi1d<int> nrow(Nd) ;
        nrow = foo ; // Use only Nd elements
        Layout::setLattSize(nrow) ;
        Layout::create() ;
        $4 ;
        $5 ;
        QDP_finalize() ;
      ],
      [pac_qdpxx_working=yes],
      [pac_qdpxx_working=no]
    )
    CXXFLAGS="$pac_saved_CXXFLAGS"
    LDFLAGS="$pac_saved_LDFLAGS"
    LIBS="$pac_saved_LIBS"
    AC_LANG_RESTORE
    if test "X${pac_qdpxx_working}X"="XyesX";
    then
       ifelse([$6],,:,[$6])
    else
       ifelse([$7],,:,[$7])
    fi
  ]
)

AC_DEFUN(
  PAC_BAGEL_WFM_LINK_CXX_FUNC,
  [
dnl - set local parallel compiler environments
dnl   so input variables can be CFLAGS, LDFLAGS or LIBS
    pac_BAGEL_WFM_CFLAGS="$1"
    pac_BAGEL_WFM_LDFLAGS="$2"
    pac_BAGEL_WFM_LIBS="$3"
    AC_LANG_SAVE
    AC_LANG_CPLUSPLUS
dnl - save the original environment
    pac_saved_CXXFLAGS="$CXXFLAGS"
    pac_saved_LDFLAGS="$LDFLAGS"
    pac_saved_LIBS="$LIBS"
dnl - set the parallel compiler environment
    CXXFLAGS="$CXXFLAGS $pac_BAGEL_WFM_CFLAGS"
    LDFLAGS="$LDFLAGS $pac_BAGEL_WFM_LDFLAGS"
    LIBS="$LIBS $pac_BAGEL_WFM_LIBS"
    AC_TRY_LINK(
      [
        #include "wfm.h"
      ],
      [
        int argc ; char **argv ;
	$4
	$5
      ],
      [pac_bagel_wfm_working=yes],
      [pac_bagel_wfm_working=no]
    )
    CXXFLAGS="$pac_saved_CXXFLAGS"
    LDFLAGS="$pac_saved_LDFLAGS"
    LIBS="$pac_saved_LIBS"
    AC_LANG_RESTORE
    if test "X${pac_bagel_wfm_working}X" = "XyesX" ; then
       ifelse([$6],,:,[$6])
    else
       ifelse([$7],,:,[$7])
    fi
  ]
)

AC_DEFUN(
  PAC_GMP_LINK_CXX_FUNC,
  [
dnl - set local parallel compiler environments
dnl   so input variables can be CFLAGS, LDFLAGS or LIBS
    pac_GMP_CFLAGS="$1"
    pac_GMP_LDFLAGS="$2"
    pac_GMP_LIBS="$3"
    AC_LANG_SAVE
    AC_LANG_CPLUSPLUS
dnl - save the original environment
    pac_saved_CXXFLAGS="$CXXFLAGS"
    pac_saved_LDFLAGS="$LDFLAGS"
    pac_saved_LIBS="$LIBS"
dnl - set the parallel compiler environment
    CXXFLAGS="$CXXFLAGS $pac_GMP_CFLAGS"
    LDFLAGS="$LDFLAGS $pac_GMP_LDFLAGS"
    LIBS="$LIBS $pac_GMP_LIBS"
    AC_TRY_LINK(
      [
        #include <gmp.h>
      ],
      [
        int argc ; char **argv ;
	$4
	$5
      ],
      [pac_gmp_working=yes],
      [pac_gmp_working=no]
    )
    CXXFLAGS="$pac_saved_CXXFLAGS"
    LDFLAGS="$pac_saved_LDFLAGS"
    LIBS="$pac_saved_LIBS"
    AC_LANG_RESTORE
    if test "X${pac_gmp_working}X" = "XyesX" ; 
    then
       ifelse([$6],,:,[$6])
    else
       ifelse([$7],,:,[$7])
    fi
  ]
)

AC_DEFUN(
  PAC_BAGEL_CLOVER_LINK_CXX_FUNC,
  [
dnl - set local parallel compiler environments
dnl   so input variables can be CFLAGS, LDFLAGS or LIBS
    pac_BAGEL_CLOVER_CFLAGS="$1"
    pac_BAGEL_CLOVER_LDFLAGS="$2"
    pac_BAGEL_CLOVER_LIBS="$3"
    AC_LANG_SAVE
    AC_LANG_CPLUSPLUS
dnl - save the original environment
    pac_saved_CXXFLAGS="$CXXFLAGS"
    pac_saved_LDFLAGS="$LDFLAGS"
    pac_saved_LIBS="$LIBS"
dnl - set the parallel compiler environment
    CXXFLAGS="$CXXFLAGS $pac_BAGEL_CLOVER_CFLAGS"
    LDFLAGS="$LDFLAGS $pac_BAGEL_CLOVER_LDFLAGS"
    LIBS="$LIBS $pac_BAGEL_CLOVER_LIBS"
    AC_TRY_LINK(
      [
        #include <bagel_clover.h>
      ],
      [
        int argc ; char **argv ;
	$4
	$5
      ],
      [pac_bagel_clover_working=yes],
      [pac_bagel_clover_working=no]
    )
    CXXFLAGS="$pac_saved_CXXFLAGS"
    LDFLAGS="$pac_saved_LDFLAGS"
    LIBS="$pac_saved_LIBS"
    AC_LANG_RESTORE
    if test "X${pac_bagel_clover_working}X" = "XyesX" ; then
       ifelse([$6],,:,[$6])
    else
       ifelse([$7],,:,[$7])
    fi
  ]
)

