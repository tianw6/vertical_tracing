% The second version of the tracing algorithm: increase the efficiency.
% If the 2 seed points generate 2 identical neurites, only one will be 
% preserved. 

clear all; close all; clc;

t6 = load('trace_t6.mat');

% create total image numbers
image_num = 50;

% read files
dataDir = '/Users/tianwang/Desktop/research/test_cap/Feb5_t5/';
file_type = '.jpg';
for ii = 1 : image_num
    if ii < 11 
        list_num = append('0',num2str(ii - 1));
    else 
        list_num = num2str(ii - 1);
    end
    full_name = [dataDir 'Feb5_t5' list_num file_type];
    % raw data of all images 
    data(:,:,ii) = im2bw(imread(full_name));
end


%% load the first image to define seedpoint
first_file_name = [dataDir 'Feb5_t5' '00' file_type];
I = im2bw(imread(first_file_name));
imshow(I);

%% input seedpoint and show the image along with the tracing boundary
close all; 
% create trace matrix
trace_matrix = zeros(1024, 1024, image_num);
% create the tracing boundary
range = 10;
% potential seeds: [306,291]  [679,175] [295,384]
seed = [380,888];

% store the shift in neurites on the first layer to connect
neurite_shift = cell2mat(t6.newSeed) - seed
% add the seedpoint on the trace_matrix
temp = seed + neurite_shift;
trace_matrix(temp(1), temp(2)) = 1;
% update trace matrix to include seed points
for s = 1 : size(seed,1)
    trace_matrix(temp(s,1), temp(s,2)) = 1;
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

seed_cell = mat2cell(seed, ones(1,size(seed,1)));
% total image number: image_num
for num = 2 : image_num 
    
    result = {};
    % update all seeds on the current image
    for jj = 1 : length(dir_vec)
        result{jj,1} = dir_vec{jj} + seed_cell{jj};
    end
    % (print out) seeds on the current image
     num
     seed = cell2mat(result)
    % after updating seed points, initialize direction & newSeed to be 0
    dir_vec = {};
    newSeed = {};

    % loop through all seeds
    for seedPoint_num = 1 : size(seed,1)
        % calculate all neurite around one seed 
        neurite = dynamic_searching(seed(seedPoint_num,:),data(:,:,num),range);  % data is the current image
        % update the new seed point & check whether the neurite is zero 
        
        %%%%%%%
        % have to make sure the newSeed is unique
        %%%%%%%
        
        if (isempty(neurite) == 0) 
            truNeurite = checkUnique(newSeed, neurite);
            if (isempty(truNeurite) == 0)
                newSeed{end + 1,1} = truNeurite;

                % update the position of neurite on the tracing matrix
                for nn = 1 : size(truNeurite, 1)
                    
                    %%%%%%%%%%%%%%%%%% add shift of neurite
                    trace_matrix(truNeurite(nn,1) + neurite_shift(1), truNeurite(nn,2) + neurite_shift(2), num) = 1;
                    %%%%%%%%%%%%%%%%%%
                    % test resultant point
                     [truNeurite(nn,1), truNeurite(nn,2)]
                end
                % calculate the direction of neurite tracing.
                dir_vec{end + 1,1} = truNeurite - seed(seedPoint_num,:);
                % (print out) direction
                seedPoint_num 
                neurite - seed(seedPoint_num,:)
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
% user define 
check_layer_num = input('What layer? ');

if check_layer_num < 10
    check_file_name = [dataDir 'Feb5_t6' '0' num2str(check_layer_num - 1) file_type];
else 
    check_file_name = [dataDir 'Feb5_t6' num2str(check_layer_num - 1) file_type];
end
    
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

%% plot the trace matrix & export the useful data

% plot the tracing matrix
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

%% export the data
% save('trace_matrix.mat', 'trace_matrix');
% save('newSeed.mat', 'newSeed');
% save('dir_vec.mat', 'dir_vec');
save('trace_t5.mat', 'trace_matrix', 'newSeed', 'dir_vec');

%%

data1 = t6.trace_matrix;
data1 = cat(3, data1, trace_matrix);

% plot the tracing matrix of 2 sections
A = logical(data1);
[x, y, z] = meshgrid(1:1024,1:1024,1:image_num*2);
% scatter3(x(:),y(:),z(:),90,A(:));
A = logical(A);
scatter3(x(A(:)),y(A(:)),z(A(:)),90,'r.');
xlabel("x");
ylabel("y");
zlabel("z");
xlim([1 1024]);
ylim([1 1024]);
