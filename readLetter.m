function letter=readLetter(snap, i1 , index)

snap=imresize(snap,[42 24]);
    
load NewTemplates 
% Loads the templates of characters in the memory.
% Resize the input image so it can be compared with the template's images.


%layer 1 check corelation values-------------------------------------------
comp=[ ];
if (i1==1)
    for n=1:(length(NewTemplates)-1)
        sem=corr2(NewTemplates{1,n},snap); 
        %feature(NewTemplates)        
        % Correlation the input image
        %with every image in the template for best matching.
        comp=[comp sem];
        % Record the value of correlation for each 
        %template's character.
    end
   
%finding index of eligible characters
    comp_s=sort(comp,'descend');
    can(1)=find(comp==comp_s(1));
    can(2)=find(comp==comp_s(2));
    can(3)=find(comp==comp_s(3));
    for i=1:3
                if can(i)==1 || can(i)==2
                    candidate='A';
                elseif can(i)==3 || can(i)==4
                    candidate='B';
                elseif can(i)==5
                    candidate='C';
                elseif can(i)==6 || can(i)==7
                    candidate='D';
                elseif can(i)==8
                    candidate='E';
                elseif can(i)==9
                    candidate='F';
                elseif can(i)==10
                    candidate='G';
                elseif can(i)==11
                    candidate='H';
                elseif can(i)==12
                    candidate='I';
                elseif can(i)==13
                    candidate='J';
                elseif can(i)==14
                    candidate='K';
                elseif can(i)==15
                    candidate='L';
                elseif can(i)==16
                    candidate='M';
                elseif can(i)==17
                    candidate='N';
                elseif can(i)==18 || can(i)==19
                    candidate='O';
                elseif can(i)==20 || can(i)==21
                    candidate='P';
                elseif can(i)==22 || can(i)==23
                    candidate='Q';
                elseif can(i)==24 || can(i)==25
                    candidate='R';
                elseif can(i)==26
                    candidate='S';
                elseif can(i)==27
                    candidate='T';
                elseif can(i)==28
                    candidate='U';
                elseif can(i)==29
                    candidate='V';
                elseif can(i)==30
                    candidate='W';
                elseif can(i)==31
                    candidate='X';
                elseif can(i)==32
                    candidate='Y';
                elseif can(i)==33
                    candidate='Z';
                %*-*-*-*-*
                % Numerals listings.
                elseif can(i)==34
                    candidate='1';
                elseif can(i)==35
                    candidate='2';
                elseif can(i)==36
                    candidate='3';
                elseif can(i)==37 || can(i)==38
                    candidate='4';
                elseif can(i)==39
                    candidate='5';
                elseif can(i)==40 || can(i)==41 || can(i)==42
                    candidate='6';
                elseif can(i)==43
                    candidate='7';
                elseif can(i)==44 || can(i)==45
                    candidate='8';
                elseif can(i)==46 || can(i)==47 || can(i)==48
                    candidate='9';
                elseif can(i)==49 || can(i)==50
                    candidate='0';
                else 
                    candidate=' ';
                end
          cand(i)= candidate;
    end
  cand1=cand;
    
%------------------------------------------------------------------
 %layer 2   
 %check for repetetion in candidate
 %if yes thats the output
    cand1=cand;
    repeat1=0;
    repeat2=0;
    for i=1:2
        if cand(i)==cand(i+1)
            for j=1:3
                cand1(j)=cand(i);
                repeat1=i;
                repeat2=i+1;
            end
        end
    end
    if cand(3)==cand(1)
         for j=1:3
                cand1(j)=cand(1);
                repeat1=1;
                repeat2=3;
         end
    end
    
    if repeat1==1 || repeat2==1   %if highest correlated one is repeated
        cand=cand1;
    else
        cand=cand;     %if lower correlated ones are repeated skip step
    end
  cand2=cand;   
