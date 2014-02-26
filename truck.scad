//inches
truck_base_hole_w_in = 1.625;
truck_base_hole_l_in = 2.5;  //2.125 for new school

truck_base_hole_w = truck_base_hole_w_in * 25.4;
truck_base_hole_l = truck_base_hole_l_in * 25.4;

truck_base_l = truck_base_hole_l + 12;
truck_base_w = truck_base_hole_w + 12;

//##################### BASE PLATE ####################

base_plate_hole_dia = 4.7625;
base_plate_thick = 8;

module base_plate_2d() {
	difference() {
		square([truck_base_w, truck_base_l], center=true);
		translate([-truck_base_hole_w/2, -truck_base_hole_l/2]) circle(base_plate_hole_dia/2);
		translate([truck_base_hole_w/2, -truck_base_hole_l/2]) circle(base_plate_hole_dia/2);
		translate([truck_base_hole_w/2, truck_base_hole_l/2]) circle(base_plate_hole_dia/2);
		translate([-truck_base_hole_w/2, truck_base_hole_l/2]) circle(base_plate_hole_dia/2);
	}
}

module base_plate() {
	linear_extrude(height=base_plate_thick) base_plate_2d();
}

//###################### HOUSING ######################

housing_id = 23;
housing_od = 50;
inset = 5;
housing_w = truck_base_w;

module housing_2d() {
	difference() {
		hull() {
			circle(housing_od/2);
			translate([housing_od/2+base_plate_thick-inset-1,0,0]) 
				square([1,housing_od],center=true);
		}
		circle(housing_id/2);
	}
}

module housing() {
	rotate([0,90,0])
	translate([-housing_od/2-base_plate_thick+inset,0,-housing_w/2])
	linear_extrude(height=housing_w) {
		housing_2d();
	}
}

//####################### MAIN ########################

housing();
base_plate();

