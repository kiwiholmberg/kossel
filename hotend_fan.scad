include <configuration.scad>;

barrel_radius = 8;
barrel_height = 18;
pipe_radius = 3;
pipe_height = 12.5;
head_radius = 6;
head_height = 21;

groove_radius = 6;
groove_height = 4.6;

fan_offset = 15;

module hotend_fan() {
  difference() {
    union() {
      translate([0, 2 - fan_offset, 0])
        cylinder(r=21, h=40, $fn=6);
      translate([0, 0, groove_height/2]) //hotend groove
        cube([32, 22, groove_height], center=true);
    }
    // Opposite side cutaway (outgoing airflow).
    translate([0, 38, groove_height + 0.01]) rotate([0, 0, 30])
      cylinder(r=43, h=200, $fn=6);
    // Groove mount insert slot.
    translate([0, 10, 0])
      cube([2*groove_radius, 20, 20], center=true);
    // Keep printed plastic away from the hotend.
    intersection() {
      translate([0, 20, 0]) rotate([0, 0, 30])
        cylinder(r=33 , h=100, center=true, $fn=36);
      translate([0, 23, barrel_height-6])
        cylinder(r1=barrel_radius-1, r2=100, h=55, $fn=36);
        //cube([100, 100 ,barrel_height-6], center=true);
    }
    
    // Groove mount.
    cylinder(r=groove_radius, h=200, center=true, $fn=24);
    // J-Head barrel.
    translate([0, 0, groove_height + 0.02])
      cylinder(r=barrel_radius + 1, h=100, $fn=24);
    // Fan mounting surface and screws.
    translate([0, -50 - fan_offset, 0])
      cube([100, 100, 100], center=true);
    for (x = [-16, 16]) {
      for (z = [-16, 16]) {
        translate([x, -fan_offset, z+20]) rotate([90, 0, 0]) #
          cylinder(r=m3_radius, h=16, center=true, $fn=12);
      }
    }
    // Vertical inner space. lol this doesnt do anything? :D 
    //intersection() {
      //cube([12, 100, 50], center=true);
      //translate([0, 12, groove_height + 2])
        //cylinder(r=16, h=40, $fn=6);
    //}
    // Air funnel.
    difference() {
      translate([0, -1 - fan_offset, 20]) rotate([-90, 0, 0])
        cylinder(r1=20, r2=0, h=20, $fn=36);
      cube([8, 40, 10], center=true); //center fasting with screw hole to baseplate.
    }
    for (a = [60:60:359]) { 
      rotate([0, 0, a]) translate([0, 12.5, 5]) #
        cylinder(r=m3_radius, h=12, center=true, $fn=12);
    }
    //Cut the sides so they align with the fan.
    translate([25,0,0])
      cube([10,100,100], center=true);
    translate([-25,0,0])
      cube([10,100,100], center=true);
  }
}

hotend_fan();

// Hotend barrel.
translate([0, 0, groove_height]) %
  cylinder(r=barrel_radius, h=barrel_height);

// 40mm fan.
translate([0, -5 - fan_offset, 20]) % difference() {
  cube([40, 10, 40], center=true);
  rotate([90, 0, 0,]) cylinder(r=19, h=20, center=true);
}
//Pipe between hotend cold and warm side.
translate([0,0,barrel_height+groove_height]) %
  cylinder(r=pipe_radius, h=pipe_height, $fn=90);
//Hotend head.
translate([0, 4 + barrel_radius , barrel_height+groove_height+pipe_height+(head_radius)]) rotate([90,0,0], center=true) %
  cylinder(r=head_radius,h=head_height, $fn=64);