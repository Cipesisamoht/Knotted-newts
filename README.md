This repository contains MATLAB code implementing the full pipeline for converting
a braid word into a planar diagram and computing the Jones polynomial of the
resulting knot or link.

File descriptions:

WritheKaufmanJones.m
  Author: **Thomas Stennett**
  Questions: 2, 3
  Description: Contains functions solving the writhe, Kauffman bracket and Jones polynomial of a knot (using planar diagram input).

braids.m
  Author: **Bede Capstick**
  Question: 4
  Description: Takes braid word as an input, and outputs a planar diagram notation array.

polynomialConvert:
  Author: **Aragorn Nichol**
  Question: 3 & 4
  Description: Takes jonesArray of highest exponent and coefficients as input, and outputs clean Jones polynomial.

knottesting.m
  Author: **Aragorn Nichol**
  Question: 2, 3 & 4
  Description: Compiles all functions into one place, and tests against knotinfo.csv, which are verified Jones polynomials, to ensure all code is working correctly.
  
