function knottest(braid_to_pd,Jones,polynomialConvert,datafile)
    T = readtable(datafile,'HeaderLines',0,'ReadVariableNames',true);
    names = T.Name;
    PDs = T.PDNotation;
    jones = T.Jones;
    braids = T.BraidNotation;
    for i = 1:length(names)
        %define the data for the current test
        cName = names(i);
        cPD = cell2mat(PDs(i));
        cPD = cPD(3:end-2);
        cPD = split(cPD,"];[").';
        temp = [];
        for j = 1:length(cPD)
            temp = [temp str2num(cell2mat(cPD(j))).'];
        end
        cPD = temp;
        cBraid = cell2mat(braids(i));
        cBraid = cBraid(2:end-1);
        cBraid = str2num(cBraid).';
        cPDTest = braid_to_pd(cBraid);
        cJones = str2sym(jones(i));
        [~, cJonesTest] = polynomialConvert(Jones(cPDTest));
        %Data display
        disp(["Current knot:" cName])
        disp(["Braid notation:" cBraid])
        disp(["Planar Diagram notation:"])
        disp(["Reference:" cPD])
        disp(["Output:" cPDTest])
        disp(["Jones Polynomial:"])
        disp(["Expected:" string(cJones);"Output:" string(cJonesTest)])
        if cJones == cJonesTest && PDTest(cPD,cPDTest)
            disp("Test Passed")
        elseif cJones == cJonesTest && ~PDTest(cPD,cPDTest)
            disp("Planar diagram differs but Jones does not")
            disp("Likely a different projection due to braid form")
        else
            disp("Test Failed")
        end
        disp(".-''-..-''-..-''-..-''-..-''-..-''-..-''-..-''-..-''")
    end
end

function PDFlag = PDTest(refPD, testPD)
    %Goal is to find a way to apply some "transform"
    %to all elements of all crossings in testPD
    %and end up with refPD
    %Modular arithmetic mod highest arc number
    if length(refPD) ~= length(testPD)
        PDFlag = false;
    else
        maxArc = max(refPD);
        crossings = length(refPD)/4;
        refMat = zeros(crossings,4);
        testMat = zeros(crossings,4);
        %put the crossings in the same order
        for i = 1:crossings;
            refC = refPD(4*(i-1)+1:4*i);
            refMat(i,:) = refC;
            for j = 1:crossings;
                testC = testPD(4*(j-1)+1:1:4*j);
                if all(ismember(refC,testC)) && all(ismember(testC,refC))
                    testMat(i,:) = testC;
                end
            end
        end
        %apply the modular arithmetic
        addend = mod(refMat(1,1) - testMat(1,1),maxArc);
        testMat = mod(testMat + addend,maxArc);
        refMat = mod(refMat, maxArc);
        if refMat == testMat
            PDFlag = true;
        else
            PDFlag = false;
        end
    end
end

braidFun = @braid_to_PD;
jonesFun = @Jones;
polyFun = @polynomialConvert;
datafile = "knotinfo.csv";

knottest(braidFun, jonesFun, polyFun, datafile)

%Thomas' functions
function x = Writhe(knot) %Findds Writhe of an inputed planar Diagram
L = length(knot);
L = L/4;
x = 0;
for i = 1:L
    First = knot(4*i-2);
    Second = knot(4*i);
    if abs(First-Second)~=1
        temp = First;
        First = Second;
        Second = temp;
    end
    if First < Second
        x = x-1;
    else
        x = x+1;
    end
end
end

function [First,First0,Second,Second0] = KnotSplit(knot) %Used in kaufman Function input is planar diagram
a = knot(1);
b = knot(2);
c = knot(3);
d = knot(4);
First0 = 0;
Second0 = 0;
if a == b || c == d
    First0 = 1;
end
if a == d || b == c
    Second0 = 1;
end
First = knot(5:end);
Second = First;
for i = 1:length(First)
    if First(i) == b
        First(i) = a;
    end
    if First(i) == d
        if c==b
            First(i) = a;
        else
            First(i) = c; 
        end
    end
    if c==d
        if Second(i) == a
            Second(i) = d;
        end
        if Second(i) == b
            Second(i) = c;
        end
    else
        if Second(i) == d
            Second(i) = a;
        end
        if Second(i) == c
            Second(i) = b;
        end
    end
end
end

function x = Kaufmann(knot) %finds the kaufman bracket of a knot output form is [highest power of A, coeficient of highest power, coeficient of second highest power ...]
Length1 = length(knot)/4;
Length2 = Length1;
xnew = knot;
x1 = [];
amount = 1;
loopCache = [0];
loopCacheNew = loopCache;
while Length1 > 1 %breaks the knot down untill there is only a single intersection left
    x1 = xnew;
    xnew = [];
    loopCache = loopCacheNew;
    loopCacheNew = [];
    for i = 1:amount
        xcurrent = x1(4*i*Length1-4*Length1+1:4*i*Length1);
        [a,a0,b,b0] = KnotSplit(xcurrent);
        xnew = [xnew, a, b];
        loopCurrent1 = loopCache(i); %counts the amount of extra loops in the subknots
        loopCurrent2 = loopCurrent1 + b0;
        loopCurrent1 = loopCurrent1 + a0;
        loopCacheNew = [loopCacheNew, loopCurrent1, loopCurrent2];
    end
    Length1 = Length1-1;
    amount = amount*2;
end
x1 = xnew;
loopCache = loopCacheNew;
loopCacheNew = [];
for i = 1:length(x1)/4 %does the final break only counting the exess loops
    if x1(4*i-3)==x1(4*i-2)
        a0 = 1; b0 = 0;
    else
        b0 = 1; a0 = 0;
    end
    loopCurrent1 = loopCache(i);
    loopCurrent2 = loopCurrent1 + b0;
    loopCurrent1 = loopCurrent1 + a0;
    loopCacheNew = [loopCacheNew, loopCurrent1, loopCurrent2];
end
loopCache = loopCacheNew; %finds the number of loops in each subknot after split so there are no more intersections
poly = [0]; 
first = 0;
last = 0;
for i = 1:length(loopCache)
    position = 0;
    currentI = i;
    for j = 1:Length2
        floatLength = length(loopCache);
        if currentI > floatLength/(2^j)
            position = position + 1;
            currentI = currentI-floatLength/(2^j);
        else
            position = position -1;
        end
    end
    positions = [position]; %finds the starting position of each elment of loopCache
    positionsNew = [];
    multiply = 1;
    numberof = 1;
    if loopCache(i) > 0
        for j = 1:loopCache(i)
            multiply = -multiply;
            for k = 1:numberof
                positionsNew = [positionsNew, positions(k)-2, positions(k)+2];
                positionsNew = unique(positionsNew);
            end
            numberof = numberof+1;
            positions = positionsNew;
            positionsNew = [];
        end
    else
        positions = [position];
    end %starts generating the polynomial
    oldFirst = first;
    first = min([first, positions]);
    if oldFirst ~= first
        difference = oldFirst-first;
        poly = [zeros(1,difference), poly];
    end
    oldLast = last;
    last = max([last,positions]);
    if oldLast ~= last
        difference = last-oldLast;
        poly = [poly,zeros(1,difference)];
    end
    for j = 1:length(positions)
        current = positions(j);
        poly(current-first+1) = poly(current-first+1)+multiply*nchoosek(length(positions)-1,j-1); %writes into the poly function
    end
end
x = [-first, poly];
end

function x = Jones(knot)% uses the kauffman function to find the Jones polynomial. output form is [highest power of A, coeficient of highest power, coeficient of second highest power ...]
poly=Kaufmann(knot);
writhe1 = Writhe(knot);
order = poly(1);
poly = poly(2:end);
poly = poly.*((-1)^writhe1);
order = order-3*writhe1;
x = [order,poly];
end

%Bede's function
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

%polynomial convert
function [Jones_A,Jones_t] = polynomialConvert(jonesArray)
    syms A t
    highestPower = jonesArray(1);
    jonesArray = jonesArray(2:end);
    Jones_A = 0;
    Jones_t = 0;
    for i = 1:length(jonesArray)
        %In terms of A
        Jones_A = Jones_A + jonesArray(i)*A^(highestPower-(i-1));
        %In terms of t
        Jones_t = Jones_t + jonesArray(i)*t^((-1/4)*(highestPower-(i-1)));
    end
    
end
