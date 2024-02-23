%% 
% ����������ı��εȲε�Ԫ���������(�ܾ�����)������м���
%ģ�ͣ�һ���ܵ��̶�Լ������һ�����ɵ���������
%������λ�ơ�Ӧ����Ӧ��������ָ��ķ�����
% ���������
%            1.��������ʼͼ��figure��1��
%            2.���κ�ı���ͼfigure��2��
%            2.���κ����ꡢӦ����Ӧ����ͼfigure��3��~figure��10��
% ������ݰ�����
%            1.ͼ�������
%            2.plt�ļ����(λ�ơ�Ӧ����Ӧ�䡢���ϳ�����)��
%% 
clear all;clc;clear;
format short
first_time=cputime; 

%���Ľڵ�͵�Ԫ����
lengthx=12;             %���ȷ��򳤶�
lengthy=6;              %��ȷ��򳤶�
lx=60;                  %���ȷ���Ԫ��
ly=30;                  %��ȷ���Ԫ��
nel=lx*ly;            %�ܵĵ�Ԫ��
nnel=4;                %ÿ����Ԫ�Ľڵ���
ndof=2;                 %ÿ���ڵ�����ɶ�
nnode=(lx+1)*(ly+1);    %ϵͳ�ܽڵ���    
sdof=nnode*ndof;        %ϵͳ�����ɶ�
edof=nnel*ndof;        %ÿ����Ԫ�����ɶ�

%���ϲ���
Emodule=1E6;                  %����ģ��E
Poisson=0.3;                %���ɱ�

%��˹���ֵ��ѡ�񣨿ɷֱ����1X1��˹���֡�2X2��˹���֡�3X3��˹���ֵĽ����
%�˴�ѡ��3X3��˹����
% nglx=1; ngly=1;       %(1X1��˹����)
% nglx=2; ngly=2;       %(2X2��˹����)
nglx=3; ngly=3;         %(3X3��˹����)
nglxy=nglx*ngly;        %��˹���ֵ�����
%%
%�ڵ�����
x0=[];
for i=1:lx+1
    for j=1:ly+1
        x0=[x0; (i-1)*lengthx/lx  -0.5*lengthy*(1+(lx+1-i)/lx)*(1-(j+16)/ly)];
    end
end

%����Ԫ�Ľڵ�����
nodes=[];
for i=1:lx
    for j=1:ly
        nodes=[nodes; (ly+1)*(i-1)+j (ly+1)*i+j (ly+1)*i+j+1 (ly+1)*(i-1)+j+1;];
    end
end

%���Ƴ�ʼλ��ͼ��
figure(1) 
axis off                           %ȡ�����������һ������
axis equal                         %�ϸ���Ƹ�����ķֶ�ʹ�����
hold on
 for ie=1:nel                      %����Ԫ
    for j=1:nnel+1                 %���ӳɻ�
        j1=mod(j-1,nnel)+1;
        xp(j)=x0(nodes(ie,j1),1);  %����Ԫ�ڵ�x����
        yp(j)=x0(nodes(ie,j1),2);  %����Ԫ�ڵ�y����
    end
       plot(xp,yp,'-b')   
 end
legend('����ǰ״̬') 
%%
%���о���ĳ�ʼ��
ff=sparse(sdof,1);			%����ʼ��
kk=zeros(sdof,sdof);	    %ϵͳ����
U=sparse(sdof,1);		    %��ʼϵͳλ��
u=sparse(edof,1);		    %��ʼ��Ԫλ��
stress=zeros(nel,4,3);      %��ʼӦ������selem��ʾ��Ԫ����4��ʾһ����Ԫ��Ӧ�����ĸ���˹���ֵ㣬3��ʾÿһ����˹���ֵ��Ӧ������Ӧ��ֵ��;
strain=zeros(nel,4,3);      %��ʼ��Ӧ�����
B=sparse(3,8);              %B�����ʼ��
D=sparse(3,3);			    %D�����ʼ��

