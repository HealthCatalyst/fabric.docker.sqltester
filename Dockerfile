FROM healthcatalyst/fabric.baseos:latest
LABEL maintainer="Health Catalyst"
LABEL version="1.1"

RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all

ADD https://raw.githubusercontent.com/HealthCatalyst/InstallScripts/master/testsql.txt /opt/install/testsql.sh

ADD docker-entrypoint.sh ./docker-entrypoint.sh
ADD login.sh ./login.sh

RUN curl -o /etc/yum.repos.d/mssql-release.repo https://packages.microsoft.com/config/rhel/7/prod.repo && echo "curled" \
    && yum remove unixODBC-utf16 unixODBC-utf16-devel \
    && ACCEPT_EULA=Y yum install -y msodbcsql17-17.1.0.1-1 mssql-tools-17.1.0.1-1 unixODBC-devel && echo "installed" \
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bash_profile && echo "exported to bash_profile" \
    && echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc && echo "exported to bashrc" \
    && source ~/.bashrc

RUN dos2unix ./docker-entrypoint.sh \
    && chmod a+x ./docker-entrypoint.sh \
    && dos2unix ./login.sh \
    && chmod a+x ./login.sh \
    && dos2unix /opt/install/testsql.sh \
    && chmod a+x /opt/install/testsql.sh

ENTRYPOINT ["./docker-entrypoint.sh"]
