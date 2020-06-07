% debug use: draw a box with side length of 2*range
function bdPts = boundBox(a,b, range)

bdPts(1) = a - range;
bdPts(2) = a + range;
bdPts(3) = b - range;
bdPts(4) = b + range;

hold on
plot([bdPts(1) bdPts(2)], [bdPts(3) bdPts(3)],'c');
plot([bdPts(1) bdPts(1)],[bdPts(3) bdPts(4)],'c');
plot([bdPts(1) bdPts(2)],[bdPts(4) bdPts(4)],'c');
plot([bdPts(2) bdPts(2)],[bdPts(3) bdPts(4)],'c');


end

