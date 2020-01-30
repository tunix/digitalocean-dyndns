#!/bin/sh

api_host="https://api.digitalocean.com/v2"
sleep_interval=${SLEEP_INTERVAL:-300}

die() {
    echo "$1"
    exit 1
}

test -z $DIGITALOCEAN_TOKEN && die "DIGITALOCEAN_TOKEN not set!"
test -z $DOMAIN && die "DOMAIN not set!"
test -z $NAME && die "NAME not set!"

dns_list="$api_host/domains/$DOMAIN/records"

while ( true ); do
    domain_records=$(curl -s -X GET \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
        $dns_list)

    ip="$(curl -s ipinfo.io/ip)"

    if [[ -n $ip ]]; then
        for sub in ${NAME//;/ }; do
            record_id=$(echo $domain_records| jq ".domain_records[] | select(.type == \"A\" and .name == \"$sub\") | .id")
            record_data=$(echo $domain_records| jq -r ".domain_records[] | select(.type == \"A\" and .name == \"$sub\") | .data")
            
            test -z $record_id && echo "No record found with '$sub' domain name!" && continue

            if [[ "$ip" != "$record_data" ]]; then
                data="{\"type\": \"A\", \"name\": \"$sub\", \"data\": \"$ip\"}"
                url="$dns_list/$record_id"

                echo "existing DNS record address ($record_data) doesn't match current IP ($ip), sending data=$data to url=$url"

                curl -s -X PUT \
                    -H "Content-Type: application/json" \
                    -H "Authorization: Bearer $DIGITALOCEAN_TOKEN" \
                    -d "$data" \
                    "$url" &> /dev/null
            fi
        done
    else
        echo "IP wasn't retrieved within allowed interval. Will try $sleep_interval seconds later.."
    fi

    sleep $sleep_interval
done
