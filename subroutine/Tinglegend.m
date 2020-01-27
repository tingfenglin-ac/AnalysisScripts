function Tinglegend(symbol,str,symbolloca,txtloca,FONT);

for i=1:length(symbol)
plot(symbolloca(i,1),symbolloca(i,2),symbol{i})
text(txtloca(i,1),txtloca(i,2),str{i},'FontSize',FONT)
end