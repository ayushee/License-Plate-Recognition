function varargout = GUI(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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




% --- Outputs from this function are returned to the command line.
function varargout = GUI_OutputFcn(hObject, eventdata, handles) 

varargout{1} = handles.output;



% --- Executes on button press in buttonLoad.
function buttonLoad_Callback(hObject, eventdata, handles)
global im;
[path,user_cance]=imgetfile()
if user_cance
    msgbox(sprintf('Error'),'Error','Error')
    return
end
im=imread(path);
axes(handles.image);
imshow(im);




% --- Executes on button press in buttonMorph.
function buttonMorph_Callback(hObject, eventdata, handles)
global im;
f=im;
global a1;
global b1;
%----------------------------------------------------------------------------------------------
f=imresize(f,[400 NaN]);                   %%image loading unit
%no of rows =400 
imshow(f);
g=rgb2gray(f);
g=medfilt2(g,[3 3]);
%2d median filter
%reduce salt n pepper noise
%the median value in the 3-by-3 neighborhood

%**********************************
stre=strel('disk',1);     %strucruring element
%structuring element of disk shape(matrix of 1) with radius 1

gi=imdilate(g,stre);
%fill gaps

ge=imerode(g,stre);   %%%% morphological image processing
%shrink or eliminate irrelevant details

gdiff=imsubtract(gi,ge);
gdiff=mat2gray(gdiff);
%amin and amax as min and mx value of image

gdiff=conv2(gdiff,[1 1;1 1]); %convolution of matrix   %brighten(doubt)

gdiff=imadjust(gdiff,[0.5 0.7],[0 1],.1);
%maps intensity from .5-.7 to 0-1 with curve of gamma .1

B=logical(gdiff);%so that size works
[a1 b1]=size(B);
%---------------------------------------------------------------------------------------------------
im=B;
axes(handles.morph);
imshow(im);





% --- Executes on button press in buttonHor.
function buttonHor_Callback(hObject, eventdata, handles)
global er;
global im;
B=im;
%-------------------------------------------------------------------------------------------------
er=imerode(B,strel('line',100,0));  
%img , structuring element
%-------------------------------------------------------------------------------------------------
axes(handles.hor);
imshow(er);





% --- Executes on button press in buttonSub.
function buttonSub_Callback(hObject, eventdata, handles)
global im;
global er;
B=im;
%----------------------------------------------------------------------------------------
out1=imsubtract(B,er);

F=imfill(out1,'holes');      %filling the object

H=bwmorph(F,'thin',1);    
%morphological operation on binary image
%thin it once  %to remove useless thin lines

H=imerode(H,strel('line',3,90));
%remove useless vertical lines
%structuring element of lenf=gth 3 and degree 90
%-----------------------------------------------------------------------------------------
im=H;
axes(handles.sub);
imshow(im);


function buttonArea_Callback(hObject, eventdata, handles)
global im;
H=im;
global a1;
global b1;
%-----------------------------------------------------------------------------
final=bwareaopen(H,floor((a1/15)*(b1/15)));  
%----------------------------------------------------------------------------
im=final;
axes(handles.removeArea);
imshow(im);


% --- Executes on button press in buttonBox.
function buttonBox_Callback(hObject, eventdata, handles)
global im;
final=im;
%-------------------------------------------------------------------------------
Iprops=regionprops(final,'BoundingBox','Image');
hold on                            %add to the exsisting graph
for n=1:size(Iprops,1)               %sixe of iprops in first dimension
    rectangle('Position',Iprops(n).BoundingBox,'EdgeColor','g','LineWidth',2); 
end
hold off                            %reset axis properties
%-------------------------------------------------------------------------------