%��1X1��˹���֡�2X2��˹���֡�3X3��˹���ֵĻ��ֵ�ֵ��Ȩϵ������ͬһ�������У�����ѡ����ȡ
ss=[0 0 0;-1/sqrt(3) 1/sqrt(3) 0; -sqrt(0.6) 0 sqrt(0.6)];%��˹���ֵ�ֵ����
tt=[2 0 0;1 1 0;5/9 8/9 5/9];                             %��1X1��˹���֡�2X2��˹���֡�3X3��˹����Ȩϵ������
intpoint=ss(nglx,1:nglx);
weight=tt(nglx,1:nglx);
D=Emodule/(1-Poisson^2)*[1 Poisson 0;Poisson 1 0;0 0 (1-Poisson)/2];

%���е�Ԫ��ѭ������ɵ�Ԫ�նȾ���ļ��㣻
for iel=1:nel                           
    for i=1:nnel
        nd(i)=nodes(iel,i);                %��ȡ��iel����Ԫ�ĵ�i���ڵ�
        xcoord(i)=x0(nd(i),1);             %��ȡ��i�ڵ��x����ֵ
        ycoord(i)=x0(nd(i),2);             %��ȡ��i�ڵ��y����ֵ
    end
k=sparse(edof,edof);			           %��Ԫ����ĳ�ʼ��
jacob=zeros(2,2);                          %�ſ˱Ⱦ���ĳ�ʼ��

%���ø�˹���ֽ��е�Ԫ�նȾ�������
 for intx=1:nglx
        x=intpoint(intx);                  %��x���ϵĸ�˹��
        wx=weight(intx);                   %��x���ϵ�Ȩϵ��
        for inty=1:ngly
            y=intpoint(inty);              %��y���ϵĸ�˹��
            wy=weight(inty);               %��y���ϵ�Ȩϵ��
            [shape,dr,ds]=dshape(x,y);     %�����κ�������ƫ��
            jacob(1,1)=dr(1)*xcoord(1)+dr(2)*xcoord(2)+dr(3)*xcoord(3)+dr(4)*xcoord(4);
            jacob(1,2)=dr(1)*ycoord(1)+dr(2)*ycoord(2)+dr(3)*ycoord(3)+dr(4)*ycoord(4);
            jacob(2,1)=ds(1)*xcoord(1)+ds(2)*xcoord(2)+ds(3)*xcoord(3)+ds(4)*xcoord(4);
            jacob(2,2)=ds(1)*ycoord(1)+ds(2)*ycoord(2)+ds(3)*ycoord(3)+ds(4)*ycoord(4);
            detjacob=det(jacob);           %����ſ˱Ⱦ��������ʽ         
            invjacob=[jacob(2,2) -jacob(1,2);-jacob(2,1) jacob(1,1)]/detjacob; %�ſ˱Ⱦ�������
            dd=invjacob*[dr(1) dr(2) dr(3) dr(4);ds(1) ds(2) ds(3) ds(4)];     %ȫ������ϵ�µ�ƫ΢��
            B=bjuzhen(nnel,dd);                                                %���B����
            k=k+B'*D*B*wx*wy*detjacob;                                         %��Ԫ�նȾ������
            
        end
 end
   m=1;
     for i=1:nnel            %���е�Ԫ�նȾ�����ϵͳ�նȾ����еı任
         T(m)=2*nd(i)-1;
         T(m+1)=2*nd(i);
          m=m+2;
     end    
      for i=1:edof           %���иնȾ���ı任
          for j=1:edof
              kk(T(i),T(j))=kk(T(i),T(j))+k(i,j);
         end
      end
end
%%
%���ļ���
for i=1:lx+1
ff(2*(ly+1)*i,1)=-1000;        %ʩ��1000N�ľ����غ�
end

%�߽������Ĵ���
w=1:ly+1;
b=size(w,2);                   %��ȡ��Լ���Ľڵ���
for i=1:b
    kk(2*w(i)-1,2*w(i)-1)=1e20;%�ô��������������Ա�֤Լ���㴦��λ��Ϊ0��
    kk(2*w(i),2*w(i))=1e20;
