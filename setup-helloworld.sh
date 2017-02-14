#!/bin/bash

echo "Verify access to an openshift instance"
oc whoami || { echo "Please login to an openshift instance" && exit 1; }

echo "Create the pod"
oc create -f https://raw.githubusercontent.com/openshift/origin/master/examples/hello-openshift/hello-pod.json
echo "Create/expose a service binding for the pod"
oc expose service hello-openshift
echo "Create/expose an external route to the service"
oc expose pod hello-openshift

echo "Save the application as a template"
oc export pod,route,service -o json --as-template=hello-world > helloworld-template-prs.json

echo "Delete all the (current) resources"
oc delete all --all

echo "Publish our new, custom, reusable template for hello world"
oc create -f helloworld-template-prs.json

echo "make this template available to a group of users"
