# If you have a proxy server, enter the settings here and in maven/settings.xml.
# I set up a Squid Proxy on my host machine to cache apt and maven packages.

export http_proxy=http://10.13.39.1:3128
export https_proxy=https://10.13.39.1:3128
export ftp_proxy=ftp://10.13.39.1:3128
export no_proxy=localhost,127.0.0.1,10.,consul0
export MAVEN_OPTS="-Dhttp.proxyHost=10.13.39.1 -Dhttp.proxyPort=3128 -Dhttps.proxyHost=10.13.39.1 -Dhttps.proxyPort=3128"
