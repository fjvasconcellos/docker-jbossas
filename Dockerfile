# Criado como base na imagem Wildlfy
FROM jboss/base-jdk:7

# Set the JBOSS_VERSION env variable
ENV JBOSS_VERSION 7.0.1.Final
ENV JBOSS_HOME /opt/jboss/as7

USER root

# Add the WildFly distribution to /opt, and make wildfly the owner of the extracted tar content
# Make sure the distribution is available from a well-known place
RUN cd $HOME \
    && curl -O http://download.jboss.org/jbossas/7.1/jboss-as-$JBOSS_VERSION/jboss-as-$JBOSS_VERSION.tar.gz \
    && tar xf jboss-as-$JBOSS_VERSION.tar.gz \
    && mv $HOME/jboss-as-$JBOSS_VERSION $JBOSS_HOME \
    && rm jboss-as-$JBOSS_VERSION.tar.gz \
    && chown -R jboss:0 ${JBOSS_HOME} \
    && chmod -R g+rw ${JBOSS_HOME}

# Ensure signals are forwarded to the JVM process correctly for graceful shutdown
ENV LAUNCH_JBOSS_IN_BACKGROUND true

USER jboss

# Expose the ports we're interested in
EXPOSE 8080

# Set the default command to run on boot
# This will boot WildFly in the standalone mode and bind to all interface
CMD ["/opt/jboss/as7/bin/standalone.sh", "-b", "0.0.0.0"]
