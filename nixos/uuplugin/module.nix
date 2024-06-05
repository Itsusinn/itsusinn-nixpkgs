{ config, pkgs, lib, utils, ... }:

let
  cfg = config.programs.uuplugin;
in
{
  options.programs.uuplugin = {
    enable = lib.mkEnableOption "Netease UU Steamdeck";
    package = lib.mkPackageOption pkgs "uuplugin" {};
    autoStart = lib.mkEnableOption "uuplugin auto launch";
  };

  config =
    let
      cfg = config.programs.uuplugin;
      firewall = if config.networking.nftables.enable then pkgs.nftables else pkgs.iptables;
    in
    lib.mkIf cfg.enable {
      environment.systemPackages = [
        cfg.package
      ];
      systemd.services.uuplugin = lib.mkIf cfg.autoStart {
        enable = true;
        description = "uuplugin";
        path = [ firewall pkgs.iproute2 pkgs.procps];
        after = ["network.target"];
        wants = ["network-online.target"];
        serviceConfig = {
          WorkingDirectory = "/var/run/";
          ExecStart = "${lib.getExe cfg.package}";
        };
        wantedBy = [ "default.target" ];
      };
      security.wrappers.uuplugin = {
        owner = "root";
        group = "root";
        capabilities = "cap_net_bind_service,cap_net_admin=+ep";
        source = "${lib.getExe cfg.package}";
      };
    };

  meta.maintainers = with lib.maintainers; [ itsusinn ];
}