Jones([1,4,2,5,5,2,6,3,3,6,4,1])

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
        x = x+1;
    else
        x = x-1;
    end
end
end

function [First,First0,Second,Second0] = KnotSplit(knot) %Used in Jones Function input is planar diagram
a = knot(1);
b = knot(2);
c = knot(3);
d = knot(4);
First0 = 0;
Second0 = 0;
if a == b || c == d
    Second0 = 1;
end
if a == d || b == c
    First0 = 1;
end
First = knot(5:end);
Second = First;
for i = 1:length(First)
    if Second(i) == b
        Second(i) = a;
    end
    if Second(i) == d
        if c==b
            Second(i) = a;
        else
            Second(i) = c; 
        end
    end
    if c==d
        if First(i) == a
            First(i) = d;
        end
        if First(i) == b
            First(i) = c;
        end
    else
        if First(i) == d
            First(i) = a;
        end
        if First(i) == c
            First(i) = b;
        end
    end
end
end

function x = Kaufmann(knot) %finds the kauffman bracket of a knot
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
        b0 = 1; a0 = 0;
    else
        a0 = 1; b0 = 0;
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

function x = Jones(knot)% uses the kauffman function to find the Jones polynomial
poly=Kaufmann(knot);
writhe1 = Writhe(knot);
order = poly(1);
poly = poly(2:end);
poly = poly.*(-1);
order = order-3*writhe1;
x = [order,poly];
end