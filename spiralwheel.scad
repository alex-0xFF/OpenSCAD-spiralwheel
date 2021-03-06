/*
    Parametric airless tire
    by Travis Howse <tjhowse@gmail.com>
    alex-0xFF <https://github.com/alex-0xFF>
    2012-2020    License, GPL v2 or later
*/

dia_in = 8;
dia_out = 70;
spoke_count = 20;
spoke_thickness = 0.5;
tread_thickness = 1;
hub_thickness = 2;
hub_indent = 5;
height = 10;
$fn = 30;
spoke_dia = (dia_in/2) + hub_thickness + (dia_out/2) - tread_thickness+spoke_thickness;
grip_density = 0.1 ; //0..1 Set to 0 for no grip.
grip_height = 0.5;
grip_depth = 1;
pi = 3.1415926;
zff = 0.001;

//Set to 1 for a double spiral.
// Note: single-wall spokes probably won't work with double spirals, as the
// first layer of the upper spiral would bridge in a straight line, rather
// than a curve. Successive layers probably wouldn't recover.
double_spiral = 0;

module wheel()
{
    //rim
    difference()
    {
        cylinder(r=dia_out/2,h=height);
        cylinder(r=(dia_out/2)-tread_thickness,h=height);
    }

    //hub
    difference()
    {
        cylinder(r=(dia_in/2)+hub_thickness,h=height+hub_indent);
        cylinder(r=dia_in/2,h=height+hub_indent);
    }

    for (i = [0:spoke_count-1])
    {
        if (double_spiral)
        {
            rotate([0,0,i * (360/spoke_count)]) {
                translate([(spoke_dia/2)-(dia_in/2)-hub_thickness,0,(height/2)+zff]) spoke();
            }
            rotate([180,0,i * (360/spoke_count)]) {
                translate([(spoke_dia/2)-(dia_in/2)-hub_thickness,0,-height/2]) spoke();
            }
        } else {
            rotate([0,0,i * (360/spoke_count)]) {
                translate([(spoke_dia/2)-(dia_in/2)-hub_thickness,0,0]) spoke();
            }
        }
    }

    if (grip_density != 0)
    {
        for (i = [0:(360*grip_density)])
        {
            rotate([0,0,i*(360/(360*grip_density))]) {
                translate([dia_out/2-grip_height/2,0,0]) cube([grip_height,grip_depth,height]);
            }
        }
    }
}

module spoke()
{
    intersection()
    {
        difference()
        {
            cylinder(r=spoke_dia/2,h=height);
            cylinder(r=(spoke_dia/2)-spoke_thickness,h=height);
        }
        if (double_spiral)
        {
            translate([-spoke_dia/2,-spoke_dia,0]) cube([spoke_dia,spoke_dia,height/2]);
        } else {
            translate([-spoke_dia/2,-spoke_dia,0]) cube([spoke_dia,spoke_dia,height]);
        }
    }
}

wheel();
