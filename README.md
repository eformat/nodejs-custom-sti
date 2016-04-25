# Custom Node.JS 5.X STI builder image

prerequisites
- openshift v3
- rhel subscribed openshift nodes (Dockerfile based on rhel)

load into openshift namespace, as cluster admin, this will start a build of s2i image

    oc create -f ./sti-template.json -n openshift

test it using a new application using the s2i builder image

    oc new-project foo
    oc new-app nodejs-custom-sti:latest~https://github.com/eformat/node-hello-world-swagger
