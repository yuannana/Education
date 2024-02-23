function plotstrain(nel,stress_node,nodes,x0,iStrain)
% ��ʾӦ����ͼ
% �������
% iStress Ӧ������ָ�꣬�������������ֵ
%           1����x����Ӧ��
%           2����y����Ӧ��
%           3������Ӧ�� 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ȷ��ͼ�δ�������
format  short 
switch iStrain
    case 1
        title='epsilongx';
    case 2
        title='epsilongy';
    case 3
        title='epsilongxy';
end
%%%%%%%%%%%%%%%%%%%%%����ͼ�δ��ڣ������������ᣬָ������
axis equal;
axis off;
set(gcf,'NumberTitle','off');
set(gcf,'Name',title);               
strainMin=min(stress_node(iStrain,:));  %ȷ����СӦ��
strainMax=max(stress_node(iStrain,:));  %���Ӧ��
caxis([strainMin,strainMax]);           %ָ����ɫӳ���
colormap('jet');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%���ݵ�Ԫ�ڵ������Ӧ��ֵ���������ı��Σ���ʾӦ����ͼ
for ie=1:1:nel
    x=[x0(nodes(ie,1),1);
       x0(nodes(ie,2),1);
       x0(nodes(ie,3),1);
       x0(nodes(ie,4),1)];
    y=[x0(nodes(ie,1),2);
       x0(nodes(ie,2),2);
       x0(nodes(ie,3),2);
       x0(nodes(ie,4),2)];
   c=[ stress_node(iStrain,nodes(ie,1));
       stress_node(iStrain,nodes(ie,2));
       stress_node(iStrain,nodes(ie,3));
       stress_node(iStrain,nodes(ie,4))];
   set(patch(x,y,c),'EdgeColor','interp')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%������ɫ��������ָʾ��ͬ��ɫ����Ӧ��Ӧ��ֵ
yTick=strainMin:(strainMax-strainMin)/10:strainMax;
Label=cell(1,length(yTick));
for i=1:length(yTick)
    Label{i}=sprintf('%2f',yTick(i));
end
set(colorbar('vert'),'YTick',yTick,...
    'YTickLabelMode','Manual','YTickLabel',Label);
