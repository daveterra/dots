#!/usr/bin/env fish
set t $argv[1]

set count $(task _get $t.annotations.count)
echo $count

for annotation in $(seq 1 $count) 
	set url $(task _get $t.annotations.$annotation.description)
	echo $url
	open $url
end