%---------------------------------------------------------------------     
 %%layer 3 ,,, parse by holes
      holes=hole(snap);
      j=1;
      flag=0;
      temp='M';
  
      for i=1:3 
          if holes==0
              if cand(i)=='1'||cand(i)=='2'||cand(i)=='3'||cand(i)=='5'||cand(i)=='7'
                   temp=cand(i);
              elseif ((cand(i)=='C'||cand(i)=='E'||cand(i)=='F'||cand(i)=='G'||cand(i)=='H'||cand(i)=='I'||cand(i)=='J'||cand(i)=='K'||cand(i)=='L'||cand(i)=='M'||cand(i)=='N'||cand(i)=='S'||cand(i)=='T'||cand(i)=='U'||cand(i)=='V'||cand(i)=='W'||cand(i)=='X'||cand(i)=='Y'||cand(i)=='Z') && index<=6 && index~=3 && index~=4)
                  temp=cand(i);
              else
                  if i==1
                      flag=1;
                  elseif i==2 && flag==1
                      flag=2;
                  elseif i==3 && flag==2
                      flag=3;
                  end
              end
          elseif holes==1
               if cand(i)== '0'||cand(i)=='4'||cand(i)=='6'||cand(i)=='9'
                  temp=cand(i);
               elseif ((cand(i)=='A'||cand(i)=='D'||cand(i)=='O'||cand(i)=='P'||cand(i)=='Q'||cand(i)=='R')&& index<=6 && index~=3 && index~=4)
                  temp=cand(i);
               else
                  if i==1
                      flag=1;
                  elseif i==2 && flag==1
                      flag=2;
                  elseif i==3 && flag==2
                      flag=3;
                  end
               end
          elseif holes==2 
               if cand(i)== '8'
                  temp=cand(i);
               elseif (cand(i)=='B' && index<=6 && index~=3 && index~=4)
                   temp=cand(i);
                else
                  if i==1
                      flag=1;
                  elseif i==2 && flag==1
                      flag=2;
                  elseif i==3 && flag==2
                      flag=3;
                  end
               end
          else
               temp=cand(i);
          end  
      cand1(j)=temp;
      j=j+1;    
      end
        
        if flag==1 
                cand1(1)=cand1(2);
            elseif flag==2
                cand1(1)=cand1(3);
                cand1(2)=cand1(3);
            elseif flag==3
                   cand1=cand;   % if nothin qualifies hole criteria skip layer
            else
                cand1=cand1;
        end
        cand=cand1;
        cand3=cand;
 %--------------------------------------------------------
 %layer 4
 %half holes
 snap1=snap;
 %size is 42*24
 snap1(1:1:5,1:1:24)=1;
 snap1(42:-1:37,24:-1:1)=1;
 
 snap1(1:1:42,1:1:5)=1;
 snap1(42:-1:1,24:-1:20)=1;
 
 holes2= hole(snap1);
 half_holes=holes2-holes;
 temp='0';
 j=1;
 flag=0;
 for i=1:3
     if half_holes==0
              if cand(i)=='0'||cand(i)=='8'||cand(i)=='1'
                   temp=cand(i);
              elseif cand(i)=='D'||cand(i)=='O'||cand(i)=='Q'||cand(i)=='I'||cand(i)=='B'
                  temp=cand(i);
              else
                  if i==1
                      flag=1;
                  elseif i==2 && flag==1
                      flag=2;
                  elseif i==3 && flag==2
                      flag=3;
                  end
              end
              
      elseif half_holes==1
              if cand(i)=='6'||cand(i)=='9'||cand(i)=='1'
                   temp=cand(i);
              elseif cand(i)=='A'||cand(i)=='C'||cand(i)=='L'||cand(i)=='P'||cand(i)=='U'||cand(i)=='V'...
                      ||cand(i)=='G'||cand(i)=='R'||cand(i)=='J'
                  temp=cand(i);
              else
                  if i==1
                      flag=1;
                  elseif i==2 && flag==1
                      flag=2;
                  elseif i==3 && flag==2
                      flag=3;
                  end
               end
              
     elseif half_holes==2
              if cand(i)=='1'||cand(i)=='2'||cand(i)=='3'||cand(i)=='4'||cand(i)=='5'||cand(i)=='7'||cand(i)=='9'
                  if cand(i)=='1'||cand(i)=='3' 
                       snap1(1:1:7,1:1:24)=1;
                       snap1(42:-1:37,24:-1:1)=1;
                       snap1(1:1:42,1:1:10)=1;
                       snap1(42:-1:1,24:-1:19)=1;
                       temp_hole=hole(snap1);
                       if temp_hole==1||temp_hole==0
                           cand(i)='1';
                       else
                           cand(i)='3';
                       end
                  end
                  temp=cand(i);                 
              elseif cand(i)=='E'||cand(i)=='F'||cand(i)=='G'||cand(i)=='H'||cand(i)=='I'||...
                      cand(i)=='J'||cand(i)=='K'||cand(i)=='M'||cand(i)=='N'||cand(i)=='R'||...
                      cand(i)=='S'||cand(i)=='T'||cand(i)=='W'||cand(i)=='Z'
                  temp=cand(i);
              else
                  if i==1
                      flag=1;
                  elseif i==2 && flag==1
                      flag=2;
                  elseif i==3 && flag==2
                      flag=3;
                  end
              end
              
      elseif half_holes==3
              if cand(i)=='3'
                   temp=cand(i);
              elseif cand(i)=='A'||cand(i)=='K'||cand(i)=='M'||cand(i)=='V'||cand(i)=='W'||cand(i)=='Y'
                  temp=cand(i);
              else
                  if i==1
                      flag=1;
                  elseif i==2 && flag==1
                      flag=2;
                  elseif i==3 && flag==2
                      flag=3;
                  end
              end
              
      elseif half_holes==4
              if cand(i)=='X'
                  temp=cand(i);
              else
                  if i==1
                      flag=1;
                  elseif i==2 && flag==1
                      flag=2;
                  elseif i==3 && flag==2
                      flag=3;
                  end
              end
     else
         cand(i)=temp;
     end
