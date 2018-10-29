# Netdata on Openshift


This project deploys [Netdata](https://github.com/netdata/netdata) in a distributed way. Every node of your OpenShift cluster will get a netdata slave
that sends information back to the netdata-master.

## Installation

First create a project with the name `netdata`

1.  Deploy the configmap for the netdata slave - This holds the basic configuration for the netdata slave

```
oc apply -f configmap-netdata-slave.yml
```

2. Deploy the service for netdata - This enables the communication between the slaves and the master within the Cluster

```
oc apply -f service-netdata.yml
```

3. **Optional:** If you with to add additional checks for netdata, this is the place to add the netdata alerts. This can also be changed at a later stage.

```
oc apply -f configmap-netdata-master.yml
```

4. The netdata-slaves need to have privileges on the machines they monitor. The privileges can be added by adapting the policies.

```
oc adm policy add-scc-to-user privileged -n netdata -z default
```

5. After adding the privileged security context you can deploy netdata-master

```
oc apply -f dc-netdata-master.yml
```


6. Deploy the Daemonset of netdata-slaves into the cluster

```
oc apply -f daemonset-netdata-slave.yml
```


7. In order to protect the Netdata Frontend with a password you can adapt the Environment variables mentioned below in `dc-nginx.ymnl`. This will automatically add Basic Auth to the nginx pod.

```
- name: BASIC_AUTH_USERNAME
  value: netdata
- name: BASIC_AUTH_PASSWORD
  value: NeverGonnaLetYouDown!
```

8. Afer adapting the deployment config in `dc-nginx.yml` we can apply those to the project as well as the configmap with the nginx configuration.

```
oc apply -f dc-nginx.yml
oc apply -f configmap-nginx.yml
```

9. Deploy the nginx service
```
oc apply -f service-nginx.yml
```

10.  In order to deploy netdata to all nodes in your openshift cluster you need to change the project and add an annotation
```
oc edit project netdata
```
and add following annotation

```
metadata:
  annotations:
    openshift.io/node-selector: ""
```

## Common pitfals

- The API Key (in `configmap-netdata-slave.yml` and `dc-netdata.master.yml`) needs to be in this format: `11111111-2222-3333-4444-555555555555`
