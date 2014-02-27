$fn = 80;

demo = true;
//exploded = true;

//inches
truck_base_hole_w_in = 1.625;
truck_base_hole_l_in = 2.5;  //2.125 for new school

truck_base_hole_w = truck_base_hole_w_in * 25.4;
truck_base_hole_l = truck_base_hole_l_in * 25.4;
echo ("Width: ",truck_base_hole_w,"Length: ",truck_base_hole_l);

truck_base_l = truck_base_hole_l + 12;
truck_base_w = truck_base_hole_w + 12;

//Axle params
center_dia = 19;
center_w = 5;

major_dia = 12.7;
major_len = 350;

minor_dia = 10;
minor_len = 412;

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

housing_id = 32.25;
housing_od = 50;
inset = 6;
//housing_w = 41;//truck_base_w;
housing_w = truck_base_w;

face_plate_hole_dia = base_plate_hole_dia;
number_of_holes = 10;
fudge_angle = 18;
lock_out=2;
face_thick = 8;
axle_slop=0.5;
face_slop=0.5;
bushing_squisher=6;

module housing_2d() {
	difference() {
		hull() {
			circle(housing_od/2);
			translate([housing_od/2+base_plate_thick-inset-1,0,0]) 
				square([1,housing_od],center=true);
		}
		circle(housing_id/2);
		for(i=[0:2:number_of_holes-1]) {
			rotate(i * 360 / number_of_holes + fudge_angle, [0, 0, 1])
				translate([0,(housing_od/2-housing_id/2)/2+housing_id/2,0]) circle(face_plate_hole_dia/2);
		}
	}
}

module housing() {
	rotate([0,90,0])
	translate([-housing_od/2-base_plate_thick+inset,0,-housing_w/2])
	linear_extrude(height=housing_w) {
		housing_2d();
	}
}

module face_plate_2d() {
	difference() {
		circle(housing_od/2);
		for(i=[0:number_of_holes-1]) {
			rotate(i * 360 / number_of_holes + fudge_angle, [0, 0, 1])
				translate([0,(housing_od/2-housing_id/2)/2+housing_id/2,0]) circle(face_plate_hole_dia/2);
		}
	}	
}

module face_plate() {
	slot_rad = major_dia/2+axle_slop;
	rotate([0,90,0]) {
		difference() {
			union() {
				linear_extrude(height=face_thick,center=true)
					face_plate_2d();
				translate([0,0,face_thick/2]) 
					cylinder(r1=housing_id/2-face_slop,r2=housing_id/2-face_slop,bushing_squisher);
			}
			translate([0,0,bushing_squisher/2])
			linear_extrude(height=face_thick+1+bushing_squisher*2,center=true) {
				hull() { 
					translate([housing_id/2-slot_rad-lock_out,0,0]) circle(slot_rad);
					translate([-(housing_id/2-slot_rad-lock_out),0,0]) circle(slot_rad);
				}
			}
		}
	}
}

//####################### DEMO ########################

module axle() {
	color("LightGrey", 1){
		translate([0,0,housing_od/2+base_plate_thick-inset]) 
			rotate([0,90,0]) cylinder(r1=center_dia/2, r2=center_dia/2,center_w,center=true);
		translate([0,0,housing_od/2+base_plate_thick-inset]) 
			rotate([0,90,0]) cylinder(r1=major_dia/2, r2=major_dia/2,major_len,center=true);
		translate([0,0,housing_od/2+base_plate_thick-inset]) 
			rotate([0,90,0]) cylinder(r1=minor_dia/2, r2=minor_dia/2,minor_len,center=true);
	}
}

module bushing() {
	//9.8103 Energy Suspension
	od = 1.25 * 25.4;
	id = 7/16 * 25.4;
	nip_w = 7/8 * 25.4;
	nip_h = .1 * 25.4;
	l = .75 * 25.4 - nip_h;

	module left() {
		translate([-l/2-center_w,0,housing_od/2+base_plate_thick-inset])
		rotate([0,90,180])
		difference() {
			union() {
				cylinder(r1=od/2, r2=od/2, l,center=true);
				translate([0,0,-l/2-nip_h/2]) cylinder(r1=nip_w/2, r2=nip_w/2, nip_h,center=true);
			}
			cylinder(r1=id/2, r2=id/2, l+2+nip_h*2,center=true);
		}
	}

	module right() {
		translate([-(-l/2-center_w),0,housing_od/2+base_plate_thick-inset])
		rotate([0,90,180])
		difference() {
			union() {
				cylinder(r1=od/2, r2=od/2, l,center=true);
				translate([0,0,-(-l/2-nip_h/2)]) cylinder(r1=nip_w/2, r2=nip_w/2, nip_h,center=true);
			}
			cylinder(r1=id/2, r2=id/2, l+2+nip_h*2,center=true);
		}
	}

	color("OrangeRed",0.25) {
		if(exploded) {
			translate([-30,0,0]) left();
			translate([30,0,0]) right();
		} else {
			left();
			right();
		}
	}
}


if(demo) {
	//rotate([0,7,6])
	axle();
	bushing();
}

//####################### MAIN ########################

module assembly() {
	color("gold", 0.25) {
		housing();
		base_plate();
	}

	color("DarkGreen",0.75) {
		translate([housing_w/2+face_thick/2,0,housing_od/2+base_plate_thick-inset]) rotate([36*1,0,180]) face_plate();
		translate([-(housing_w/2+face_thick/2),0,housing_od/2+base_plate_thick-inset]) rotate([36*1,0,0]) face_plate();
	}
}

module exploded() {
	color("gold", 0.25) {
		housing();
		base_plate();
	}

	color("DarkGreen",0.75) {
		translate([housing_w/2+face_thick/2+40,0,housing_od/2+base_plate_thick-inset]) rotate([-36*1,0,180]) face_plate();
		translate([-(housing_w/2+face_thick/2+40),0,housing_od/2+base_plate_thick-inset]) rotate([36*1,0,0]) face_plate();
	}
}

if(exploded) {
	exploded();
} else {
	assembly();
}