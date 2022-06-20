#today=`date +%y-%m-%d`
#today="aero"
tailsize=10000
files=`ls -1t ./*.ping.txt | grep 100 | head -2`
#files=`ls -1t /Users/bghita/data/*.txt | head -2`
rm ./tmp.*
echo "set logscale y" > ./tmp.plot
cnt=1
for i in $files
do
	echo $i
#	cat $i | tr '=' ' ' | grep bytes | cut -f6,10 -d' ' | tail -$tailsize  > ./tmp.out.$cnt
#	cat $i | grep Request | cut -f5,10 -d' ' | tail -$tailsize  >> ./tmp.out.$cnt	
#	tail -$tailsize $i | awk ' $1=="Request" {print $5, "1"} ; $2=="bytes" {print substr($5,10), substr($7,6)}' > ./tmp.out.$cnt
	tail -$tailsize $i | tr -d '-' | awk ' $1=="Request" {print $5, "1" > "tmp.loss.'$cnt'" } ; $2=="bytes" {print substr($5,10), substr($7,6) > "tmp.out.'$cnt'" }' 
	cnt=$(($cnt+1))
	cat ./tmp.out.* | grep ^[0-9] >> ./tmp.minmax

done
	minmax=`cat tmp.minmax | awk ' NR==1 { min=$2 ; max=$2} ; $2 < min { min = $2 } $2> max { max = $2 }; END {printf "\[%s:%s\]",min,max} '`
echo "outfiles=\"`ls -1 tmp.out.* | tr '\n' ' '`\"" >> ./tmp.plot
echo "lossfiles=\"`ls -1 tmp.loss.* | tr '\n' ' '`\"" >> ./tmp.plot
echo "set yrange $minmax">> ./tmp.plot
echo "set y2range [0.99:1.01]>> ./tmp.plot"
echo "plot for [file in outfiles ] file using 1:2 smooth bezier axes x1y1, for [file in lossfiles ] file using 1:2 with points axes x1y2" >> ./tmp.plot
#echo "plot for [file in datfiles ] file" >> ./tmp.plot
echo "pause -1" >> ./tmp.plot
gnuplot ./tmp.plot
 

 	
