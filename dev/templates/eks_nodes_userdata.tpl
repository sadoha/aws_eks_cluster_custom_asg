#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh --apiserver-endpoint '${clusterEndpoint}' --b64-cluster-ca '${clusterCertificateAuthority}' '${clusterName}' --kubelet-extra-args '${kubletExtraArgs}'
