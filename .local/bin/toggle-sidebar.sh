_() {
    bspc config right_padding "$@"
}

p=300 && [[ $(_) -eq $p ]] && _ 0 || _ $p
