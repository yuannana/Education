function plotu(nel,U,nodes,x0,nnode,idisp)
% ��ʾӦ����ͼ
% �������
% iStress Ӧ������ָ�꣬�������������ֵ
%           1����u����λ��
%           2����v����λ��  
%ȷ��ͼ�δ�������
switch idisp
    case 1
        title='u';
    case 2
        title='v';
end
a=zeros(nnode,2);
for i=1:nel
    a(i,1)=U(2*i-1);
    a(i,2)=U(2*i);
end
%����ͼ�δ��ڣ������������ᣬָ������
axis equal;
axis off;
set(gcf,'NumberTitle','off');
set(gcf,'Name',title);               
aMin=min(a(:,idisp));  %��Сλ��
aMax=max(a(:,idisp));  %���λ��
caxis([aMin,aMax]);           %ָ����ɫӳ���
colormap('jet');
%���ݵ�Ԫ�ڵ������Ӧ��ֵ���������ı��Σ���ʾӦ����ͼ
for ie=1:1:nel
    x=[x0(nodes(ie,1),1);
       x0(nodes(ie,2),1);
       x0(nodes(ie,3),1);
       x0(nodes(ie,4),1)];
    y=[x0(nodes(ie,1),2);
       x0(nodes(ie,2),2);
       x0(nodes(ie,3),2);
       x0(nodes(ie,4),2)];
   c=[ a(nodes(ie,1),idisp);
       a(nodes(ie,2),idisp);
       a(nodes(ie,3),idisp);
       a(nodes(ie,4),idisp)];
   set(patch(x,y,c),'EdgeColor','interp')
end
%������ɫ��������ָʾ��ͬ��ɫ����Ӧ��Ӧ��ֵ
yTick=aMin:(aMax-aMin)/10:aMax;
Label=cell(1,length(yTick));
for i=1:length(yTick)
    Label{i}=sprintf('%2f',yTick(i));
end
set(colorbar('vert'),'YTick',yTick,'YTickLabelMode','Manual','YTickLabel',Label);