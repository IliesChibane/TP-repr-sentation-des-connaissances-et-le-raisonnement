function h=gaussplot(mu, Sigma, ncontours)
% GAUSSDRAW Plot some contours of constant probability density of a 2D Gaussian centered on the mean
% h=gaussdraw(mu, Sigma, ncontours)

if ~exist('ncontours'), ncontours = -1; end

% Modelled afer demgauss from netlab.

ngrid = 50;
sx = 1*Sigma(1,1);
sy = 1*Sigma(2,2);
Xmin = mu(1)-sx; Xmax = mu(1)+sx; 
Ymin = mu(2)-sy; Ymax = mu(2)+sy; 
Xvals = linspace(Xmin, Xmax, ngrid);
Yvals = linspace(Ymin, Ymax, ngrid);
[X1, X2] = meshgrid(Xvals, Yvals);
XX = [X1(:), X2(:)];
% the i'th row of XX is the (x,y) coord of the i'th point in the raster scan of the grid

probs = gauss(mu, Sigma, XX);
probs = reshape(probs, ngrid, ngrid);

if ncontours==-1
  [C,h]=contour(X1, X2, probs);
else
  [C,h]=contour(X1, X2, probs, ncontours, 'k');
end
