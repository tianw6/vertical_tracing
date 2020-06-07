% the function to check whether the current neurite is already exist in the
% newSeed
function truNeurite = checkUnique(newSeed, neurite)
    truNeurite = [];
    if (isempty(newSeed) == 1)
        truNeurite = neurite;
    else
        temp = cell2mat(newSeed);
        for num = 1 : size(neurite, 1)
            if ismember(neurite(num,:),temp,'rows') == 0
                truNeurite = cat(1, truNeurite, neurite(num,:));
            end
        end
    end
end

