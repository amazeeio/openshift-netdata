## Netdata on Openshift

This helps you deploy Netdata as a Demonset onto an Openshift

> oc apply -f configmap-netdata-master.yml
> oc apply -f configmap-netdata-slave.yml
> oc apply -f service-netdata.yml

After adding the privileged security context you can deploy netdata-master
> oc adm policy add-scc-to-user privileged -n netdata -z default
> oc apply -f dc-netdata-master.yml

Deploy the Daemonset of netdata-slaves
> oc apply -f daemonset-netdata-slave.yml

If you wish to have an Nginx with Basic Auth Deployed:
> oc apply -f service-nginx.yml
> oc apply -f dc-nginx.yml
> oc apply -f configmap-nginx.yml
