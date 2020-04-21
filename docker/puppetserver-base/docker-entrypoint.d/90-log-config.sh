#! /bin/sh

### Print configuration for troubleshooting
echo "System configuration values:"
# shellcheck disable=SC2039 # Docker injects $HOSTNAME
echo "* HOSTNAME: '${HOSTNAME}'"
echo "* hostname -f: '$(hostname -f)'"
echo "* PUPPETSERVER_HOSTNAME:PUPPET_MASTERPORT: '${PUPPETSERVER_HOSTNAME}:${PUPPET_MASTERPORT}'"
certname=$(ls "${SSLDIR}/certs" | grep --invert-match ca.pem)
echo "* Generated certname: '${certname}'"
echo "* DNS_ALT_NAMES: '${DNS_ALT_NAMES}'"
echo "* SSLDIR: '${SSLDIR}'"

altnames="-certopt no_subject,no_header,no_version,no_serial,no_signame,no_validity,no_issuer,no_pubkey,no_sigdump,no_aux"

if [ -f "${SSLDIR}/certs/ca.pem" ]; then
  echo "CA Certificate:"
  # shellcheck disable=SC2086 # $altnames shouldn't be quoted
  openssl x509 -subject -issuer -text -noout -in "${SSLDIR}/certs/ca.pem" $altnames
fi

echo "Certificate:"
# shellcheck disable=SC2086 # $altnames shouldn't be quoted
openssl x509 -subject -issuer -text -noout -in "${SSLDIR}/certs/${certname}" $altnames
