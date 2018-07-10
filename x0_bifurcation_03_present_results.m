%present results

%input is the tested coordinates of bifurcation diagram output from
%02_test_solutions

%output is a collection of bifurcation diagrams containing solutions which
%are considered legitimate within specified error tolerances

maxj=[];
minj=[];


infolder='/Users/alexonderdonk/Documents/Output/';
outfolder=infolder;
mat=load(strcat(infolder,'x0_bifurc_tested.csv'));

n=size(mat,1);

%the following section of code is useful for presenting a continuous line
%graph, but is not necessary for a scatter plot which is the current form
%of the output

gap=0.15;
jumps=[1];

for i=2:n
    if abs(mat(i,1)-mat(i-1,1))>gap
        jumps=vertcat(jumps,[i]);
    end
end

m=size(jumps,1);
flips=permn([-1 1],m);
p=2^m;

jumps=vertcat(jumps,[n+1]); %to avoid indexing errors

% miminizer=1;
narrowest=gap;

swaps=perms(1:m);
M=factorial(m);
for mm=1:M
    swap=swaps(mm,:);

    for k=1:p

        %obtain the continuous submatrices
        for L=1:m
            cell{L}=mat(jumps(L):jumps(L+1)-1,:);
        end

        flip=flips(k,:);

        for l=1:m
            if flip(l)==-1
                cell{l}=flipud(cell{l});
            end
        end

        test=[];
        for r=1:m
            test=vertcat(test,cell{swap(r)});
        end
        tests{mm,k}=test;
        diff=zeros(n-1,1);
        for i=1:n-1
        diff(i)=abs(test(i+1,1)-test(i,1));
        end
        widest=max(diff);
    %     if widest<gap
    %         sort=test;
    %         break;
    %     end
        if max(diff)<narrowest
    %             minimizer=k;
            narrowest=max(diff);
            sort=test;
            winner=tests{mm,k};
        end
    end

end

%relabel sorted output
x0=sort(:,1);
v_blue=sort(:,2);
v_red=sort(:,2);
th_blue=sort(:,3);
th_red=sort(:,3);
ck=sort(:,4);

blue=[];
red=[];

%separate legitimate ("blue") and illegitimate ("red") solutions
 for i=1:n
     if ck(i)==1
         blue=vertcat(blue,sort(i,1:3));
     else
         red=vertcat(red,sort(i,1:3));
     end
 end


legit=(ck==1);

v_blue(~legit)=NaN;
v_red(legit)=NaN;
th_blue(~legit)=NaN;
th_red(legit)=NaN;

%OUTPUT LEGITIMATE AND ILLEGITIMATE MATRICES
% csvwrite(strcat(outfolder,'legit.csv'),blue); 
% csvwrite(strcat(outfolder,'illegit.csv'),red);

figure

 subplot(3,1,1)
%  plot(x0,v_blue,'b',x0,v_red,'r')
plot(x0,v_blue,'bo')
 title('(a)')
 xlabel('x0')
 ylabel('v')
%      title('j vs v')
%    title('c vs v')

 subplot(3,1,2)
%  plot(j,th_blue,'b',j,th_red,'r',j,j,'g')
% plot(x0,th_blue,'b',x0,th_red,'r')
plot(x0,th_blue,'bo',x0,x0,'g')
title('(b)')
xlabel('x0')
ylabel('\theta')
%      title('j vs theta')
%    title('c vs theta')

 subplot(3,1,3)
%  plot(v_blue,th_blue,'b',v_red,th_red,'r')
plot(v_blue,th_blue,'bo')
 title('(c)')
 xlabel('v')
 ylabel('\theta')

 saveas(gcf,strcat(outfolder,'x0_bifurcation.png'))
 saveas(gcf,strcat(outfolder,'x0_bifurcation.fig'))


 close

