use <rounded-cube.scad>;

shelf_thickness=1.6;
shelf_cutout_width=10;
shelf_cutout_height=16;
shelf_cutout_space=60;

shelf_cutout_height_tolerance=0.5;

width_fudge=0.1;

backplate_adjust=12;
backplate_width=shelf_cutout_width-width_fudge;
backplate_height=shelf_cutout_space*1.75;
backplate_thickness=6;

clip_thickness=3;
clip_width=shelf_cutout_width-width_fudge;
clip_height=shelf_cutout_height-shelf_cutout_height_tolerance;
clip_offset=shelf_thickness;
clip_downshift=shelf_cutout_space+clip_height;

clip_bevel=1;

top_chamfer_angle=45;
bottom_chamfer_angle=45;
chamfer_square=clip_thickness;

module clip() {
    union() {
        cube([clip_offset, clip_thickness, clip_width]);

        difference() {
            translate([clip_thickness+clip_offset,clip_height,clip_width])
            rotate([90,180,0])
            linear_extrude(height=clip_height) {
                polygon(points=[
                    [0+clip_bevel,0],[0,0+clip_bevel],
                    [0,clip_width-clip_bevel],[0+clip_bevel,clip_width],
                    [clip_thickness,clip_width],[clip_thickness,0]
                ]);
            }

            translate([clip_offset,0,0])
            union() {
                // bottom chamfer
                translate([0,clip_height,0])
                rotate([0,0,bottom_chamfer_angle])
                cube([chamfer_square,chamfer_square,(clip_width+2)*2],center=true);

                // top chamfer
                translate([clip_thickness,0,0])
                rotate([0,0,top_chamfer_angle])
                cube([chamfer_square,chamfer_square,(clip_width+2)*2],center=true);
            }
        }
    }
}


union() {
    translate([0,-backplate_adjust,0])
    difference() {
        cube([backplate_thickness, backplate_height, backplate_width]);

        translate([backplate_thickness/2,-2,-1])
        cube([backplate_thickness/2+2, backplate_adjust+2, backplate_width+2]);
    }

    translate([backplate_thickness,0,0])
    union() {
        clip();
        translate([0,clip_downshift,0]) clip();
    }
}
