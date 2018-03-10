sorted = sort(double(searchv), 1);
spacing = diff(sorted, 1, 1);
minspacing = min(spacing, [], 1);
[maxminspacing, mmsindex] = max(minspacing, [], 2);
disp(sprintf('good seed = %d, min spacing = %d', goodseed(mmsindex), maxminspacing));