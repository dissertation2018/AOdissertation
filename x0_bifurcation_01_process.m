%data preprocessing

%inputs are data points of the bifurcation diagrams x0 obtained from
%xpp/auto (1) speed v vs shift
%parameter x0 and (2) width theta vs shift parameter 

%output data is a three-column array whose first column gives the value of
%x0 and second and third columns respectively give the speed and width of a
%traveling pulse solution at that point

%paths
in_path = '/Users/alexonderdonk/Desktop/';
out_path = '/Users/alexonderdonk/Documents/Output/x0_bifurc_processed.csv';

%inputs
v_file = 'v';
th_file = 'th';

%process
V=dlmread(strcat(in_path,v_file));

X0=V(:,1);
V=V(:,2);

TH=dlmread(strcat(in_path, th_file));

if X0==TH(:,1)    
    THETA=TH(:,2);
else disp('Error')
end

d=size(V,1);

data=horzcat(X0,V,THETA);

%plots for visualization
plot(X0,V,'go')
plot(X0,THETA,'bo')

%output
csvwrite(out_path,data);