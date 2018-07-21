cutout_depth=10;
cutout_offset=-cutout_depth/2;

ethernet_width=16;
ethernet_height=13.5;
ethernet_offset=2.5;

audio_jack_width=7;
audio_jack_offset=54.5;

usb_width=15;
usb_height=15.6;
usb1_offset=21.5;
usb2_offset=39.5;

hdmi_width=15;
hdmi_height=5.5;
hdmi_offset=25.5;

micro_usb_width=8;
micro_usb_height=3;
micro_usb_offset=7.5;

m2_5_screw_width=2.5;
m2_5_spacer_width=m2_5_screw_width*2;
m2_5_spacer_height=5;
pcb_thickness=2;

rpi_bounding_height=18;
rpi_bounding_length=87;
rpi_bounding_width=58;

rpi_screw_origin_length=4;
rpi_screw_origin_width=4;
rpi_screw_offset_length=58;
rpi_screw_offset_width=49;

wall_thickness=3;
case_height=rpi_bounding_height+wall_thickness*2+pcb_thickness+2;

module ethernet() {
    cube([cutout_depth,ethernet_width,ethernet_height]);
}

module usb() {
    cube([cutout_depth,usb_width,usb_height]);
}

// TODO
module micro_usb() {
    translate([0,-cutout_depth/2,0]) cube([micro_usb_width,cutout_depth,micro_usb_height]);
}

module hdmi() {
    translate([0,-cutout_depth/2,0]) cube([hdmi_width,cutout_depth,hdmi_height]);
}

module audio_jack() {
    translate([0,0,audio_jack_width/2])
    rotate([90,0,0])
    cylinder(d=audio_jack_width,h=cutout_depth,center=true);
}

module m2_5_screw_hole() {
    cylinder(d=m2_5_screw_width,h=cutout_depth,$fn=10,center=true);
}

module m2_5_spacer() {
    translate([0,0,m2_5_spacer_height/2])
    difference() {
        cylinder(d=m2_5_spacer_width,h=m2_5_spacer_height,center=true);
        cylinder(d=m2_5_screw_width,h=m2_5_spacer_height+cutout_depth,$fn=10,center=true);
    }
}

union() {
    difference() {
        cube([
            rpi_bounding_length+wall_thickness*2,
            rpi_bounding_width+wall_thickness*2,
            case_height
        ]);

        translate([wall_thickness,wall_thickness,wall_thickness])
        union() {
            cube([rpi_bounding_length, rpi_bounding_width, rpi_bounding_height+cutout_depth]);

            // translate([rpi_screw_origin_length,rpi_screw_origin_width,0])
            // union() {
            //     translate([0,0,0]) m2_5_screw_hole();
            //     translate([0,rpi_screw_offset_width,0]) m2_5_screw_hole();
            //     translate([rpi_screw_offset_length,0,0]) m2_5_screw_hole();
            //     translate([rpi_screw_offset_length,rpi_screw_offset_width,0]) m2_5_screw_hole();
            // }

            translate([0,0,m2_5_spacer_height+pcb_thickness])
            union() {
                translate([rpi_bounding_length+cutout_offset,ethernet_offset,0]) ethernet();

                translate([rpi_bounding_length+cutout_offset,usb1_offset,0]) usb();
                translate([rpi_bounding_length+cutout_offset,usb2_offset,0]) usb();

                translate([audio_jack_offset,0,0]) audio_jack();

                translate([hdmi_offset,0,0]) hdmi();

                translate([micro_usb_offset,0,0]) micro_usb();
            }
        }
    }

    translate([
        rpi_screw_origin_length+wall_thickness,
        rpi_screw_origin_width+wall_thickness,
        wall_thickness
    ])
    union() {
        translate([0,0,0]) m2_5_spacer();
        translate([0,rpi_screw_offset_width,0]) m2_5_spacer();
        translate([rpi_screw_offset_length,0,0]) m2_5_spacer();
        translate([rpi_screw_offset_length,rpi_screw_offset_width,0]) m2_5_spacer();
    }
}

//translate([3,0,17])
//cube([4, 60, 3]);
