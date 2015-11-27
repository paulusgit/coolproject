def GCcontent (filename):
# My name is Alice and I am also part of the team.
	def get_sequences(file):
	list = [] 
	header= file.readline()
	while len(header) != 0:
		seq = []
		seq.append(header[1:-1])
		r = ''
		while True:
			s=file.readline()
			if len(s)==0 or s[0] == '>':
				header = s
				break
			r=r+s[:-1]
		seq.append(r)
		list.append(seq)
	return list
	
	def GC_content(seq):
	cnt=0
	for c in seq:
	if c == 'C' or c == 'G':
		cnt = cnt+1
	return float(cnt) / len(seq)