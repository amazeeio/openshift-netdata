# Netdata on Openshift

This helps you deploy Netdata as a Demonset onto an Openshift

> oc apply -f configmap-netdata-slave.yml
> oc apply -f service-netdata.yml

If you with to add additional checks for netdata, this is the place to add the netdata alerts
> oc apply -f configmap-netdata-master.yml


After adding the privileged security context you can deploy netdata-master
> oc adm policy add-scc-to-user privileged -n netdata -z default
> oc apply -f dc-netdata-master.yml

Deploy the Daemonset of netdata-slaves
> oc apply -f daemonset-netdata-slave.yml

If you wish to have an Nginx with Basic Auth Deployed:
> oc apply -f service-nginx.yml

Change the Username and Password for Basicauth in `dc-nginx.yml`
> oc apply -f dc-nginx.yml
> oc apply -f configmap-nginx.yml

In order to deploy netdata to all nodes in your openshift cluster you need to change the project and add an annotation
> $ oc edit project netdata

and add following annotation

> metadata:
>   annotations:
>    openshift.io/node-selector: ""

## Pitfals

The API Key (in `configmap-netdata-slave.yml` and `dc-netdata.master.yml`) needs to be in this format: `11111111-2222-3333-4444-555555555555`
