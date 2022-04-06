#!/bin/bash
trap "exit" INT TERM ERR
trap "kill 0" EXIT
cd ~
wget https://binary.mirantis.com/releases/get_container_cloud.sh
chmod 0755 get_container_cloud.sh
./get_container_cloud.sh
echo "Download a new license file by logging in or creating an accunt at https://container-cloud.mirantis.com/. After log in Click download download license under Try On-Prem."
read -p "Paste contents of mirantis license file: " mirantis_lic
echo $mirantis_lic > ~/kaas-bootstrap/mirantis.lic


export AWS_DEFAULT_REGION=us-east-1
export AWS_ACCESS_KEY_ID=AAAAEXAMPLEXXX
export AWS_SECRET_ACCESS_KEY=ExAMpLE123XXXX987123
export KAAS_AWS_ENABLED=true

echo "Wait for the bootstrap to get as far as validating the AWS credentials, you should see a log message like:"
echo "credential default/cloud-config not valid yet"
echo "When you see the above message, use CTRL + c to quit the bootstrap."
echo ""

~/kaas-bootstrap/bootstrap.sh all &
while :
do
  echo "Waiting for bootstrap cluster ..."
  if grep -q "credential default/cloud-config not valid yet" ~/kaas-bootstrap/logs/kaas-bootstrap-cluster.log; then
    echo "Local boostratp cluster created successfully. "
    echo "creating kubeconfig file..."
    ./bin/kind get kubeconfig --name=clusterapi > ~/mgmt-kc.yml
    echo "applying templates ...."
    ./bin/kubectl --kubeconfig ~/mgmt-kc.yml create -f ../templates/full-cluster/docs-template.yml
    exit
  fi
  sleep 5
done