cand1(j)=temp;
j=j+1;
end

       if flag==1 
            cand1(1)=cand1(2);
        elseif flag==2
            cand1(1)=cand1(3);
            cand1(2)=cand1(3);
       elseif flag==3
           cand1=cand;
        else
            cand1=cand1;   % if nothin qualifies hole criteria skip layer
        end
        
 cand4=cand1;
 %----------------------------------------------------------   
 %layer 5  
 %call for nn
    fid = fopen( 'C:\Users\shivang\Desktop\BE_PROJECT\\cand.txt','w');
    fprintf(fid,cand1);
    z=feature_vector(snap);
    load ('C:\Users\shivang\Desktop\BE_PROJECT\featureout.mat');
    %disp(z);
    save ('C:\Users\shivang\Desktop\BE_PROJECT\featureout.mat','featureout');
    test(z);
 
 %-----------------------------------------------------------------
   %%direct template matching
    %*-*-*-*-*-*-*-*-*-*-*-*-*-
    % Accodrding to the index assign to 'letter'.
    % Alphabets listings.
    if can(1)==1 || can(1)==2
        letter='A';
    elseif can(1)==3 || can(1)==4
        letter='B';
    elseif can(1)==5
        letter='C';
    elseif can(1)==6 || can(1)==7
        letter='D';
    elseif can(1)==8
        letter='E';
    elseif can(1)==9
        letter='F';
    elseif can(1)==10
        letter='G';
    elseif can(1)==11
        letter='H';
    elseif can(1)==12
        letter='I';
    elseif can(1)==13
        letter='J';
    elseif can(1)==14
        letter='K';
    elseif can(1)==15
        letter='L';
    elseif can(1)==16
        letter='M';
    elseif can(1)==17
        letter='N';
    elseif can(1)==18 || can(1)==19
        letter='O';
    elseif can(1)==20 || can(1)==21
        letter='P';
    elseif can(1)==22 || can(1)==23
        letter='Q';
    elseif can(1)==24 || can(1)==25
        letter='R';
    elseif can(1)==26
        letter='S';
    elseif can(1)==27
        letter='T';
    elseif can(1)==28
        letter='U';
    elseif can(1)==29
        letter='V';
    elseif can(1)==30
        letter='W';
    elseif can(1)==31
        letter='X';
    elseif can(1)==32
        letter='Y';
    elseif can(1)==33
        letter='Z';
    %*-*-*-*-*
    % Numerals listings.
    elseif can(1)==34
        letter='1';
    elseif can(1)==35
        letter='2';
    elseif can(1)==36
        letter='3';
    elseif can(1)==37 || can(1)==38
        letter='4';
    elseif can(1)==39
        letter='5';
    elseif can(1)==40 || can(1)==41 || can(1)==42
        letter='6';
    elseif can(1)==43
        letter='7';
    elseif can(1)==44 || can(1)==45
        letter='8';
    elseif can(1)==46 || can(1)==47 || can(1)==48
        letter='9';
    elseif can(1)==49 || can(1)==50
        letter='0';
    elseif can(1)==51
        letter='-';
    end
end
if (i1==2)
    for n=51:length(NewTemplates)
        sem=corr2(NewTemplates{1,n},snap);
        comp=[comp sem];
        max(comp);
    end
    if (max(comp)>.3)
        letter='-';
    else
        letter=[];
    end
end
end
