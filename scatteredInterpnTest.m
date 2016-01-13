% function scatteredInterpnTest()
nDim = 2;
nRNG = nDim*75;

xInterp = 0:0.1:1;

X = rand(nRNG,nDim);

funV = @(X) prod(0.5*cos(bsxfun(@plus,2*pi.*X,pi/3*(1:size(X,2)))),2);

V = funV(X);

XIgrid = cell(1,nDim);
[XIgrid{:}] = ndgrid(xInterp);

XI = cell2mat(cellfun(@(xi) xi(:),XIgrid, 'un',0));

[VI, T] = scatteredInterpn(X, V, XI, 'l');

nFl = @()  scatteredInterpn(X, V, XI, T, 'l');
nFn = @()  scatteredInterpn(X, V, XI, T, 'n');
t_nfl = timeit(nFl,2)
t_nfn = timeit(nFn,2)

if nDim == 2
   Fl = scatteredInterpolant(X,V,'linear','none');
   VIF = Fl(XI(:,1), XI(:,2));
   fFl = @() Fl(XI(:,1), XI(:,2));
   t_Fl = timeit(fFl)


   % figureDefault(1,true,[6,3])%
   figure

   VIgrid = reshape(VI,size(XIgrid{1}));
   subplot(1,2,1),grid on, hold on, box on
   plot3(X(:,1),X(:,2),V(:),'ok','linewidth',1,'markerfacecolor','k','markerSize',5)
   patch('Faces',T,'Vertices',[X,V],'FaceVertexCData',V,'facecolor','interp',...
      'facealpha',0.85);
   axis square
   view([-40,60])

   subplot(1,2,2),grid on, hold on, box on
   surf(XIgrid{:},VIgrid,'facealpha',0.85,'facecolor','interp','edgecolor','k','markerSize',5)
   plot3(X(:,1),X(:,2),V(:),'ok','linewidth',1,'markerfacecolor','k')
   % view(3)
   axis square
   view([-40,60])
end
