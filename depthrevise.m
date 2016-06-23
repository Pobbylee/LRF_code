function[x,y,d] = depthrevise(I,row,col,pdepth)

%ȡ��������ȣ���rΪ����ȡֵ��ֱ�����С��30000

r = 0;
minpix = pdepth;
%ȡ�õ�����Ϊr������ֵ��С������ֵ
while(minpix > 30000)
    r = r+1;
    if(row-r <= 0)  %����r����ͼ���Ͻ�
        neardepth = I(row:row+r,col-r:col+r);
        [minpix,dindex] = min(neardepth(:));
        [subr,subc] = ind2sub(size(neardepth),dindex);
        corct_row = row+subr;
        corct_col = col-(r+1)+subc;
    elseif(row+r > 240)  %����r����ͼ���½�
        neardepth = I(row-r:row,col-r:col+r);
        [minpix,dindex] = min(neardepth(:));
        [subr,subc] = ind2sub(size(neardepth),dindex);
        corct_row = row-subr;
        corct_col = col-(r+1)+subc;
    else %δ�������½磨�˴�û���������ҽ磩
        neardepth = I(row-r:row+r,col-r:col+r);
        [minpix,dindex] = min(neardepth(:));
        [subr,subc] = ind2sub(size(neardepth),dindex);
        corct_row = row-(r+1)+subr;
        corct_col = col-(r+1)+subc;
    end
    
    %check image
    if(r >50)
        disp('Please check this image');
    end
    
end
%plot(corct_col,corct_row,'g.');
x = corct_col;
y = corct_row;
d = I(corct_row,corct_col);
           

        
end