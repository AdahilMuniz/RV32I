proc compile {args} {

    set LIST [ lindex $args 0 ]

    set COMPILER "vlog"
    set ARGS [ list "-sv" "+acc"]

    foreach element $LIST {
        array set module $element
        puts "\n> Compiling $module(name)\n"

        set INCDIR_LIST [ list ]; #Include dir list with '+incdir+' string
        foreach inc $module(incdir) {
            lappend INCDIR_LIST "+incdir+$inc"
        }

        foreach file $module(files) {
            puts [ exec $COMPILER {*}$ARGS {*}$INCDIR_LIST "$module(dir)/$file" ]
        }
    }
}

proc compile_design {args} {
    global LIST_DESIGN
    compile $LIST_DESIGN
}

proc compile_tb {args} {
    global LIST_TB
    compile $LIST_TB
}