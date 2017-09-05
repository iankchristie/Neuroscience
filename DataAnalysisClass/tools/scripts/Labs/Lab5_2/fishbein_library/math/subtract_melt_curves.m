function [T, mcdiff] = subtract_melt_curves(m1,m2)


T = m1(1,:);
mcdiff = m1(2:end,:)-m2(2:end,:);
