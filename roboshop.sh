#!/bin/bash

AMI_ID="ami-09c813fb715477c4f"
SG_ID="sg-02beb32ed88e88ebf"
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")
ZONE_ID="Z0366236DN65ZS8CYIL"
DOMAIN_NAME="daws84s.online"

for instance in "${INSTANCES[@]}"
do
  INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --instance-type t3.micro \
    --security-group-ids "$SG_ID" \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[0].InstanceId' \
    --output text)

  echo "$instance Instance launched: $INSTANCE_ID"

  # Wait a bit to let the instance start and get IP assigned
  sleep 10

  if [ "$instance" == "frontend" ]; then
      IP=$(aws ec2 describe-instances \
      --instance-ids "$INSTANCE_ID" \
      --query "Reservations[0].Instances[0].PublicIpAddress" \
      --output text)
  else
      IP=$(aws ec2 describe-instances \
      --instance-ids "$INSTANCE_ID" \
      --query "Reservations[0].Instances[0].PrivateIpAddress" \
      --output text)
  fi

  echo "$instance IP address: $IP"
done