function [Stress,Strain]=Post_treatment(Displacement,ID_Element,Information_element)
%% ���ù�ʽ��ȫ��λ��ת��Ϊ�ֲ�λ��
Num_element=size(ID_Element,1);
Strain=[];%��ʼ����Ԫ�ֲ�λ��
for i =1:Num_element
    u=[Information_element(i,2) Information_element(i,3) 0 0;...
        0 0 Information_element(i,2) Information_element(i,3)]...
        *[Displacement(2*ID_Element(i,2)-1);Displacement(2*ID_Element(i,2));...
        Displacement(2*ID_Element(i,3)-1);Displacement(2*ID_Element(i,3))];
    Strain=[Strain;(u(2)-u(1))/Information_element(i,1)];
end
Stress=ID_Element(:,4).*Strain;%ֱ�����ù�ʽ��Ӧ��

end
