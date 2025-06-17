#!/bin/bash

AMI_ID="ami-09c813fb71547fc4f"
SG_ID="sg-02beb32ed3e88e9bf"
INSTANCES=("mongodb" "redis" "mysql" "rabbitmq" "catalogue" "user" "cart" "shipping" "payment" "dispatch" "frontend")
ZONE_ID="Z03666236DN6S5ZBYZCYL"
DOMAIN_NAME="daws84s.online"

for instance in "${INSTANCES[@]}"
do
  # Launch EC2 Instance
  INSTANCE_ID=$(aws ec2 run-instances \
    --image-id ami-09c813fb71547fc4f \
    --instance-type t3.micro \
    --security-group-ids sg-02beb32ed3e88e9bf \
    --query "Instances[0].InstanceId" \
    --output text)

  # Check if it's frontend to fetch public IP
  if [ "$instance" != "frontend" ]; then
    IP=$(aws ec2 describe-instances \
      --instance-ids $INSTANCE_ID \
      --query "Reservations[0].Instances[0].PrivateIpAddress" \
      --output text)
  else
    IP=$(aws ec2 describe-instances \
      --instance-ids $INSTANCE_ID \
      --query "Reservations[0].Instances[0].PublicIpAddress" \
      --output text)
  fi

  echo "$instance IP address: $IP"
done
