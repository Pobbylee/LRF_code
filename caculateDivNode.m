%%  caculate divisionNode offset ,LRT v1&v2
%
%  call function: NULL
%
%  Function: This .m file is used for caculate divisionNode offset
%                   ���㵱ǰ���ݼ�LTM�ڵ㵽���ӽڵ�����ӽ���offsetƽ��ֵ
%
%  Input: @curIndex: ��ǰ���ݼ��±�
%            @LTM_node: ��ǰLTM�ڵ�
%            @allVertexpos���������ݵ�����vertexֵ
%            @LTM
%
%  Output: @offset��division node to left & right LTM sblings' offset
%
%  written by Sophia
%  last modified date:2016.03.24
%%


function offset = caculateDivNode(curIndex,LTM_node,allVertexpos,LTM)

    leftLTMsbling = LTM{LTM_node,1}(3);  
    rigtLTMsbling = LTM{LTM_node,1}(4);
    
    %% no depth 
    leftoffset = [allVertexpos(curIndex,(leftLTMsbling*3-2))-allVertexpos(curIndex,(LTM_node*3-2)),  allVertexpos(curIndex,(leftLTMsbling*3-1))-allVertexpos(curIndex,(LTM_node*3-1))];   
    rigtoffset = [allVertexpos(curIndex,(rigtLTMsbling*3-2))-allVertexpos(curIndex,(LTM_node*3-2)),  allVertexpos(curIndex,(rigtLTMsbling*3-1))-allVertexpos(curIndex,(LTM_node*3-1))];
    offset =[mean(leftoffset(:,1)),mean(leftoffset(:,2)),mean(rigtoffset(:,1)),mean(rigtoffset(:,2))];
    
%     %% no hand size normolize 
%     leftoffset = [allVertexpos(curIndex,(leftLTMsbling*3-2))-allVertexpos(curIndex,(LTM_node*3-2)),  allVertexpos(curIndex,(leftLTMsbling*3-1))-allVertexpos(curIndex,(LTM_node*3-1)),  allVertexpos(curIndex,(leftLTMsbling*3))-allVertexpos(curIndex,(LTM_node*3))];   
%     rigtoffset = [allVertexpos(curIndex,(rigtLTMsbling*3-2))-allVertexpos(curIndex,(LTM_node*3-2)),  allVertexpos(curIndex,(rigtLTMsbling*3-1))-allVertexpos(curIndex,(LTM_node*3-1)),  allVertexpos(curIndex,(rigtLTMsbling*3))-allVertexpos(curIndex,(LTM_node*3))];
%     offset =[mean(leftoffset(:,1)),mean(leftoffset(:,2)),mean(leftoffset(:,3)),mean(rigtoffset(:,1)),mean(rigtoffset(:,2)),mean(rigtoffset(:,3))];
%     

end