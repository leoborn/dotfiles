#!/usr/bin/python
# coding=utf8

import sys
import subprocess
import re

# Get process info
ps = subprocess.Popen(['ps', '-caxm', '-orss,comm'], stdout=subprocess.PIPE).communicate()[0]
vm = subprocess.Popen(['vm_stat'], stdout=subprocess.PIPE).communicate()[0]

# Iterate processes
processLines = ps.split('\n')
sep = re.compile('[\s]+')
rssTotal = 0 # kB
for row in range(1,len(processLines)):
    rowText = processLines[row].strip()
    rowElements = sep.split(rowText)
    try:
        rss = float(rowElements[0]) * 1024
    except:
        rss = 0 # ignore...
    rssTotal += rss

# Process vm_stat
vmLines = vm.split('\n')
sep = re.compile(':[\s]+')
vmStats = {}
for row in range(1,len(vmLines)-2):
    rowText = vmLines[row].strip()
    rowElements = sep.split(rowText)
    vmStats[(rowElements[0])] = int(rowElements[1].strip('\.')) * 4096

if len(sys.argv) == 1:
	print 'Ⓜ %.1f% %' % ( (float(((vmStats["Pages active"]/1024/1024)+(vmStats["Pages wired down"]/1024/1024))/16000.0)*100 ))
elif sys.argv[1] == "all":
	#print 'Free: %.1f% % (%.1f GB)' % ( 100.0 - (float(((vmStats["Pages active"]/1024/1024)+(vmStats["Pages wired down"]/1024/1024))/16000.0)*100 ), 16.0 - float(((vmStats["Pages active"]/1024/1024)+(vmStats["Pages wired down"]/1024/1024))/1000.0) )
	#print 'Used: %.1f% % (%.1f GB)' % ( (float(((vmStats["Pages active"]/1024/1024)+(vmStats["Pages wired down"]/1024/1024))/16000.0)*100 ),  float(((vmStats["Pages active"]/1024/1024)+(vmStats["Pages wired down"]/1024/1024))/1000.0) )
	#print 'Total: 16.0 GB'
	
	# Output (example):
	# Free: 49.0 % (7.8 GB) | Used: 50.9 % (8.1 GB) | Total: 16.0 GB
	print 'Free: %.1f% % (%.1f GB) | Used: %.1f% % (%.1f GB) | Total: 16.0 GB' % ( 100.0 - (float(((vmStats["Pages active"]/1024/1024)+(vmStats["Pages wired down"]/1024/1024))/16000.0)*100 ), 16.0 - float(((vmStats["Pages active"]/1024/1024)+(vmStats["Pages wired down"]/1024/1024))/1000.0), (float(((vmStats["Pages active"]/1024/1024)+(vmStats["Pages wired down"]/1024/1024))/16000.0)*100 ), float(((vmStats["Pages active"]/1024/1024)+(vmStats["Pages wired down"]/1024/1024))/1000.0)  )
else:
	print 'Ⓜ %.1f% %' % ( (float(((vmStats["Pages active"]/1024/1024)+(vmStats["Pages wired down"]/1024/1024))/16000.0)*100 ))