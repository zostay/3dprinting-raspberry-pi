use <./rpi3bplus-base.scad>;

perforation_length_offset=3;

perforation_triangle_bits=5;

case_length=case_dimensions().x;
case_width=case_dimensions().y;
case_height=case_dimensions().z;

wall_thickness=case_wall_thickness();

tab_thickness=1;
tab_depth=5;
socket_thickness=1;
socket_depth=5;

socket_join_fudge=0.2;

attachment_height=2;
attachment_length=5;

module case_split(join_fudge) {
    module upright_triangle_cutout() {
        translate([0,wall_thickness,wall_thickness])
        rotate([90,0,0])
        linear_extrude(height=wall_thickness)
        polygon([
            [0,0],[perforation_triangle_bits,0],[perforation_triangle_bits,join_fudge],[0,perforation_triangle_bits+join_fudge]
        ]);
    }

    module socket_cutout() {
        translate([0,(wall_thickness-socket_thickness+join_fudge)/2,0])
        cube([socket_depth+join_fudge,socket_thickness+join_fudge,case_height-wall_thickness/2]);
    }

    difference() {
        cube([case_length,case_width,case_height]);

        union() {
            cube([perforation_triangle_bits,case_width,wall_thickness]);

            upright_triangle_cutout();
            translate([0,case_width-wall_thickness,0]) upright_triangle_cutout();

            socket_cutout();
            translate([0,case_width-wall_thickness,0]) socket_cutout();
        }
    }

    linear_extrude(height=wall_thickness)
    polygon([
        [perforation_triangle_bits,wall_thickness],[0,perforation_triangle_bits+wall_thickness],
        [0,case_width-perforation_triangle_bits-wall_thickness],[perforation_triangle_bits,case_width-wall_thickness]
    ]);
}

module rpi3bplus_main_body() {
    intersection() {
        rpi3bplus(camera_hole=true);
        translate([perforation_length_offset+socket_join_fudge,0,0]) case_split(socket_join_fudge);
    }
}

module rpi3bplus_lid() {
    module tab() {
        translate([wall_thickness,(wall_thickness-socket_thickness)/2+socket_join_fudge,0])
        cube([socket_depth,socket_thickness,case_height-wall_thickness/2-socket_join_fudge]);
    }

    module attachment() {
        linear_extrude(height=socket_thickness)
        polygon([
            [0,0], [attachment_height,attachment_height],
            [attachment_height+attachment_length,attachment_height],
            [attachment_height*2+attachment_length,0]
        ]);
    }

    difference() {
        rpi3bplus();
        translate([perforation_length_offset,0,0]) case_split();
    }

    tab();
    translate([0,case_width-wall_thickness,0]) tab();

    translate([1,case_width/3+socket_thickness,case_height])
    rotate([90,0,0])
    attachment();

    translate([1,2*case_width/3+socket_thickness,case_height])
    rotate([90,0,0])
    attachment();
}

module hanger() {
    difference() {
        cube([60,6,9]);

        translate([3,0,0]) cube([60,3,6]);
    }

    cube([15,3,3]);
}

union() {
    rpi3bplus_main_body();
    rpi3bplus_lid();
    translate([10,case_width,0]) hanger();
}

