dig=$(dig +short sdok.no @127.0.0.1 +tries=1 +time=1)

if($dig = ";; connection timed out; no servers could be reached")
then
echo "DNS SERVER DOWN"
else
  echo "DNS SERVER UP"
fi
