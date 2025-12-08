function [PD, arcMat] = braid_to_pd(word, m)
% Converts a braid word to a planar diagram

    % Ensure inputs are correct
    word = word(:).';
    n = numel(word);
    if any(abs(word) < 1 | abs(word) > m-1)
        error('Each generator index must satisfy 1 <= |k| <= m-1 for m strands.');
    end

    % Initialisation
    arcMat = zeros(m, n+1);
    currentArc = 1;
    startRow   = find(arcMat(:,1) == 0, 1, 'first');
    currentRow = startRow;
    arcMat(currentRow, 1) = currentArc;

    % Fill arcMat
    while any(arcMat(:) == 0)
        for j = 1:n
            gen = word(j);
            k   = abs(gen);
            if currentRow == k
                currentRow = k + 1;
                currentArc = currentArc + 1;
            elseif currentRow == k + 1
                currentRow = k;
                currentArc = currentArc + 1;
            else
            end

            if arcMat(currentRow, j+1) == 0
                arcMat(currentRow, j+1) = currentArc;
            end
        end

        endRow = currentRow;

        if arcMat(endRow, 1) == 0
            arcMat(endRow, 1) = currentArc;
        else
            nextRow = find(arcMat(:,1) == 0, 1, 'first');
            if isempty(nextRow)
                break;
            else
                currentRow = nextRow;
                currentArc = currentArc + 1;
                if arcMat(currentRow, 1) == 0
                    arcMat(currentRow, 1) = currentArc;
                end
            end
        end

        if ~any(arcMat(:) == 0)
            break;
        end
    end

    % Building Planar Diagram
    PD = zeros(n, 4);

    for j = 1:n
        gen = word(j);
        k   = abs(gen);

        a = arcMat(k,   j    ); 
        b = arcMat(k,   j+1  ); 
        c = arcMat(k+1, j+1  ); 
        d = arcMat(k+1, j    ); 

        if gen > 0
            PD(j, :) = [d, c, b, a];
        else
            PD(j, :) = [a, d, c, b];
        end
    end

    % Merge closure arcs
    [arcMat, PD] = mergeClosureArcs(arcMat, PD);
end


function [arcMat, PD] = mergeClosureArcs(arcMat, PD)
%   Adjust arc labels to avoid extra numbers

    [m, nPlus1] = size(arcMat);
    lastCol = nPlus1;

    for r = 1:m
        a_start = arcMat(r, 1);
        a_end   = arcMat(r, lastCol);

        if a_start ~= a_end
            keep = min(a_start, a_end);
            kill = max(a_start, a_end);

            arcMat(arcMat == kill) = keep;

            PD(PD == kill) = keep;
        end
    end
end
