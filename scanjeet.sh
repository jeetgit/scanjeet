#!/bin/bash

nmapscan (){
	echo "Running nmap scan on **$domain** => => =>"
	start_time=$(date +%s)
	nmap $domain > nmapReport.txt
	cat nmapReport.txt
	end_time=$(date +%s)
	echo "Scan completed in $(expr $end_time - $start_time) seconds"
return
}

knockpy(){
	echo "Running Knockpy scan on **$domain** => => => =>"
	start_time=$(date +%s)
	knockpy.py -j $domain > Reports/knockpyReport.txt

	#cat knockpyReport.json | grep target | cut -c 24- | rev | cut -c 3- | rev > 
	#< inputfile awk 'NR>1 {print r}; {r=$0}' > outputfile
	#awk -F'\t' 'NR > 21{print $4}' knockpyReport.txt > knockpyReportprocessed.txt
	awk -F'\t' 'NR>21{print $4}' Reports/knockpyReport.txt |uniq|sort > Reports/knockpyReportprocessed.txt

	end_time=$(date +%s)
	echo "Scan completed in $(expr $end_time - $start_time) seconds"
}

amasscan(){
        echo "Runnning Amass scan for you on **$domain** => => => =>"
	start_time=$(date +%s)
	amass enum -d $domain > Reports/amassReport.txt
#https://github.com/OWASP/Amass/blob/master/doc/user_guide.md
	end_time=$(date +%s)
	echo "Scan completed in $(expr $end_time - $start_time) seconds"
}

gobdns(){
	echo " Runnning go buster dns scan for you on **$domain** => => => => "
	start_time=$(date +%s)
	gobuster dns -d $domain -t 10 -w ../altdns-master/words.txt -o Reports/gobusterdnsReport.txt

	cat Reports/gobusterdnsReport.txt | cut -c 7- > Reports/gobusterReportprocessed.txt
	end_time=$(date +%s)
	echo "Scan completed in $(expr $end_time - $start_time) seconds"
}
sublist3r(){

	start_time=$(date +%s)
	sublist3r -d $domain -o Reports/sublist3rReport.txt
	end_time=$(date +%s)
	echo "Scan completed in $(expr $end_time - $start_time) seconds"
	#scan_timespan $start_time $end_time
	return
}

scan_timespan(){	
#start_time= date '+%s';	
#end_time= date '+%s';
#seconds1=$(date --date "$(echo "$start_time" | sed -nr 's/(....)(..)(..)(..)(..)(..)/\1-\2-\3 \4:\5:\6/p')" +%s)
#seconds2=$(date --date "$(echo "$end_time" | sed -nr 's/(....)(..)(..)(..)(..)(..)/\1-\2-\3 \4:\5:\6/p')" +%s)
#timespan= $((seconds1 - seconds2));
echo "Scan completed in $(expr $2 - $1) seconds"
return
}
	
subfinder(){
	subfinder -d $domain -o Reports/subfinderReport.txt
	return
}
assetfinder(){
start_time=$(date +%s)	
        echo "Running AssetFinder for you $domain => => => =>"
	assetfinder $domain > Reports/assetfinderfinderReport.txt
	end_time=$(date +%s)
	echo "Scan completed in $(expr $end_time - $start_time) seconds"
}
mergedomain(){

	cat Reports/knockpyReportprocessed.txt > Reports/finalDomains.txt
	cat Reports/amassReport.txt >> Reports/finalDomains.txt
	cat Reports/sublist3rReport.txt >> Reports/finalDomains.txt
	cat Reports/subfinderReport.txt >> Reports/finalDomains.txt
        cat Reports/assetfinderReport.txt >> Reports/finalDomains.txt
	cat Reports/gobusterReportprocessed.txt >> Reports/finalDomains.txt
	cat Reports/finalDomains.txt |uniq|sort > Reports/altdnsInput.txt
	echo "Known domains are merged successfully..."
	return
}
altdnscan(){
	echo "Running altdns scan on **$domain**> => => =>"
	start_time=$(date +%s)
	
	altdns -i Reports/altdnsInput.txt -o data_output -w ../altdns-master/words.txt -r -s Reports/altdnsReport.txt
	
	awk -F: '{print $1}' Reports/altdnsReport.txt > Reports/altdnsReportprocessed.txt
#subdomain.txt contains known subdomains
	end_time=$(date +%s)
	echo "Scan completed in $(expr $end_time - $start_time) seconds"
}
mergeall(){
	#cat Reports/altdnsReportprocessed.txt >> Reports/finalDomains.txt
#	cat dirsearchReport.txt >> Reports/finalDomains.txt
#	cat megReport.txt >> Reports/finalDomains.txt
	cat Reports/finalDomains.txt |uniq|sort > Reports/finalInput.txt
	return
}
aquatone(){
	start_time=$(date +%s)
	cat Reports/finalInput1.txt | ../aquatone_linux_amd64_1.7.0/aquatone --ports medium -scan-timeout 500 -screenshot-timeout 60000 -out aquatoneoutput -debug
	end_time=$(date +%s)
	echo "Scan completed in $(expr $end_time - $start_time) seconds"
}
eyewitness(){
	start_time=$(date +%s)	
        echo "Running Eyewitness for you $domain => => => =>"
	../EyeWitness/Python/EyeWitness.py --web --no-dns --timeout 10 --delay 10 --max-retries 5 -f Reports/finalInputSc.txt -d Eyewitnessoutput
	end_time=$(date +%s)
	echo "Scan completed in $(expr $end_time - $start_time) seconds"

}
runall(){
	knockpy ; 
	amasscan ; 
	gobdns; 
	sublist3r ; 
	subfinder ;
	mergedomain ;
	altdnscan ;
	mergeall ;
	aquatone ;
	eyewitness ;
}
cleanReports(){
	cat Reports/EmptyReport.txt > Reports/knockpyReport.txt
	cat Reports/EmptyReport.txt > Reports/knockpyReportprocessed.txt
	cat Reports/EmptyReport.txt > Reports/amassReport.txt
	cat Reports/EmptyReport.txt > Reports/sublist3rReport.txt
	cat Reports/EmptyReport.txt > Reports/subfinderReport.txt
	cat Reports/EmptyReport.txt > Reports/assetfinderReport.txt
	cat Reports/EmptyReport.txt > Reports/gobusterdnsReport.txt
	cat Reports/EmptyReport.txt > Reports/gobusterReportprocessed.txt
	cat Reports/EmptyReport.txt > Reports/altdnsReport.txt
	cat Reports/EmptyReport.txt > Reports/altdnsReportprocessed.txt
	cat Reports/EmptyReport.txt > Reports/finalDomains.txt
	cat Reports/EmptyReport.txt > Reports/finalInput.txt
	echo ">>>>>>> >>>>>> >>>>>> Reports are cleaned >>>>>>> >>>>>> >>>>>>"
	return

}
runallcheck(){

for i in 1 2 3 4 5 6 7 9 10 11
do
case $i in
1) knockpy ;;
2) amasscan ;;
3) gobdns ;;
4) sublist3r ;;
5) subfinder ;;
6) assetfinder ;;
7) mergedomain ;;
8) altdnscan ;;
9) mergeall ;;
10) echo "wait" ;;#aquatone ;;
11) echo "wait" ;;#eyewitness ;;
*) echo ">>>>>>> >>>>>> >>>>>>Executed all scans >>>>>>> >>>>>> >>>>>>"

