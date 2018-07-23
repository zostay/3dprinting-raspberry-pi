use <./rpi3bplus-base.scad>;
use <./octopi-hook.scad>;

wall_thickness=case_wall_thickness();

perforation_length_offset=rpi_origin().x / 2;

perforation_triangle_bits=5;

case_length=case_dimensions().x;
case_width=case_dimensions().y;
case_height=case_dimensions().z;

socket_join_fudge=.5;

tab_thickness=1;
tab_depth=5;
socket_thickness=1;
socket_depth=5+socket_join_fudge;

attachment_height=5;
attachment_length=perforation_length_offset*2;
attachment_width=1;

hanger_hook_width=shelf_cutout_dimensions().y;
hanger_hook_depth=hook_backplate_dimensions().z;
hanger_hook_height=60;
hanger_hook_clip_thickness=hook_backplate_dimensions().z - hook_backplate_hook_dimensions().z;
hanger_hook_clip_depth=hook_backplate_hook_dimensions().x;

module case_split(join_fudge) {
    module upright_triangle_cutout() {
        translate([0,wall_thickness,wall_thickness])
        rotate([90,0,0])
        linear_extrude(height=wall_thickness)
        polygon([
            [0,0],[perforation_triangle_bits,0],[perforation_triangle_bits,join_fudge],[0,perforation_triangle_bits+join_fudge]
        ]);
    }

    module socket_cutout(join_fudge) {
        translate([0,(wall_thickness-socket_thickness-join_fudge*2)/2,0])
        cube([socket_depth+join_fudge,socket_thickness+join_fudge*2,case_height-wall_thickness/2]);
    }

    difference() {
        cube([case_length,case_width,case_height]);

        union() {
            cube([perforation_triangle_bits,case_width,wall_thickness]);

            upright_triangle_cutout();
            translate([0,case_width-wall_thickness,0]) upright_triangle_cutout();

            socket_cutout(join_fudge);
            translate([0,case_width-wall_thickness,0]) socket_cutout(join_fudge);
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

    translate([perforation_length_offset+10,case_width,0]) hanger();

}

module rpi3bplus_lid() {
    module tab() {
        translate([wall_thickness,(wall_thickness-socket_thickness)/2+socket_join_fudge,0])
        cube([socket_depth,socket_thickness,case_height-wall_thickness/2-socket_join_fudge]);
    }

    difference() {
        rpi3bplus();
        translate([perforation_length_offset,0,0]) case_split();
    }

    tab();
    translate([0,case_width-wall_thickness,0]) tab();

    module attachment() {
        linear_extrude(height=attachment_width)
        polygon([
            [0,0], [attachment_height,attachment_height],
            [attachment_height+attachment_length,attachment_height],
            [attachment_height*2+attachment_length,0]
        ]);
    }

    translate([0,case_width/3+attachment_width,case_height])
    rotate([90,0,0])
    attachment();

    translate([0,2*case_width/3+attachment_width,case_height])
    rotate([90,0,0])
    attachment();

}

module hanger() {
    difference() {
        cube([hanger_hook_height,hanger_hook_width+wall_thickness,hanger_hook_depth+wall_thickness]);

        translate([wall_thickness,0,0])
        cube([hanger_hook_height,hanger_hook_width,hanger_hook_depth]);
    }

    cube([wall_thickness+hanger_hook_clip_depth,hanger_hook_width,hanger_hook_clip_thickness-socket_join_fudge]);
}

union() {
    rpi3bplus_main_body();
    rpi3bplus_lid();
}

