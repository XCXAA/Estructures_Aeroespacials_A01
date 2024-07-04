function [x_2]=nodal_2(n_b,data,R_w,coord)

x_2=zeros(n_b,data.ni);

angle_i=2*pi/n_b;
angle=angle_i*3/2;
x_2(1,:)=[coord(1),coord(2)];

for i=2:n_b+1
    
    x_2(i,:)=[cos(angle)*R_w+coord(1),sin(angle)*R_w];
    angle=angle+angle_i;
end 