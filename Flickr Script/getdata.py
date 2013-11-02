import json

d = 1
while (True):
	c = 1
	try:
   		with open('set_data ' + str(d)+'-'+str(c)+'.temp'): pass
	except IOError:
		break
	file_temp = open ('photourls ' + str(d)+'.temp' , 'w')
	while (True):
		try:
	   		with open('set_data ' + str(d)+'-'+str(c)+'.temp'): pass
		except IOError:
			break
		print ("URLS FOR NUMBER" + str(d))
		json_data=open('set_data ' + str(d)+'-'+str(c)+'.temp')
		data = json.load(json_data)	
		for a in range (0 , len(data['rows'])):
			for b in range (0 ,len(data['rows'][a]['row'])):
				file_temp.write(data['rows'][a]['row'][b]['sizes']['o']['url'] + '\n')
		json_data.close()
		c = c + 1
	file_temp.close()
	d = d + 1
