 cube([86,54,2]);

translate([(86-65)/2,(54-16)/2,2])
difference() {
    cube([65,16,8]);
    
    translate([4,3,-.5])
        cube([65,10,4.5]);
    translate([20,3,1])
    cube([65,10,8.5]);
}