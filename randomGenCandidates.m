%% random generate RBF features and choose maxIG RBF
%
%  call function: NULL
%
%  Function: This .m file is used for randomly propose a set of split candidates {fi,ti}
%
%  Input:  @curImgIndex : current image index
%             @allVertexpos : all image 's all vertexpos(x,y,z)
%             @imageNames : all image Names
%             @LTM
%             @nodeLTM:  current LTM node
%
%  Output: @maxIG:  max Information Gain
%              @bestfeat: best RBF feature
%              @leftset: the left image set after splitting
%              @rigtset:  the right image set after splitting
%
%   written by Sophia
%   2016.01.14
%%

function [maxIG,bestfeat,leftset,rigtset] = randomGenCandidates(curImgIndex,allVertexpos,allmageNames,LTM,nodeLTM,dr)

%if only one image
if(size(curImgIndex,1) <= 1)
    maxIG = 0;
    bestfeat = 0;
    leftset = curImgIndex;
    rigtset = curImgIndex;
    return;
end

currVertexpos = allVertexpos(curImgIndex,:);  %��ǰ�����ݼ�������vertexpos����
normalizeDepth = currVertexpos(:,3);  %����ͼ���center position����ȣ�������һ��

numOffsets = 100; %����������u,v������
numTaos = 20;     %����������tao������
numImages = size(curImgIndex,1);
%numCandidates = numOffsets*numTaos;   %�õ�Candidate������

%%randomly generate 
r = mean(normalizeDepth)*dr; %ȡֵ�뾶
u = (rand(numOffsets,2)*2-1)*r;  %���ɣ�0,1�����offset u
v = (rand(numOffsets,2)*2-1)*r;  %���ɣ�0,1�����offset v
taoindex = uint32((rand(numTaos,1))*(numImages-1)+1);     %��������±꣬����ѡȡtao
f = zeros(numOffsets,numImages); 


for i = 1:numImages
    dI0 = normalizeDepth(i);
    I = imread(['./Training/Depth/',allmageNames{curImgIndex(i),1}]);
    %�г����ƣ�������Ȳ����
    maxpix = max(I(find(I < 30000)));
    I(find(I > 30000)) = maxpix;
    curVertexpos_x = repmat(currVertexpos(i,(nodeLTM-1)*3+1),numOffsets,1);
    curVertexpos_y = repmat(currVertexpos(i,(nodeLTM-1)*3+2),numOffsets,1);  
    
%     imshow(I);
%     hold on; 
%     plot(uint16(curVertexpos_x(1,1)),uint16(curVertexpos_y(1,1)),'ro');
%     plot(curVertexpos_x(1,1),curVertexpos_y(1,1),'g.');
%     depth = I(uint16(curVertexpos_y(1,1)),uint16(curVertexpos_x(1,1)));
    
    uI = [uint16(curVertexpos_x+(u(:,1)/dI0)),uint16(curVertexpos_y+(u(:,2)/dI0))];
    vI = [uint16(curVertexpos_x+(v(:,1)/dI0)),uint16(curVertexpos_y+(v(:,2)/dI0))];
    
    %judge whether position in the range of image 0<pos<240*320
    uI(find(uI(:,1)<=0 | uI(:,1)>=320),1) = ceil(curVertexpos_x(1,1));
    uI(find(uI(:,2)<=0 | uI(:,2)>=240),2) = ceil(curVertexpos_y(1,1));
    vI(find(vI(:,1)<=0 | vI(:,1)>=320),1) = ceil(curVertexpos_x(1,1));
    vI(find(vI(:,2)<=0 | vI(:,2)>=240),2) = ceil(curVertexpos_y(1,1));
    
    uf = zeros(size(uI,1),1); 
    vf = zeros(size(vI,1),1); 

    for t = 1:size(uI,1)
        uf(t,1) = I(uI(t,2),uI(t,1));
        vf(t,1) = I(vI(t,2),vI(t,1)); %һ��ͼƬһ�У�100��offset��Ӧ����Ȳһ�б�ʾͬһ��offset
    end
    f(:,i) = uf - vf;

end;

lnodeLTM = LTM{nodeLTM,1}(3);  %��ǰ�ڵ�����ӽڵ�
rnodeLTM = LTM{nodeLTM,1}(4);  %��ǰ�ڵ�����ӽ��
alloffvector2left = [currVertexpos(:,lnodeLTM*3-2)-currVertexpos(:,nodeLTM*3-2) , currVertexpos(:,lnodeLTM*3-1)-currVertexpos(:,nodeLTM*3-1) , currVertexpos(:,lnodeLTM*3)-currVertexpos(:,nodeLTM*3)];
alloffvector2rigt = [currVertexpos(:,rnodeLTM*3-2)-currVertexpos(:,nodeLTM*3-2) , currVertexpos(:,rnodeLTM*3-1)-currVertexpos(:,nodeLTM*3-1) , currVertexpos(:,rnodeLTM*3)-currVertexpos(:,nodeLTM*3)];
allcov = sum(diag(cov(alloffvector2left))) + sum(diag(cov(alloffvector2rigt))); %��������������offset vector��Э�������

IG = zeros(numOffsets,numTaos);

for j = 1:numTaos
    tao = f(:,taoindex(j));
    flag = f - repmat(tao,1,numImages);  
   
    flag(find(flag<=0)) = 0;
    flag(find(flag>0)) = 1;   %0��ʾ��ֵ���ߣ�1��ʾ���ֵ��ұ�
    
    for t = 1:numOffsets
        %%left dataset
        lindex = find(flag(t,:) == 0);
        if(size(lindex,2) <= 1)
            lcov = 0;
        else
            lcov = sum(diag(cov(alloffvector2left(lindex,:)))) + sum(diag(cov(alloffvector2rigt(lindex,:))));
        end
        
        %right dataset
        rindex = find(flag(t,:) == 1);
        if(size(rindex,2) <= 1)
            rcov = 0;
        else
            rcov = sum(diag(cov(alloffvector2left(rindex,:)))) + sum(diag(cov(alloffvector2rigt(rindex,:))));
        end
        
        IG(t,j) = allcov - lcov*size(lindex,2)/numImages - rcov*size(rindex,2)/numImages;
    end;
end

[maxIG,index] = max(IG(:));
[subx,suby] = ind2sub(size(IG),index);
% disp(['maxIG = ' num2str(maxIG) 'index = ' num2str(index)]);
besttao = f(subx,taoindex(suby));
bestfeat = [u(subx,:),v(subx,:),besttao];
leftset = curImgIndex(find(f(subx,:) <= besttao));
rigtset = curImgIndex(find(f(subx,:) > besttao));

end
