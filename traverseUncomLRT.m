%% test Process : recursively traverse a unfinished LRT
%
%  call function: traverseComLRT
%
%  Function:  This .m file is used for traverse a LRT with a single image
%
%  Input: @img �� test image
%            @nodeNo :  current node no.
%            @LRT : a finished LRT tree 
%            @pos : centre of mass of depth image(x,y,z/ z is an origin depth using to normalize)
%            @postionSet : 16 obserable vertexes
%            @latentSet : all vertexes including latent vertexes
%
%  Output: @postionSet : final 16 positions
%               @latentSet: 31 vertexes
%
%   written by Sophia
%   2016.01.22
%%

function leafNode= traverseUncomLRT(img,nodeNo,LRT,pos,leafNode)

x = pos(1,1);
y = pos(1,2);
origind = pos(1,3);

%% ������
if(LRT{nodeNo,1}(1) == 1)
%split node
    u = [x+(LRT{nodeNo,1}(5)/origind) y+(LRT{nodeNo,1}(6)/origind)];
    v = [x+(LRT{nodeNo,1}(7)/origind) y+(LRT{nodeNo,1}(8)/origind)];
    f = double(img(uint16(u(1,2)),uint16(u(1,1)))) - double(img(uint16(v(1,2)),uint16(v(1,1))));
    if(f <= LRT{nodeNo,1}(9))
        %% left 
        [leafNode] = traverseUncomLRT(img,LRT{nodeNo,1}(3),LRT,pos,leafNode);
    else 
        %% right
        [leafNode] = traverseUncomLRT(img,LRT{nodeNo,1}(4),LRT,pos,leafNode);
    end
else
    %%division node
    posl = pos + [LRT{nodeNo,1}(5) LRT{nodeNo,1}(6) 0];
    posr = pos + [LRT{nodeNo,1}(8) LRT{nodeNo,1}(9) 0];
    
    if(LRT{nodeNo,1}(3) == -2 && LRT{nodeNo,1}(4) ~= -2)
    %%division node ��ڵ���Ҷ�ӽڵ�
       leafNode = traverseUncomLRT(img,LRT{nodeNo,1}(4),LRT,posr,leafNode);
    elseif(LRT{nodeNo,1}(4) == -2 && LRT{nodeNo,1}(3) ~= -2)
    %%division node �ҽڵ���Ҷ�ӽڵ�
        leafNode = traverseUncomLRT(img,LRT{nodeNo,1}(3),LRT,posl,leafNode);
    elseif(LRT{nodeNo,1}(3) == -1 && LRT{nodeNo,1}(4) == -1)
    %%LRT division node ��Ҷ�ӽڵ�
        leafNode{size(leafNode,1)+1,1} = nodeNo;
        return;
    elseif(LRT{nodeNo,1}(3) == -2 && LRT{nodeNo,1}(4) == -2)
     %%LTM division node ��Ҷ�ӽڵ�
        return;
    else
    %%division node�м�ڵ�
        leafNode = traverseUncomLRT(img,LRT{nodeNo,1}(3),LRT,posl,leafNode);
        leafNode = traverseUncomLRT(img,LRT{nodeNo,1}(4),LRT,posr,leafNode);
    end
end