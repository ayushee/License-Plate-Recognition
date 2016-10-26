function [r takethisbox]=connn(NR)
%%Characters in bounding box have near about same y-coordinate and y width
%%rest useless boxes have different values

A=mode(NR); %Returns max occurances in each column and returns lowest value if there are no repetitions
[r1 c1]=size(NR);
a=1;
for i=1:r1
     x1(i)=NR(i,2); %Copying the second column matrix
     x2(i)=NR(i,4); %Copying the fourth column matrix
end
k1=find(x1==A(2)); %Find returns the incides having A(2) elements
k2=find(x2==A(4));
for i=1:r1
    if((length(k1)==1) && (length(k2)==1)) %(non repeating)Checking if there are multiple values of A(2) and A(4). If not it takes mean as a citeria for takethisbox
        temp=mean(NR);
        if((NR(i,4)>=(temp(1,4)-30))&&(NR(i,4)<=(temp(1,4)+30)))%condition on ydimension
             r(a)=i;
             a=a+1; 
        end
    elseif ((NR(i,4)>=(A(1,4)-7))&&(NR(i,4)<=(A(1,4)+7)) && (NR(i,2)>=(A(1,2)-10))&&(NR(i,2)<=(A(1,2)+10))&& (length(k1)>1))
        %repeating y width as well as repeating y coordinate
        % using max occurance of y-coordinate and y-width criteria and
        % saving its row indices
            r(a)=i;
            a=a+1;  
    elseif ((NR(i,4)>=(A(1,4)-5))&&(NR(i,4)<=(A(1,4)+5))) 
        %y width repetetion
        % using max occurance of y-width criteria if y co-ordinate doesn't have max occurances and
        % saving its row indices
             r(a)=i;
             a=a+1; 
   end
end
a=1;
for i=1:length(r) %Saving the bounding box indices in takethisbox array
    for j=1:c1
        takethisbox(a,j)=NR(r(i),j);
    end
    a=a+1;
end
% NR
% A
% takethisbox