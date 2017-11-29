
# nodered-s2i
FROM openshift/base-centos7

# TODO: Put the maintainer name in the image metadata
# MAINTAINER Your Name <your@email.com>

# TODO: Rename the builder environment variable to inform users about application you provide them
# ENV BUILDER_VERSION 1.0

# TODO: Set labels used in OpenShift to describe the builder image
#LABEL io.k8s.description="Platform for building xyz" \
#      io.k8s.display-name="builder x.y.z" \
#      io.openshift.expose-services="8080:http" \
#      io.openshift.tags="builder,x.y.z,etc."

# TODO: Install required packages here:
# RUN yum install -y ... && yum clean all -y

RUN yum -y install gcc-c++ make
RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
RUN yum -y install nodejs


# TODO (optional): Copy the builder files into /opt/app-root
# COPY ./<builder_folder>/ /opt/app-root/

# TODO: Copy the S2I scripts to /usr/libexec/s2i, since openshift/base-centos7 image
# sets io.openshift.s2i.scripts-url label that way, or update that label
COPY ./s2i/bin/ /usr/libexec/s2i




RUN mkdir -p /usr/src/node-red
RUN mkdir /data
RUN mkdir /data/flows

COPY package.json /usr/src/node-red/
COPY settings.js /data/
WORKDIR /usr/src/node-red
RUN npm install

RUN chmod -R 777 /data 
RUN chmod -R 777 /usr/src/node-red/

RUN npm install node-red-contrib-redis



# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
EXPOSE 1880


# TODO: Set the default CMD for the image
# CMD ["/usr/libexec/s2i/usage"]
