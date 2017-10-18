use <eurorack_panel.scad>;
$fn=2;

height = 128.5;
safe = 20;

hp = 6;
x_offset = 6.7;
y_offset = 0;

count = 7;

banana_pos = [x_offset,y_offset];
phono35mm_pos = [-x_offset,-y_offset];

eurorack_panel(hp=hp, label=false) {
    h = height-safe*2;
    for(y=[-h/2:h/(count-1):h/2]) {
        base = [0, y];
        banana(base + banana_pos) ;
        phono35mm(base + phono35mm_pos, 90);
        line(base + banana_pos, base + phono35mm_pos);
    }
}

$fn = 100;