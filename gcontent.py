def GCcontent (filename):
	data = filename.read()
	datasplit = data.split("\n")
	data2 = "".join(datasplit)
	entries = []
	values = []
	for i,n in enumerate(data2):
		if n == ">":
			entries.append(i)
	entries.append(len(data2))
	w = 0
	for i,n in enumerate(data2):
		if n == ">":
			w = w+1
			GC = (data2.count("G",i,entries[w])+data2.count("C",i,entries[w]))*100/(entries[w]-i-14)
			values.append(data2[i:i+14]) # El +14 reflecteix els espais que ocupa el codi
			values.append(GC)
	mGC = max(values[1::2])
	print "The highest GC content can be found in:"
	print(values[values.index(mGC)-1],mGC)
	
	