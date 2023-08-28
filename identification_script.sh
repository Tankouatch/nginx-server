#!/bin/bash

# Replace with your actual VPC and subnet IDs
VPC_ID="your-vpc-id"
SUBNET_IDS=("subnet-id-1" "subnet-id-2" "subnet-id-3" "subnet-id-4")

public_counter=1
private_counter=1

for SUBNET_ID in "${SUBNET_IDS[@]}"; do
  # Check if the subnet is public by inspecting its route table associations
  ROUTE_TABLES=$(aws ec2 describe-route-tables --filters "Name=association.subnet-id,Values=${SUBNET_ID}" --query "RouteTables[].Associations[].RouteTableId" --output text)

  # Check if any of the associated route tables have a route to an internet gateway
  is_public=false
  for RT in ${ROUTE_TABLES}; do
    INTERNET_GATEWAY=$(aws ec2 describe-route-tables --route-table-ids "${RT}" --query "RouteTables[].Routes[?DestinationCidrBlock == '0.0.0.0/0' && GatewayId =~ /^igw-/].GatewayId" --output text)
    if [[ -n "${INTERNET_GATEWAY}" ]]; then
      is_public=true
      break
    fi
  done

  # Determine if the subnet is public or private
  if "${is_public}"; then
    echo "Subnet ${SUBNET_ID} is a public subnet."
    echo "${SUBNET_ID}" > "public${public_counter}"
    ((public_counter++))
  else
    echo "Subnet ${SUBNET_ID} is a private subnet."
    echo "${SUBNET_ID}" > "private${private_counter}"
    ((private_counter++))
  fi
done
