function imout=thining(imin)

I1=bwmorph(imin,'skel',Inf);

imout=bwmorph(I1,'thin',Inf);

end