export EBS_CSI_POLICY_NAME=
AWS_REGION="us-west-2"

# download the IAM policy document
curl -sSL -o ebs-csi-policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json

# Create the IAM policy
aws iam create-policy \
  --region ${AWS_REGION} \
  --policy-name ${EBS_CSI_POLICY_NAME} \
  --policy-document file://ebs-csi-policy.json

# export the policy ARN as a variable
export EBS_CSI_POLICY_ARN=$(aws --region ${AWS_REGION} iam list-policies --query 'Policies[?PolicyName==`'$EBS_CSI_POLICY_NAME'`].Arn' --output text)

# Create an IAM OIDC provider for your cluster
eksctl utils associate-iam-oidc-provider \
  --region=$AWS_REGION \
  --cluster=DedicatedServers \
  --approve

# Create a service account
eksctl create iamserviceaccount \
  --cluster DedicatedServers \
  --name ebs-csi-controller-irsa \
  --namespace servers \
  --override-existing-serviceaccounts \
  --attach-policy-arn "Amazon_EBS_CSI_Driver" \
  --approve

aws eks create-addon --cluster-name DedicatedServers --addon-name aws-ebs-csi-driver \
  --service-account-role-arn arn:aws:iam::262580537006:role/EBSVolumeAdmin


kubectl annotate serviceaccount ebs-csi-controller-sa \
    -n kube-system \
    eks.amazonaws.com/role-arn=arn:aws:iam::262580537006:role/EBSVolumeAdmin

# helm repo add aws-ebs-csi-driver https://kubernetes-sigs.github.io/aws-ebs-csi-driver
# helm search repo aws-ebs-csi-driver

# helm upgrade --install aws-ebs-csi-driver \
#   --version=1.2.4 \
#   --namespace kube-system \
#   --set serviceAccount.controller.create=false \
#   --set serviceAccount.snapshot.create=false \
#   --set enableVolumeScheduling=true \
#   --set enableVolumeResizing=true \
#   --set enableVolumeSnapshot=true \
#   --set serviceAccount.snapshot.name=ebs-csi-controller-irsa \
#   --set serviceAccount.controller.name=ebs-csi-controller-irsa \
#   aws-ebs-csi-driver/aws-ebs-csi-driver

# kubectl -n kube-system rollout status deployment ebs-csi-controller