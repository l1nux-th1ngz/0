#!/bin/sh

# we need gettext (is loaded in ssft.sh or cloned...)
if [ -f /usr/bin/gettext.sh ]; then
	. /usr/bin/gettext.sh || exit 1
else
	exit 1
fi

#---------------------------------------------------------------------
# we need root rights
#---------------------------------------------------------------------
if [ "$(id -u)" -ne 0 ]; then
	if [ -x "$(which pkexec)" ]; then
		exec pkexec ${0} $@
	fi

	printf "ERROR: $0 needs root capabilities, please start it as root.\n\n" >&2
	exit 1
else
	if  test  -n "$DISPLAY"  && ! xset q > /dev/null  2>&1 ; then unset DISPLAY; fi
fi

TEXTDOMAIN="kernel-remover"
export TEXTDOMAIN
TEXTDOMAINDIR=/usr/share/locale
export TEXTDOMAINDIR

#---------------------------------------------------------------------
usage()
{
	echo  "$(basename $0)"
	echo  "     -G parameter    use parameter as the graphical frontend"
	echo  "                     one of text | dialog | fzf | yad "
	echo  "     -f              proceed without asking, do complete cleanup"
	echo  "     -h              show this usage"
	exit 1
}
#---------------------------------------------------------------------

force=0
xtra=0
unset frontend
while getopts fhxG: name; do
	case $name in
	f)
		force=1
		;;
	G)
		frontend="$OPTARG"
		;;
	h)	usage
		;;
	x)
		xtra=1
		;;
	*)
		usage
		;;
	esac
done
shift $(($OPTIND - 1))

#---------------------------------------------------------------------
prepare()
{
	if [ "$force" -eq 0 ]; then
		# we need ssft 
		if [ -f /usr/bin/ssft.sh ]; then
			. /usr/bin/ssft.sh || exit 1
		else
			 echo "Please install the package \"ssft\"."
			 exit 1
		fi
	fi

	if [ -n "${frontend}" ]; then
		case $frontend in
			text)
				SSFT_FRONTEND="${frontend}"
				;;
			dialog)
				SSFT_FRONTEND="${frontend}"
				;;
			fzf)
				SSFT_FRONTEND="${frontend}"
				;;
			yad)
				SSFT_FRONTEND="${frontend}"
				;;
			*)
				echo unknown frontend
				exit 1
				;;
		esac
	fi

	if [ -z "$DISPLAY" ] &&  ! /usr/bin/xdpyinfo >/dev/null 2>&1 ; then
		unset DISPLAY
	fi

	if [ -z "$DISPLAY" ]; then
		[ -x /usr/bin/dialog ] && SSFT_FRONTEND=${SSFT_FRONTEND:-"dialog"} || \
			SSFT_FRONTEND=${SSFT_FRONTEND:-"text"}
	else
		if [ -n "$DISPLAY" ] && [ ! -x /usr/bin/yad ]; then
			if [ -x /usr/bin/dialog ]; then
				SSFT_FRONTEND="dialog"
			else
				SSFT_FRONTEND="text"
			fi
			DISPLAY=""
		else
			SSFT_FRONTEND=${SSFT_FRONTEND:-"yad"}
		fi
	fi

	# the current one will not be shown in the list ....
	CURRENTKERNEL=$(uname -r)
	TITLE="$(gettext "Removing installed kernels")"
	PAD="======="

	if [ "${SSFT_FRONTEND}" = "dialog" ] || [ -z "${SSFT_FRONTEND}" ]; then
		CURRENT="$(eval_gettext "The current (active) kernel is ${PAD}$(uname -r)${PAD}")"
	else
		CURRENT="$(eval_gettext "The current (active) kernel is $(uname -r)")"
	fi
}

#---------------------------------------------------------------------
# some useful functions
#---------------------------------------------------------------------
inputbox()
{
	# inputbox Title Text dummy default
	Title="$1"
	Text="$2"

	# $3 not used
	# The default value if used
	SSFT_DEFAULT=$4

	ssft_read_string "${Title}" "${Text}";
}

#---------------------------------------------------------------------
msgbox()
{
	# msgbox title text
	Title="$1"
	Text="$2"
	ssft_display_message "${Title}" "${Text}"
}

