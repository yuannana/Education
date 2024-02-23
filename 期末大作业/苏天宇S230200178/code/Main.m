clear
clc
%% ��ȡ��Ŀ��Ϣ����
Input
%% ��Ԫ�նȾ���Ĺ�����ȫ�ָնȾ����װ��
Dimension_Matrix=2*Num_Node;%����ά��
K_global=zeros(Dimension_Matrix);%��ʼ��ȫ�־���
Information_element=[];%���ܵ�Ԫ��Ϣ ���� �Ƕ�ֵ �Ұ���Ԫ˳��
for i = 1:Num_Element%ȫ�־���װ��
    [stiffness_element,length_element,c,s]=Element_stiffness_matrix(ID_Element(i,4),ID_Element(i,5),...
        ID_Node(ID_Element(i,2),2),ID_Node(ID_Element(i,2),3),...
        ID_Node(ID_Element(i,3),2),ID_Node(ID_Element(i,3),3));
    K_global=K_global+Assembly_stiffness_matrix(stiffness_element,...
        ID_Element(i,2),ID_Element(i,3),Num_Node);
    Information_element=[Information_element;length_element,c,s];
end
%% ����������λ���Լ���Ԫ�̶�֧����
[Displacement,Force]=Solve_problem(K_global,ID_Node(:,6),ID_Node(:,7),ID_Node(:,4),ID_Node(:,5),Num_Node);
%% �����ĿҪ����ֱλ��
Displacement_y=[];
Displacement_x=[];
for i =1:Dimension_Matrix %��ֱλ��
    if mod(i,2)==0
        Displacement_y=[Displacement_y;Displacement(i)];
    else
        Displacement_x=[Displacement_x;Displacement(i)];
    end
end
[max_Displacement_y,max_Displacement_pos]=min(Displacement_y);
%% ������ⵥԪӦ����Ӧ��
[Stress,Strain]=Post_treatment(Displacement,ID_Element,Information_element);
%% �����Ŀ�����ѹӦ��
[max_stress,max_pos]=max(Stress);
[min_stress,min_pos]=min(Stress);
%% ���ͼ����
Output
