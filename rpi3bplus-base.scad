sdc_overhang=3; // actual overhang is 2.6

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
hdmi_width=15.75;
hdmi_height=6.5;
hdmi_offset=25;

micro_usb_width=8.75;
micro_usb_height=3.5;
micro_usb_offset=7.5;

screw_driver_width=4;

extra_length=10;
extra_width=10;
extra_height=0;

function extra_dimensions() = [extra_length,extra_width,extra_height];

wall_thickness=4;

cutout_depth=wall_thickness*3;
cutout_offset=-cutout_depth/2;

rpi_below_board=5;
rpi_pcb_thickness=2;
rpi_above_board=18;
rpi_bounding_height=rpi_below_board+rpi_above_board+rpi_pcb_thickness;
rpi_bounding_length=87+sdc_overhang;
rpi_bounding_width=58;

rpi_origin_length=extra_length+wall_thickness;
rpi_origin_width=wall_thickness;
rpi_origin_height=wall_thickness+rpi_below_board;

function rpi_origin() = [rpi_origin_length,rpi_origin_width,rpi_origin_height];

side_plate_actual_width=audio_jack_offset-micro_usb_offset+audio_jack_width/2;
side_plate_width=1.2*side_plate_actual_width;
side_plate_depth=wall_thickness-1;
side_plate_height=2*max(micro_usb_height, hdmi_height, audio_jack_width);
side_plate_offset_length=rpi_origin_length+micro_usb_width-(side_plate_width-side_plate_actual_width)/2;
side_plate_offset_height=rpi_origin_height-1.5;

back_plate_actual_width=usb2_offset+usb_width-ethernet_offset;
back_plate_width=back_plate_actual_width*1.1;
back_plate_depth=wall_thickness-1;
back_plate_height=1.2*max(usb_height, ethernet_height);
back_plate_offset_width=rpi_origin_width+ethernet_offset-(back_plate_width-back_plate_actual_width)/2;
back_plate_offset_height=rpi_origin_height+0.5;

m2_5_screw_width=2.5;
m2_5_spacer_width=m2_5_screw_width*2;
m2_5_spacer_height=rpi_origin_height-wall_thickness;

case_int_length=rpi_bounding_length+extra_length;
case_int_width=rpi_bounding_width+extra_width;
case_int_height=rpi_bounding_height+extra_height;

rpi_screw_origin_length=4+sdc_overhang;
rpi_screw_origin_width=4;
rpi_screw_offset_length=58;
rpi_screw_offset_width=49;

case_length=case_int_length+wall_thickness*2;
case_width=case_int_width+wall_thickness*2;
case_height=case_int_height+wall_thickness*2;

etch_depth=1;
etch_size=3;
etch_edge_offset=2;

rail_depth=0.5;
rail_width=2;
rail_bridge_depth=0.25;

label_power_offset=2;
label_hdmi_offset=25;
label_audio_offset=47;
label_ethernet_offset=9;
label_usb_offset=35;
label_dash1_adjust=12;
label_dash2_adjust=10;
label_dash_raise=1.5;
label_camera_offset=42;
label_camera_edge_offset=5.25;

camera_cable_width=20;
camera_cable_thickness=4;
camera_length_offset=43;
camera_width_offset=2;

function case_wall_thickness() = wall_thickness;
function case_dimensions() = [case_length,case_width,case_height];

module camera() {
    cube([camera_cable_thickness,camera_cable_width,cutout_depth]);
}

