function NC=NC_calc(o_watermark,e_watermark)
pay=sum(sum(sum(o_watermark.*e_watermark)));
payda=sqrt(sum(sum(sum(o_watermark.*o_watermark))))*sqrt(sum(sum(sum(e_watermark.*e_watermark))));
NC=pay/payda;
end

