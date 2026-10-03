{ ... }:

{
  services.jenkins = {
    enable = true;

    home = "/var/lib/jenkins";

    listenAddress = "127.0.0.1";
    port = 8082;

    plugins = null;
    packages = [ ];
  };
}
