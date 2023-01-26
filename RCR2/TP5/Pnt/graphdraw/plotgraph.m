function plotgraph(G)
% PLOTGRAPH Display a directed graph using dotty
% plotgraph(G)
% G is the adjacency matrix

mkdot(G, 'junk.dot');
!dot -Tps junk.dot -o junk.ps
!convert junk.ps junk.tif
A = imread('junk.tif', 'tif');
imagesc(A);
colormap(gray)
