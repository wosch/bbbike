mkdir -p tmp/dateline-planet
osmconvert-wrapper -o tmp/dateline-planet/planet-latest-osmconvert-fiji.osm.pbf -B=world/etc/dateline-planet/fiji.poly --drop-author --drop-version --out-pbf ../osm/download/pbf/planet-latest.osm.pbf
osmconvert-wrapper -o tmp/dateline-planet/planet-latest-osmconvert-left-179.osm.pbf -B=world/etc/dateline-planet/left-179.poly --drop-author --drop-version --out-pbf ../osm/download/pbf/planet-latest.osm.pbf
osmconvert-wrapper -o tmp/dateline-planet/planet-latest-osmconvert-left-180.osm.pbf -B=world/etc/dateline-planet/left-180.poly --drop-author --drop-version --out-pbf ../osm/download/pbf/planet-latest.osm.pbf
osmconvert-wrapper -o tmp/dateline-planet/planet-latest-osmconvert-left-right-180.osm.pbf -B=world/etc/dateline-planet/left-right-180.poly --drop-author --drop-version --out-pbf ../osm/download/pbf/planet-latest.osm.pbf
osmconvert-wrapper -o tmp/dateline-planet/planet-latest-osmconvert-right-179.osm.pbf -B=world/etc/dateline-planet/right-179.poly --drop-author --drop-version --out-pbf ../osm/download/pbf/planet-latest.osm.pbf
osmconvert-wrapper -o tmp/dateline-planet/planet-latest-osmconvert-right-180.osm.pbf -B=world/etc/dateline-planet/right-180.poly --drop-author --drop-version --out-pbf ../osm/download/pbf/planet-latest.osm.pbf