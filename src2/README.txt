main： 程序入口
getSymbolCharacter：提取符号字符
symchar2codeword： 由符号字符提取码字
decode：将码字解码得到最后结果，包含3个子模块：
	numberDecode：数字压缩模式的解码
	textDecode：  文本压缩模式的解码
	byteDecode：  字节压缩模式的解码（未实现）