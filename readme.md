## Netdata on Openshift

> oc apply -f configmap.yml
> oc apply -f service.yml
> oc adm policy add-scc-to-user privileged -n netdata -z default
> oc apply -f netdata-master-deployconfig.yml
> oc apply -f daemonset.yml

