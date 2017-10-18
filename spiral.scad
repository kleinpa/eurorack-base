use <eurorack_panel.scad>;

hp=14;
hp_width = 5.08;
margin = 6;

module spiral(
    revolutions = 4,
    width = 1,
    spacing = 0.7,
    height = 1) {
    function polar(r, t) = [r*sin(t),r*cos(t)];
    points = 360 * 2 * revolutions; 
    slope = 1/360 * (spacing+1)*width;
    linear_extrude(height,center = true) 
    polygon([for (i = [0:3:points], convexity = 4*revolutions)
        i < points/2?
        polar(slope*i,i):
        polar(slope*(points-i)+min(width,(points-i)/45),(points-i))]);
}

eurorack_panel(hp=hp, label=false) {
    intersection() {
        cube([hp_width*hp-2*margin,128.5-2*margin,40], center=true);    
        spiral(width=2.6, spacing=2, height=99, revolutions = 14);
    }
}

