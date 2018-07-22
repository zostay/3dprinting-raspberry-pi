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

hdmi_angle_width=2;
hdmi_width=15;
hdmi_height=5.5;
hdmi_offset=25;

micro_usb_width=8;
micro_usb_height=3;
micro_usb_offset=7.5;

m2_5_screw_width=2.5;
m2_5_spacer_width=m2_5_screw_width*2;
m2_5_spacer_height=5;

rpi_below_board=5;
rpi_pcb_thickness=2;
rpi_above_board=18;
rpi_bounding_height=rpi_below_board+rpi_above_board+rpi_pcb_thickness;
rpi_bounding_length=87;
rpi_bounding_width=58;

rpi_screw_origin_length=4;
rpi_screw_origin_width=4;
rpi_screw_offset_length=58;
rpi_screw_offset_width=49;

wall_thickness=3;
case_length=rpi_bounding_length+wall_thickness*2;
case_width=rpi_bounding_width+wall_thickness*2;
case_height=rpi_bounding_height+wall_thickness*2;

etch_depth=1;
etch_size=3;
etch_edge_offset=2;

label_power_offset=7;
label_hdmi_offset=28;
label_audio_offset=51;
label_ethernet_offset=4;
label_usb_offset=35;
label_dash1_adjust=12;
label_dash2_adjust=10;
label_dash_raise=1.5;

camera_cable_width=20;
camera_cable_thickness=4;
camera_length_offset=43;
camera_width_offset=2;

function case_wall_thickness() = wall_thickness;
function case_dimensions() = [case_length,case_width,case_height];

module camera() {
    cube([camera_cable_thickness,camera_cable_width,cutout_depth]);
}

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
    translate([0,-cutout_depth/2,0]) difference() {
        cube([hdmi_width,cutout_depth,hdmi_height]);
        union() {
            translate([0,cutout_depth/2,0])
            rotate([90,0,0])
            linear_extrude(h=cutout_depth+2) {
                polygon([
                    [0,0],[0,hdmi_angle_width],[hdmi_angle_width,0]
                ]);
            }

            translate([hdmi_width-hdmi_angle_width,cutout_depth/2,0])
            rotate([90,0,0])
            linear_extrude(h=cutout_depth+2) {
                polygon([
                    [0,0],[hdmi_angle_width,0],[hdmi_angle_width, hdmi_angle_width]
                ]);
            }
        }
    }
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

module rpi3bplus(camera_hole=false) {
    union() {
        difference() {
            cube([
                rpi_bounding_length+wall_thickness*2,
                rpi_bounding_width+wall_thickness*2,
                case_height
            ]);

            translate([wall_thickness,wall_thickness,wall_thickness])
            union() {
                cube([rpi_bounding_length, rpi_bounding_width, rpi_bounding_height]);

                // translate([rpi_screw_origin_length,rpi_screw_origin_width,0])
                // union() {
                //     translate([0,0,0]) m2_5_screw_hole();
                //     translate([0,rpi_screw_offset_width,0]) m2_5_screw_hole();
                //     translate([rpi_screw_offset_length,0,0]) m2_5_screw_hole();
                //     translate([rpi_screw_offset_length,rpi_screw_offset_width,0]) m2_5_screw_hole();
                // }

                translate([0,0,m2_5_spacer_height+rpi_pcb_thickness])
                union() {
                    translate([rpi_bounding_length+cutout_offset,ethernet_offset,0]) ethernet();

                    translate([rpi_bounding_length+cutout_offset,usb1_offset,0]) usb();
                    translate([rpi_bounding_length+cutout_offset,usb2_offset,0]) usb();

                    translate([audio_jack_offset,0,0]) audio_jack();

                    translate([hdmi_offset,0,0]) hdmi();

                    translate([micro_usb_offset,0,0]) micro_usb();

                    if (camera_hole) {
                        translate([camera_length_offset,camera_width_offset,case_height/2])
                        camera();
                    }
                }
            }

            translate([0,0,case_height-etch_depth])
            union() {
                linear_extrude(height=etch_depth+1) {
                    translate([etch_edge_offset+label_power_offset,etch_edge_offset,0]) text("Power", size=etch_size);
                    translate([etch_edge_offset+label_hdmi_offset,etch_edge_offset,0]) text("HDMI", size=etch_size);
                    translate([etch_edge_offset+label_audio_offset,etch_edge_offset,0]) text("Audio", size=etch_size);

                    translate([rpi_bounding_length+wall_thickness*2,0,0])
                    union() {
                        translate([-etch_edge_offset,etch_edge_offset+label_ethernet_offset,0])
                        rotate([0,0,90])
                        text("Ethernet", size=etch_size);

                        translate([-etch_edge_offset,etch_edge_offset+label_usb_offset,0])
                        rotate([0,0,90])
                        text("USB", size=etch_size);

                        translate([-etch_edge_offset,etch_edge_offset,0])
                        union() {
                            translate([-label_dash_raise,label_usb_offset-label_dash1_adjust,0]) square([1,10]);
                            translate([-label_dash_raise,label_usb_offset+label_dash2_adjust,0]) square([1,10]);
                        }
                    }
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
}

rpi3bplus(camera_hole=true);
