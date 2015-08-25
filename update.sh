br=11g
git pull origin $br
git submodule update
for i in setup nglib bigbang plugin
do cd $i ; git checkout origin/$br -b $br ; cd -
done

