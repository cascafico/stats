INTERVAL="yesterday"

T0=`date -d "$INTERVAL" '+%Y-%m-%dT%H:%M:%SZ'`
T1=`date                '+%Y-%m-%dT%H:%M:%SZ'`
IERI=`date -d "$INTERVAL" '+%Y-%m-%d'`
OGGI=`date +"%Y-%m-%d"`
AREACODE=3600179296

curl -G 'http://overpass-api.de/api/interpreter' --data-urlencode 'data=[out:xml][timeout:300][adiff:"'$T0'","'$T1'"];area('$AREACODE')->.searchArea;(relation["operator"="Club Alpino Italiano"](area.searchArea);relation["operator"="CAI"](area.searchArea););(._;>;);out meta geom;' > CAI_mods.osm
#curl -G 'http://overpass-api.de/api/interpreter' --data-urlencode 'data=[out:xml][timeout:300][adiff:"'$T0'","'$T1'"];area('$AREACODE')->.searchArea;(relation["operator"="Club Alpino Italiano"](area.searchArea);relation["operator"="CAI"](area.searchArea););(._;>;);out;' > CAI_mods.osm

#parsing involved changeset(s)
cat CAI_mods.osm | grep "$IERI\|$OGGI" | grep changeset | awk ' { print "<a href=https://pewu.github.io/osm-history/#/relation/"substr($0,index($0, "changeset")+11,8) }' > changeset.lst


cat CAI_mods.osm | grep "relation id" | awk -F\" '{print "<a href=https://pewu.github.io/osm-history/#/relation/"$2">"$2"</A>"}' | sort -u > last_changes_relations.html
