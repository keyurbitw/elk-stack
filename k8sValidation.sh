kubectl get po -n obs --kubeconfig=/home/.kube/config
restartCount=$(kubectl get po -n obs --kubeconfig=/home/ec2-user/.kube/config -o jsonpath={'$.items[*].status.containerStatuses[*].restartCount'})
for count in $restartCount
do
	if [ $count -ge 2 ]
	then
		echo "Found some pods that have been restarted"
	else
		echo "No pods restarted"
	fi
done

notRunningPods=$(kubectl get po -n obs -o jsonpath='{.items[*].status.containerStatuses[?(@.started==false)].name}' --kubeconfig=/home/ec2-user/.kube/config)
if [ -z "$notRunningPods" ]
then
	echo "All Pods are Running!!"
else
	echo "Found some pods in Not Ready State. Stopping execution!!"
	exit 0
fi

nodeStatus=$(kubectl get nodes -o jsonpath='{$.items[*].status.conditions[3].type}' --kubeconfig=/home/ec2-user/.kube/config)
if [[ $nodeStatus -eq "Ready" ]]
then
	echo "Kubelet is in ready state!!"
else
	echo "Kubelet is not in ready state. Stopping execution"
	exit 0
fi
