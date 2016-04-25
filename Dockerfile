# nodejs-custom-sti
FROM registry.access.redhat.com/library/rhel7

# Install from Official NodJS RPM repository
RUN rpm -Uvh https://rpm.nodesource.com/pub_5.x/el/7/x86_64/nodesource-release-el7-1.noarch.rpm

RUN yum-config-manager --disable="*"
RUN yum-config-manager --enable="rhel-7-server-rpms" --enable="rhel-7-server-extras-rpms"

RUN yum install -y nodejs tar && \
    mkdir -p /opt/openshift && \
    mkdir -p /opt/app-root/source && chmod -R a+rwX /opt/app-root/source && \
    mkdir -p /opt/s2i/destination && chmod -R a+rwX /opt/s2i/destination && \
    mkdir -p /opt/app-root/src && chmod -R a+rwX /opt/app-root/src && \
    yum clean all -y

ENV BUILDER_VERSION 1.0

LABEL io.k8s.description="Platform for building NodeJS applications" \
      io.k8s.display-name="Node.JS 5.X" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,nodejs500" \
      com.redhat.deployments-dir="/opt/app-root/src"

# TODO (optional): Copy the builder files into /opt/openshift
# COPY ./<builder_folder>/ /opt/openshift/
# COPY Additional files,configurations that we want to ship by default

LABEL io.openshift.s2i.scripts-url=image:///usr/local/sti
COPY ./.sti/bin/ /usr/local/sti

RUN chown -R 1001:1001 /opt/openshift
RUN chgrp -R 0 /opt/app-root/src
RUN chmod -R g+rw /opt/app-root/src
WORKDIR /opt/app-root/src

# This default user is created in the os image
USER 1001

# Set the default port for applications built using this image
EXPOSE 8080

# Set the default CMD for the image
CMD ["usage"]
