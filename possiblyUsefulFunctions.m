Jones([4,2,5,1,2,6,3,5,6,4,1,3])


function x = Writhe(knot) %Findds Writhe of an inputed planar Diagram
L = length(knot);
L = L/4;
x = 0;
for i = 1:L
    First = knot(4*i-2);
    Second = knot(4*i);
    if First < Second
        x = x-1;
    else
        x = x+1;
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
if a == b || c == d % there is an issue here with duplicate numbers
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
        First(i) = c;
    end
    if Second(i) == d
        Second(i) = a;
    end
    if Second(i) == c
        Second(i) = b;
    end
end
end

function x = Jones(knot) %finds the jones polynomial of a knot WIP
writhe = Writhe(knot);
Length1 = length(knot)/4;
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
x = loopCache; %need to turn this into the actual polynomial
end