% This is the debug version of neurite_tracing2 : for each layer, the
% seedpoints along with a boundbox with side length of range are drawn
% Also, the tracing neurites are drawn in green
% Each seedpoint, direction and neurite will be printed in command window

clear all; close all; clc;

% create total image numbers
image_num = 50;

% read files
dataDir = '/Users/tianwang/Desktop/research/test_cap/Feb5_t6/';
file_list = [0 : 49];
file_type = '.jpg';
for ii = 1 : length(file_list)
    if ii < 11 
        list_num = append('0',num2str(ii - 1));
    else 
        list_num = num2str(ii - 1);
    end
    full_name = [dataDir 'Feb5_t6' list_num file_type];
    % raw data of all images 
    data(:,:,ii) = im2bw(imread(full_name));
end


%% load the first image to define seedpoint
first_file_name = [dataDir 'Feb5_t6' '00' file_type];
I = im2bw(imread(first_file_name));
imshow(I);

%% input seedpoint and show the image along with the tracing boundary
close all; 
% create trace matrix
trace_matrix = zeros(1024, 1024, image_num);
% create the tracing boundary
range = 10;
% potential seeds: [306,291]  [679,175] [295,384]
seed = [306,291;679,175;295,384];
% update trace matrix to include seed points
for s = 1 : size(seed,1)
    trace_matrix(seed(s,1), seed(s,2)) = 1;
end

% initialize the z direction of the seedpoint: all 0
dir_vec = cell(1, size(seed,1));
dir_vec(:) = {[0,0]};

%%%%%%%%%%%%
% show the image along with the tracing boundary
%%%%%%%%%%%%
imshow(I);
    for pt = 1 : size(seed, 1)
        hold on
        plot(seed(pt,1), seed(pt,2), 'r.');
        boundBox(seed(pt,1), seed(pt,2), range);
    end
%% dynamic tracing
clc
% define how many images you want to plot boundary box
images = 4;

seed_cell = mat2cell(seed, ones(1,size(seed,1)));
% total image number: image_num
for num = 2 : images
    
    result = {};
    % update all seeds on the current image
    for jj = 1 : length(dir_vec)
        result{jj,1} = dir_vec{jj} + seed_cell{jj};
    end
    %%%%%%%%%%%%%%%%%%%%% (print out) layer number and seeds on the current image
    num
    seed = cell2mat(result)  
    %%%%%%%%%%%%%%%%%%%%% plot the seed points
    figure;
    imshow(data(:,:,num));
    for pt = 1 : size(seed, 1)
        hold on
        plot(seed(pt,1), seed(pt,2), 'r.');
        boundBox(seed(pt,1), seed(pt,2), range);
    end
    %%%%%%%%%%%%%%%%%%%%%
    
    % after updating seed points, initialize direction & newSeed to be 0
    dir_vec = {};
    newSeed = {};

    % loop through all seeds
    for seedPoint_num = 1 : size(seed,1)
        % calculate all neurite around one seed 
        neurite = dynamic_searching(seed(seedPoint_num,:),data(:,:,num),range);  % data is the current image
        % update the new seed point & check whether the neurite is zero 
        
        if (isempty(neurite) == 0) 
            truNeurite = checkUnique(newSeed, neurite);
            if (isempty(truNeurite) == 0)
                newSeed{end + 1,1} = truNeurite;

                % update the position of neurite on the tracing matrix
                for nn = 1 : size(truNeurite, 1)
                    trace_matrix(truNeurite(nn,1), truNeurite(nn,2), num) = 1;
                
                    %%%%%%%%%%%%%%%%%% plot resultant point
                    hold on
                    plot(neurite(nn,1), neurite(nn,2),'g.')
                    % (print out) each neurite on current layer
                    [neurite(nn,1), neurite(nn,2)]
                    %%%%%%%%%%%%%%%%%% test resultant point
                    [truNeurite(nn,1), truNeurite(nn,2)]
                    %%%%%%%%%%%%%%%%%%                    
                end
                % calculate the direction of neurite tracing.
                dir_vec{end + 1,1} = truNeurite - seed(seedPoint_num,:);
                %%%%%%%%%%%%%%%%%%% (print out) direction
                seedPoint_num 
                neurite - seed(seedPoint_num,:)
                %%%%%%%%%%%%%%%%%%%
            end
        end
    end
    
    seed_cell = newSeed;
    % (print out) new Seed 
    newSeed
    % if there's no seed point, stop tracing 
    if (isempty(seed))
        disp('no seed')
        break
    end
end

%%
% debug plots: plot information of one specific layer
% require the previous code run to layer - 1
clc
% User define
check_layer_num = images + 1;
if check_layer_num < 10
    check_file_name = [dataDir 'Feb5_t6' '0' num2str(check_layer_num - 1) file_type];
else 
    check_file_name = [dataDir 'Feb5_t6' num2str(check_layer_num - 1) file_type];
end
    

check = im2bw(imread(check_file_name));
c = cell2mat(newSeed);

figure
imshow(check)
hold on
% initial point
for n = 1 : size(seed,1)
    plot(seed(n,1), seed(n,2), 'g.');
    boundBox(seed(n,1), seed(n,2), range);

end

seed_cell = mat2cell(seed, ones(1,size(seed,1)));
result = {};

% update all seeds on the current image
for jj = 1 : length(dir_vec)
    result{jj,1} = dir_vec{jj} + seed_cell{jj};
end
% (print out) seeds on the current image
 num
 seed = cell2mat(result)

%% plot the trace matrix
A = logical(trace_matrix);
[x, y, z] = meshgrid(1:1024,1:1024,1:image_num);
% scatter3(x(:),y(:),z(:),90,A(:));
A = logical(A);
scatter3(x(A(:)),y(A(:)),z(A(:)),90,'r.');
xlabel("x");
ylabel("y");
zlabel("z");
xlim([1 1024]);
ylim([1 1024]);

    


