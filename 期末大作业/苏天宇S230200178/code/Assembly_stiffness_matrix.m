function [Global_stiffness_matrix]=Assembly_stiffness_matrix(Element_stiffness_matrix,I,J,Num_node)
%% �նȾ����װ�� ��Ҫ�ѵ���ȫ�ָնȾ������䵽����ȫ�ָնȾ���֮�� ����ѭ�������ν���
Global_stiffness_matrix=zeros(2*Num_node);%��ʼ���նȾ���
Identifier=[2*I-1,2*I,2*J-1,2*J];
for i=1:4%ͨ������ѭ�����뵽ȫ�ָնȾ���֮��
    for j=1:4
        Global_stiffness_matrix(Identifier(i),Identifier(j))=Element_stiffness_matrix(i,j);
    end
end
end