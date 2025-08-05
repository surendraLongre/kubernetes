# Set the cluster name (must match your hosted zone)
export NAME=kubevpro.mkinko.shop

kops create cluster --name=${NAME} \
  --zones=us-east-1a \
  --state=${KOPS_STATE_STORE} \
  --node-count=2 \
  --node-size=t3.medium \
  --master-size=t3.medium \
  --dns-zone=kubevpro.mkinko.shop \
  --yes

