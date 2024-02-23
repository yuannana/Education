function plotstress(nel,stress_node,nodes,x0,iStress)
% ��ʾӦ����ͼ
% �������
% iStress Ӧ������ָ�꣬�������������ֵ
%           1����x����Ӧ��
%           2����y����Ӧ��
%           3������Ӧ��  
%%%%%%%%%%%%%%%%%%%%%%%%%ȷ��ͼ�δ�������
switch iStress
    case 1
        title='sigamx';
    case 2
        title='sigamy';
    case 3
        title='sigamxy';
end
%%%%%%%%%%%%%%%%%%%%%����ͼ�δ��ڣ������������ᣬָ������
axis equal;
axis off;
set(gcf,'NumberTitle','off');
set(gcf,'Name',title);               
stressMin=min(stress_node(iStress,:));  %ȷ����СӦ��
stressMax=max(stress_node(iStress,:));  %���Ӧ��
caxis([stressMin,stressMax]);           %ָ����ɫӳ���
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
   c=[ stress_node(iStress,nodes(ie,1));
       stress_node(iStress,nodes(ie,2));
       stress_node(iStress,nodes(ie,3));
       stress_node(iStress,nodes(ie,4))];
   set(patch(x,y,c),'EdgeColor','interp')
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%������ɫ��������ָʾ��ͬ��ɫ����Ӧ��Ӧ��ֵ
yTick=stressMin:(stressMax-stressMin)/10:stressMax;
Label=cell(1,length(yTick));
for i=1:length(yTick)
    Label{i}=sprintf('%2f',yTick(i));
end
set(colorbar('vert'),'YTick',yTick,...
    'YTickLabelMode','Manual','YTickLabel',Label);

