// Pixel separator for a LED matrix - (c) Bertrand Le Roy 2023

// Minimum size
$fs = 0.1;

// Number of rows
rows = 8;

// Number of columns
columns = 10;

// Pixel size
pixel_size = 4;

// Wall thickness
wall_thickness = 0.8;

// Height
height = 3;

// Anchor height
anchor_height = 0;

// Screw hole diameter
screw_hole_diameter = 3.8;

// Screw head diameter
screw_head_diameter = 6;

// Screw distance from matrix
screw_distance = 3.4;

// Top margin
top_margin = 0.334;

echo("Total height: ", rows * pixel_size + wall_thickness + top_margin);
echo("Total width: ", columns * pixel_size + 2 * screw_distance + wall_thickness);

union() {
    difference() {
        union() {
            hull() {
                translate([-screw_distance, screw_head_diameter / 2, 0])
                    cylinder(r = screw_head_diameter / 2, h = height);
                translate([columns * pixel_size + screw_distance + wall_thickness, screw_head_diameter / 2, 0])
                    cylinder(r = screw_head_diameter / 2, h = height);
                translate([-screw_distance, rows * pixel_size - screw_head_diameter / 2 + wall_thickness + top_margin, 0])
                    cylinder(r = screw_head_diameter / 2, h = height);
                translate([columns * pixel_size + screw_distance + wall_thickness, rows * pixel_size - screw_head_diameter / 2 + wall_thickness + top_margin, 0])
                    cylinder(r = screw_head_diameter / 2, h = height);
            }
        }
        for (row = [0 : rows - 1]) {
            for (column = [0 : columns - 1]) {
                translate([column * pixel_size + wall_thickness, row * pixel_size + wall_thickness, -1])
                    cube([pixel_size - wall_thickness, pixel_size - wall_thickness, height + 2]);
            }
        }
        translate([-screw_distance, screw_head_diameter / 2, -1])
            cylinder(r = screw_hole_diameter / 2, h = height + 2);
        translate([columns * pixel_size + screw_distance + wall_thickness, screw_head_diameter / 2, -1])
            cylinder(r = screw_hole_diameter / 2, h = height + 2);
        translate([-screw_distance, rows * pixel_size - screw_head_diameter / 2 + wall_thickness + top_margin, -1])
            cylinder(r = screw_hole_diameter / 2, h = height + 2);
        translate([columns * pixel_size + screw_distance + wall_thickness, rows * pixel_size - screw_head_diameter / 2 + wall_thickness + top_margin, -1])
            cylinder(r = screw_hole_diameter / 2, h = height + 2);
    }
    anchor_radius = wall_thickness * sqrt(2) / (sqrt(2) + 1);
    translate([anchor_radius, anchor_radius, height])
        cylinder(r = anchor_radius, h = anchor_height);
    translate([columns * pixel_size - anchor_radius + wall_thickness, anchor_radius, height])
        cylinder(r = anchor_radius, h = anchor_height);
    translate([columns * pixel_size - anchor_radius + wall_thickness, rows * pixel_size - anchor_radius + wall_thickness, height])
        cylinder(r = anchor_radius, h = anchor_height);
    translate([anchor_radius, rows * pixel_size - anchor_radius + wall_thickness, height])
        cylinder(r = anchor_radius, h = anchor_height);
}