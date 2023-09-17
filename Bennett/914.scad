//Bennett Type Element
//September 14, 2023
//Leonard Chau



/* [Character Details] */
LAYOUT=["qweruiopasdftyjkl,zxcvghbnm.",
        "QWERUIOPASDFTYJKL,ZXCVGHBNM.",
        "12347890\"#$%56;?:,£@_(&-)/'."];
CharLegend=[12,22,3,11,21,2,10,20,1,9,19,0,8,18,27,17,7,26,16,6,25,15,5,24,14,4,23,13];

//Custom Layout As Seen on Keyboard. Left to Right, Top to Bottom
Lowercase="";
Uppercase="";
Figs="";
CUSTOMLAYOUT=[Lowercase,Uppercase,Figs];
//Use Custom Layout?
Custom_Layout=false;
Layout= Custom_Layout==false ? LAYOUT : CUSTOMLAYOUT;
//Typeface
Typeface_="Libertinus Mono";
Type_Size=2.85;//[1:.05:10]
//Speedy Preview and Render with No Minkowski
Debug_No_Minkowski=true;

//Max Minimum Diameter Across 2 Concave Characters
Min_Final_Character_Diameter=32.9;
//Platen Diameter
Platen_Diameter=30;

/* [Element Details] */
//Element Diameter
Element_Diameter=31.9;
//Element Height
Element_Height=18.65;
//Shaft Diameter
Shaft_Diameter=3.483;
//Element Positioner Pin Diameter
Element_Positioner_Pin_Diameter=2.464;
//Element Positioner Pin - Radial Position
Element_Positioner_Pin_Radius=4.813;
//Indicator Hole Diameter
Indicator_Diameter=2.2;
//Alignment Pin Hole Diameter
Alignment_Hole_Diameter=1.94;
//Alignment Hole Depth
Alignment_Hole_Depth=2.4;
//Alignment Hole Chamfer Size
Alignment_Hole_Chamfer=.2;
//Speed Hole Diameter
Speed_Hole_Diameter=6.1;
//Speed Hole - Radial Position
Speed_Hole_Radius=10.801;
//Number of Speed Holes
Speed_Hole_Quantity=8;
//Countersink Diameter
Countersink_Diameter=23.4;
//Top Countersink Depth
Top_Countersink_Depth=1.85;
//Bottom Countersink Depth
Bottom_Countersink_Depth=1.3;
//Minimum Cylinder Thickness
Shell_Size=1;

/* [Character Placement Details] */
//[Lowercase, Uppercase, Figures] Row Height
Baseline=[15.05,9,2.95];//[-1:.05:1]
//[Lowercase, Uppercase, Figures] Row Height Offset
Baseline_Offset=[0,0,0];//[-1:.05:1]
//[Lowercase, Uppercase, Figures] Platen Cutout Height
Cutout=[17,10.95,4.9];//[-1:.05:1]
//[Lowercase, Uppercase, Figures] Platen Cutout Height Offset
Cutout_Offset=[0,0,0];//[-1:.05:1]
//[Lowercase, Uppercase, Figures] Alignment Hole Height
Alignment_Hole=[13.29,7.24,1.19];//[-1:.05:1]
//[Lowercase, Uppercase, Figures] Alignment Hole Height Offset
Alignment_Hole_Offset=[0,0,0];//[-1:.05:1]

/* [Resin Print Support] */
//Generate Print Support?
Generate_Support=true;//
//Resin Support Cut Groove Thickness
Resin_Support_Cut_Groove_Thickness=.1;
//Resin Support Height
Resin_Support_Height=6;
//Resin Support Chamfer Size
Resin_Support_Thickness=2;
//Resin Support Cut Groove Diameter
Resin_Support_Cut_Groove_Diameter=.75;
//Resin Support Wire Thickness
Resin_Support_Wire_Thickness=.6;

$fn=180;

