/* MONOPRICE MP MINI DELTA, TOWER SHIELD
   keep debris from falling through the towers into the printer's inner
   workings. Patterned after thetrebor's "Monoprice Mini Delta V2 Shield"
   (https://www.thingiverse.com/thing:2622002).

   (see https://github.com/aegean-odyssey/mpmd-tower-shield/)
*/
/* 
Copyright (c) 2020 Aegean Associates, Inc. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted (subject to the limitations in the disclaimer
below) provided that the following conditions are met:

     * Redistributions of source code must retain the above copyright notice,
     this list of conditions and the following disclaimer.

     * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.

     * Neither the name of the copyright holder nor the names of its
     contributors may be used to endorse or promote products derived from this
     software without specific prior written permission.

NO EXPRESS OR IMPLIED LICENSES TO ANY PARTY'S PATENT RIGHTS ARE GRANTED BY
THIS LICENSE. THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR
BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER
IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
POSSIBILITY OF SUCH DAMAGE.
*/   

/* 3D PRINTING
   layer height:    0.200mm
   supports:        not required
*/

A = 64.4; // center to center distance of tower screws
B = 7.0;  // distance from screw center to channel edge
C = 8.4;  // channel width (really, 2x slot center to inside edge)
D = 2.8;  // channel slot (tab) width
E = 4.0;  // channel slot (tab) depth
F = 16;   // flap height
G = 50;   // flap angle (degrees)
H = 6;    // bar height
t = 2.0;  // bar thickness
j = 1.4;  // flap thickness

module tower_shield() 
{
    xa = (A + B - C*cos(30))/2;
    xb = xa + C*cos(30);
    xc = xb + t*sin(30);
    xd = xa + t*sin(30);
    xe = xa;
    ya = 0;
    yb = ya + C*sin(30);
    yc = yb - t*cos(30);
    yd = ya - t*cos(30);
    ye = ya - t;
    bp = [[+xa,ya],[+xb,yb],[+xc,yc],[+xd,yd],[+xe,ye],
          [-xe,ye],[-xd,yd],[-xc,yc],[-xb,yb],[-xa,ya]];
    linear_extrude(H) polygon(bp);
    module T() { translate([-D/2,0]) cube([D,E,H]); }
    translate([-(xa+xb),(ya+yb)]/2) rotate(-30) T();
    translate([+(xa+xb),(ya+yb)]/2) rotate(+30) T();
    fa = xa - 1;
    fp = [[-fa,0],[-fa*7/8,F],[+fa*7/8,F],[+fa,0]];
    translate([0,j*sin(G)-t,H-j*cos(G)])
        rotate([G,0,0]) linear_extrude(j) polygon(fp);
}

module mouse_ears(layer_height=0.200, first_layer=0.200) 
{
    // loosely tied to the dimensions
    x = (A + B + C*cos(3))/2 - t;
    difference() {
        union() {
            translate([-x,t,0]) cylinder(d=14,h=layer_height+first_layer);
            translate([+x,t,0]) cylinder(d=14,h=layer_height+first_layer);
        }
        translate([0,0,-0.1]) linear_extrude(first_layer+0.1)
            offset(delta=0.4) projection() tower_shield();
    }
}

tower_shield();
