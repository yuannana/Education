clc
clear
%%%%%%%%%%%%%%%%%%%%%%%%��������
load('x0.mat');         %��ȡ�ڵ�����x0Ϊ1225x2����
load('nodes.mat');      %��ȡ��Ԫ���nodesΪ1152x4����

nel=1152;               % ��Ԫ��
nnel=4;                 %ÿ����Ԫ�ڵ���
ndof=2;                 %ÿ���ڵ����ɶ�
nnode=1225;             %�ڵ�����   
sdof=2450;              %�����ɶ�
edof=8;                 %ÿ����Ԫ���ɶ�

%%%%%%%%%%%%%%%%%%%%%%%%��������

elastic=2e5;             %����ģ��
poisson=0.3;             %���ɱ�

fload=-10;               % ��10N
    
%%%%%%%%%%%%%%%%%%%%%%%%%%�߽�����

bcdof=[];
bcval=[];
for i=1:25
        bcdof=[bcdof 1+2*(i-1) 2+2*(i-1)];
        bcval=[bcval 0 0];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%��ʼ������
ff=sparse(sdof,1);			%������
k=sparse(edof,edof);		%��Ԫ�նȾ���
kk=zeros(sdof,sdof);		%�ܸնȾ���
disp=sparse(sdof,1);		%�ܽ��λ��
eldisp=zeros(edof,1);		%��Ԫ�ڵ�λ��
stress=zeros(nel,4,3);		%��Ӧ������
strain=zeros(nel,4,3);		%��Ӧ�����
B=sparse(3,8);		        % Ӧ�����B
D=sparse(3,3);			    % ���Ͼ���D

D=elastic/(1-poisson*poisson)* ...
   [1  poisson 0; ...
   poisson  1  0; ...
   0  0  (1-poisson)/2];            %������Ͼ���D

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%2x2��˹���ּ��ܸնȾ�����װ
 
for iel=1:nel                       %�������е�Ԫ
   k=sparse(edof,edof); 
    for i=1:4
        nd(i)=nodes(iel,i);         %��ȡ��Ԫ�ڵ�
        xcoord(i)=x0(nd(i),1);      %��ȡ�ڵ�x����
        ycoord(i)=x0(nd(i),2);      %��ȡ�ڵ�y����
    end
    pt=1/sqrt(3);
    gp = [-pt,-pt; pt, -pt; pt,pt; -pt,pt];             % ��˹���ֵ�  
    w1= [1,1,1,1];
    for t = 1:4                                         % ������˹���ֵ�
            
        [shape,dhdr,dhds]=feisoq4(gp(t,1),gp(t,2));     %�����κ����Լ��Ը�˹�Ʒֵ��ƫ��
            
         jacob=[dhdr;dhds]*[xcoord;ycoord]';            %�����ſ˱Ⱦ���  
            
         detjacob=det(jacob);                           %�����ſ˱Ⱦ�������ʽ        
            
         dxdy=(jacob)^(-1)*[dhdr;dhds];                 %�����κ����Խڵ�ƫ��
         dhdx=dxdy(1,:);
         dhdy=dxdy(2,:);  
            
         B=[dhdx(1) 0 dhdx(2) 0 dhdx(3) 0 dhdx(4) 0;
                 0 dhdy(1) 0 dhdy(2) 0 dhdy(3) 0 dhdy(4);
                 dhdy(1) dhdx(1) dhdy(2) dhdx(2) dhdy(3) dhdx(3) dhdy(4) dhdx(4)];%�������B
                                                         
         k=k+B'*D*B*w1(t)*detjacob;                                               %���㵥Ԫ�նȾ���
            
    end
 
    G=zeros(8,2*nnode);                             %��ʼ�ܸձ任����
    G(1,2*nodes(iel,1)-1)=1;                        %�ܸձ任����
    G(2,2*nodes(iel,1))=1;
    G(3,2*nodes(iel,2)-1)=1;
    G(4,2*nodes(iel,2))=1;
    G(5,2*nodes(iel,3)-1)=1;
    G(6,2*nodes(iel,3))=1;
    G(7,2*nodes(iel,4)-1)=1;
    G(8,2*nodes(iel,4))=1;
    kk=kk+G'*k*G;                                    %����նȾ���ϳ�
  
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%����
for i=50:50:2450;
    ff(i,1)=fload;  
end                                                  %�Ӿ����غ�10N
%------------------------
%Ӧ�ñ߽�����
[kk,ff]=feaplyc(kk,ff,bcdof,bcval);

[LL,UU]=lu(kk);                                     %�����طֽ�
utemp=LL\ff;
disp=UU\utemp;                                      %�ڵ�λ��

