## Netdata on Openshift


> oc create -f configmap.yml
> oc create -f ingress.yml
> oc create -f service.yml

> oc adm policy add-scc-to-user privileged -n netdata -z default

> oc create -f netdata-pod.yml
> oc create -f daemonset.yml


oc apply -f configmap.yml
oc apply -f ingress.yml
oc apply -f service.yml
oc apply -f netdata-pod.yml
oc apply -f daemonset.yml
