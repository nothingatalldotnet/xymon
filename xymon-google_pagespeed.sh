#!/bin/bash

		HOSTTAG=pagespeed
        COLUMN=$HOSTTAG
        REGEX='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'
        KEY="GOOGLEAPI"
        grep -C 0 'pagespeed' /usr/share/xymon/server/etc/hosts.cfg | while read -r LINE ; do

                if [[ $LINE =~ $REGEX ]]
                then
                    	URL=${BASH_REMATCH}
                        SPLIT=($(echo "$LINE" | tr ' ' '\n'))
                        IP=${SPLIT[0]}
                        MACHINE=${SPLIT[1]}
                        MACHINECOMMAS=${MACHINE//./,}

                        COLOR=green
                        MSG="$HOSTTAG status for host $MACHINE"

                        curl https://www.googleapis.com/pagespeedonline/v5/runPagespeed\?key=${KEY}\&url=${URL}\&fields=lighthouseResult\/categories\/*\/score\&prettyPrint=false\&strategy=desktop\&category=performance\&category=pwa\&category=best-practices\&category=accessibility\&category=seo | tee /usr/share/xymon/server/ext/pagespeed.json

                        PS_PERFORMANCE=($(jq -r '.lighthouseResult.categories.performance.score' /usr/share/xymon/server/ext/pagespeed.json))
                        PS_ACCESSIBILITY=($(jq -r '.lighthouseResult.categories.accessibility.score' /usr/share/xymon/server/ext/pagespeed.json))
                        PS_BEST=($(jq -r '.lighthouseResult.categories."best-practices".score' /usr/share/xymon/server/ext/pagespeed.json))
                        PS_SEO=($(jq -r '.lighthouseResult.categories.seo.score' /usr/share/xymon/server/ext/pagespeed.json))
                        PS_PWA=($(jq -r '.lighthouseResult.categories.pwa.score' /usr/share/xymon/server/ext/pagespeed.json))

                        MSG="$MSG

Performance: ${PS_PERFORMANCE}
Accessibility: ${PS_ACCESSIBILITY} 
Best Practices: ${PS_BEST}
SEO: ${PS_SEO}
PWA: ${PS_PWA}"

                        $XYMON $XYMSRV "status+1w $MACHINECOMMAS.$COLUMN $COLOR `date`

${MSG}"
                fi

        done

exit 0
