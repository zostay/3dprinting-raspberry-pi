m2_screw_width=2.5;

rpic_bounding_height=8.5;
rpic_bounding_length=24;
rpic_bounding_width=24.8;

rpic_camera_rise=5;

wall_thickness=2;

rpic_screw_edge_offset=1;
rpic_screw_center_offset=rpic_screw_edge_offset+m2_screw_width/2;
rpic_screw_midling_offset=14.5;

rpic_screw_wall_center_offset=rpic_screw_center_offset+wall_thickness;
rpic_screw_wall_midling_offset=rpic_screw_midling_offset+wall_thickness;

case_height=rpic_bounding_height+wall_thickness*2;
case_length=rpic_bounding_length+wall_thickness*2;
case_width=rpic_bounding_width+wall_thickness*2;

rpic_pinhole_length_center=14.5;
rpic_pinhole_width_center=rpic_bounding_width/2;
rpic_pinhole_diameter=7;

module m2_screw() {
    translate([0,0,case_height/2]) cylinder(h=case_height*2,d=m2_screw_width,$fn=10,center=true);
}

difference() {
    cube([case_width,case_length,case_height]);

    union() {
        translate([rpic_screw_wall_center_offset,case_length-rpic_screw_wall_center_offset,0]) m2_screw();
        translate([case_width-rpic_screw_wall_center_offset,case_length-rpic_screw_wall_center_offset,0]) m2_screw();
        translate([rpic_screw_wall_center_offset,case_length-rpic_screw_wall_midling_offset,0]) m2_screw();
        translate([case_width-rpic_screw_wall_center_offset,case_length-rpic_screw_wall_midling_offset,0]) m2_screw();

        translate([wall_thickness,-1,wall_thickness])
        cube([rpic_bounding_width,rpic_bounding_length+wall_thickness+1,rpic_bounding_height]);

        translate([wall_thickness+rpic_pinhole_width_center,wall_thickness+rpic_pinhole_length_center,case_height-wall_thickness])
        cylinder(h=wall_thickness*2,d=rpic_pinhole_diameter,$fn=15);
    }
}
