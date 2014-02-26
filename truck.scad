//inches
truck_base_hole_w_in = 1.625;
truck_base_hole_l_in = 2.5;  //2.125 for new school

truck_base_hole_w = truck_base_hole_w_in * 25.4;
truck_base_hole_l = truck_base_hole_l_in * 25.4;

truck_base_l = truck_base_hole_l + 12;
truck_base_w = truck_base_hole_w + 12;

base_plate_hole_dia = 4.7625;

module base_plate_2d() {
	difference() {
		square([truck_base_w, truck_base_l], center=true);
		translate([-truck_base_hole_w/2, -truck_base_hole_l/2]) circle(base_plate_hole_dia/2);
		translate([truck_base_hole_w/2, -truck_base_hole_l/2]) circle(base_plate_hole_dia/2);
		translate([truck_base_hole_w/2, truck_base_hole_l/2]) circle(base_plate_hole_dia/2);
		translate([-truck_base_hole_w/2, truck_base_hole_l/2]) circle(base_plate_hole_dia/2);
	}
}

housing_id = 23;
housing_od = 60;

module housing_2d() {
	difference() {
		circle(housing_od/2);
		circle(housing_id/2);
	}
}

base_plate_thick = 8;

module base_plate() {
	linear_extrude(height=base_plate_thick) base_plate_2d();
}

housing_w = truck_base_w;
inset = 5;

module housing() {
	rotate([0,90,0])
	translate([-housing_od/2-base_plate_thick+inset,0,-housing_w/2])
	linear_extrude(height=housing_w) {
		housing_2d();
	}
}

housing();
base_plate();

