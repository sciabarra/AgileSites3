cd starter
#sh agilesites.sh asSetup
echo "==================== SERVICES"
sh agilesites.sh "service version"
cd ..
echo "==================== CORE"
java -jar sites/webapps/cs/WEB-INF/lib/agilesites_agilesites3-core.jar
echo "==================== API"
java -jar sites/shared/agilesites/lib/agilesites3-api.jar
