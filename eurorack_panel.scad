module eurorack_panel(hp = 14, full_thickness = 6, bevel_angle = 45, label = "auto") {
    // approximation of doepfer standard
    width = 5.077183587 * hp - 0.2690561803;
    height = 128.5;
    m3_hole_dia = 3.2;
    text_thickness = 0.4;

    hp_width = 5.08;
    first_hole_offset = 7.5 - hp_width + (hp>2?hp_width:0);
    last_hole_offset = first_hole_offset + (hp_width * (hp - 3));
    echo(last_hole_offset);

    panel_thickness = 2;
    panel_safe_height = 9;
    panel_bevel_disatance = panel_safe_height + (full_thickness - panel_thickness) * 1;

    all_holes = hp >= 12;
    diag_holes = hp >= 6 && !all_holes;
    
    difference() {
        rotate([90, 0, 90]) linear_extrude(height = width)
        polygon([[0, 0],
            [panel_thickness, 0],
            [panel_thickness, panel_safe_height],
            [full_thickness, panel_bevel_disatance],
            [full_thickness, height-panel_bevel_disatance],
            [panel_thickness, height-panel_safe_height],
            [panel_thickness, height],
            [0,height]]);
        
        rotate([90,0,0]) {
            translate([first_hole_offset,height-3])
            cylinder(h = 99, d = m3_hole_dia, center = true);
            
            if(!diag_holes) {
                translate([first_hole_offset,3])
                cylinder(h = 99, d = m3_hole_dia, center = true);
            }
            
            if(all_holes) {
                translate([last_hole_offset,height-3])
                cylinder(h = 99, d = m3_hole_dia, center = true);
            }
            
            if(all_holes || diag_holes) {
                translate([last_hole_offset,3]) 
                cylinder(h = 99, d = m3_hole_dia, center = true);
            }
            
            translate([width/2,height/2])
            children();
        }
    }
    
    text_size = min(10, hp*3.1);
    text_rotation = (hp > 5)?0:90;
    color("orange")
    translate([width/2,full_thickness,height/2]) 
    rotate([90, text_rotation, 180])
    linear_extrude(text_thickness)
    text(label=="auto"?str(width_hp, "hp"):label, size=text_size, halign="center", valign="center");
}


module banana(t=[0,0,0], r = 0) {
    translate(t)
    rotate(r)
    render() intersection() {
        cylinder(h = 99, r = 4.1656, center = true);
        cube([6.35, 4.1656*2, 99], center=true);
    }
}

module phono35mm(t=[0,0,0], r = 0) {
    translate(t) rotate(r) {
        cylinder(h = 99, d = 6.1, center = true);
    
        translate([0,(4.5-6)/2,-12])
        cube([10.5,12,20], center=true);
    }
}

module line(a, b, width=1.5, depth=1) {
    l = sqrt(pow(a[0]-b[0],2)+pow(a[1]-b[1],2));
    
    translate([(a[0]+b[0]),(a[1]+b[1])/2])
    rotate([0,0,atan2(a[1]-b[1],a[0]-b[0])])
    cube([l,width,depth],center = true);
}

$fn=20;

hp_width = 5.08;

for(p = [1 : 24]) {
  translate([((p-1)*(p/2)) * hp_width*1.05,0,0])
  eurorack_panel(hp=p);    
}

