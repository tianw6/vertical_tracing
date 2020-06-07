% This is the first version of tracing algorithm. It can trace multiple
% neurites on 1 section. However, when tracing branches, some neurites are 
% identical and these neurites will pass to become seed points of next
% layer, which increase the computing resources

clear all; close all; clc;

% create variables
image_num = 50;
range = 10;

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
I = im2bw(imread('/Users/tianwang/Desktop/research/test_cap/Feb5_t6/Feb5_t601.jpg'));
imshow(I);

%% input seedpoint
close all;
% create trace matrix
trace_matrix = zeros(1024, 1024, image_num);

% potential seeds: [306,291]  [679,175] [295,384]
% seed = [306,291;295,384;679,175];
% branch & merge seeds
seed = [727,220];
% initialize the z direction of the seedpoint: all 0
dir_vec = cell(1, size(seed,1));
dir_vec(:) = {[0,0]};

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
            newSeed{end + 1} = neurite;
            
%             % update the position of neurite on the tracing matrix
            for nn = 1 : size(neurite, 1)
                trace_matrix(neurite(nn,1), neurite(nn,2), num) = 1;
                % test resultant point
                 [neurite(nn,1), neurite(nn,2)]
            end
            % calculate the direction of neurite tracing.
            dir_vec{end + 1} = neurite - seed(seedPoint_num,:);
            % (print out) direction
            seedPoint_num 
            neurite - seed(seedPoint_num,:)
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
check = im2bw(imread('/Users/tianwang/Desktop/research/test_cap/Feb5_t6/Feb5_t610.jpg'));
c = [288,378];
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

    


