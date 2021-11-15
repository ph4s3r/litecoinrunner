#! /bin/bash

set -ex 

IMG=peetk/litecoind-alpine
TAG=1.0

#building the image, assuming we are in the same dir as the Dockerfile
sudo docker build --no-cache -t $IMG:$TAG .

if [ ! -f /opt/anchore/grype ]; then
    echo "Anchore/Grype not found, installing"
	# installing Anchor / Grype to /opt/anchore/grype for vulnerability scanning
	mkdir -p /opt/anchore/
	curl -sSfL https://raw.githubusercontent.com/anchore/grype/main/install.sh | sh -s -- -b /opt/anchore/ v0.24.1
fi

# run scan and display
sudo /opt/anchore/grype docker:$IMG:$TAG --fail-on medium | head

echo "Hit y to run image > "
read justdoit

if [ "$justdoit" = "y" ]; then
        sudo docker run --rm --name litecoind-node -p 9333:9333 $IMG:$TAG
else echo "bye then";

fi

# running with data dir       docker run -e LITECOIN_DATA=/var/lib/litecoind --rm $IMG:$TAG -printtoconsole -regtest=1
