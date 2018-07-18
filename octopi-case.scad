module ethernet() {
    cube([20,16,13.5]);
}

module usb() {
    cube([20,15,15.6]);
}

// TODO
module micro_usb() {
    translate([0,-5,0]) cube([8,10,3]);
}

module hdmi() {
    translate([0,-5,0]) cube([15,10,5.5]);
}

module audio_jack() {
    translate([0,0,7/2])
    rotate([90,0,0])
    cylinder(d=7,h=10,center=true);
}

// TODO
module m2_5_screw() {
    cylinder(d=2.5,h=10,$fn=10,center=true);
}

difference() {
    cube([92, 62, 25]);
    
    translate([3,3,3])
    union() {
        cube([86, 56, 25]);
    
        translate([3,4,0])
        union() {
            translate([0,0,0]) m2_5_screw();
            translate([0,48,0]) m2_5_screw();
            translate([58,0,0]) m2_5_screw();
            translate([58,48,0]) m2_5_screw(); 
        }
        
        translate([0,0,5])
        union() {
            translate([80,1,0]) ethernet();
            
            translate([80,20,0]) usb();
            translate([80,38,0]) usb();
            
            translate([86-33,0,0]) audio_jack();
            
            translate([86-47-15,0,0]) hdmi();
            
            translate([6,0,0]) micro_usb();
        }
    }
}

//translate([3,0,17])
//cube([4, 60, 3]);