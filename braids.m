word = [];
PD_arr = braid_to_PD(word)

function [PD_arr] = braid_to_PD(word)
% braid_to_PD Convert a braid word to a planar diagram

% Input: word - row or column vector of braid generators

% Output: PD_arr - 1*4n array encoding the planar diagram with n crossings,
% ensuring correct notation for input to other functions for computing the 
% writhe, Kauffman bracket and Jones Polynomial
    
    % Ensure inputs are correct and determine size of braid
    word = word(:).';
    n = numel(word);         % number of crossings
    m = max(abs(word)) + 1;  % number of strands
    if any(abs(word) < 1)
        error('Invalid braid word inputted');
    end

% Step 1:    

    % Initialise arc labelling matrix and starting values
    arc_mat = zeros(m, n+1);
    current_arc = 1;
    current_row = 1;
    arc_mat(1, 1) = 1;

    % Traverse arc_mat 'm' times for each operation 'n' of the braid word
    % to fill with arc values
    for i = 1:m
        for j = 1:n
        
            % Check if the current strand participates in the crossing and 
            % adjust current_row and current_arc accordingly
            k = abs(word(j));
            if current_row == k
                current_row = k + 1;
                current_arc = current_arc + 1;
            elseif current_row == k + 1
                current_row = k;
                current_arc = current_arc + 1;
            end
            % Fill the next matrix component with the correct arc value
            arc_mat(current_row, j+1) = current_arc;
        end

        % Close this strand of the braid and ensure matrix gives consistent
        % arc values from 1 to n, with no arc having more than 1 number
        if arc_mat(current_row, 1) == 0
            arc_mat(current_row, 1) = current_arc;
        else
            arc_mat(arc_mat == current_arc) = arc_mat(current_row, 1);
            current_row = find(arc_mat(:,1) == 0, 1, 'first');
            arc_mat(current_row, 1) = current_arc;
        end
    end

% Step 2:

    % Initialise matrix to hold four arc labels around each crossing
    PD_mat = zeros(n, 4);

    % Find arc values for all n crossings
    for j = 1:n

        % Find all four arc values for a crossing
        k = abs(word(j));

        a = arc_mat(k,   j);
        b = arc_mat(k+1, j);
        c = arc_mat(k+1, j+1);
        d = arc_mat(k,   j+1);

        % Ensure arc orders are correct depending on sign of the braid 
        % operation, so that PD notation is correct for further computation
        if word(j) < 0
            PD_mat(j, :) = [a, b, c, d];
        else
            PD_mat(j, :) = [b, c, d, a];
        end
    end

    % Format as an array for Jones Polynomial function computation
    PD_arr = reshape(PD_mat.', 1, []);
end
