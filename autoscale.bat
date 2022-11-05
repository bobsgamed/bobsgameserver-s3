




@rem created BobELB using EC2 Control Panel


@rem --monitoring-disabled true otherwise it uses the detailed 1-minute monitoring and costs $3.50 per instance, heh. is DEFAULT!
as-create-launch-config BobASLaunchConfigNoDetailedMon --image-id ami-3d4ff254 --instance-type t1.micro --key bobsgame --group quick-start-1 --monitoring-disabled true --user-data-file bootstrap.sh



@rem BobELB is in us-east-1d so these all must be in the same.

as-create-auto-scaling-group BobAutoScaleGroup --launch-configuration BobASLaunchConfigNoDetailedMon --health-check-type ELB --min-size 1 --max-size 10 --grace-period 300 --default-cooldown 300 --load-balancers BobELB --availability-zones "us-east-1d"
as-update-auto-scaling-group BobAutoScaleGroup --launch-configuration BobASLaunchConfigNoDetailedMon --health-check-type ELB --min-size 1 --max-size 10 --grace-period 300 --default-cooldown 300 --availability-zones "us-east-1d"



as-put-scaling-policy BobAutoScaleUpPolicy --auto-scaling-group BobAutoScaleGroup --adjustment=1 --type ChangeInCapacity --cooldown 300 
as-put-scaling-policy BobAutoScaleDownPolicy --auto-scaling-group BobAutoScaleGroup "--adjustment=-1" --type ChangeInCapacity --cooldown 300 

@rem create CloudWatch alarms that trigger these policies based on mem/cpu

mon-put-metric-alarm MyLowCPUAlarm --comparison-operator LessThanThreshold --evaluation-periods 1 --metric-name CPUUtilization --namespace "AWS/EC2" --period 600 --statistic Average --threshold 40 --alarm-actions arn:aws:autoscaling:us-east-1:xxxxxxxxxxxxxx:scalingPolicy:xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx:autoScalingGroupName/autoscleasg1:policyName/MyScaleDownPolicy1 --dimensions "AutoScalingGroupName=autoscleasg"




@rem use this on all the instances to rebuild and launch the latest version, if i teminate them directly the ELB will still try to forward to them.
as-terminate-instance-in-auto-scaling-group






