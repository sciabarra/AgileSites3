msg=${1:?commit}
br=11g
subs="nglib plugin setup bigbang"
for i in $subs
do cd $i 
   git commit -m "$msg" -a 
   git pull origin $br
   git push origin $br
   cd ..
done
git add $subs
git commit -m "$msg" -a
git pull origin $br
git push origin $br
