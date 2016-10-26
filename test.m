function[] = test(p)
%disp('testing');
load ('C:\Users\shivang\Desktop\BE_PROJECT\featureout.mat');
  
net.inputs{1}.processFcns = {'removeconstantrows','mapminmax'};
load C:\Users\shivang\Desktop\BE_PROJECT\net.mat;
load net;

y5=sim(net,p);
% y5=abs(y5);
% y5=round(y5);
% y5=y5'
%disp(y5); 
%[C I]=max(y5)

fid = fopen( 'C:\Users\shivang\Desktop\BE_PROJECT\output.txt','a');


fid2 = fopen( 'C:\Users\shivang\Desktop\BE_PROJECT\cand.txt','r');
cand=fscanf(fid2,'%c');

for  i=1:3

                        if (cand(i)=='0')
                             index(i)=1;   
                        elseif (cand(i)=='1')
                             index(i)=2; 
                        elseif (cand(i)=='2')
                             index(i)=3; 
                        elseif (cand(i)=='3')
                             index(i)=4; 
                        elseif (cand(i)=='4')
                             index(i)=5; 
                        elseif (cand(i)=='5')
                             index(i)=6; 
                        elseif (cand(i)=='6')
                             index(i)=7; 
                        elseif (cand(i)=='7')
                             index(i)=8; 
                        elseif (cand(i)=='8')
                             index(i)=9; 
                        elseif (cand(i)=='9')
                             index(i)=10; 
                        elseif (cand(i)=='A')
                             index(i)=11;
                        elseif (cand(i)=='B')
                             index(i)=12; 
                        elseif (cand(i)=='C')
                             index(i)=13; 
                        elseif (cand(i)=='D')
                             index(i)=14; 
                        elseif (cand(i)=='E')
                             index(i)=15; 
                        elseif (cand(i)=='F')
                             index(i)=16; 
                        elseif (cand(i)=='G')
                             index(i)=17; 
                        elseif (cand(i)=='H')
                             index(i)=18; 
                        elseif (cand(i)=='I')
                             index(i)=19; 
                        elseif (cand(i)=='J')
                             index(i)=20; 
                        elseif (cand(i)=='K')
                             index(i)=21; 
                        elseif (cand(i)=='L')
                             index(i)=22; 
                        elseif (cand(i)=='M')
                             index(i)=23; 
                        elseif (cand(i)=='N')
                             index(i)=24; 
                        elseif (cand(i)=='O')
                             index(i)=25; 
                        elseif (cand(i)=='P')
                             index(i)=26; 
                        elseif (cand(i)=='Q')
                             index(i)=27; 
                        elseif (cand(i)=='R')
                             index(i)=28; 
                        elseif (cand(i)=='S')
                             index(i)=29; 
                        elseif (cand(i)=='T')
                             index(i)=30; 
                        elseif (cand(i)=='U')
                             index(i)=31; 
                        elseif (cand(i)=='V')
                             index(i)=32; 
                        elseif (cand(i)=='W')
                             index(i)=33; 
                        elseif (cand(i)=='X')
                             index(i)=34; 
                        elseif (cand(i)=='Y')
                             index(i)=35; 
                        elseif (cand(i)=='Z')
                             index(i)=36; 
                        end
                        
                        temp(i)=y5(index(i));
end
%index
%temp
[p Q]=max(temp);
I=index(Q);





 
if (I==1)
    fprintf(fid,'0');
fclose(fid);
elseif (I==2)
    fprintf(fid,'1');
fclose(fid);     
elseif (I==3)
    fprintf(fid,'2 ');
fclose(fid);     
elseif (I==4)
    fprintf(fid,'3');
fclose(fid);     
elseif (I==5)
    fprintf(fid,'4');
fclose(fid);     
elseif (I==6)
    fprintf(fid,'5');
fclose(fid);     
elseif (I==7)
    fprintf(fid,'6');
fclose(fid);     
elseif (I==8)
    fprintf(fid,'7');
fclose(fid);     
elseif (I==9)
    fprintf(fid,'8');
fclose(fid);     
elseif (I==10)
    fprintf(fid,'9');
fclose(fid);     
elseif (I==11)
    fprintf(fid,'A');
fclose(fid);     
elseif (I==12)
    fprintf(fid,'B');
fclose(fid);     
elseif (I==13)
    fprintf(fid,'C');
fclose(fid);     
elseif (I==14)
    fprintf(fid,'D');
fclose(fid);     
elseif (I==15)
    fprintf(fid,'E');
fclose(fid);     
elseif (I==16)
    fprintf(fid,'F');
fclose(fid);     
elseif (I==17)
    fprintf(fid,'G');
fclose(fid);     
elseif (I==18)
    fprintf(fid,'H');
fclose(fid);     
elseif (I==19)
    fprintf(fid,'I');
fclose(fid);     
elseif (I==20)
    fprintf(fid,'J');
fclose(fid);     
elseif (I==21)
    fprintf(fid,'K');
fclose(fid);     
elseif (I==22)
    fprintf(fid,'L');
fclose(fid);     
elseif (I==23)
    fprintf(fid,'M');
fclose(fid);     
elseif (I==24)
    fprintf(fid,'N');
fclose(fid);
elseif (I==25)
    fprintf(fid,'O');
fclose(fid);     
elseif (I==26)
    fprintf(fid,'P');
fclose(fid);     
elseif (I==27)
    fprintf(fid,'Q');
fclose(fid);     
elseif (I==28)
    fprintf(fid,'R');
fclose(fid);     
elseif (I==29)
    fprintf(fid,'S');
fclose(fid);     
elseif (I==30)
    fprintf(fid,'T');
fclose(fid);     
elseif (I==31)
    fprintf(fid,'U');
fclose(fid);     
elseif (I==32)
    fprintf(fid,'V');
fclose(fid);     
elseif (I==33)
    fprintf(fid,'W');
fclose(fid);     
elseif (I==34)
    fprintf(fid,'X');
fclose(fid);     
elseif (I==35)
    fprintf(fid,'Y');
fclose(fid);
elseif (I==36)
    fprintf(fid,'Z');
fclose(fid);     
 
 else
     disp(' not Found');
     
   clear
end
 
end 
 