{ config, lib, ... }:

let
  jenkins = config.systemd.services.jenkins;
in
{
  assertions = [
    {
      assertion = config.services.jenkins.enable;
      message = "Jenkins native service must be enabled";
    }

    {
      assertion = config.services.jenkins.home == "/var/lib/jenkins";
      message = "Jenkins home must be /var/lib/jenkins";
    }

    {
      assertion = config.services.jenkins.listenAddress == "127.0.0.1";
      message = "Jenkins must listen only on localhost";
    }

    {
      assertion = config.services.jenkins.port == 8082;
      message = "Jenkins must listen on port 8082";
    }

    {
      assertion = config.services.jenkins.plugins == null;
      message = "Jenkins plugins must be left unmanaged during the migration";
    }

    {
      assertion = config.services.jenkins.packages == [ ];
      message = "Jenkins must not introduce an unnecessary build toolchain";
    }

    {
      assertion = jenkins.serviceConfig.User == "jenkins";
      message = "Native Jenkins service must run as the jenkins user";
    }

    {
      assertion = jenkins.serviceConfig.Group == "jenkins";
      message = "Native Jenkins service must run with the jenkins group";
    }

    {
      assertion = config.users.users.jenkins.uid != null;
      message = "The native Jenkins system user must exist";
    }

    {
      assertion = config.users.groups.jenkins.gid != null;
      message = "The native Jenkins group must exist";
    }

    {
      assertion = !(config.systemd.services ? jenkins-compose);
      message = "The obsolete Jenkins Docker Compose service must not exist";
    }
  ];
}
