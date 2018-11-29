force enable 1 @ 0, 0 @ 40, 1 @ 50
force Cx 320 @ 0

for {set i 0} {$i < 430} {incr i 10} {
	set x = i;
	force Cy x @ x;
	if {i = 430} {
		i = 0;
	}
}

force Oh 24 @ 0
force Ow 32 @ 0
force Ox 304 @ 0

for {set i 0} {$i < 430} {incr i 50} {
	set x = i; 
	force Oy i @ i;
	if {i>430} {

		i = 0;
	}

}
run 500