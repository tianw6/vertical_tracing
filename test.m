% test centroid 
close all; clc; clear all;

I = imread('coins.png');
% level = graythresh(I);
% Iblur = imgaussfilt(I,3);
Ibw = im2bw(I);
% Ibw = Iblur > 10;
Ibw = imfill(Ibw,'holes');
% imshowpair(Iblur,Ibw,'montage')

Ilabel = bwlabel(Ibw);
stat = regionprops(Ilabel,'centroid');
centroid = cat(1, stat.Centroid);
imshow(Ibw); hold on;
for x = 1: numel(stat)
    a = stat(x).Centroid(1);
    b = stat(x).Centroid(2);
    plot(a,b,'ro');

end
% 
% for ii = 1 : size(centroid, 1)
%     plot(centroid(ii,1), centroid(ii,2), 'ro');
% end
%% general testing

m = {};
n = zeros(3,2);
nn = ones(1,2);
m{end + 1} = n;
m{2} = nn;
% m{2}
%% test the direction vector
clear all; clc;
% t represent the seed
t = [1,2;1,3;1,4;1,5;2,5];
% te represent the cell created by seed
te = mat2cell(t, ones(1,5));

% add represent the dir vec
add = {[2,1],[1,2;2,3], [1,3], [4,4], [3,4;5,4]};

result = {};
for jj = 1 : length(te)
    result{jj,1} = add{jj} + te{jj};
end

A = cell2mat(result);


%% test 3D plot
clear all; close all; clc;

A = zeros(20,20,10);
for aa = 1 : 10
    A(aa,aa,aa) = 1;
end
[x, y, z] = meshgrid(1:20,1:20,1:10);
% scatter3(x(:),y(:),z(:),90,A(:));
A = logical(A);
scatter3(x(A(:)),y(A(:)),z(A(:)),90,'filled');


%% test tracing algorithm
clear all; close all; clc
% dynamic_searching([291,306], data(:,:,2))
% % 
I = im2bw(imread('/Users/tianwang/Desktop/research/test_cap/Feb5_t6/Feb5_t600.jpg'));
c = [306,291];

range = 10;
% search the new centroid within 10 by 10 pixels around the center 
temp = I(c(2)- range: c(2) + range, c(1)- range: c(1) + range);
Ibw = imfill(temp,'holes');

Ilabel = bwlabel(Ibw);
s = regionprops(Ilabel,'centroid');
centroid = cat(1, s.Centroid);

% a n by 2 matrix, each row is a centroid
n = round(centroid) + c - range;

figure;
imshow(I);

hold on

% initial point
plot(c(1), c(2), 'g.');
boundBox(c(1), c(2), range);
% centroid 
for num2 = 1 : size(n,1)
    plot(n(num2,1),n(num2,2), 'r.');
end

%% test checkUnique
clc; clear all; close all
a = [1,2;2,3;3,4;1,1];
b = [3,3];
ismember(b,a,'rows')
% mm = a == b;
% nn = mm(:,1) + mm(:,2);
% find(nn == )

a = [[0,2],[2,4],[3,3],[3,3]];
unique(a)

%% 
clc; clear all; close all

layer = input('What layer? ');

%% test matrix segmentation

A = [1,2,4,5,6; 3,4,5,6,7;4,4,4,4,4;5,5,5,5,5];
B = A(1:2,3:4);

%% test horizontal tracing
clear all; clc; close all;
test = zeros(5,5,10);
test(3,3,2) = 1; test(3,3,4) = 1; test(3,3,6) = 1; test(3,3,8) = 1;
test(4,4,2) = 1; test(4,4,6) = 1; 
test(2,2,2) = 1; test(2,2,4) = 1; 

result = zeros(size(test));

for ll = 1 : size(test,1)
    for ww = 1 : size(test,2)
        pixel_sum = sum(test(ll,ww, :));
        if pixel_sum > 1
            pos = [];
            for dd = 1 : size(test,3)
                if test(ll,ww,dd) == 1
                    pos = [pos, dd];
                end
            end
            result(ll,ww,round(sum(pos)/pixel_sum)) = 1;
        end
        pixel_sum = 0;
    end
end

%% test connection points
close all; clear all; clc;

A = zeros(5,10);
A(2,1) = 1; A(5,10) = 1;


