function [kk,ff]=feaplyc(kk,ff,bcdof,bcval)

%----------------------------------------------------------
% �ⷽ��[kk]{x}={ff}
%  kk �ܸնȾ���
%  ff �ڵ���
%  bcdof Լ���Ľڵ����ɶ�
%  bcval Լ���Ľڵ����ɶ�ֵ
%

 
 n=length(bcdof);
 sdof=size(kk);

 for i=1:n
    c=bcdof(i);
    for j=1:sdof
       kk(c,j)=0;
    end

    kk(c,c)=1;
    ff(c)=bcval(i);
 end

