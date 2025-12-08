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
    currentRow = 1;
    arcMat(1, 1) = 1;

    % Fill arcMat
    for i = 1:m
        for j = 1:n
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
        if arcMat(currentRow, 1) == 0
            arcMat(currentRow, 1) = currentArc;
        else
            arcMat(arcMat == currentArc) = arcMat(currentRow, 1);
            currentRow = find(arcMat(:,1) == 0, 1, 'first');
            arcMat(currentRow, 1) = currentArc;
        end
    end

    % Building Planar Diagram
    PD = zeros(n, 4);

    for j = 1:n
        k = abs(word(j));

        a = arcMat(k,   j);
        b = arcMat(k+1, j);
        c = arcMat(k+1, j+1);
        d = arcMat(k,   j+1);

        if word(j) < 0
            PD(j, :) = [a, b, c, d];
        else
            PD(j, :) = [b, c, d, a];
        end
    end
end
