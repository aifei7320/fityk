dnl $Id$

AC_DEFUN([READLINE_STUFF], 
[
 dnl GNU readline and the required terminal library check
 AC_SUBST(READLINE_LIBS)
 AC_SUBST(NO_READLINE)
 if test "x$with_readline" != "xno" ; then
     dnl check for terminal library (based on octave's configure.in)
     gp_tcap=""
     for termlib in ncurses curses termcap terminfo termlib; do
         AC_CHECK_LIB(${termlib}, tputs, [gp_tcap="${gp_tcap} -l${termlib}"])
         case "${gp_tcap}" in
             *-l${termlib}*)
             AC_MSG_RESULT([using ${gp_tcap} with readline])
             break
             ;;
         esac
     done
 
     AC_CHECK_LIB([readline], [readline], 
	              [READLINE_LIBS="-lreadline $gp_tcap"],
                      [AC_MSG_ERROR([
      Can't find -lreadline in a standard path. 
      Install GNU readline library or, if it is already installed 
      in non-standard location, use CPPFLAGS and LDFLAGS. 
      You can also configure fityk with option --without-readline])], 
 		      [${gp_tcap}]) dnl readline
     AC_CHECK_HEADER([readline/readline.h], [], [AC_MSG_ERROR([
      You don't have headers of the readline library. 
      Perhaps you have installed run-time part of the readline library 
      from RPM or another binary package and have not installed development 
      package, which usually have appendix -dev or -devel.
      Either install it, or configure fityk with option --without-readline])])
     dnl readline < 4.2 doesn't have rl_completion_matches() function
     dnl some libreadline-compatibile libraries (like libedit) also
     dnl don't have it. We don't support them.
     AC_CHECK_DECLS([rl_completion_matches], [], [AC_MSG_ERROR([ 
     Although you seem to have a readline-compatible library, it is either 
     old GNU readline <= 4.1 (XX century), or readline-compatible library, 
     like libedit, but it's not compatible enough with readline >= 4.2.
         Either install libreadline >= 4.2, 
         or configure fityk with option --without-readline])],
     [
      #include <stdio.h> 
      #include <readline/readline.h>
     ]) 
 else
     AC_DEFINE(NO_READLINE, 1,
        [Define if you do not want to use or do not have readline library.])
 fi
]) 
