{
  config,
  lib,
  ...
}: let
  cfg = config.backupDrive;
in {
  options.backupDrive.enable = lib.mkOption {
    default = false;
    type = lib.types.bool;
    description = "Configure a dedicated backup mount";
  };
  config = lib.mkIf cfg.enable {
    fileSystems."/backups" = {
      device = "/dev/disk/by-uuid/2da4ca3c-5cfa-4759-8d64-de5f553e16e7";
      fsType = "ext4";
      options = ["noatime" "defaults"];
    };
  };
}
