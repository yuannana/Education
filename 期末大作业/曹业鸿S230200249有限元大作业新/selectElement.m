function [selection]=selectElement()
fprintf('���㵥Ԫ���ͣ�\n');
fprintf('CPS6--����������ƽ��Ӧ�䵥Ԫ\n');
fprintf('CPS4--�����ı�����ƽ��Ӧ�䵥Ԫ\n');
fprintf('C3D4--���������嵥Ԫ\n');
fprintf('S4R --�������ֿǵ�Ԫ\n');
selection=input('\n','s');
switch selection
    case 'CPS6'
        fprintf('ѡ��Ԫ:%s\n',selection);
    case 'CPS4'
        fprintf('ѡ��Ԫ:%s\n',selection);
    case 'C3D4'
        fprintf('ѡ��Ԫ:%s\n',selection);
    case 'S4R'
        fprintf('ѡ��Ԫ:%s\n',selection);
    otherwise
        fprintf('�������\n');
end
% LOAD DATA
selection=strcat(selection,'.inp');

return