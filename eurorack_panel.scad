module eurorack_panel(width_hp = 6, full_thickness = 6, label = "auto") {
    // approximation of doepfer standard
    width = 5.077183587 * width_hp - 0.2690561803;
    height = 128.5;
    m3_hole_dia = 3.2;
    text_thickness = 0.4;

    hp1 = 5.08;
    first_hole_offset = 7.5 - hp1 + (width_hp>2?hp1:0);
    last_hole_offset = first_hole_offset + (hp1 * (width_hp-3));
    echo(last_hole_offset);

    panel_thickness = 2;
    panel_safe_height = 9;
    panel_bevel_disatance = panel_safe_height + (full_thickness-panel_thickness)*1;

    all_holes = width_hp >= 12;
    diag_holes = width_hp >= 6 && !all_holes;
    

    difference() {
        rotate([90,0,90]) linear_extrude(height = width)
        polygon([[0,0], 
            [panel_thickness,0], 
            [panel_thickness,panel_safe_height],
            [full_thickness, panel_bevel_disatance],
            [full_thickness, height-panel_bevel_disatance],
            [panel_thickness, height-panel_safe_height],
            [panel_thickness, height],
            [0,height]]);
        
        rotate([90,0,0])
        translate([first_hole_offset,height-3])
        cylinder(h = 99, d = m3_hole_dia, center = true);
        
        if(!diag_holes) {
            rotate([90,0,0])
            translate([first_hole_offset,3])
            cylinder(h = 99, d = m3_hole_dia, center = true);
        }
        
        if(all_holes) {
            rotate([90,0,0])
            translate([last_hole_offset,height-3])
            cylinder(h = 99, d = m3_hole_dia, center = true);
        }
        
        if(all_holes || diag_holes) {
            rotate([90,0,0]) 
            translate([last_hole_offset,3]) 
            cylinder(h = 99, d = m3_hole_dia, center = true);
        }
    }
    
    text_size = min(10, width_hp*3.1);
    text_rotation = (width_hp > 5)?0:90;
    color("orange")
    translate([width/2,full_thickness,height/2]) 
    rotate([90, text_rotation, 180])
    linear_extrude(text_thickness)
    text(label=="auto"?str(width_hp, "hp"):label, size=text_size, halign="center", valign="center");
}

$fn=100;
eurorack_panel(width_hp=6);