module LetterText (SomeElement_Diameter,SomeBaseline,SomeBaseline_Offset,SomeCutout,SomeCutout_Offset, SomeTypeface_,SomeType_Size,SomeChar,SomeTheta,SomePlaten_Diameter,SomeMin_Final_Character_Diameter,SomeDebug){
    $fn = $preview ? 12 : 24;
    
    minkowski(){
        difference(){
            translate([cos(SomeTheta)*SomeElement_Diameter/2,sin(SomeTheta)*SomeElement_Diameter/2,SomeBaseline+SomeBaseline_Offset])
            rotate([90,0,90+SomeTheta])
            mirror([1,0,0])
            linear_extrude(2)
            text(SomeChar,size=SomeType_Size,halign="center",valign="baseline",font=SomeTypeface_);
            translate([cos(SomeTheta)*(SomePlaten_Diameter/2+SomeMin_Final_Character_Diameter/2),sin(SomeTheta)*(SomePlaten_Diameter/2+SomeMin_Final_Character_Diameter/2),SomeCutout+SomeCutout_Offset])
            rotate([90,0,SomeTheta])
            cylinder(h=5,d=SomePlaten_Diameter,center=true,$fn=$preview ? 60 : 360);
        }
        if (SomeDebug!=true)
            rotate([0,-90,SomeTheta])
            cylinder(h=1.5,r2=.75,r1=0,$fn=6);
    }
}


union(){
    difference(){
        union(){
            for (row=[0:1:len(Layout)-1]){
                for (n=[0:1:len(Layout[0])-1]){
                    PickedChar=CharLegend[n];
                    theta=-(360/(len(Layout[0]))*n+360/(2*28));
                    if (Layout[row][PickedChar] != " "){
                        LetterText(Element_Diameter-1,Baseline[row],Baseline_Offset[row],Cutout[row],Cutout_Offset[row],Typeface_,Type_Size,Layout[row][PickedChar],theta,Platen_Diameter,Min_Final_Character_Diameter,Debug_No_Minkowski);
                    }
                }
            }
            cylinder(h=Element_Height,d=Element_Diameter);
        }
        translate([0,0,Element_Height])
        cylinder(h=5,d=Element_Diameter);
        translate([0,0,-.001]){
            cylinder(h=Element_Height+2*.001,d=Shaft_Diameter);
            cylinder(h=Bottom_Countersink_Depth,d=Countersink_Diameter);
            for (n=[0:1:7]){
                theta=360/Speed_Hole_Quantity*n+360/(Speed_Hole_Quantity*2);
                translate([Speed_Hole_Radius*cos(theta),Speed_Hole_Radius*sin(theta),0])
                cylinder(h=Element_Height+2*.001,d=Speed_Hole_Diameter);
            }
            for (n=[0:1:1]){
                theta=180*n+90;
                translate([Element_Positioner_Pin_Radius*cos(theta),Element_Positioner_Pin_Radius*sin(theta),0])
                cylinder(h=Element_Height+2*.001,d=Element_Positioner_Pin_Diameter);
            }
        }
        translate([0,0,Element_Height-Top_Countersink_Depth])
        cylinder(h=Top_Countersink_Depth+.001,d=Countersink_Diameter);
        rotate_extrude(){
            polygon([[Shaft_Diameter/2+Shell_Size, Bottom_Countersink_Depth+Shell_Size], [Shaft_Diameter/2+Shell_Size, Element_Height-Top_Countersink_Depth-Shell_Size], [Element_Diameter/2-Shell_Size, Element_Height-Top_Countersink_Depth-Shell_Size], [Element_Diameter/2-Shell_Size, Bottom_Countersink_Depth+Shell_Size]]);
        }
        translate([Element_Diameter/2-Shell_Size-Indicator_Diameter/2,0,Element_Height-Top_Countersink_Depth-Shell_Size-.001])
        cylinder(h=5,d=Indicator_Diameter);
    //ALIGNMENT HOLES
    for (row=[0:1:len(Layout)-1]){
        for (n=[0:1:len(Layout[0])-1]){
            theta=-(360/(len(Layout[0]))*n+360/(2*28));
            translate([(Element_Diameter)/2*cos(theta),(Element_Diameter)/2*sin(theta),Alignment_Hole[row]])
            rotate([0,-90,theta]){
                cylinder(h=Alignment_Hole_Depth-Alignment_Hole_Diameter/2,d=Alignment_Hole_Diameter);
                translate([0,0,-1])
                cylinder(h=1,d=Alignment_Hole_Diameter+2*Alignment_Hole_Chamfer);
                cylinder(h=Alignment_Hole_Chamfer,d1=Alignment_Hole_Diameter+2*Alignment_Hole_Chamfer,d2=Alignment_Hole_Diameter);
                }
            translate([((Element_Diameter/2)-Alignment_Hole_Depth+Alignment_Hole_Diameter/2)*cos(theta),((Element_Diameter/2)-Alignment_Hole_Depth+Alignment_Hole_Diameter/2)*sin(theta),Alignment_Hole[row]])
            sphere(d=Alignment_Hole_Diameter);
        }
    }
    }

