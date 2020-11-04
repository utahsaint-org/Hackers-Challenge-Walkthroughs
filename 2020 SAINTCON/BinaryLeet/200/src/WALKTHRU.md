# Run strings on the binary for little endian encoding

灰色浪人$ strings -eL escape
flag{Strings_with_Extr4_St3p5}

# or a hex editor/dump works well too

灰色浪人$ hexdump -e "16 \"%_p\" \"\\n\"" escape | head -n 25 | sed 's/\.//g' | tr '\n' ' ' | sed 's/ //g'
ELF>@@@8@@@``H`PH`<H1flag{Strings_with_Extr4_St3p5}Getting_warmerGo