#---------------------------------------------------------------------
select_more()
{
	# select one of a list
	Title=$1
	Text=$2
	shift 2

	if ssft_select_multiple "$Title" "$Text" $@ ; then
		Selected=$SSFT_RESULT
		return 0
	else
		return 1 
	fi
}

#---------------------------------------------------------------------
yesno()
{
	# yesno title text width
	Title=$1
	Text=$2

	ssft_yesno "${Title}" "${Text}"

	return $?
}

#---------------------------------------------------------------------
remove_one_kernel()
{
	Kernel=$1 
	if [ "${Kernel}" != "${CURRENTKERNEL}" ]; then
		apt-get remove --purge --yes $(dpkg -l | grep ${Kernel} | awk '{print $2}')

		dpkg -l "linux-headers-${Kernel}-common" >/dev/null 2>&1 && \
			apt-get remove --purge --yes "linux-headers-${Kernel}-common"
		dpkg -l "linux-support-${Kernel}" >/dev/null 2>&1 && \
			apt-get remove --purge --yes "linux-support-${Kernel}"

		# dispose make install artefacts
		if [ ! -e "/boot/vmlinuz-${Kernel}" ]; then
			rm -rf /lib/modules/${Kernel}
		fi
	fi
}

#---------------------------------------------------------------------

get_KernelList()
{
	for v in /boot/vmlinuz-*; do 
		Kernel="$(basename $v | sed s/vmlinuz-//)"
		if [ "${Kernel}" != "${CURRENTKERNEL}" ]; then
			meta_package="$(echo $(grep-status \
				-F Depends -s Package \
				linux-image-${Kernel}) | cut -d: -f 2)"

			case $meta_package in
				*$Kernel* )
					# this is an old style kernel
					KernelList="${KernelList} ${Kernel}"

					continue
					;;
			esac

			[ -n "${meta_package}" ] && \
				meta_status="$(dpkg-query  -f='${STATUS}\n' \
					-W  ${meta_package}|\
				 	cut -d ' ' -f 3)" || \
				meta_status="not-installed"

			if [ "${meta_status}" = "not-installed" ]; then
				[ -z "${KernelList}" ] && KernelList="${Kernel}" ||\
				KernelList="${KernelList} ${Kernel}"
				# echo KernelList="$KernelList"
			fi
		fi
	done
}

#---------------------------------------------------------------------
# Main
#---------------------------------------------------------------------
if [ "${xtra}" -eq 1 ]; then
	KernelList="$@"
	for i in  ${KernelList} ; do
		removing="$(eval_gettext "removing kernel ${i}")"
		echo $removing
		remove_one_kernel "$i"
	done

	MSG="$(eval_gettext "the following kernels have been removed: \"${KernelList}\"")"
	echo $MSG

	exit 0
fi

prepare

get_KernelList

if [ -z "${KernelList}" ]; then
	MSG="$(gettext "There is only one kernel installed on this system. Nothing to be done!")"

	if [ "${force}" -eq 1 ]; then
		echo "${MSG}"
	else
		msgbox "${TITLE}" "${MSG}"
	fi

	exit 0
fi

if [ "${force}" -eq 1 ]; then
	current="$(eval_gettext "The current (active) kernel is $(uname -r)")"
	echo ${current}

	for i in  ${KernelList} ; do
		removing="$(eval_gettext "removing kernel ${i}")"
		echo $removing
		remove_one_kernel "$i"
	done

	MSG="$(eval_gettext "the following kernels have been removed: \"${KernelList}\"")"
	echo $MSG
else
	select_more "${TITLE}" "${CURRENT}" ${KernelList} 
	if [ "$?" -ne 0 ]; then
		exit 10
	fi

	if [ -z "${SSFT_RESULT}" ]; then
		exit 12
	fi

	one_removed=false
	for i in ${SSFT_RESULT}; do
		MSG="$i : $(gettext "Should I remove this kernel?") "
		yesno "${TITLE}" "${MSG}"

		if [ "$?" -eq 0 ]; then
			remove_one_kernel "$i"
			one_removed=true
		else
			msgbox "${TiTLE}" "$(gettext "Kernel not removed:") $i"
		fi
	done
fi

exit 0