    translate([0,0,-Resin_Support_Height+.001]){
        difference(){
            cylinder(d=Element_Diameter, h=Resin_Support_Height);
            translate([0,0,-.001])
            cylinder(h=Resin_Support_Height+2*.001, r=Element_Diameter/2-Resin_Support_Cut_Groove_Diameter/2-Resin_Support_Cut_Groove_Thickness);
            rotate_extrude(){
                translate([Element_Diameter/2,Resin_Support_Height-Resin_Support_Cut_Groove_Diameter/2])
                circle(r=Resin_Support_Cut_Groove_Diameter/2);
            }
        }
    
        rotate_extrude(){
            polygon([[Element_Diameter/2,0], [Element_Diameter/2-Resin_Support_Thickness,0], [Element_Diameter/2-Resin_Support_Thickness,Resin_Support_Thickness], [Element_Diameter/2+Resin_Support_Thickness,Resin_Support_Thickness]]);
        }
        for (n=[0:1:7]){
            theta=360/8*n;
            translate([(Countersink_Diameter+Resin_Support_Wire_Thickness)/2*cos(theta),(Countersink_Diameter+Resin_Support_Wire_Thickness)/2*sin(theta),0]){
                cylinder(h=Resin_Support_Height-1,r=Resin_Support_Wire_Thickness);
                translate([0,0,Resin_Support_Height-1])
                cylinder(h=1, r2=.3, r1=Resin_Support_Wire_Thickness);
                cylinder(h=Resin_Support_Thickness,r2=Resin_Support_Thickness,r1=1.2);
            }
            
            translate([Countersink_Diameter*cos(theta)/3,Countersink_Diameter*sin(theta)/3,0]){
            cylinder(h=Resin_Support_Height+Bottom_Countersink_Depth-1,r=Resin_Support_Wire_Thickness);
            translate([0,0,Resin_Support_Height+Bottom_Countersink_Depth-1])
            cylinder(h=1, r2=.3, r1=Resin_Support_Wire_Thickness);
            cylinder(h=Resin_Support_Thickness,r2=Resin_Support_Thickness,r1=1.2);
            }
        }
        for (n=[0:1:3]){
            theta=90*n;
            translate([(Shaft_Diameter/2+1)*cos(theta),(Shaft_Diameter/2+1)*sin(theta),0]){
            cylinder(h=Resin_Support_Height+Bottom_Countersink_Depth-1,r=Resin_Support_Wire_Thickness);
            translate([0,0,Resin_Support_Height+Bottom_Countersink_Depth-1])
            cylinder(h=1, r2=.3, r1=Resin_Support_Wire_Thickness);
            cylinder(h=Resin_Support_Thickness,r2=Resin_Support_Thickness,r1=1.2);
            }
        }
    
    }
 
}
//ADD RESIN SUPPORT