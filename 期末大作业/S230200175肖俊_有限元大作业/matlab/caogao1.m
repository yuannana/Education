%%
%�ڵ�����
x0=[];
for i=1:lx+1
    for j=1:ly+1
        x0=[x0; (i-1)*lengthx/lx  -0.5*lengthy*(1+(lx+1-i)/lx)*(1-(j+16)/ly)];
    end
end

%��ʾ����Ԫ�ڵ����꣬�������Ǻ�������
nodes=[];%������Ԫ�Ľڵ�����
for i=1:lx
    for j=1:ly
        nodes=[nodes; (ly+1)*(i-1)+j (ly+1)*i+j (ly+1)*i+j+1 (ly+1)*(i-1)+j+1;];
    end
end

%��������
figure(2)
hold on
axis off%ȡ�����������һ������
axis equal%�ϸ���Ƹ�����ķֶ�ʹ�����
for ie=1:nel%��Ԫ��
    for j=1:nnel+1%���ӳɻ�
        j1=mod(j-1,nnel)+1;%modȡ�������㣨(j-1��/nnel)
        xp(j)=x0(nodes(ie,j1),1);
        yp(j)=x0(nodes(ie,j1),2);
    end
    plot(xp,yp,'-')
end