%********************����ڵ�Ӧ��Ӧ��*******************************

 stab=zeros(4);                                     %���ֵ�Ӧ�����ڵ�Ӧ����ת������
 for t=1:4
 stab(t,1)=0.25*(1-gp(t,1))*(1-gp(t,2));
 stab(t,2)=0.25*(1+gp(t,1))*(1-gp(t,2));
 stab(t,3)=0.25*(1+gp(t,1))*(1+gp(t,2));
 stab(t,4)=0.25*(1-gp(t,1))*(1+gp(t,2));
 end

 
 for iel=1:nel                      %%�������е�Ԫ
    for i=1:nnel
        nd(i)=nodes(iel,i);         %��ȡ��Ԫ�ڵ�
        xcoord(i)=x0(nd(i),1);      %��ȡ�ڵ�x����
        ycoord(i)=x0(nd(i),2);      %��ȡ�ڵ�y����
    end
  
    k=sparse(edof,edof);			%��ʼ��Ԫ�նȾ��� 
    
 
    %%%%%%%%%%%%%%2x2��˹����
    pk=0;
    gstress=zeros(3,4);
    gstrain=zeros(3,4);
    pt=1/sqrt(3);
    gp = [-pt,-pt; pt, -pt; pt,pt; -pt,pt];             
    w1  = [1,1,1,1];
    for t = 1:length(w1)                                 % ������˹���ֵ�
            
        [shape,dhdr,dhds]=feisoq4(gp(t,1),gp(t,2));     %�����κ����Լ��Ը�˹�Ʒֵ��ƫ��
            
         jacob=[dhdr;dhds]*[xcoord;ycoord]';           %�����ſ˱Ⱦ��� 
            
         detjacob=det(jacob);                           %�����ſ˱Ⱦ�������ʽ        
            
         dxdy=(jacob)^(-1)*[dhdr;dhds];                 %�����κ����Խڵ��ƫ��
         dhdx=dxdy(1,:);
         dhdy=dxdy(2,:);  
            
         B=[dhdx(1) 0 dhdx(2) 0 dhdx(3) 0 dhdx(4) 0;
                  0 dhdy(1) 0 dhdy(2) 0 dhdy(3) 0 dhdy(4);
                  dhdy(1) dhdx(1) dhdy(2) dhdx(2) dhdy(3) dhdx(3) dhdy(4) dhdx(4)];%�������B
            
         eldisp=[disp(2*nodes(iel,1)-1);disp(2*nodes(iel,1));
                 disp(2*nodes(iel,2)-1);disp(2*nodes(iel,2));
                 disp(2*nodes(iel,3)-1);disp(2*nodes(iel,3));
                 disp(2*nodes(iel,4)-1);disp(2*nodes(iel,4))]; % ��ȡ��Ԫλ��         
         estrain=B*eldisp;                                     % �����˹���ֵ��Ӧ��
         estress=D*estrain;                                    % �����˹���ֵ��Ӧ��         
         pk=pk+1;
         gstress(:,pk)=estress;                                 % �����˹���ֵ��Ӧ��
         gstrain(:,pk)=estrain;
    end
    for i=1:3                                                   % �ڵ���������Ӧ��
        for j=1:4                                               % ��Ԫ���ĸ��ڵ�Ӧ��
             stress(iel,j,i)= stress(iel,j,i)+stab(j,1)*gstress(i,1)+stab(j,2)*gstress(i,2)+stab(j,3)*gstress(i,3)+stab(j,4)*gstress(i,4);
             strain(iel,j,i)= strain(iel,j,i)+stab(j,1)*gstrain(i,1)+stab(j,2)*gstrain(i,2)+stab(j,3)*gstrain(i,3)+stab(j,4)*gstrain(i,4);
        end
    end
    
 end
stress_node=tolstress(nel,nnode,nodes,stress); %��stressת��Ϊstress_node3x1225����3������Ӧ��1225���ڵ�
strain_node=tolstress(nel,nnode,nodes,strain); %��strainת��Ϊstrain_node3x1225����3������Ӧ��1225���ڵ�

%********************����Ԫ����*******************************
% �������ͱ���ͼ
   figure(1)
   hold on
   axis off
   axis equal
   for ie=1:nel             
        for j=1:5
            j1=mod(j-1,4)+1;  
            xp(j)=x0(nodes(ie,j1),1);
            xp1(j)=x0(nodes(ie,j1),1)+disp((2*nodes(ie,j1)-1));
            yp(j)=x0(nodes(ie,j1),2);
            yp1(j)=x0(nodes(ie,j1),2)+disp(2*nodes(ie,j1));
        end
        plot(xp,yp,'-')
        hold on
        plot(xp1,yp1,'-g')
       
   end
% �����ͼ
plotdisp(nel,disp,nodes,x0,1)            %���u����λ����ͼ
plotdisp(nel,disp,nodes,x0,2)            %���u����λ����ͼ
plotstrain(nel,strain_node,nodes,x0,1)   %���x����Ӧ����ͼ
plotstrain(nel,strain_node,nodes,x0,2)   %���y����Ӧ����ͼ
plotstrain(nel,strain_node,nodes,x0,3)   %�������Ӧ����ͼ
plotstress(nel,stress_node,nodes,x0,1);  %���x����Ӧ����ͼ
plotstress(nel,stress_node,nodes,x0,2);  %���y����Ӧ����ͼ
plotstress(nel,stress_node,nodes,x0,3);  %�������Ӧ����ͼ


