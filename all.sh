for i in plugin core api
do cd $i 
   sbt7 "$@"
   cd ..
done
