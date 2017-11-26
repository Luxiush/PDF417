codewords = [883 821 459 841 278 151 62 131 885 899 899 899 899 883 899 853];
ch = zeros(1,2*length(codewords));
c = 1;
for i = 1:length(codewords)
    lh = [floor(codewords(i)/30),mod(codewords(i),30)];% low && high
    for j = 1:2
        ch(c) = lh(j);
        c = c+1;
    end
    
end

%%
seq_num = [204,44,201,108,112,106,202,49,57,56,53,49,50,50,52,13,204,10,204,200,204,200,204,200,204,200,204,44,204,200,202,44];

seq2 = '';
for i=1:length(seq_num)
   seq2 = [seq2,char(seq_num(i))]; 
end
disp(seq2);

%%
tmp = '';
for i=0:32
    tmp = [tmp,char(i)];
end
disp(['|',tmp,'|']);
