{ lib, ... }:
with builtins;
let
  configFile = toFile "recyclarr.yml" (toJSON (lib.attrsets.concatMapAttrs
    (service: attrs: {
      "${service}"."${service}" = {
        base_url = "http://${service}:${toString attrs.port}";
        api_key = attrs.api_key;
        delete_old_custom_formats = true;
        replace_existing_custom_formats = true;
        custom_formats = [{ trash_ids = attrs.trash_ids; }];
      };
    })
    {
      radarr = {
        port = 7878;
        api_key = import ../../secrets/radarr.nix;
        trash_ids = [
          # HDR Formats
          "58d6a88f13e2db7f5059c41047876f00" # DV
          "e23edd2482476e595fb990b12e7c609c" # DV HDR10
          "c53085ddbd027d9624b320627748612f" # DV HDR10+
          "55d53828b9d81cbe20b02efd00aa0efd" # DV HLG
          "a3e19f8f627608af0211acd02bf89735" # DV SDR
          "e61e28db95d22bedcadf030b8f156d96" # HDR
          "2a4d9069cc1fe3242ff9bdaebed239bb" # HDR (undefined)
          "dfb86d5941bc9075d6af23b09c2aeecd" # HDR10
          "b974a6cd08c1066250f1f177d7aa1225" # HDR10+
          "9364dd386c9b4a1100dde8264690add7" # HLG
          "08d6d8834ad9ec87b1dc7ec8148e7a1f" # PQ
          # HQ Release Groups
          "ed27ebfef2f323e964fb1f61391bcb35" # HD Bluray Tier 01
          "c20c8647f2746a1f4c4262b0fbbeeeae" # HD Bluray Tier 02
          "5608c71bcebba0a5e666223bae8c9227" # HD Bluray Tier 03
          "3a3ff47579026e76d6504ebea39390de" # Remux Tier 01
          "9f98181fe5a3fbeb0cc29340da2a468a" # Remux Tier 02
          "8baaf0b3142bf4d94c42a724f034e27a" # Remux Tier 03
          "4d74ac4c4db0b64bff6ce0cffef99bf0" # UHD Bluray Tier 01
          "a58f517a70193f8e578056642178419d" # UHD Bluray Tier 02
          "e71939fae578037e7aed3ee219bbe7c1" # UHD Bluray Tier 03
          "c20f169ef63c5f40c2def54abaf4438e" # WEB Tier 01
          "403816d65392c79236dcb6dd591aeda4" # WEB Tier 02
          "af94e0fe497124d1f9ce732069ec8c3b" # WEB Tier 03
          # Unwanted
          "b8cd450cbfa689c0259a01d9e29ba3d6" # 3D
          "ed38b889b31be83fda192888e2286d83" # BR-DISK
          "0a3f082873eb454bde444150b70253cc" # Extras
          "90a6f9a284dff5103f6346090e6280c8" # LQ
          "e204b80c87be9497a8a6eaff48f72905" # LQ (Release Title)
          "bfd8eb01832d646a0a89c4deb46f8564" # Upscaled
          "dc98083864ea246d05a42df0d05f81cc" # x265 (HD)
        ];
      };
      sonarr = {
        port = 8989;
        api_key = import ../../secrets/sonarr.nix;
        trash_ids = [
          # HDR Formats
          "6d0d8de7b57e35518ac0308b0ddf404e" # DV
          "7878c33f1963fefb3d6c8657d46c2f0a" # DV HDR10
          "2b239ed870daba8126a53bd5dc8dc1c8" # DV HDR10+
          "1f733af03141f068a540eec352589a89" # DV HLG
          "27954b0a80aab882522a88a4d9eae1cd" # DV SDR
          "3e2c4e748b64a1a1118e0ea3f4cf6875" # HDR
          "bb019e1cd00f304f80971c965de064dc" # HDR (undefined)
          "3497799d29a085e2ac2df9d468413c94" # HDR10
          "a3d82cbef5039f8d295478d28a887159" # HDR10+
          "17e889ce13117940092308f48b48b45b" # HLG
          "2a7e3be05d3861d6df7171ec74cad727" # PQ
          # HQ Source Groups
          "d6819cba26b1a6508138d25fb5e32293" # HD Bluray Tier 01
          "c2216b7b8aa545dc1ce8388c618f8d57" # HD Bluray Tier 02
          "9965a052eb87b0d10313b1cea89eb451" # Remux Tier 01
          "8a1d0c3d7497e741736761a1da866a2e" # Remux Tier 02
          "d0c516558625b04b363fa6c5c2c7cfd4" # WEB Scene
          "e6258996055b9fbab7e9cb2f75819294" # WEB Tier 01
          "58790d4e2fdcd9733aa7ae68ba2bb503" # WEB Tier 02
          "d84935abd3f8556dcd51d4f27e22d0a6" # WEB Tier 03
          # Unwanted
          "85c61753df5da1fb2aab6f2a47426b09" # BR-DISK
          "9c11cd3f07101cdba90a2d81cf0e56b4" # LQ
          "e2315f990da2e2cbfc9fa5b7a6fcfe48" # LQ (Release Title)
          "23297a736ca77c0fc8e70f8edd7ee56c" # Upscaled
          "47435ece6b99a0b477caf360e79ba0bb" # x265 (HD)
        ];
      };
    }
  ));
in
rec {
  users = rec {
    groups.recyclarr.gid = users.recyclarr.uid;
    users.recyclarr = {
      isSystemUser = true;
      uid = 808;
      group = "recyclarr";
    };
  };
  
  systemd.services.podman-recyclarr = {
    after = [ "data.mount" ];
    requires = [ "data.mount" ];
  };
  
  virtualisation.oci-containers.containers.recyclarr = {
    image = "ghcr.io/recyclarr/recyclarr:latest";
    labels = { "io.containers.autoupdate" = "registry"; };
    user = "${toString users.users.recyclarr.uid}:${toString users.groups.recyclarr.gid}";
    volumes = [
      "${configFile}:/config/recyclarr.yml:ro"
      "/data/oci-containers/recyclarr/config:/config:rw"
      "/etc/localtime:/etc/localtime:ro"
    ];
  };
}
