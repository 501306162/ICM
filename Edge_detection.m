%edge detection
% �Ҷ�ͻ��..�Ǳ�Ե..feֵΪ1...����Ϊ0...û����Ŀ�����...
fe=((ind-neighbor).^2-alpha)>0;
% ÿ�����ص��smoothcost
Uf=((ind-neighbor).^2)*(1-fe)+alpha*fe;

Uf_d=datacost+lamda*Uf;