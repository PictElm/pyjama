# notes on diff with part:
#  changed sep from '/' to ':' (and thus ':' for '/' in `w`)
#  no '"' allowed, changed to use $w
#  removed '\' that would be wrong escapes

h=
all=_no_cmp_add_sub_mul_div_mod_pow_sum_prd_max_min_v_s_l_span_copy_pick_stow_find_size_hold_drop_does_

pIFS=$IFS
w() {
	#echo "-> w $@" >/dev/tty
	z=
	if [ "$1" = "${1#@}" ]
		then
			x=
			for y in $*
				do
					if [ -n "$x" ] && [ "$x" = "${x%,}" ]
						then x=$x:$y
						else x=$x$y
					fi
			done
			IFS=,
			for y in $x
				do
					[ -z "${all##*_${y%_*}_*}" ] && eval y=$(IFS=:;y=$(echo $y);IFS=$pIFS;$y)
					z=$z${z:+ }$y
					IFS=,
			done
			IFS=$pIFS
		else z=${1#@}
	fi
	#echo "<- w $z" >/dev/tty
	echo $z
}

split() {
	IFS=/
	echo $1
	IFS=$pIFS
}
zap() {
	r=
	k=0
	for v in $(split $2)
		do
			u=$(eval echo "$"$((k+3)))
			r=$r${r:+/}$(eval echo "$1")
			k=$((k+1))
	done
	echo ${r:-/}
}
powu() {
	if [ 1 -eq $2 ]
		then echo $1
	elif [ 0 -eq $2 ]
		then echo 1
		else
			c=$(($2 / 2))
			d=$(powu $1 $c)
			s=$((d * d))
			[ 1 -eq $(($2 % 2)) ] && s=$((s * $1))
			echo $s
	fi
}
setat() {
	n=$1
	m=$2
	shift 2
	i=$@
	shift $n
	o=${i%$@}
	shift
	echo $o$m $@ # note: a surveiller de pres
}

no_() {
	zap '$((!v))' $1
}

cmp_() {
	zap '$((v < u ? -1 : v > u))' $1 $(split $2)
}
add_() {
	zap '$((v + u))' $1 $(split $2)
}
sub_() {
	zap '$((v - u))' $1 $(split $2)
}
mul_() {
	zap '$((v * u))' $1 $(split $2)
}
div_() {
	zap '$((v / u))' $1 $(split $2)
}
mod_() {
	zap '$(((v % u + u) % u))' $1 $(split $2)
}
pow_() {
	zap '$(powu $v $u)' $1 $(split $2)
}

sum_() {
	r=0
	for v in $(split $1)
		do r=$((r + v))
	done
	echo $r
}
prd_() {
	r=1
	for v in $(split $1)
		do r=$((r * v))
	done
	echo $r
}
max_() {
	r=-2147483648
	for v in $(split $1)
		do [ $r -lt $v ] && r=$v
	done
	echo $r
}
min_() {
	r=2147483647
	for v in $(split $1)
		do [ $r -gt $v ] && r=$v
	done
	echo $r
}

v_() {
	#echo "v_($@)" >/dev/tty
	r=
	for t in $*
		do r=$r${r:+/}$t
	done
	echo ${r:-/}
}
s_() {
	s="$*"
	r=
	while [ -n "$s" ]
		do
			c=$(printf %c "$s")
			s=${s#$c}
			r=$r${r:+/}$(printf %d "'$c")
	done
	echo ${r:-/}
}
l_() {
	echo ${1##*/}
}

span_() {
	#echo "span_($@)" >/dev/tty
	r=
	k=$1
	d=-lt
	[ $3 -lt 0 ] && d=-gt
	while [ $k $d $2 ]
		do
			r=$r${r:+/}$k
			k=$((k+$3))
	done
	echo ${r:-/}
}
copy_() {
	r=
	if [ -n "$2" ]
		then
			c=$2
			while [ 0 -ne $c ]
				do
					c=$((c-1))
					r=$r${r:+/}${1#/}
			done
	fi
	echo ${r:-/}
}
pick_() {
	#echo "pick_($1, $2)" >/dev/tty
	r=
	if [ -n "$2" ]
		then
			set -- $2 $(split $1)
			for k in $(split $1)
				do eval r=$r${r:+/}'$'$((k+2))
			done
	fi
	echo ${r:-/}
}
stow_() {
	#echo "stow_($1, $2, $3)" >/dev/tty
	r=$(split $1)
	set -- $2 $(split $3)
	for k in $(split $1)
		do
			shift
			r=$(setat $k $1 $r)
	done
	v_ $r
}
find_() {
	r=
	if [ -n "$2" ]
		then
			k=0
			for e in $(split $1)
				do
					[ $e -eq $2 ] && r=$r${r:+/}$k
					k=$((k+1))
			done
	fi
	echo ${r:-/}
}

size_() {
	set -- $(split $1)
	echo $#
}

hold_() {
	#echo "hold_($@) {${h:-empty}}" >/dev/tty
	# h=$h${h:+/}$1
	#echo "  --> {${h:-empty}}" >/dev/tty
	# echo "$1;h=$h"
	echo "$1;h=$h${h:+/}${1#/}"
}
drop_() {
	#echo "drop_($@) {${h:-empty}}" >/dev/tty
	o=$1
	c=$2
	set -- $(split $h)
	i=$@
	shift $(($#-$o-$c))
	m=$@
	shift $(($c))
	# h=$(v_ ${i%$m} $@)
	#echo "  --> {${h:-empty}}" >/dev/tty
	# echo "$(v_ ${m%$@});h=$h"
	echo "$(v_ ${m%$@});h=$(v_ ${i%$m} $@)"
}

does_() {
	eval echo '$'$# # or: shift $(($#-1));echo $1
}

skip=1
text=
s=' $(w '
while read -r line
	do
		IFS=$pIFS
		if [ -n "$skip" ]
			then [ "program_(" = "$line" ] && skip=
			else [ "voila_()" = "$line" ] && break
				togg=
				IFS=\"
				for chunk in $line
					do
						if [ -z "$togg" ]
							then
								if [ "(" = "$chunk" ]
									then added=$s
									else
										added=
										IFS="("
										for part in $chunk
											do added=$added${added:+$s}$part
										done
										[ "$chunk" = "${chunk#(}" ] || added=$s$added
										[ "$chunk" = "${chunk%(}" ] || added=$added$s
								fi
								text=$text$added
								togg=1
							else
								text="$text'@$chunk'"
								togg=
						fi
				done
				IFS=$pIFS
		fi
done < "$0"
# echo "eval echo \$(w $text)" >/dev/tty
eval echo '$(w '$text')'
exit

program_(
	copy_(v_(6, 7), 2),
voila_()
	%heretest% (whole line is replaced)
voila_()
)
