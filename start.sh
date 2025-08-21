#!/bin/bash
# start.sh
# 2025.08.05

#set -x

# Check if /etc/nut files exist, and copy them from /opt/apcupsd if they don't
files=( hosts.conf upsset.conf )

for file in "${files[@]}"; do
  if [ ! -f /etc/nut/$file ] || [[ $UPDATE_CONFIGS == "true" ]]; then
    cp /opt/nut/$file /etc/nut/$file \
    && sed -i 's/\b\(example\|Example\|sample\)\s\?//' /etc/nut/$file \
    && echo "No existing $file found or UPDATE_CONFIGS set to true"

  else
    echo "Existing $file found, and will be used"
  fi
done

htmls=( upsstats-single.html upsstats.html )

for html in "${htmls[@]}"; do
  if [ ! -f /etc/nut/$html ] || [[ $UPDATE_HTMLS == "true" ]]; then
    cp /opt/nut/$html /etc/nut/$html \
    && sed -i 's/\b\(example\|Example\|sample\)\s\?//' /etc/nut/$html \
    && echo "No existing $html found or UPDATE_HTMLS set to true"

  else
    echo "Existing $html found, and will be used"
  fi
done

echo -e "\n----------------------------------------\n"

# Configure upsset.conf
sed -i "s|^### I_HAVE_SECURED_MY_CGI_DIRECTORY|I_HAVE_SECURED_MY_CGI_DIRECTORY|" /etc/nut/upsset.conf

# populate two arrays with host and UPS names
HOSTS=( $UPSHOSTS )
NAMES=( $UPSNAMES )

# add monitors to hosts.conf for each host and UPS name combo
for ((monitor=0;monitor<${#HOSTS[@]};monitor++)); do
  echo "MONITOR ${NAMES[$monitor]}@${HOSTS[$monitor]} \"${NAMES[$monitor]}\"" >> /etc/nut/hosts.conf
  echo "MONITOR ${NAMES[$monitor]}@${HOSTS[$monitor]} \"${NAMES[$monitor]}\""
done

# Set default ServerName
echo "ServerName localhost" > /etc/apache2/conf-available/servername.conf
a2enconf servername

# Redirect root to upsstats.cgi
echo "RedirectMatch ^/\$ /cgi-bin/nut/upsstats.cgi" >> /etc/apache2/sites-available/000-default.conf

# Initiate nut-upsd packages
a2enmod cgi
echo -e "\n----------------------------------------\n"
exec apache2ctl -D FOREGROUND