end

%�������
U=kk\ff;

%��ԪӦ������
  stab=[ 1.8660   -0.5000   0.1340 -0.50000 ;
          -0.500    1.8660 -0.5000 0.1340 ;
          0.1340   -0.5000  1.8660 -0.5000 ;
          -0.5000    0.1340 -0.5000 1.8660];    %���ֵ㴦Ӧ����ڵ㴦Ӧ����ת��ϵ��
      
for iel=1:nel                                 
    for i=1:nnel
        nd(i)=nodes(iel,i);                     %��ȡ��iel����Ԫ�ĵ�i���ڵ�
        xcoord(i)=x0(nd(i),1);                  %��ȡ��i�ڵ��x����ֵ
        ycoord(i)=x0(nd(i),2);                  %��ȡ��i�ڵ��y����ֵ
    end
    k=sparse(edof,edof);			       
    
%���и�˹����
    t=0;
    gstress=zeros(3,4);                         %ÿһ�д���һ����˹���ϵ�Ӧ��
    gstrain=zeros(3,4);
    for intx=1:nglx
        x=intpoint(intx);                       %��x���ϵĸ�˹��
        wx=weight(intx);                        %��x���ϵ�Ȩϵ��
        for inty=1:ngly
            y=intpoint(inty);                   %��y���ϵĸ�˹��
            wy=weight(inty);                    %��y���ϵ�Ȩϵ��
            [shape,dr,ds]=dshape(x,y);          %�����κ�������ƫ��
            jacob(1,1)=dr(1)*xcoord(1)+dr(2)*xcoord(2)+dr(3)*xcoord(3)+dr(4)*xcoord(4);
            jacob(1,2)=dr(1)*ycoord(1)+dr(2)*ycoord(2)+dr(3)*ycoord(3)+dr(4)*ycoord(4);
            jacob(2,1)=ds(1)*xcoord(1)+ds(2)*xcoord(2)+ds(3)*xcoord(3)+ds(4)*xcoord(4);
            jacob(1,2)=ds(1)*xcoord(1)+ds(2)*ycoord(2)+ds(3)*ycoord(3)+ds(4)*ycoord(4);
            detjacob=det(jacob);                %�ſ˱Ⱦ��������ʽ         
            invjacob=[jacob(2,2) -jacob(1,2);-jacob(2,1) jacob(1,1)]/detjacob; %�ſ˱Ⱦ�������
            
            dd=invjacob*[dr(1) dr(2) dr(3) dr(4);ds(1) ds(2) ds(3) ds(4)];     %ȫ������ϵ�µ�ƫ΢��
                        
            B=bjuzhen(nnel,dd);                 %��⼸�ξ���B
   
            u=[U(2*nd(1)-1);U(2*nd(1));U(2*nd(2)-1);U(2*nd(2));U(2*nd(3)-1);U(2*nd(3));U(2*nd(4)-1);U(2*nd(4))];%��ÿ����Ԫ�����ڵ�λ�Ƽ���           
            estrain=B*u;                        %���㵥ԪӦ��
            estress=D*estrain;                  %���㵥ԪӦ��          
            t=t+1;                              %t��ʾ��t�����ֵ�
            gstress(:,t)=estress;               %�����γ�3X4����ÿһ�б�ʾһ����˹���Ӧ��
            gstrain(:,t)=estrain;
        end
    end

%ʵ�ָ�˹����ڵ�Ӧ����ת��
   for i=1:3
        for j=1:4
           for n=1:4
                stress(iel,j,i)= stress(iel,j,i)+stab(j,n)*gstress(i,n);
                strain(iel,j,i)=strain(iel,j,i)+stab(j,n)*gstrain(i,n);
            end
        end
   end