module camera_rails() {
    cube([rail_width,case_width,rail_depth]);
    translate([camera_cable_thickness+rail_width,0,0]) cube([rail_width,case_width,rail_depth]);
    difference() {
        translate([0,0,rail_depth-rail_bridge_depth]) cube([camera_cable_thickness+rail_width*2,case_width,rail_bridge_depth]);
        translate([rail_width,wall_thickness+camera_width_offset,0])
        camera();
    }
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

module screw_driver_hole() {
    cylinder(d=screw_driver_width,h=cutout_depth*2,$fn=10,center=true);
}

module screw_driver_hole_rails() {
    cube([rail_width,case_width,rail_depth]);
    translate([screw_driver_width+rail_width,0,0]) cube([rail_width,case_width,rail_depth]);
    difference() {
        translate([0,0,rail_depth-rail_bridge_depth]) cube([screw_driver_width+rail_width*2,case_width,rail_bridge_depth]);

        translate([
            0,
            rpi_screw_origin_width+wall_thickness,
            0
        ])
        union() {
            center_x = (rail_width*2+screw_driver_width)/2;
            translate([center_x,0,0]) screw_driver_hole();
            translate([center_x,rpi_screw_offset_width,0]) screw_driver_hole();
        }
    }
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
                case_length,
                case_width,
                case_height
            ]);

            union() {
                translate([wall_thickness,wall_thickness,wall_thickness])
                cube([case_int_length, case_int_width, case_int_height]);

                // translate([rpi_screw_origin_length,rpi_screw_origin_width,0])
                // union() {
                //     translate([0,0,0]) m2_5_screw_hole();
                //     translate([0,rpi_screw_offset_width,0]) m2_5_screw_hole();
                //     translate([rpi_screw_offset_length,0,0]) m2_5_screw_hole();
                //     translate([rpi_screw_offset_length,rpi_screw_offset_width,0]) m2_5_screw_hole();
                // }

                translate([rpi_origin_length,rpi_origin_width,rpi_origin_height+rpi_pcb_thickness])
                union() {
                    translate([case_int_length-rpi_origin_length,ethernet_offset,0]) ethernet();

                    translate([case_int_length-rpi_origin_length,usb1_offset,0]) usb();
                    translate([case_int_length-rpi_origin_length,usb2_offset,0]) usb();

                    translate([audio_jack_offset,0,0]) audio_jack();

                    translate([hdmi_offset,0,0]) hdmi();

                    translate([micro_usb_offset,0,0]) micro_usb();

                    if (camera_hole) {
                        translate([camera_length_offset,camera_width_offset,case_height/2])
                        camera();
                    }
                }

                translate([side_plate_offset_length,0,side_plate_offset_height]) cube([side_plate_width,side_plate_depth,side_plate_height]);
                #translate([case_length-back_plate_depth,back_plate_offset_width,back_plate_offset_height]) cube([back_plate_depth,back_plate_width,back_plate_height]);

                translate([
                    rpi_origin_length+rpi_screw_origin_length,
                    rpi_origin_width+rpi_screw_origin_width,
                    case_height
                ])
                union() {
                    translate([0,0,0]) screw_driver_hole();
                    translate([0,rpi_screw_offset_width,0]) screw_driver_hole();
                    translate([rpi_screw_offset_length,0,0]) screw_driver_hole();
                    translate([rpi_screw_offset_length,rpi_screw_offset_width,0]) screw_driver_hole();
                }
            }

            translate([0,0,case_height-etch_depth])
            union() {
                linear_extrude(height=etch_depth+1) {
                    translate([rpi_origin_length+etch_edge_offset,etch_edge_offset,0]) {
                        translate([label_power_offset,0,0]) text("POWER", size=etch_size);
                        translate([label_hdmi_offset,0,0]) text("HDMI", size=etch_size);
                        translate([label_audio_offset,0,0]) text("AUDIO", size=etch_size);
                    }

                    if (camera_hole) {
                        translate([rpi_origin_length-wall_thickness+etch_edge_offset+label_camera_offset,etch_edge_offset+label_camera_edge_offset,0])
                        rotate([0,0,90])
                        text("CAMERA", size=etch_size);
                    }

                    translate([case_length,0,0])
                    union() {
                        translate([-etch_edge_offset,etch_edge_offset,0]) {
                            translate([0,label_ethernet_offset,0])
                            rotate([0,0,90])
                            text("ETH", size=etch_size);

                            translate([0,label_usb_offset,0])
                            rotate([0,0,90])
                            text("USB", size=etch_size);

                            union() {
                                translate([-label_dash_raise,label_usb_offset-label_dash1_adjust,0]) square([1,10]);
                                translate([-label_dash_raise,label_usb_offset+label_dash2_adjust,0]) square([1,10]);
                            }
                        }
                    }
                }
            }
        }

        translate([
            rpi_screw_origin_length+rpi_origin_length,
            rpi_screw_origin_width+rpi_origin_width,
            wall_thickness
        ])
        union() {
            translate([0,0,0]) m2_5_spacer();
            translate([0,rpi_screw_offset_width,0]) m2_5_spacer();
            translate([rpi_screw_offset_length,0,0]) m2_5_spacer();
            translate([rpi_screw_offset_length,rpi_screw_offset_width,0]) m2_5_spacer();
        }

        // Special bridging for the camera hole
        if (camera_hole) {
            translate([rpi_origin_length+camera_length_offset-rail_width,0,case_height-wall_thickness-rail_depth])
            camera_rails();
        }

        // Special bridging for the screw driver holes
        translate([rpi_origin_length-wall_thickness,0,case_height-wall_thickness-rail_depth]) {
            translate([rpi_screw_origin_length,0,0]) screw_driver_hole_rails();
            translate([rpi_screw_origin_length+rpi_screw_offset_length,0,0]) screw_driver_hole_rails();
        }
    }
}

rpi3bplus(camera_hole=true);
