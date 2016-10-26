function varargout = GUI(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

% --- Executes just before GUI is made visible.
function GUI_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
set(handles.buttonLoad,'Enable','off');
set(handles.buttonPreProExtraction,'Enable','off');
set(handles.buttonEnclosingChar,'Enable','off');
set(handles.buttonSelectingChar,'Enable','off');
set(handles.buttonTemplate,'Enable','off');
trained= exist('net.mat');%name exist in the search path then retun 2 else 0
if trained==2
    set(handles.buttonReset,'Enable','on');
    set(handles.buttonLoad,'Enable','on');
else
    set(handles.buttonReset,'Enable','off');
    set(handles.buttonLoad,'Enable','off');
end
fid = fopen( 'C:\Users\shivang\Desktop\BE_PROJECT\output.txt','wt');
fprintf(fid,'');
fclose(fid);


% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --- Executes on button press in button_train.
function button_train_Callback(hObject, eventdata, handles)
train
set(handles.buttonLoad,'Enable','on');
set(handles.buttonReset,'Enable','on');

% --- Executes on button press in buttonLoad.
function buttonLoad_Callback(hObject, eventdata, handles)
global im;
clc;
warning off;
fid = fopen( 'C:\Users\shivang\Desktop\BE_PROJECT\output.txt','wt');
fprintf(fid,'');
fclose(fid);
[path,user_cance]=imgetfile();
if user_cance
    msgbox(sprintf('Error'),'Error','Error')
    return
end

im=imread(path);
axes(handles.image);
imshow(im);
set(handles.buttonPreProExtraction,'Enable','on');

% --- Executes on button press in buttonPreProExtraction.
function buttonPreProExtraction_Callback(hObject, eventdata, handles)
global im;
global H;
I=im;
%------------------------------------------------------------------------
 [r,c]=size(im);
 if(r>900)
  I=imresize(I,[700 NaN]); 
 end
%I=imresize(I,.7);
I=rgb2gray(I);
I1=I;
[rows cols] = size(I);
% %--------- Dilate and Erode Image in order to remove noise-----------
tempI=I;
stre=strel('line',1,3);   
I=imdilate(I,stre);
%-------------------- PROCESS EDGES IN HORIZONTAL DIRECTION--------------
difference = 0;
total_sum = 0;
max_horz = 0;
maximum = 0;
for j = 2:cols
    sum = 0;
    for i = 2:rows
        difference = abs(uint32(I(i, j) - I(i-1,j)));
        if(difference > 50)
            sum = sum + difference;
        end
    end
    horz1(j) = sum;
   %----------------------------- Find Peak horizontal Value---------------
    if(sum > maximum)
        max_horz = j;
        maximum = sum;
    end
    total_sum = total_sum + sum;
end
average = total_sum / cols;
%------- Smoothen the Horizontal Histogram by applying Low Pass Filter
horz = horz1;
for i = 21:(cols-21)
sum = 0;
    for j = (i-20):(i+20)
        sum = sum + horz1(j);
    end
    horz(i) = sum / 40;
end

for j = 1:cols
    if(horz(j) < .35*average)
        horz(j) = 0;
        for i = 1:rows
            I(i, j) = 0;
        end
    end
end
%--------------- PROCESS EDGES IN VERTICAL DIRECTION
difference = 0;
total_sum = 0;
maximum = 0;
max_vert = 0;
for i = 2:rows
    sum = 0;
    for j = 2:cols
        difference = abs(uint32(I(i, j) - I(i, j-1)));
        if(difference > 20)
            sum = sum + difference;
        end
    end
    vert1(i) = sum;
    %-------------------------- Find Peak in Vertical Histogram
    if(sum > maximum)
        max_vert = i;
        maximum = sum;
    end
    total_sum = total_sum + sum;
end
average = total_sum / rows;
%-------Smoothen the Vertical Histogram by applying Low Pass Filter
sum = 0;
vert = vert1;
temp_vert=0;

if (average <0.45*maximum)
    temp_vert=1;
    for i = 21:(rows-21)
            sum = 0;
                        for j = (i-20):(i+20)
                            sum = sum + vert1(j);
                        end
             vert(i) = sum / 40;
        end

    for i = 1:rows
            if(vert(i) < average)
                vert(i) = 0;
                for j = 1:cols
                    I(i, j) = 0;
                end
            end
    end
else
    I=I1;
end

if(temp_vert==1)
    %--------------------- Find Probable candidates for Number Plate
    %--------Saving the co-ordinates having non-zero horizontal histogram
    j = 1;
    for i = 2:cols-2
        if(horz(i) ~= 0 && horz(i-1) == 0 && horz(i+1) == 0)
            column(j) = i;
            column(j+1) = i;
            j = j + 2;
        elseif((horz(i) ~= 0 && horz(i-1) == 0) || (horz(i) ~= 0 && horz(i+1) == 0))
            column(j) = i;
            j = j+1;
        end
    end

    %--------------Saving the co-ordinates having non-zero vertical histogram
    j = 1;
    for i = 2:rows-2
        if(vert(i) ~= 0 && vert(i-1) == 0 && vert(i+1) == 0)
            row(j) = i;
            row(j+1) = i;
            j = j + 2;
        elseif((vert(i) ~= 0 && vert(i-1) == 0) || (vert(i) ~= 0 && vert(i+1) == 0))
            row(j) = i;
            j = j+1;
        end
    end

    %-------------------converting odd size of the hori co-ordinate array to even
    [temp column_size] = size (column);
    if(mod(column_size, 2))
        column(column_size+1) = cols;
    end

    %----------------converting odd size of the verti co-ordinate array to even
    [temp row_size] = size (row);
    if(mod(row_size, 2))
        row(row_size+1) = rows;
    end
    %------------------------------Region of Interest Extraction
    %---------------------------Check each probable candidate
    for i = 1:2:row_size
        for j = 1:2:column_size
    %------------------------If it is not the most probable region remove it from image
            
            if(~((max_horz >= column(j) && max_horz <= column(j+1)) && (max_vert >=row(i) && max_vert <= row(i+1))))
            for m = row(i):row(i+1)
                for n = column(j):column(j+1)
                    I(m, n) = 0;
                end
            end
          end
        end
    end

        str=strel('disk', 1);
        I=imerode(I,str);
        % Get all rows and columns where the image is nonzero
        [nonZeroRows nonZeroColumns] = find(I);
        % Get the cropping parameters
        topRow = min(nonZeroRows(:));
        bottomRow = max(nonZeroRows(:));
        leftColumn = min(nonZeroColumns(:));
        rightColumn = max(nonZeroColumns(:));
        [x y]=size(I1);
        % Extract a cropped image from the original.
        if(((topRow-5)>0)&&((leftColumn-5)>0))
            if((bottomRow+5)<=x && (rightColumn+5)<=y)
                croppedImage = I1(topRow-5:bottomRow+5, leftColumn-5:rightColumn+5);
            elseif((bottomRow+5)<=x)
                  croppedImage = I1(topRow-5:bottomRow+5, leftColumn-5:rightColumn);      
            elseif((rightColumn+5)<=y)
                    croppedImage = I1(topRow-5:bottomRow, leftColumn-5:rightColumn+5);         
            else
                croppedImage = I1(topRow-5:bottomRow, leftColumn-5:rightColumn);
            end
            I=croppedImage;
            temp_f=1;
          
        else
             croppedImage = I1(topRow:bottomRow,leftColumn:rightColumn);
            I=croppedImage;
            temp_f=0;
        end
end
%temp_f =0 means image didnr extract hrixi
f=imresize(I,[400 NaN]);
[r, c]=size(f);
%----------------------------------------------------------------------------% 
%If image isn't cropped then the letters are small and hence using bwareaopen with larger floor will erode them
%
g=medfilt2(I,[3 3]);
%2d median filter
%reduce salt n pepper noise
%the median value in the 3-by-3 neighborhood

%**********************************
stre=strel('disk',1);    %strucruring element
%structuring element of disk shape(matrix of 1) with radius 1

gi=imdilate(g,stre);
%fill gaps

ge=imerode(g,stre);   %%%% morphological image processing
%shrink or eliminate irrelevant details

gdiff=imsubtract(gi,ge);
gdiff=mat2gray(gdiff);
%amin and amax as min and mx value of image

gdiff=conv2(gdiff,[1 1;1 1]); %convolution of matrix   %brighten

gdiff=imadjust(gdiff,[0.5 0.7],[0 1],.1);
%maps intensity from .5-.7 to 0-1 with curve of gamma .1

B=logical(gdiff);%so that size works
[a1 b1]=size(B);


er=imerode(B,strel('line',100,0));  
%img , structuring element
%removing usless horizontal line

out1=imsubtract(B,er);
F=imfill(out1,'holes');      %filling the object
H=bwmorph(F,'thin',1); 
%morphological operation on binary image
%thin it once  %to remove useless thin lines
final=imerode(H,strel('line',3,90));
%structuring element of lenf=gth 3 and degree 90
if temp_f==1 %temp_f image is extracted correctly and plate was far
    final=bwareaopen(final,floor((r/43)*(c/43)));
else
    [rp cp]=size(final);
    if(cp/rp>4)   %image not extracted completely(vertically)
       final=bwareaopen(final,floor((r/40)*(c/40)));
    else   %image extracted completely image is actually close OR image not extracted vertically and hori
        final=bwareaopen(final,floor((r/25)*(c/25)));
    end
end
I_ori=imresize(im2bw(g),[a1 b1]);
 stre=strel('disk',2);   

 %g is original image after extraction
 global final_hole;
 final_hole=(final).*imcomplement(I_ori);
%  figure(1);imshow(imcomplement(I_ori));
%  figure(2);imshow((final));
 %to get image with holes (imfill removes holes
%------------------------------------------------------------------------
im=final;
axes(handles.PreProExtraction);
imshow(im);
set(handles.buttonEnclosingChar,'Enable','on');


% --- Executes on button press in buttonEnclosingChar.
function buttonEnclosingChar_Callback(hObject, eventdata, handles)
global im;
final=im;
axes(handles.enclosingChar);
imshow(im);

yyy=template(2);
%-------------------------------------------------------------------------------
Iprops=regionprops(final,'BoundingBox','Image');
hold on                            %add to the exsisting graph
for n=1:size(Iprops,1)               %sixe of iprops in first dimension
    rectangle('Position',Iprops(n).BoundingBox,'EdgeColor','g','LineWidth',2); 
end
hold off                            %reset axis properties
%-------------------
set(handles.buttonSelectingChar,'Enable','on');


% --- Executes on button press in buttonSelectingChar.
function buttonSelectingChar_Callback(hObject, eventdata, handles)
global im;
final=im;
global final_hole;
global carnum;
global r;
Iprops=regionprops(final,'BoundingBox','Image');
% drawing boundary box around 
% each connected component in the image
hold on                            %add to the exsisting graph
for n=1:size(Iprops,1)               %sixe of iprops in first dimension
    rectangle('Position',Iprops(n).BoundingBox,'EdgeColor','g','LineWidth',2); 
end
hold off                            %reset axis properties

NR=cat(1,Iprops.BoundingBox);  %%Data storage section
%string of all boundary boxes, 
%the properties in the string are x coordinate,y coordinate, x width, y width
%white box of size bounding box
%NR= number of regions*4

[r ttb]=connn(NR);
%ttb is array of useful NR

[x y]=size(final_hole);
if ~isempty(r)
    %taking the selected NR and contatenating them
    xlow=ceil(min(reshape(ttb(:,1),1,[])));
    xhigh=ceil(max(reshape(ttb(:,1),1,[])));
    xadd=ceil(max(reshape(ttb(:,3),1,[])));
    ylow=ceil(min(reshape(ttb(:,2),1,[])));
    yhigh=floor(max(reshape(ttb(:,2),1,[])));
    yadd=ceil(max(reshape(ttb(:,4),1,[])));
    if(x>(yhigh+yadd)&& y>(xhigh+xadd))
        final1=final_hole(ylow:(yhigh+yadd),xlow:(xhigh+xadd));
    elseif((x>(yhigh+yadd)&& y<(xhigh+xadd)));
        final1=final_hole(ylow:(yhigh+yadd),xlow:y);
    elseif((x<(yhigh+yadd)&& y>(xhigh+xadd)))
         final1=final_hole(ylow:x,xlow:(xhigh+xadd));
    else
         final1=final_hole(ylow:x,xlow:y);
    end
    [a2 b2]=size(final1);
    final1=bwareaopen(final1,floor((a2/10)*(b2/10)));
    Iprops1=regionprops(final1,'BoundingBox','Image');
    NR3=cat(1,Iprops1.BoundingBox);
    I1={Iprops1.Image};
    %%
   carnum=[];
    if (size(NR3,1)>size(ttb,1))
        [r2 to ]=connn2(NR3);
        for i=1:size(Iprops1,1)
            ff=find(i==r2);
            if ~isempty(ff)
                N1=I1{1,i};
                letter=readLetter(N1,2,i);
            else
                N1=I1{1,i};
                letter=readLetter(N1,1,i);
            end
            if ~isempty(letter)
                carnum=[carnum letter];
            end
        end
    else
        for i=1:size(Iprops1,1)
            N1=I1{1,i};
            letter=readLetter(N1,1,i);
            carnum=[carnum letter];
        end
    end
  
end

 im=final1;
 axes(handles.selectingChar);
 imshow(im);
 set(handles.buttonTemplate,'Enable','on');

 
% --- Executes on button press in buttonTemplate.
function buttonTemplate_Callback(hObject, eventdata, handles)
global carnum;
global r;
if ~isempty(r)
    fid1 = fopen('carnum.txt', 'wt');
    fprintf(fid1,'%s',carnum);
    fclose(fid1);
  else
    fprintf('license plate recognition failure\n');
    fprintf('Characters are not clear \n');
  end

%for nn
fid2=fopen('output.txt','r');
text=fscanf(fid2,'%c');
set(handles.nn,'String',text);
fclose(fid2);


% --- Executes on button press in buttonReset.
function buttonReset_Callback(hObject, eventdata, handles)
% hObject    handle to buttonReset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(gcbf)
GUI
fid1=fopen('output.txt','w');
fclose(fid1);
