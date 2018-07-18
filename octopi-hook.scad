module clip() {
    translate([4, 0, 0]) union() {
        cube([0.5, 4, 10]);
        
        difference() {
            translate([4.5,20,10])
            rotate([90,180,0])
            linear_extrude(height=20) {
                polygon(points=[[1,0],[0,1],[0,9],[1,10],[4,10],[4,0]]);
            }
            
            translate([4.5,-3,-1])
            rotate([0,0,45])
            cube([4, 4, 12]);
        }
    }
}


union() {
    translate([0,-12,0]) cube([4, 65, 10]);
    clip();
    translate([0,30,0]) clip();
}