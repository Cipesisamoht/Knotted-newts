word = [];
PD_arr = braid_to_pd(word)

function [PD_arr] = braid_to_pd(word)
% Converts a braid word to a planar diagram
    
    % Ensure inputs are correct and calculate how many strands are necessary
    word = word(:).';
    n = numel(word);
    m = max(abs(word)) + 1;
    if any(abs(word) < 1
        error('Invalid braid word inputted');
    end

    % Initialise matrix and starting values
    arcMat = zeros(m, n+1);
    currentArc = 1;
    currentRow = 1;
    arcMat(1, 1) = 1;

    % Traverse arcMat with Braid word m times to fill with arc values
    for i = 1:m
        for j = 1:n
        
            % Check if the crossings affect current strand path
            k = abs(word(j));
            if currentRow == k
                currentRow = k + 1;
                currentArc = currentArc + 1;
            elseif currentRow == k + 1
                currentRow = k;
                currentArc = currentArc + 1;
            end
            arcMat(currentRow, j+1) = currentArc;
        end

        % Ensure braid connection gives consistent arc values from 1 to n with no gaps
        if arcMat(currentRow, 1) == 0
            arcMat(currentRow, 1) = currentArc;
        else
            arcMat(arcMat == currentArc) = arcMat(currentRow, 1);
            currentRow = find(arcMat(:,1) == 0, 1, 'first');
            arcMat(currentRow, 1) = currentArc;
        end
    end

    % Building Planar Diagram
    PD_mat = zeros(n, 4);

    for j = 1:n
        k = abs(word(j));

        % Find arc values for each crossing
        a = arcMat(k,   j);
        b = arcMat(k+1, j);
        c = arcMat(k+1, j+1);
        d = arcMat(k,   j+1);

        % Define planar diagram notation in matrix form
        if word(j) < 0
            PD_mat(j, :) = [a, b, c, d];
        else
            PD_mat(j, :) = [b, c, d, a];
        end
    end

    % Format as an array for Jones Polynomial function computation
    PD_arr = reshape(PD_mat.', 1, []);
end

