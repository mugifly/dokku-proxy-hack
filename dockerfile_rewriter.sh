#!/bin/bash
# Dockerfile rewriter

function show_help() {
	echo ""
	echo "Dockerfile rewriter"
	echo ""
	echo "Usage:"
	echo "  $0 PARAMETERS"
	echo ""
	echo "PARAMETERS:"
	echo "  You can specify any environment variables (e.g., http_proxy)"
	echo ""
	echo "Example:"
	echo "  $0 http_proxy=http://proxy.example.com:8080/ https_proxy=http://proxy.example.com:8080/"
}

# Checking for docker file
if [ ! -f Dockerfile ]; then
	echo "Dockerfile is not found."
	show_help
	exit 1
fi

# Checking for parameters
if [ $# -eq 0 ]; then
	echo "Parameters not given."
	show_help
	exit 1
fi

# Inserting environment variables
for i in $*; do
	CMD=$1
	grep "ENV ${CMD}" Dockerfile > /dev/null
	if [ $? -ne 0 ]; then
		echo "DockerfileRewriter - Insert env: ${CMD}"
		sed -e "3iENV $CMD" -i Dockerfile
	fi
	shift
done

echo "Dockerfile rewrote."
exit 0