esac
done
}
#read choice

while (( $# )); do
echo -e "\e[1;31m  
  ██████  ▄████▄   ▄▄▄       ███▄    █  ▄▄▄██▀▀▀▓█████ ▓█████▄▄▄█████▓
▒██    ▒ ▒██▀ ▀█  ▒████▄     ██ ▀█   █    ▒██   ▓█   ▀ ▓█   ▀▓  ██▒ ▓▒ 
░ ▓██▄   ▒▓█    ▄ ▒██  ▀█▄  ▓██  ▀█ ██▒   ░██   ▒███   ▒███  ▒ ▓██░ ▒░ 
  ▒   ██▒▒▓▓▄ ▄██▒░██▄▄▄▄██ ▓██▒  ▐▌██▒▓██▄██▓  ▒▓█  ▄ ▒▓█  ▄░ ▓██▓ ░ 
▒██████▒▒▒ ▓███▀ ░ ▓█   ▓██▒▒██░   ▓██░ ▓███▒   ░▒████▒░▒████▒ ▒██▒ ░
▒ ▒▓▒ ▒ ░░ ░▒ ▒  ░ ▒▒   ▓▒█░░ ▒░   ▒ ▒  ▒▓▒▒░   ░░ ▒░ ░░░ ▒░ ░ ▒ ░░   
░ ░▒  ░ ░  ░  ▒     ▒   ▒▒ ░░ ░░   ░ ▒░ ▒ ░▒░    ░ ░  ░ ░ ░  ░   ░     
░  ░  ░  ░          ░   ▒      ░   ░ ░  ░ ░ ░      ░      ░    ░      
      ░  ░ ░            ░  ░         ░  ░   ░      ░  ░   ░  ░        
         ░                                                              \e[0m"
echo -e "usage: ./scanjeet.sh --option -d domain \n\n [ -runall run all scans] \n [-nmp nmap scan] \n [-knckpy knockpy] \n [-ams amass scan] \n [-gobdns gobusterdn] \n [-s3r sublist3r scan] \n [-sfndr subfinder scan] \n [-afndr asset finder scan] \n [-merge mergedomains] \n [-ads altdns scan] \n [-mergeall merge all domains] \n [-aqtne Aquatone Scan] \n [-ewtnes Eyewitness Scan]  \n [-cleanReports] \n"

	domain=$3;
	case $1 in		
	-runall) runall ; break ;;
	-runallcheck) runallcheck ; break ;;
	-nmp)    nmapscan ; break ;;
	-knckpy) knockpy ; break ;;
	-ams)    amasscan ; break ;;
	-gobdns) gobdns ; break ;;
	-s3r)	 sublist3r ; break ;;	
	-sfndr)  subfinder ; break ;;
	-afndr)  assetfinder ; breal ;;
 	-merge)  mergedomain ; break ;;
	-ads)    altdnscan ; break ;;
	-mergeall) mergeall ; break ;;
	-aqtne)  aquatone ; break ;; 
	-ewtnes) eyewitness ; break ;;	
	-cleanReports) cleanReports ; break ;;
	*)	echo "Wrong selection" 
		exit 1 ;;
esac
done

