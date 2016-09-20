FROM node:6.5-wheezy

# cloud9 default is 8181, we use 8080
EXPOSE 8080

# add backports for fish shell
RUN echo "deb http://ftp.us.debian.org/debian/ jessie-backports main contrib" >> /etc/apt/sources.list; apt-get update; apt-get install -y fish man-db
# add fish shell configuration files to /root
COPY .config /root/.config

# allow bower to run as root inside container
RUN echo '{ "allow_root": true }' > /root/.bowerrc

# install cloud9
RUN git clone git://github.com/c9/core.git c9sdk
RUN cd c9sdk; ./scripts/install-sdk.sh

# global npm modules used for development
RUN npm install -g coffee-script node-gyp jasmine-node bower

# add preferred Cloud9 settings
COPY user.settings /root/.c9/
COPY .c9 /home/.c9

# start cloud9 with no authentication by default
# if authentication is desired, set the value of -a, i.e. -a user:pass at docker run
ENTRYPOINT ["node", "c9sdk/server.js", "-w", "/home", "--listen", "0.0.0.0", "-p", "8080"]
CMD ["-a", ":"]