end
neigh_node = cell(nnode,1);
neigh_node_ind = cell(nnode,1);
indneigh=zeros(1,nnode);
for i=1:nel
    for j=1:4
        indneigh(nodes(i,j))=indneigh(nodes(i,j))+1;
        neigh_node{nodes(i,j)}(indneigh(nodes(i,j)))=i;
        neigh_node_ind{nodes(i,j)}(indneigh(nodes(i,j)))=j;
    end
end

% ÿ���ڵ��Ӧ��ֵ��Ӧ��ֵ
stress_node=zeros(3,nnode);	
strain_node=zeros(3,nnode);
for inode=1:nnode
    numel= indneigh(inode);
    for i=1:numel
        ind_nel= neigh_node{inode}(i);
        ind_nod=neigh_node_ind{inode}(i);
        for j=1:3
            stress_node(j,inode)=stress_node(j,inode)+stress(ind_nel,ind_nod,j);
            strain_node(j,inode)=strain_node(j,inode)+strain(ind_nel,ind_nod,j);
        end
    end
    stress_node(:,inode)=stress_node(:,inode)/numel;
    strain_node(:,inode)=strain_node(:,inode)/numel;
end
%%
%���
%����ڵ����ꡢλ�ơ�Ӧ����Ӧ����Ϣ
fid_out=fopen('result.plt','w');
fprintf(fid_out,'Title="test case governed by poisson equation"\n');
fprintf(fid_out,'lengthx=12;lengthy=6;lx=60;ly=30;Emodule=1E6;Poisson=0.3"\n');
fprintf(fid_out,'Variables="x" "y" "u" "v" "sigamx"  "sigmay" "sigmaxy" "epsilongx" "epsilongy""epsilongxy"\n');
fprintf(fid_out,'ZONE T="flow-field", N= %8d,E=%8d,ET=QUADRILATERAL, F=FEPOINT\n',nnode,nel);
for i=1:nnode
    fprintf(fid_out,'%16.6e%16.6e%16.6e%16.6e%16.6e%16.6e%16.6e%16.6e%16.6e%16.6e\n',x0(i,1),x0(i,2),U(2*i-1),U(2*i),stress_node(1,i),stress_node(2,i),stress_node(3,i),strain_node(1,i),strain_node(2,i),strain_node(3,i));
end
for i=1:nel
    fprintf(fid_out,'%8d%8d%8d%8d\n',nodes(i,1),nodes(i,2),nodes(i,3),nodes(i,4));
end

%������κ�λ��ͼ��
figure(2)
axis off%ȡ�����������һ������
axis equal%�ϸ���Ƹ�����ķֶ�ʹ�����
hold on
 for ie=1:nel
    for j=1:nnel+1
        j1=mod(j-1,nnel)+1;
        xp(j)=x0(nodes(ie,j1),1);
        yp(j)=x0(nodes(ie,j1),2);
        xm(j)=xp(j)+U(2*nodes(ie,j1)-1);
        ym(j)=yp(j)+U(2*nodes(ie,j1));
    end
       plot(xm,ym,'-r')   
 end
legend('���κ�״̬')     %���Ƴ�����ǰ���ͼ��

% �����ͼ
figure(3)
plotu(nel,U,nodes,x0,nnode,1)            %���u����λ����ͼ
figure(4)
plotu(nel,U,nodes,x0,nnode,2)            %���v����λ����ͼ
figure(5)
plotstress(nel,stress_node,nodes,x0,1)   %���x����sigamx��ͼ
figure(6)
plotstress(nel,stress_node,nodes,x0,2)   %���y����sigmay��ͼ
figure(7)
plotstress(nel,stress_node,nodes,x0,3)   %���sigmaxy��ͼ
figure(8)
plotstrain(nel,strain_node,nodes,x0,1)   %���x����epsilongx��ͼ
figure(9)
plotstrain(nel,strain_node,nodes,x0,2)   %���y����epsilongy��ͼ
figure(10)
plotstrain(nel,strain_node,nodes,x0,3)   %�������epsilongxy��ͼ




