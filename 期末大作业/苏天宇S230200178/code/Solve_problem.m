function [Displacement,Force]=Solve_problem(Stiffness_matrix,...
    Fixed_situation_x,Fixed_situation_y,External_load_x,External_load_y,Num_node)
%% ��¼�ǹ̶��ڵ��Լ�����
Record=[];%��¼��һ�����ǹ̶���
for i=1:Num_node %�ж��Ƿ�̶�x
    if Fixed_situation_x(i)==0 %ֻ��¼��Щ�ǹ̶���
        Record=[Record 2*i-1];
    end
    if Fixed_situation_y(i)==0
        Record=[Record 2*i];
    end
end
%% �������������
External_load_sum=[];%���ؾ�����ϳ�һ��
for i = 1:2*Num_node
    if mod(i,2)==1
        External_load_sum(i)=External_load_x((i+1)/2);
    else
        External_load_sum(i)=External_load_y(i/2);
    end
end
%% ɸѡ���ǹ̶��ڵ�Ķ�Ӧ�նȾ���
Free_External_load=[];%�������ɾ���ɸѡ
Free_stiffness=[];% �նȾ���ɸѡ�����ɵ���
Num_record=size(Record,2);
for i =1:Num_record
    Free_External_load(i)=External_load_sum(Record(i));
    for j =1:Num_record
        Free_stiffness(i,j)=Stiffness_matrix(Record(i),Record(j));
    end
end
%% �����ڵ�λ���Լ�֧����
Free_Displacement=(Free_stiffness^-1)*Free_External_load';%���ó�����λ��
Displacement=zeros(2*Num_node,1);%����λ�� �����������
for i =1:Num_record %������װΪ����
    Displacement(Record(i))=Free_Displacement(i);
end
Force=Stiffness_matrix*Displacement;%�õ������ڵ����õ���֧����

end
    
