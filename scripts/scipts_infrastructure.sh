#!/bin/bash

image_id=ami-09693313102a30b2c
instance_type=t2.micro
vpc_id=vpc-08b950cd8140c7403
key_name=user2
subnet_id=subnet-060d8c5c243f86664
shutdown_type=stop
tags="ResourceType=instance,Tags=[{Key=installation_id,Value=user2-1}]"

start()
{
  private_ip_address="10.1.1.21"
  public_ip=associate-public-ip-address

  aws ec2 run-instances \
    --image-id "$image_id" \
    --instance-type "$instance_type" \
    --key-name "$key_name" \
    --subnet-id "$subnet_id" \
    --instance-initiated-shutdown-behavior "$shutdown_type" \
    --private-ip-address "$private_ip_address" \
    --tag-specifications "$tags" \
    --${public_ip}
}

stop()
{                                                                               
  ids=($(                                                                       
   aws ec2 describe-instances \
    --query 'Reservations[*].Instances[?KeyName==`'$key_name'`].InstanceId' \
    --output text                                                               
  ))                                                                            
  aws ec2 terminate-instances --instance-ids "${ids[@]}"                        

}

if [ "$1" = start ]; then
	start
elif [ "$1" = stop ]; then
	stop
else
	cat <<EOF
Usage:

	$0 start|stop
EOF
fi
