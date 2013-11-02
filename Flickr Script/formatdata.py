json_file = open ('data.json' , 'w')

#writing set titles 
json_file.write('{"setTitles":[')
titles = []
with open ('settitles.temp' , 'r') as f:
    for line in f: 
    	titles.append(line.rstrip('\n'))
for i in range (0 , len(titles)):
	if (i == len(titles)-1):
		json_file.write(titles[i])
	else :
		json_file.write(titles[i] + ',')
json_file.write('],')

for i in range (0 , len(titles)):
	photo_urls_temp = []
	json_file.write(titles[i][:-1]+'_photos":[')
	with open ('photourls ' +str(i+1)+'.temp' , 'r') as f:
	    for line in f: 
	    	photo_urls_temp.append(line.rstrip('\n'))
	for a in range (0 , len(photo_urls_temp)):
		if (a == len(photo_urls_temp)-1):
			json_file.write('"'+photo_urls_temp[a]+'"')
		else :
			json_file.write('"'+photo_urls_temp[a]+'",')
	if (i == len(titles)-1):
		json_file.write(']}')
	else :
		json_file.write('],')



