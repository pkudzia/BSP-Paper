% This code takes stl files and outputs the interial paramters correspond
% to the geometry of the point cloud.

% this code will run on its own just give it the propoer locations of the
% File save location and STL files from this github. 

% Files corresponding to 16 body segements used in the model make sure they
% are in correct folder corresponding to the location 'Stl_location...You can see that
%the file names have been named a specifc way here. If you names do not
%reflect this naming scheme this will not run. Either modify you names or
%modify this section of the code to match what you have. If you choose to
%use less or more files some small modification will also need to be made. 

% Written by Pawel Kudzia

clear;
%% Modify This Section FIRST 
File=['/Users/pawelkudzia/Documents/GitHub/Paper-BodySegmentParameter/MATLAB Files/Results_STL/' 'example']; % Excel Location of save Example || File=['C:\Users\Wyss User\Desktop\BSIP\' Code]
Stl_Location = '/Users/pawelkudzia/Documents/GitHub/Paper-BodySegmentParameter/MATLAB Files/Example_STL1/';% Location of the STL Files that the matlab will process must end with \ -> Example || 'C:\Users\Wyss User\Desktop\BSIP\SAMPLE_STL\'

%% File Names (Headings)
%Used for Figure titles and labeling ..
name{1} = '\bf \fontname{Gothic} \fontsize{12} Head'; 
name{2} = '\bf \fontname{Gothic} \fontsize{12} UpperTorso';
name{3} = '\bf \fontname{Gothic} \fontsize{12} Abdomen'; 
name{4}= '\bf \fontname{Gothic} \fontsize{12} Pelvis';
name{5} = '\bf \fontname{Gothic} \fontsize{12} LeftThigh'; 
name{6} = '\bf \fontname{Gothic} \fontsize{12} LeftShank';
name{7} = '\bf \fontname{Gothic} \fontsize{12}  LeftFoot'; 
name{8} ='\bf \fontname{Gothic} \fontsize{12} RightThigh';
name{9} = ' \bf \fontname{Gothic} \fontsize{12} RightShank'; 
name{10} = '\bf \fontname{Gothic} \fontsize{12} RightFoot';
name{11} ='\bf \fontname{Gothic} \fontsize{12} LeftUpperArm' ;
name{12} = '\bf \fontname{Gothic} \fontsize{12} LeftForearm';
name{13} = '\bf \fontname{Gothic} \fontsize{12} LeftHand'; 
name{14} = '\bf \fontname{Gothic} \fontsize{12} RightArm';
name{15} = '\bf \fontname{Gothic} \fontsize{12} RightForearm'; 
name{16}= '\bf \fontname{Gothic} \fontsize{12} RightHand';
%% Titles used for Segments 
Title{1} = 'Head'; 
Title{2} = 'UpperTorso'; 
Title{3} = 'Abdomen'; 
Title{4}= 'Pelvis';
Title{5} = 'LeftThigh'; 
Title{6} = 'LeftShank';
Title{7} = ' LeftFoot';
Title{8} ='RightThigh';
Title{9} = ' RightShank'; 
Title{10} = 'RightFoot';
Title{11} ='LeftUpperArm' ;
Title{12} = 'LeftForearm';
Title{13} = 'LeftHand'; 
Title{14} = 'RightArm';
Title{15} = 'RightForearm'; 
Title{16}= 'RightHand';

%% Import File Names
% Files corresponding to 16 body segements used in the model make sure they
% are in correct folder corresponding to the location 'Stl_location...You can see that
%the file names have been named a specifc way here. If you names do not
%reflect this naming scheme this will not run. Either modify you names or
%modify this section of the code to match what you have 

file{1}  = [Stl_Location '1_Head.stl'];
file{2}  = [Stl_Location '1_UpperTorso.stl'];
file{3}  = [Stl_Location '1_Ab.stl'];
file{4}  = [Stl_Location '1_Pelvis.stl'];
file{5}  = [Stl_Location '1_LeftThigh.stl'];
file{6}  = [Stl_Location '1_LeftShank.stl'];
file{7}  = [Stl_Location '1_LeftFoot.stl'];
file{8}  = [Stl_Location '1_RightThigh.stl'];
file{9}  = [Stl_Location '1_RightShank.stl'];
file{10} = [Stl_Location '1_RightFoot.stl'];
file{11} = [Stl_Location '1_LeftArm.stl'];
file{12} = [Stl_Location '1_LeftForearm.stl'];
file{13} = [Stl_Location '1_LeftHand.stl'];
file{14} = [Stl_Location '1_RightArm.stl'];
file{15} = [Stl_Location '1_RightForearm.stl'];
file{16} = [Stl_Location '1_RightHand.stl'];

%file{17} = [Stl_location 'Full_Body_NotSegmented']; & Optional to run with
%a full body not segemnted model 

%% Create .Iv Files for all fo the segments being imported.
% This is just a fancy file structure used for point cloud data. aka in
% this case 'stl files. 

for i = 1:length(file)
ReadMe = file{i};  

try
[stlcoords] = READ_stl(ReadMe); % Note Read_Stl is taken from Matlab community website 
catch 
   msg ='Invalid File Name or Defined Location/Folder- Double check if folder (STL_Location) is correctly defined';
   error(msg)
end

xco = squeeze( stlcoords(:,1,:) )';
yco = squeeze( stlcoords(:,2,:) )';
zco = squeeze( stlcoords(:,3,:) )';
[hpat] = patch(xco,yco,zco,'b'); 

pts{i} = get(hpat,'Vertices');
cnt{i} = get(hpat,'Faces');

FileName = ([Stl_Location 'Segment_' num2str(i) '.iv'] );
patch2iv(pts{i},cnt{i},FileName);

close all
clear stlcoords xco yco zco hpat     
end 
%% Extract GeoMetric Properties of 
for i = 1:length(file)
FileName = ([Stl_Location 'Segment_' num2str(i) '.iv'] );
[Centroid{i},SurfaceArea{i},Volume{i},CoM_ev123{i},CoM_eigenvectors{i},I1{i},I2{i},I_CoM{i},I_origin{i},patches{i}] = mass_properties(FileName);

A = CoM_eigenvectors{i}*CoM_eigenvectors{i}'; % Global Axis 
p1{i} = Centroid{i};
p2{i} = 1000000 * A(:,1)' + Centroid{i};
p3{i} = 1000000 * A(:,2)' + Centroid{i};
p4{i} = 1000000 * A(:,3)' + Centroid{i};
end 

for i = 5:16 % NOTE different orientation for the first 1 segements [ head +trunk] Explained in reference documenet 
A = CoM_eigenvectors{i};
p1{i} = Centroid{i};
p2{i} = 1000000 * A(:,1)' + Centroid{i};
p3{i} = 1000000 * A(:,2)' + Centroid{i};
p4{i} = 1000000 * A(:,3)' + Centroid{i};
end
%% Find Intersections
% Determines the proximal and distal intersections of a long. vecotor
% originating at the COM of the segement. 

Processed_iv_file_ = 0;
for aa = 1:length(file)
    
    for i = 1:length(cnt{aa})
        pa = pts{aa}(cnt{aa}(i,1),:);
        pb = pts{aa}(cnt{aa}(i,2),:);
        pc = pts{aa}(cnt{aa}(i,3),:);

        [intersect(i,1) p(i,1:3)] = intersect_line_facet(p1{aa},p2{aa}, pa,pb,pc);
        [intersect(i,2) p(i,4:6)] = intersect_line_facet(p1{aa},-p2{aa}, pa,pb,pc);
        [intersect(i,3) p(i,7:9)] = intersect_line_facet(p1{aa},p3{aa}, pa,pb,pc);
        [intersect(i,4) p(i,10:12)] = intersect_line_facet(p1{aa},-p3{aa}, pa,pb,pc);
        [intersect(i,5) p(i,13:15)] = intersect_line_facet(p1{aa},p4{aa}, pa,pb,pc);
        [intersect(i,6) p(i,16:18)] = intersect_line_facet(p1{aa},-p4{aa}, pa,pb,pc);
    end
    
I(1) = find(intersect(:,1) == 1);
I(2) = find(intersect(:,2) == 1);
I(3) = find(intersect(:,3) == 1);
I(4) = find(intersect(:,4) == 1);
I(5) = find(intersect(:,5) == 1);
I(6) = find(intersect(:,6) == 1);

I = I';

% Interesection in each direction 
top{aa} = p(I(1),1:3); 
bottom{aa}= p(I(2),4:6);
side1{aa}= p(I(3),7:9); 
side2{aa}= p(I(4),10:12);
side3{aa}= p(I(5),13:15); 
side4{aa}= p(I(6),16:18);

Markers{aa}=  [top{aa};bottom{aa};side1{aa};side2{aa};side3{aa};side4{aa}]';

Processed_iv_file_ = Processed_iv_file_+1 

clear pa pb pc intersect p I
end

%% Graphing of the Torso and head Region 
% The following figures can be changed to meet desired outputs

for i = 1:4
 figure(1) 
 view ([1 1 1])
 subplot(2,3,[2,5])
  
axis equal
[stl] = stlread(file{i});
plot3(stl(:,1),stl(:,2),stl(:,3),'.b','MarkerSize',4); 
axis equal 
hold on
grid on

plot3(Markers{i}(1,1),Markers{i}(2,1), Markers{i}(3,1), '.k','MarkerSize',20); 
plot3(Markers{i}(1,2),Markers{i}(2,2), Markers{i}(3,2), '.k','MarkerSize',20); 
plot3(Markers{i}(1,3),Markers{i}(2,3), Markers{i}(3,3), '.k','MarkerSize',20); 
plot3(Markers{i}(1,4),Markers{i}(2,4), Markers{i}(3,4), '.k','MarkerSize',20); 
plot3(Markers{i}(1,5),Markers{i}(2,5), Markers{i}(3,5), '.k','MarkerSize',20); 
plot3(Markers{i}(1,6),Markers{i}(2,6), Markers{i}(3,6), '.k','MarkerSize',20); 

Line1 = [top{i};bottom{i}];
Line2 = [side1{i};side2{i}];
Line3 = [side3{i};side4{i}];
    
title('\bf \fontname{Gothic} \fontsize{18} Upper Body' );
clear stl 
end 

%Uper body 
for i = 1:4
 figure(1) 
 set(gcf,'units','normalized','outerposition',[0 0 1 1])
 view ([1 1 1])
 
 if (i==1)
 subplot(3,3,1)
 elseif (i==2)
  subplot(3,3,4)
 elseif (i==3)
  subplot(3,3,7)
 else 
  subplot(3,3,9)
 end
  
axis equal
axis off
axis tight

[stl] = stlread(file{i});
plot3(stl(:,1),stl(:,2),stl(:,3),'.b','MarkerSize',4); 

axis equal 
hold on
grid on

plot3(Markers{i}(1,1),Markers{i}(2,1), Markers{i}(3,1), '.k','MarkerSize',20); 
plot3(Markers{i}(1,2),Markers{i}(2,2), Markers{i}(3,2), '.k','MarkerSize',20); 
plot3(Markers{i}(1,3),Markers{i}(2,3), Markers{i}(3,3), '.k','MarkerSize',20); 
plot3(Markers{i}(1,4),Markers{i}(2,4), Markers{i}(3,4), '.k','MarkerSize',20); 
plot3(Markers{i}(1,5),Markers{i}(2,5), Markers{i}(3,5), '.k','MarkerSize',20); 
plot3(Markers{i}(1,6),Markers{i}(2,6), Markers{i}(3,6), '.k','MarkerSize',20); 

Line1 = [top{i};bottom{i}];
Line2 = [side1{i};side2{i}];
Line3 = [side3{i};side4{i}];
line(Line1(:,1), Line1(:,2), Line1(:,3),'Color','r', 'LineWidth',5);
line(Line2(:,1), Line2(:,2), Line2(:,3),'Color','g', 'LineWidth',5);
line(Line3(:,1), Line3(:,2), Line3(:,3),'Color','b', 'LineWidth',5);
    
Len = round(pdist(Line1));
Limb_Length{i} = (round(pdist(Line1)));
title( {name{i};['\bf \fontname{Gothic} \fontsize{10} Long Length =',num2str(Len),'mm']});
clear stl 
end 
%% Graphing of the Lower Body [Legs] 
for i = 5:10    
figure(2) 
view ([1 1 1])
subplot(3,3,[2,5,8])
  
axis equal
[stl] = stlread(file{i});
plot3(stl(:,1),stl(:,2),stl(:,3),'.b','MarkerSize',4); 
axis equal 
hold on
grid on

plot3(Markers{i}(1,1),Markers{i}(2,1), Markers{i}(3,1), '.k','MarkerSize',20); 
plot3(Markers{i}(1,2),Markers{i}(2,2), Markers{i}(3,2), '.k','MarkerSize',20); 
plot3(Markers{i}(1,3),Markers{i}(2,3), Markers{i}(3,3), '.k','MarkerSize',20); 
plot3(Markers{i}(1,4),Markers{i}(2,4), Markers{i}(3,4), '.k','MarkerSize',20); 
plot3(Markers{i}(1,5),Markers{i}(2,5), Markers{i}(3,5), '.k','MarkerSize',20); 
plot3(Markers{i}(1,6),Markers{i}(2,6), Markers{i}(3,6), '.k','MarkerSize',20); 

Line1 = [top{i};bottom{i}];
Line2 = [side1{i};side2{i}];
Line3 = [side3{i};side4{i}];
line(Line1(:,1), Line1(:,2), Line1(:,3),'Color','r', 'LineWidth',5);
line(Line2(:,1), Line2(:,2), Line2(:,3),'Color','g', 'LineWidth',5);
line(Line3(:,1), Line3(:,2), Line3(:,3),'Color','b', 'LineWidth',5);
    
title('\bf \fontname{Gothic} \fontsize{18} Subject Lower Body' );
clear stl 
end 

for i = 5:10
 figure(2) 
 set(gcf,'units','normalized','outerposition',[0 0 1 1])
 view ([1 1 1])
 
 if (i==5)
 subplot(3,3,1)
 elseif (i==6)
  subplot(3,3,4)
 elseif (i==7)
  subplot(3,3,7)
 elseif (i==8)
  subplot(3,3,3)
 elseif (i==9)
  subplot(3,3,6)
 else
  subplot(3,3,9)
 end
  
axis equal
axis off
axis tight

[stl] = stlread(file{i});
plot3(stl(:,1),stl(:,2),stl(:,3),'.b','MarkerSize',4); 

axis equal 
hold on
grid on

plot3(Markers{i}(1,1),Markers{i}(2,1), Markers{i}(3,1), '.k','MarkerSize',20); 
plot3(Markers{i}(1,2),Markers{i}(2,2), Markers{i}(3,2), '.k','MarkerSize',20); 
plot3(Markers{i}(1,3),Markers{i}(2,3), Markers{i}(3,3), '.k','MarkerSize',20); 
plot3(Markers{i}(1,4),Markers{i}(2,4), Markers{i}(3,4), '.k','MarkerSize',20); 
plot3(Markers{i}(1,5),Markers{i}(2,5), Markers{i}(3,5), '.k','MarkerSize',20); 
plot3(Markers{i}(1,6),Markers{i}(2,6), Markers{i}(3,6), '.k','MarkerSize',20); 

Line1 = [top{i};bottom{i}];
Line2 = [side1{i};side2{i}];
Line3 = [side3{i};side4{i}];
line(Line1(:,1), Line1(:,2), Line1(:,3),'Color','r', 'LineWidth',5);
line(Line2(:,1), Line2(:,2), Line2(:,3),'Color','g', 'LineWidth',5);
line(Line3(:,1), Line3(:,2), Line3(:,3),'Color','b', 'LineWidth',5);
    
Len = round(pdist(Line1));
Limb_Length{i} = (round(pdist(Line1)));
title( {name{i};['\bf \fontname{Gothic} \fontsize{10} Long Length =',num2str(Len),'mm']});
clear stl 
end 
%% Graphing of the Arms [Left +Right] 
%Arms
for i = 11:16   
 figure(3) 
 set(gcf,'units','normalized','outerposition',[0 0 1 1])
 view ([1 1 1])

 if (i==11)
 subplot(3,3,1)
 elseif (i==12)
  subplot(3,3,4)
 elseif (i==13)
  subplot(3,3,7)
 elseif (i==14)
  subplot(3,3,3)
 elseif (i==15)
  subplot(3,3,6)
 else
  subplot(3,3,9)
 end
  
axis equal 
axis off
axis tight

[stl] = stlread(file{i});
plot3(stl(:,1),stl(:,2),stl(:,3),'.b','MarkerSize',4); 
axis equal 
hold on
grid on

plot3(Markers{i}(1,1),Markers{i}(2,1), Markers{i}(3,1), '.k','MarkerSize',20); 
plot3(Markers{i}(1,2),Markers{i}(2,2), Markers{i}(3,2), '.k','MarkerSize',20); 
plot3(Markers{i}(1,3),Markers{i}(2,3), Markers{i}(3,3), '.k','MarkerSize',20); 
plot3(Markers{i}(1,4),Markers{i}(2,4), Markers{i}(3,4), '.k','MarkerSize',20); 
plot3(Markers{i}(1,5),Markers{i}(2,5), Markers{i}(3,5), '.k','MarkerSize',20); 
plot3(Markers{i}(1,6),Markers{i}(2,6), Markers{i}(3,6), '.k','MarkerSize',20); 

Line1 = [top{i};bottom{i}];
Line2 = [side1{i};side2{i}];
Line3 = [side3{i};side4{i}];
line(Line1(:,1), Line1(:,2), Line1(:,3),'Color','r', 'LineWidth',5);
line(Line2(:,1), Line2(:,2), Line2(:,3),'Color','g', 'LineWidth',5);
line(Line3(:,1), Line3(:,2), Line3(:,3),'Color','b', 'LineWidth',5);
    
Len = round(pdist(Line1));
Limb_Length{i} = (round(pdist(Line1)));
title( {name{i};['\bf \fontname{Gothic} \fontsize{10} Long Length =',num2str(Len),'mm']});
clear stl 
end 

for i = 11:16
 figure(3) 
 view ([1 1 1])
 subplot(3,3,[2,5,8])
  
axis equal
[stl] = stlread(file{i});
plot3(stl(:,1),stl(:,2),stl(:,3),'.b','MarkerSize',4); 
axis equal 
hold on
grid on

plot3(Markers{i}(1,1),Markers{i}(2,1), Markers{i}(3,1), '.k','MarkerSize',20); 
plot3(Markers{i}(1,2),Markers{i}(2,2), Markers{i}(3,2), '.k','MarkerSize',20); 
plot3(Markers{i}(1,3),Markers{i}(2,3), Markers{i}(3,3), '.k','MarkerSize',20); 
plot3(Markers{i}(1,4),Markers{i}(2,4), Markers{i}(3,4), '.k','MarkerSize',20); 
plot3(Markers{i}(1,5),Markers{i}(2,5), Markers{i}(3,5), '.k','MarkerSize',20); 
plot3(Markers{i}(1,6),Markers{i}(2,6), Markers{i}(3,6), '.k','MarkerSize',20); 

Line1 = [top{i};bottom{i}];
Line2 = [side1{i};side2{i}];
Line3 = [side3{i};side4{i}];
line(Line1(:,1), Line1(:,2), Line1(:,3),'Color','r', 'LineWidth',5);
line(Line2(:,1), Line2(:,2), Line2(:,3),'Color','g', 'LineWidth',5);
line(Line3(:,1), Line3(:,2), Line3(:,3),'Color','b', 'LineWidth',5);
    
title('\bf \fontname{Gothic} \fontsize{18} Subject Arms' );
clear stl 
end 

 %% Graphing of the full body full body 
 
for i =1:16
figure(4) ;
 view ([1 1 1])
 set(gcf,'units','normalized','outerposition',[0 0 1 1])
  
[stl] = stlread(file{i});
STL{i} = sortrows(stl,-3);
plot3(stl(:,1),stl(:,2),stl(:,3),'.b','MarkerSize',4); 
 view ([1 1 1])
 axis equal
hold on
grid on

plot3(Markers{i}(1,1),Markers{i}(2,1), Markers{i}(3,1), '.k','MarkerSize',20); 
plot3(Markers{i}(1,2),Markers{i}(2,2), Markers{i}(3,2), '.k','MarkerSize',20); 
plot3(Markers{i}(1,3),Markers{i}(2,3), Markers{i}(3,3), '.k','MarkerSize',20); 
plot3(Markers{i}(1,4),Markers{i}(2,4), Markers{i}(3,4), '.k','MarkerSize',20); 
plot3(Markers{i}(1,5),Markers{i}(2,5), Markers{i}(3,5), '.k','MarkerSize',20); 
plot3(Markers{i}(1,6),Markers{i}(2,6), Markers{i}(3,6), '.k','MarkerSize',20);
plot3(Centroid{i}(1,1),Centroid{i}(1,2),Centroid{i}(1,3),'.k','MarkerSize',30);

% Line1 = [Centroid{i};bottom{i}]; % SIDE TO SIDE 
Line2 = [top{i};bottom{i}]; 

if i < 5  % Trunk +Head Region
    Line2 = [side3{i};side4{i}]; 
end 

% line(Line1(:,1), Line1(:,2), Line1(:,3),'Color','r', 'LineWidth',3);
line(Line2(:,1), Line2(:,2), Line2(:,3),'Color','g', 'LineWidth',3);
% line(Line3(:,1), Line3(:,2), Line3(:,3),'Color','b', 'LineWidth',3);

% COM DATA You can change this to also showthe AP and TVP length..
Long_Length{i} = pdist(Line2);
% A_P_Length{i} =pdist(Line2);
% TVP_Length{i}= pdist(Line3);

I{i} = CoM_eigenvectors{i}'*I_CoM{i} * CoM_eigenvectors{i};

title('\bf \fontname{Gothic} \fontsize{18} Full Body - Use Mouse to Rotate' );
clear  test1 test2 test3
end 

%LONG AXIS COM COORD are ploted and shown ..later saved in excel
for i = 1:4
     figure(4)      
     J_Line = [side3{i};Centroid{i}]; 
     JDist = pdist(J_Line);
     line(J_Line(:,1), J_Line(:,2), J_Line(:,3),'Color','m', 'LineWidth',9);   
     Percent_Proximal{i} = JDist/Long_Length{i};
end

for i = 5:16 %legs
    figure(4)        
 Line1 = [top{i};Centroid{2}]; % A line extending to the hip
 Line2 = [bottom{i};Centroid{2}];
 p1 = pdist(Line1);
 p2 = pdist(Line2);
 
 if p1<p2   
 J_Line = [top{i};Centroid{i}]; 
 JDist = pdist(J_Line);
 line(J_Line(:,1), J_Line(:,2), J_Line(:,3),'Color','m', 'LineWidth',9);
 
 else
 J_Line = [bottom{i};Centroid{i}];     
 JDist = pdist(J_Line);
 line(J_Line(:,1), J_Line(:,2), J_Line(:,3),'Color','m', 'LineWidth',9);  
 end  
 Percent_Proximal{i} = JDist/Long_Length{i};
end


