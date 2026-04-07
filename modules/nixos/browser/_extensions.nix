let
  extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };
in
# To add additional extensions, find it on addons.mozilla.org, find
# the short ID in the url (like https://addons.mozilla.org/en-US/firefox/addon/!SHORT_ID!/)
# Then go to https://addons.mozilla.org/api/v5/addons/addon/!SHORT_ID!/ to get the guid
/*
  function get-extensions
      for ext in $argv
          set guid (curl -s "https://addons.mozilla.org/api/v5/addons/addon/$ext/" | yq -r '.guid')
          echo "(extension \"$ext\" \"$guid\")"
      end
  end

  get-extensions "a" "b" "c"
*/
[
  (extension "ublock-origin" "uBlock0@raymondhill.net")
  (extension "youtube-shorts-block" "{34daeb50-c2d2-4f14-886a-7160b24d66a4}")
  (extension "istilldontcareaboutcookies" "idcac-pub@guus.ninja")
  (extension "localcdn-fork-of-decentraleyes" "{b86e4813-687a-43e6-ab65-0bde4ab75758}")
  (extension "clearurls" "{74145f27-f039-47ce-a470-a662b129930a}")
  (extension "cookie-autodelete" "CookieAutoDelete@kennydo.com")
  (extension "dont-track-me-google1" "dont-track-me-google@robwu.nl")
  (extension "port-authority" "{6c00218c-707a-4977-84cf-36df1cef310f}")
  (extension "consent-o-matic" "gdpr@cavi.au.dk")
  (extension "popupoff" "{154cddeb-4c8b-4627-a478-c7e5b427ffdf}")
  (extension "canvasblocker" "CanvasBlocker@kkapsner.de")
  (extension "facebook-container" "@contain-facebook")
  (extension "privacy-badger17" "jid1-MnnxcxisBPnSXQ@jetpack")

  (extension "search_by_image" "{2e5ff8c8-32fe-46d0-9fc8-6b8986621f3c}")
  (extension "catppuccin-web-file-icons" "{bbb880ce-43c9-47ae-b746-c3e0096c5b76}")
  (extension "untrap-for-youtube" "{2662ff67-b302-4363-95f3-b050218bd72c}")
  (extension "sponsorblock" "sponsorBlocker@ajay.app")

  (extension "bitwarden-password-manager" "{446900e4-71c2-419f-a6a7-df9c091e268b}")
  (extension "wayback-machine_new" "wayback_machine@mozilla.org")

  (extension "vimium-ff" "{d7742d87-e61d-4b78-b8a1-b469842139fa}")
]
